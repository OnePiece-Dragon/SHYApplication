//
//  SHYIndexController.m
//  SongHuoYi
//
//  Created by 王亚龙 on 2017/4/4.
//  Copyright © 2017年 TianXi. All rights reserved.
//

#import "SHYIndexController.h"

#import "SHYMessageController.h"
#import "SHYTaskController.h"
#import "SHYTransportController.h"

#import "SHYReceiveBoxController.h"
#import "SHYWorkStatusModel.h"

#import "SHYNewTaskController.h"

@interface SHYIndexController ()

{
    BOOL _canWork;
    NSInteger _workStartTime;
}

@property (nonatomic, strong) SHYBaseTableView * indexListView;
@property (nonatomic, strong) NSMutableArray * dataArray;

@property (nonatomic, strong) NSIndexPath * currentPath;

@end

@implementation SHYIndexController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ([super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        self.hidesBottomBarWhenPushed = NO;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self cancelBackItem];
    self.naviTitle = @"送货易";
    kWeakSelf(self);
    [self setRightItem:@"message" rightBlock:^{
        [weakself messageItem];
    }];
    [self setUI];
    [self setContent];
}

- (void)setUI {
    [self.view addSubview:self.indexListView];
    
    kWeakSelf(self);
    [self.indexListView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(weakself.view);
        make.bottom.equalTo(weakself.view);
    }];
}
-(void)setContent {
    [self workStatusSet:0];
    
    NSArray * imageArray = @[@"woderenwu",@"wodepeisong",@"kaishishangban"];
    NSArray * highlightArray =
    @[@"dianjiwoderenwu",@"dianjiwodepeisong",@"dianjikaishishangban"];
    NSString * workStatusString = @"";
    //SHYUserModel * userModel = [SHYUserModel shareUserMsg];
    if ([USER_WORK_STATUS integerValue] != 1) {
        _canWork = NO;
        workStatusString = @"我要上班";
    }else if ([USER_WORK_STATUS integerValue] != 0){
        _canWork = YES;
        workStatusString = @"我要下班";
    }
    NSArray * titleArray = @[@"我的任务",@"我的配送",workStatusString];
    NSArray * descArray = @[@"",@"",@""];
    int i = 0;
    for (NSString * imageString in imageArray) {
        SHYIndexItemModel * model = [SHYIndexItemModel.alloc init];
        model.currentIndex = i;
        model.isClick = 0;
        model.imageName = imageString;
        model.highlightImageName = [highlightArray objectAtIndex:i];
        model.descName = [descArray objectAtIndex:i];
        model.titleName = [titleArray objectAtIndex:i++];
        [self.dataArray addObject:model];
    }
    
    [self.indexListView reloadData];
}


//我的任务
- (void)myTaskItemClick {
    SHYTaskController * VC = [SHYTaskController.alloc init];
    [self.navigationController pushViewController:VC animated:YES];
}
//我的配送
- (void)myTransportClick {
    SHYTransportController * VC = [SHYTransportController.alloc init];
    [self.navigationController pushViewController:VC animated:YES];
}
//上下班Click
- (void)workStatusSet:(NSInteger)status {
    [self showNetTips:LOADING_WAIT];
    [NetManager post:URL_WORK_UPDATE
               param:@{@"userId":USER_ID,
                       @"status":@(status)}
             success:^(NSDictionary * _Nonnull responseObj, NSString * _Nonnull failMessag, BOOL code) {
                  [self hideNetTips];
                 if (code) {
                     SHYWorkStatusModel * model = [SHYWorkStatusModel mj_objectWithKeyValues:responseObj];
                     ((SHYUserModel*)USER_MODEL).status = model.status;
                     if ([USER_WORK_STATUS integerValue] == 1) {
                         //上班状态
                         _canWork = YES;
                         [self workModelStatus:1 workTime:model.workTime];
                     }else {
                         _canWork = NO;
                         [self workModelStatus:model.status.integerValue workTime:nil];
                     }
                 }else {
                     [self showToast:failMessag];
                 }
             } failure:^(NSString * _Nonnull errorStr) {
                 [self hideNetTips];
                 [self showToast:errorStr];
             }];
}

//status == 1 上班状态
- (void)workModelStatus:(NSInteger)status workTime:(NSString*)timeString{
    kWeakSelf(self);
    //我的工作
    DLog(@"timeString:%@",timeString);
    SHYIndexItemModel * model = _dataArray.lastObject;
    [TimeManager cancelTimer];
    if (status == 1) {
        model.isClick = 1;
        model.titleName = @"我要下班";
        [TimeManager startTime:60 countTime:^(CGFloat count) {
            [weakself setWorkTime:timeString];
        }];
        //model.descName= [TimeManager timeWithTimeIntervalString:[NSString stringWithFormat:@"%f",[TimeManager timeSwitchTimeString:timeString format:@"YYYY/MM/DD HH:mm:ss"]] format:@"HH:mm"];
    }else {
        model.isClick = 0;
        model.titleName = @"我要上班";
        model.descName = @"";
    }
    [self.indexListView reloadData];
//    SHYIndexCell * cell = [self.indexListView cellForRowAtIndexPath:[NSIndexPath indexPathWithIndex:2]];
//    [cell setModel:model];
}

- (void)setWorkTime:(NSString*)timeString {
    SHYIndexItemModel * model = _dataArray.lastObject;
    NSTimeInterval startWorkTime = [TimeManager timeSwitchTimeString:timeString format:@"yyyy-MM-dd HH:mm:ss"];
    NSInteger timeSecd = NSDate.date.timeIntervalSince1970 - startWorkTime;
    //NSLog(@"timeSecond:%ld",timeSecd);
    NSString * formatStr = nil;
    
    if (timeSecd<0) {
        timeSecd = 0;
    }
    if (timeSecd/3600 >= 1) {
        formatStr = [NSString stringWithFormat:@"%ld小时%ld分",timeSecd/3600,(timeSecd%3600)/60];
    }else {
        formatStr = [NSString stringWithFormat:@"0小时%ld分",timeSecd/60];
    }
    //NSString * timeStr = [TimeManager timeWithTimeIntervalString:[NSString stringWithFormat:@"%ld",timeSecd] format:formatStr];
    model.descName = formatStr;
    
    //[self.indexListView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:2 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
    //SHYIndexCell * cell = [self.indexListView cellForRowAtIndexPath:self.currentPath];
    //[cell setModel:model];
    [self.indexListView reloadData];
}

- (void)clickItemAt:(NSInteger)row {
    switch (row) {
        case 0:
        {
            if (!_canWork) {
                return;
            }
            //我的任务
            [self myTaskItemClick];
        }
        break;
        case 1:
        {
            if (!_canWork) {
                return;
            }
            //我的配送
            [self myTransportClick];
        }
        break;
        case 2:
        {
            
            [self showAlertVCWithTitle:nil info:@"确定执行此操作？" CancelTitle:@"点错了" okTitle:@"确定" cancelBlock:nil okBlock:^{
                self.currentPath = [NSIndexPath indexPathWithIndex:2];
                
                if (((SHYUserModel*)USER_MODEL).status.integerValue != 1) {
                    //我要上班
                    [self workStatusSet:1];
                }else {
                    [self workStatusSet:2];
                }
            }];
            
        }
        break;
        default:
            break;
    }
}



- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return SCREEN_WIDTH / 2.f + 80;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SHYIndexCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    [cell setCellModel:self.dataArray[indexPath.row]];
    
    kWeakSelf(self);
    cell.tapActionBlock = ^(SHYIndexItemModel * model){
        [weakself clickItemAt:model.currentIndex];
    };
    return cell;
}


- (SHYBaseTableView *)indexListView {
    if (!_indexListView) {
        _indexListView = [SHYBaseTableView.alloc initWithFrame:CGRectZero style:UITableViewStylePlain target:self];
        //_indexListView.backgroundColor = [UIColor yellowColor];
        [_indexListView registerClass:[SHYIndexCell class] forCellReuseIdentifier:cellID];
    }
    return _indexListView;
}
- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
