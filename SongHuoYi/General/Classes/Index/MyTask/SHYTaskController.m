//
//  SHYTaskController.m
//  SongHuoYi
//
//  Created by 王亚龙 on 2017/4/6.
//  Copyright © 2017年 TianXi. All rights reserved.
//

#import "SHYTaskController.h"


@interface SHYTaskController ()<BMKMapViewDelegate,BMKLocationServiceDelegate>

{
    NSInteger _page;
    
    NSInteger _isMap;
    NSInteger _isUserLocation;
    BOOL _mapHaveLoad;
}

@property (nonatomic, strong) BMKUserLocation * userLocation;

@end

@implementation SHYTaskController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.orginView = self.view;
    self.naviTitle = @"我的任务";
    _page = 1;
    
    kWeakSelf(self);
    _isMap = NO;
    _isUserLocation = NO;
    _mapHaveLoad = NO;
    [self setRightItem:@"ditumoshi" selectedImage:@"daohang" rightBlock:^(UIButton * button) {
        [weakself mapModelSwitch:button];
    }];
    [self setUI];
    [self requestData];
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
- (void)enterCheckGoodsClick:(SHYTaskModel*)model {
    DLog(@"开始核货:%@",model.lineName);
    kWeakSelf(self);
    SHYCheckGoodsDetailController * VC = [SHYCheckGoodsDetailController.alloc init];
    VC.taskId = model.tasksId;
    VC.lineId = model.lineId;
    VC.backBlock=^(){
        [weakself resetDataWithRequest];
    };
    [self.navigationController pushViewController:VC animated:YES];
}

- (void)jumpToMyTransport {
    SHYTransportController * VC = [SHYTransportController.alloc init];
    [self.navigationController pushViewController:VC animated:YES];
}

- (void)mapModelSwitch:(UIButton*)button {
    if (button.selected) {
        //地图模式
        self.taskTableView.hidden = YES;
        self.mapView.hidden = NO;
        self.view = self.mapView;
        
        [self.locService startUserLocationService];
        //以下_mapView为BMKMapView对象
        _mapView.userTrackingMode = BMKUserTrackingModeNone;//设置定位的状态
        _mapView.showsUserLocation = YES;//显示定位图层
        
        if (self.dataArray.count) {
            [self addAnnotationOnMap];
            if (!self.annotationDetailView.superview) {
                [self.mapView addSubview:self.annotationDetailView];
            }
            kWeakSelf(self);
            [self.annotationDetailView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(weakself.mapView).offset(10);
                make.right.equalTo(weakself.mapView).offset(-10);
                make.bottom.equalTo(weakself.mapView);
                make.height.greaterThanOrEqualTo(@250);
            }];
            [self setContentView:_annotationDetailView model:self.dataArray.firstObject];
            [_mapView setCenterCoordinate:[(SHYTaskAnnotationModel*)_mapView.annotations.firstObject coordinate] animated:NO];
        }
        
        if (_mapHaveLoad) {
            _annotationDetailView.hidden = NO;
        }else {
            _annotationDetailView.hidden = YES;
        }
    }else {
        //列表模式
        self.taskTableView.hidden = NO;
        self.mapView.hidden = YES;
        self.view = self.orginView;
    }
}

- (void)setUI {
    kWeakSelf(self);
    //[self.view addSubview:self.mapView];
    //self.mapView.hidden = YES;
    [self.view addSubview:self.taskTableView];
    [self.taskTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.bottom.equalTo(weakself.view);
    }];
}

- (void)resetDataWithRequest {
    [self.dataArray removeAllObjects];
    _page = 1;
    [self requestData];
}

- (void)requestData {
    [self showNetTips:LOADING_TIPS];
    [NetManager post:URL_TASK_LIST
               param:@{@"userId":USER_ID,@"page":@(_page)}
             success:^(NSDictionary * _Nonnull responseObj, NSString * _Nonnull failMessag, BOOL code) {
                 self.taskTableView.emptyBtnString = NET_EMPTY_MSG;
                 if (code) {
                     [self hideNetTips];
                     [self handleResponseMessage:responseObj];
                 }else{
                     [self showToast:failMessag];
                 }
             } failure:^(NSString * _Nonnull errorStr) {
                 self.taskTableView.emptyBtnString = errorStr;
                 [self hideNetTips];
                 [self showToast:errorStr];
             }];
}

- (void)handleResponseMessage:(NSDictionary*)responseObject {
    DLog(@"responseObject:%@",responseObject);
    
    //NSString *plistPath = PLIST_Name(@"taskList");
    //NSDictionary * result = [NSDictionary dictionaryWithContentsOfFile:plistPath];
    
    for (NSDictionary * dic in responseObject[@"rows"]) {
        SHYTaskModel * model = [SHYTaskModel mj_objectWithKeyValues:dic];
        [self.dataArray addObject:model];
    }
    [self.taskTableView reloadData];
    
}

- (void)addAnnotationOnMap {
    NSMutableArray * annotationArray = [NSMutableArray array];
    for (SHYTaskModel *model in self.dataArray) {
        SHYTaskAnnotationModel* annotation = [[SHYTaskAnnotationModel alloc]init];
        CLLocationCoordinate2D coor;
        coor.latitude = [model.dimension floatValue];
        coor.longitude = [model.longitude floatValue];
        annotation.coordinate = coor;
        annotation.title = model.lineName;
        
        [annotation.taskModel mj_setKeyValues:model.mj_keyValues];
        [annotationArray addObject:annotation];
    }
    [_mapView removeAnnotations:_mapView.annotations];
    [_mapView addAnnotations:annotationArray];
    [_mapView selectAnnotation:annotationArray.firstObject animated:YES];
}

- (void)setContentView:(SHYTaskCell*)view model:(SHYTaskModel*)taskModel {
    [view setCellModel:taskModel];
    SHYIconLabel*label1 = view.labelArray[0];
    SHYIconLabel*label2 = view.labelArray[1];
    SHYIconLabel*label3 = view.labelArray[2];
    SHYIconLabel*label4 = view.labelArray[3];
    SHYIconLabel*label5 = view.labelArray[4];
    SHYIconLabel*label6 = view.labelArray[5];
    
    [label2 setIcon:@"renwudan" size:CGSizeMake(24, 24)];
    [label3 setIcon:@"dizhi" size:CGSizeMake(24, 28)];
    
    label1.titleLabel.text = taskModel.lineName;
    label2.titleLabel.text = [NSString stringWithFormat:@"任务单号：%@",taskModel.tasksId];
    label3.titleLabel.text = [NSString stringWithFormat:@"地址：%@",taskModel.startAddr];
    label4.titleLabel.text = [NSString stringWithFormat:@"取件任务数：%@",taskModel.orderNum];
    label5.titleLabel.text = [NSString stringWithFormat:@"商户数量：%@",taskModel.merchantNum];
    label6.titleLabel.text = [NSString stringWithFormat:@"共计：%@",taskModel.taskDetail];
    
    
    if ([taskModel.nuclearStatus integerValue] == 0) {
        //未核货
        [view.enterBtn setTitle:@"进入核货" forState:UIControlStateNormal];
    }else if ([taskModel.nuclearStatus integerValue] == 1){
        //核货完成
        [view.enterBtn setTitle:@"核货完成" forState:UIControlStateNormal];
    }
}

- (void)hideAnnotationView {
    [UIView animateWithDuration:1.f animations:^{
        _annotationDetailView.y += SCREEN_HEIGHT;
    } completion:^(BOOL finished) {
        _annotationDetailView.hidden = YES;
    }];
}
- (void)showAnnotationView {
    _annotationDetailView.hidden = NO;
    [UIView animateWithDuration:1.f animations:^{
        _annotationDetailView.y -= SCREEN_HEIGHT;
    } completion:^(BOOL finished) {
    }];
}
- (void)updateAnnotationDetailViewLocation {
    [self.mapView addSubview:self.annotationDetailView];
    kWeakSelf(self);
    [self.annotationDetailView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(weakself.mapView);
    }];
}

#pragma mark -tableViewDelegate-
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SHYTaskCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [SHYTaskCell.alloc initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID labelCount:6];
    }
    SHYTaskModel * taskModel = [self.dataArray objectAtIndex:indexPath.row];
    [self setContentView:cell model:taskModel];
    
    kWeakSelf(self);
    cell.startBtnClickBlock = ^(SHYTaskModel*model){
        [weakself sendGoodsBtnClick:model];
    };
    cell.enterBtnClickBlock = ^(SHYTaskModel*model){
        [weakself enterCheckGoodsClick:model];
    };
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 270.f;
}
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    return 270.f;
//}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 4.f;
}
- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView * view = [UIView.alloc initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 4)];
    view.backgroundColor = BACKGROUND_COLOR;
    return view;
}

#pragma mark -MP_Delegate-
/**
 *地图初始化完毕时会调用此接口
 */
- (void)mapViewDidFinishLoading:(BMKMapView *)mapView {
    _mapHaveLoad = YES;
    self.annotationDetailView.hidden = NO;
}
- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[BMKPointAnnotation class]]) {
        BMKPinAnnotationView *newAnnotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"myAnnotation"];
        newAnnotationView.pinColor = BMKPinAnnotationColorRed;
        newAnnotationView.animatesDrop = YES;// 设置该标注点动画显示
        return newAnnotationView;
    }
    return nil;
}
/**
 *当点击annotation view弹出的泡泡时，调用此接口
 *@param mapView 地图View
 *@param view 泡泡所属的annotation view
 */
- (void)mapView:(BMKMapView *)mapView annotationViewForBubble:(BMKAnnotationView *)view {
    DLog(@"当点击annotation view弹出的泡泡时，调用此接口");
    SHYTaskAnnotationModel *annotation = (SHYTaskAnnotationModel*)view.annotation;
    if (![annotation.title isEqualToString:@"我的位置"]) {
        //进入
        //[self enterCheckGoodsClick:annotation.taskModel];
    }
}
/**
 *当选中一个annotation views时，调用此接口
 *@param mapView 地图View
 */
- (void)mapView:(BMKMapView *)mapView didSelectAnnotationView:(BMKAnnotationView *)view {
    DLog(@"当选中annotation view时");
    SHYTaskAnnotationModel *annotation = (SHYTaskAnnotationModel*)view.annotation;
    if ([annotation.title isEqualToString:@"我的位置"]) {
        [self hideAnnotationView];
    }else {
        [self showAnnotationView];
        [self updateAnnotationDetailViewLocation];
        [self setContentView:_annotationDetailView model:annotation.taskModel];
    }
}
/**
 *点中底图空白处会回调此接口
 *@param coordinate 空白处坐标点的经纬度
 */
- (void)mapView:(BMKMapView *)mapView onClickedMapBlank:(CLLocationCoordinate2D)coordinate {
    DLog(@"点中底图空白处会回调此接口");
    [self hideAnnotationView];
}

#pragma mark -BMKLocationServiceDelegate-
//实现相关delegate 处理位置信息更新
//处理方向变更信息
- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation
{
    //NSLog(@"heading is %@",userLocation.heading);
    _userLocation = userLocation;
    [_mapView updateLocationData:userLocation];
}
//处理位置坐标更新
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    //NSLog(@"didUpdateUserLocation lat %f,long %f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
    _userLocation = userLocation;
    [_mapView updateLocationData:userLocation];
    
    if (!_isUserLocation) {
        _isUserLocation = !_isUserLocation;
        if (!self.dataArray.count) {
            [_mapView setCenterCoordinate:_userLocation.location.coordinate animated:NO];
        }
    }
}


#pragma mark -Lazing-
- (SHYBaseTableView *)taskTableView {
    if (!_taskTableView) {
        _taskTableView = [SHYBaseTableView.alloc initWithFrame:CGRectZero style:UITableViewStyleGrouped target:self];
        kWeakSelf(self);
        _taskTableView.backgroundColor = BACKGROUND_COLOR;
        _taskTableView.emptyRequestAgainBlock = ^(){
            [weakself resetDataWithRequest];
        };
    }
    return _taskTableView;
}
- (BMKMapView *)mapView {
    if (!_mapView) {
        _mapView = [BMKMapView.alloc initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - kStatusBarH - 20)];
        _mapView.delegate = self;
        //_mapView.userTrackingMode = BMKUserTrackingModeFollow;
    }
    return _mapView;
}
- (BMKLocationService *)locService {
    if (!_locService) {
        _locService = [BMKLocationService.alloc init];
        _locService.delegate = self;
    }
    return _locService;
}
- (SHYTaskCell *)annotationDetailView {
    if (!_annotationDetailView) {
        _annotationDetailView = [SHYTaskCell.alloc initWithFrame:CGRectZero labelCount:6];
        
        kWeakSelf(self);
        _annotationDetailView.startBtnClickBlock = ^(SHYTaskModel * model){
            [weakself sendGoodsBtnClick:model];
        };
        _annotationDetailView.enterBtnClickBlock = ^(SHYTaskModel*model) {
            [weakself enterCheckGoodsClick:model];
        };
    }
    return _annotationDetailView;
}
- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}


-(void)viewWillAppear:(BOOL)animated
{
    [_mapView viewWillAppear];
    _mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
}
-(void)viewWillDisappear:(BOOL)animated
{
    [_mapView viewWillDisappear];
    _mapView.delegate = nil; // 不用时，置nil
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
