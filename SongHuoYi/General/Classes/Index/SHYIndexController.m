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

-(void)setContent {
    NSArray * imageArray = @[@"dianjiwoderenwu2",@"dianjiwodepeisong2",@"dianjikaishishangban"];
    NSArray * titleArray = @[@"我的任务",@"我的配送",@"我要上班"];
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

- (void)messageItem {
    SHYMessageController * VC = [SHYMessageController.alloc init];
    [self.navigationController pushViewController:VC animated:YES];
}

- (void)clickItemAt:(NSInteger)row {
    switch (row) {
        case 0:
        {
            //我的任务
            SHYTaskController * VC = [SHYTaskController.alloc init];
            [self.navigationController pushViewController:VC animated:YES];
        }
        break;
        case 1:
        {
            //我的配送
            SHYTransportController * VC = [SHYTransportController.alloc init];
            [self.navigationController pushViewController:VC animated:YES];
        }
        break;
        case 2:
        {
            //我的工作
            SHYIndexItemModel * model = _dataArray.lastObject;
            if (model.isClick == 0) {
                model.isClick = 1;
                model.titleName = @"我要下班";
                model.descName= @"12小时28分";
            }else {
                model.isClick = 0;
                model.titleName = @"我要上班";
                model.descName = @"";
            }
            [self.indexListView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:2 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
        }
        break;
        default:
            break;
    }
}


- (void)setUI {
    [self.view addSubview:self.indexListView];
    
    kWeakSelf(self);
    [self.indexListView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(weakself.view);
        make.bottom.equalTo(weakself.view).offset(kTabBarH);
    }];
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
