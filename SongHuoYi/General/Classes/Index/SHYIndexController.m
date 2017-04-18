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

@interface SHYIndexController ()

@property (nonatomic, strong) SHYBaseTableView * indexListView;
@property (nonatomic, strong) NSMutableArray * dataArray;

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
    [self setRightItem:@"ditumoshi" rightBlock:^{
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
        make.bottom.equalTo(weakself.view).offset(kTabBarH);
    }];
}
-(void)setContent {
    NSArray * imageArray = @[@"dianjiwoderenwu2",@"dianjiwodepeisong2",@"dianjikaishishangban"];
    NSString * workStatusString = nil;
    if ([USER_WORK_STATUS integerValue] != 1) {
        workStatusString = @"我要上班";
    }else {
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
        model.descName = [descArray objectAtIndex:i];
        model.titleName = [titleArray objectAtIndex:i++];
        [self.dataArray addObject:model];
    }
    
    [self.indexListView reloadData];
}

//消息列表
- (void)messageItem {
    SHYMessageController * VC = [SHYMessageController.alloc init];
    [self.navigationController pushViewController:VC animated:YES];
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
- (void)workStatusSet {
    [self showNetTips:@"处理中..."];
    [NetManager post:URL_WORK_UPDATE param:@{@"userId":USER_ID} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self hideNetTips];
        
        NSDictionary * result = responseObject[@"data"];
        
        
        ((SHYUserModel*)USER_MODEL).status = result[@"status"];
        [self showToast:result[@"valStatusMsg"]];
        if ([USER_WORK_STATUS integerValue] == 1) {
            //上班状态
            [self workModelStatus:1 workTime:result[@"workTime"]];
        }else {
            [self workModelStatus:[result[@"status"] integerValue] workTime:result[@"offDutyTime"]];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self hideNetTips];
        [self showToast:NET_ERROR_TIP];
    }];
}

//status == 1 上班状态
- (void)workModelStatus:(NSInteger)status workTime:(NSNumber*)time{
    //我的工作
    SHYIndexItemModel * model = _dataArray.lastObject;
    if (status == 1) {
        model.isClick = 1;
        model.titleName = @"我要下班";
        model.descName= [TimeManager timeWithTimeIntervalString:time.stringValue format:@"HH:mm"];
    }else {
        model.isClick = 0;
        model.titleName = @"我要上班";
        model.descName = @"";
    }
    [self.indexListView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:2 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
}

- (void)clickItemAt:(NSInteger)row {
    switch (row) {
        case 0:
        {
            //我的任务
            [self myTaskItemClick];
        }
        break;
        case 1:
        {
            //我的配送
            [self myTransportClick];
        }
        break;
        case 2:
        {
            [self workStatusSet];
        }
        break;
        default:
            break;
    }
}



- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return SCREEN_WIDTH / 2.f;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SHYIndexCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    [cell setCellModel:_dataArray[indexPath.row]];
    
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
