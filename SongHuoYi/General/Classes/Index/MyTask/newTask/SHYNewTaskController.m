//
//  SHYNewTaskController.m
//  SongHuoYi
//
//  Created by 王亚龙 on 2017/5/2.
//  Copyright © 2017年 TianXi. All rights reserved.
//

#import "SHYNewTaskController.h"

#import "SHYTaskListViewModel.h"
#import "SHYTaskMapViewModel.h"

#import "SHYTransportController.h"
#import "SHYCheckGoodsDetailController.h"

@interface SHYNewTaskController ()

@property (nonatomic, strong, nonnull) SHYTaskListViewModel * taskListViewModel;
@property (nonatomic, strong, nonnull) SHYTaskMapViewModel  * taskMapViewModel;

@end

@implementation SHYNewTaskController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.naviTitle = @"我的任务";
    kWeakSelf(self);
    [self setRightItem:@"ditumoshi" selectedImage:@"daohang" rightBlock:^(UIButton * button) {
        [weakself mapModelSwitch:button];
    }];
 
    self.view = self.taskListViewModel.taskListView;
    self.taskMapViewModel.mapView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - kStatusBarH - 20);
    self.taskListViewModel.taskListView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - kStatusBarH - 20);
    
    //self.taskMapViewModel.mapView.backgroundColor = [UIColor orangeColor];
    //self.taskListViewModel.taskListView.backgroundColor = [UIColor yellowColor];
    
    
    //taskListView
    [self showNetTips:LOADING_TIPS];
    [self.taskListViewModel fetchResponse];
    [self.taskListViewModel.responseSignal subscribeNext:^(id  _Nullable x) {
        [self hideNetTips];
        if (x) {
            //获取数据成功
            [self.taskListViewModel.taskListView reloadData];
        }else {
            [self showToast:self.taskListViewModel.failResult[@"error"]];
        }
    }];
    [self.taskListViewModel.enterBtnSignal subscribeNext:^(SHYTaskModel* model) {
        DLog(@"model:%@",model.lineName);
        [weakself enterCheckGoodsClick:model];
    }];
    [self.taskListViewModel.startBtnSignal subscribeNext:^(SHYTaskModel* model) {
        DLog(@"model:%@",model.lineName);
        [weakself sendGoodsBtnClick:model];
    }];
    
    //taskMapView
    [self.taskMapViewModel.enterBtnSignal subscribeNext:^(SHYTaskModel* model) {
        [weakself enterCheckGoodsClick:model];
    }];
    [self.taskMapViewModel.startBtnSignal subscribeNext:^(SHYTaskModel* model) {
        [weakself sendGoodsBtnClick:model];
    }];
}

- (void)mapModelSwitch:(UIButton*)button{
    if (button.selected) {
        //地图模式
        [self.taskMapViewModel startLocation];
        self.taskMapViewModel.mapAnnotationArray = self.taskListViewModel.taskListArray;
        self.view = self.taskMapViewModel.mapView;
    }else {
        //列表模式
        self.view = self.taskListViewModel.taskListView;
    }
}

- (void)loadMoreData:(id)view {
    self.taskListViewModel.page ++;
    [self.taskListViewModel fetchResponse];
}

- (void)enterCheckGoodsClick:(SHYTaskModel*)model {
    DLog(@"开始核货:%@",model.lineName);
    kWeakSelf(self);
    SHYCheckGoodsDetailController * VC = [SHYCheckGoodsDetailController.alloc init];
    VC.taskId = model.tasksId;
    VC.lineId = model.lineId;
    VC.canCheckBtnClick = model.nuclearStatus.integerValue > 0?NO:YES;
    VC.backBlock=^(){
        [weakself.taskListViewModel resetDataWithRequest];
    };
    [self.navigationController pushViewController:VC animated:YES];
}
- (void)sendGoodsBtnClick:(SHYTaskModel*)model {
    DLog(@"开始配送:%@",model.lineName);
    if (model.nuclearStatus.integerValue == 0) {
        [self showToast:@"请先完成核货"];
        return;
    }
    
    [self showNetTips:LOADING_DISPOSE];
    [NetManager post:URL_TASK_STATUS_UPDATE
               param:@{@"taskId":model.tasksId,
                       @"status":@3,
                       @"userId":USER_ID}
             success:^(NSDictionary * _Nonnull responseObj, NSString * _Nonnull failMessag, BOOL code) {
                 [self hideNetTips];
                 if (code) {
                     //
                     [self jumpToMyTransport];
                 }else {
                     [self showToast:failMessag];
                 }
             } failure:^(NSString * _Nonnull errorStr) {
                 [self hideNetTips];
                 [self showToast:errorStr];
             }];
}

- (void)jumpToMyTransport {
    SHYTransportController * VC = [SHYTransportController.alloc init];
    [self.navigationController pushViewController:VC animated:YES];
}

#pragma mark -touch delegate-
-(void)viewWillAppear:(BOOL)animated
{
    [self.taskMapViewModel.mapView viewWillAppear];
    self.taskMapViewModel.mapView.delegate = self.taskMapViewModel; // 此处记得不用的时候需要置nil，否则影响内存的释放
}
-(void)viewWillDisappear:(BOOL)animated
{
    [self.taskMapViewModel.mapView viewWillDisappear];
    self.taskMapViewModel.mapView.delegate = nil; // 不用时，置nil
}


#pragma mark -Lazing-
- (SHYTaskListViewModel *)taskListViewModel {
    if (!_taskListViewModel) {
        _taskListViewModel = [SHYTaskListViewModel.alloc initWithTarget:self];
    }
    return _taskListViewModel;
}
- (SHYTaskMapViewModel *)taskMapViewModel {
    if (!_taskMapViewModel) {
        _taskMapViewModel = [SHYTaskMapViewModel.alloc init];
    }
    return _taskMapViewModel;
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
