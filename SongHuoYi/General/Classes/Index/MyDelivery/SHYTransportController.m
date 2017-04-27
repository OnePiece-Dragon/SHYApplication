//
//  SHYTransportController.m
//  SongHuoYi
//
//  Created by 王亚龙 on 2017/4/6.
//  Copyright © 2017年 TianXi. All rights reserved.
//

#import "SHYTransportController.h"
#import "SHYSegmentView.h"
#import "SHYDeliveryModel.h"
#import "SHYTaskAnnotationModel.h"

@interface SHYTransportController ()<BMKMapViewDelegate,BMKLocationServiceDelegate>
{
    NSInteger _leftPage;
    NSInteger _rightPage;
    NSInteger _leftAllPage;
    NSInteger _rightAllPage;
    
    BOOL _haveSlide;
    
    NSInteger _isMap;
    NSInteger _isUserLocation;
    BOOL _mapHaveLoad;
}

@property (nonatomic, strong) BMKUserLocation * userLocation;

@property (nonatomic, strong) UISegmentedControl * segmentControl;
@property (nonatomic, strong) UIView * segmentLineView;

@property (nonatomic, strong) SHYSegmentView * segmentContentView;
@property (nonatomic, strong) SHYBaseTableView * deliveryingView;
@property (nonatomic, strong) SHYBaseTableView * deliveryDoneView;

@property (nonatomic, strong) NSMutableArray * deliveryingArray;
@property (nonatomic, strong) NSMutableArray * deliveryDoneArray;

@end

@implementation SHYTransportController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.orginView = self.view;
    self.naviTitle = @"我的配送";
    kWeakSelf(self);
    _leftPage   = 1;
    _rightPage  = 1;
    _haveSlide = NO;
    
    _isMap = NO;
    _isUserLocation = NO;
    _mapHaveLoad = NO;
    [self setRightItem:@"ditumoshi" selectedImage:@"daohang" rightBlock:^(UIButton * button) {
        [weakself mapModelSwitch:button];
    }];
    self.leftBar = ^(){
        [weakself.navigationController popToRootViewControllerAnimated:YES];
    };
    [self setUI];
    
    [self requestDeliveryingData];
    //[self requestDeliveryDoneData];
}

- (void)transportingDataLoadMore {
    if (_leftPage<_leftAllPage) {
        _leftPage++;
        [self requestDeliveryingData];
    }
}
- (void)transportDoneDataLoadMore {
    if (_rightPage<_rightAllPage) {
        _rightPage++;
        [self requestDeliveryDoneData];
    }
}

//请求配送中的数据
- (void)requestDeliveryingData {
    [self showNetTips:LOADING_TIPS];
    [NetManager post:URL_DISTRIBUTE_LIST
               param:@{@"userId":USER_ID,
                       @"distrStatus":@1,
                       @"curAddr":@"",
                       @"page":@(_leftPage)}
             success:^(NSDictionary * _Nonnull responseObj, NSString * _Nonnull failMessag, BOOL code) {
                 [self hideNetTips];
                   if (code) {
                       DLog(@"responseObj:%@",responseObj);
                       if (responseObj[@"pages"]) {
                           _leftAllPage = [responseObj[@"pages"] integerValue];
                       }
                       
                       for (NSDictionary * dic in responseObj[@"rows"]) {
                           SHYDeliveryModel * model = [SHYDeliveryModel mj_objectWithKeyValues:dic];
                           [self.deliveryingArray addObject:model];
                       }
                       [self.deliveryingView reloadData];
                       
                   }else {
                       if (_leftPage>1) {
                           _leftPage--;
                       }
                       
                       [self showToast:failMessag];
                   }
             } failure:^(NSString * _Nonnull errorStr) {
                 if (_leftPage>1) {
                     _leftPage--;
                 }
                 [self hideNetTips];
                 [self showToast:errorStr];
             }];
    
    //NSString * path = PLIST_Name(@"distribute_list");
    //NSDictionary * reuslt = [NSDictionary.alloc initWithContentsOfFile:path];
}
//请求配送完成数据
- (void)requestDeliveryDoneData {
    if (!_haveSlide) {
        return;
    }
    
    [self showNetTips:LOADING_TIPS];
    [NetManager post:URL_DISTRIBUTE_LIST
               param:@{@"userId":USER_ID,
                       @"distrStatus":@2,
                       @"curAddr":@"",
                       @"page":@(_rightPage)}
             success:^(NSDictionary * _Nonnull responseObj, NSString * _Nonnull failMessag, BOOL code) {
                 if (code) {
                     [self hideNetTips];
                     if (responseObj[@"pages"]) {
                         _rightAllPage = [responseObj[@"pages"] integerValue];
                     }
                     
                     for (NSDictionary * dic in responseObj[@"rows"]) {
                         SHYDeliveryModel * model = [SHYDeliveryModel mj_objectWithKeyValues:dic];
                         [self.deliveryDoneArray addObject:model];
                     }
                     [self.deliveryDoneView reloadData];
                 }else {
                     
                     if (_rightPage>1) {
                         _rightPage--;
                     }
                     [self showToast:failMessag];
                 }
             } failure:^(NSString * _Nonnull errorStr) {
                 if (_rightPage>1) {
                     _rightPage--;
                 }
                 [self hideNetTips];
                 [self showToast:errorStr];
             }];
    
    /*
    NSString * path = PLIST_Name(@"distribute_list");
    NSDictionary * reuslt = [NSDictionary.alloc initWithContentsOfFile:path];
    
    for (NSDictionary * dic in reuslt[@"data"][@"rows"]) {
        SHYDeliveryModel * model = [SHYDeliveryModel mj_objectWithKeyValues:dic];
        [self.deliveryDoneArray addObject:model];
    }
    [self.deliveryDoneView reloadData];
     */
}
- (void)endTransportRequest {
    _leftPage = 1;
    _rightPage = 1;
    [self.deliveryingArray removeAllObjects];
    [self requestDeliveryingData];
}

//添加大头针
- (void)addAnnotationOnMap {
    NSMutableArray * annotationArray = [NSMutableArray array];
    for (SHYDeliveryModel *model in self.deliveryingArray) {
        SHYTaskAnnotationModel* annotation = [[SHYTaskAnnotationModel alloc]init];
        CLLocationCoordinate2D coor;
        coor.latitude = [model.latitude floatValue];
        coor.longitude = [model.longitude floatValue];
        annotation.coordinate = coor;
        annotation.title = model.shopName;
        
        [annotation.deliveryModel mj_setKeyValues:model.mj_keyValues];
        [annotationArray addObject:annotation];
    }
    [_mapView removeAnnotations:_mapView.annotations];
    [_mapView addAnnotations:annotationArray];
    [_mapView selectAnnotation:annotationArray.firstObject animated:YES];
}
//查看配送详情
- (void)clickToSeeOrderDetail:(SHYDeliveryModel*)model {
    SHYTransportDetailController * VC = [SHYTransportDetailController.alloc init];
    VC.deliveryDetailModel = model;
    [self.navigationController pushViewController:VC animated:YES];
}
//结束配送
- (void)endDeliveryBtn:(SHYDeliveryModel*)model {
    DLog(@"model:%@",model.shopName);
    [self showAlertVCWithTitle:@"确认消息:" info:@"该货物已送达！" CancelTitle:@"取消" okTitle:@"确定" cancelBlock:nil okBlock:^{
        [self endTransportRequest];
    }];
}


- (void)setContentView:(SHYTaskCell*)view model:(SHYDeliveryModel*)model {
    [view setCellModel:model];
    SHYIconLabel*label1 = view.labelArray[0];
    SHYIconLabel*label2 = view.labelArray[1];
    SHYIconLabel*label3 = view.labelArray[2];
    SHYIconLabel*label4 = view.labelArray[3];
    
    [label2 setIcon:@"renwudan" size:CGSizeMake(24, 24)];
    [label3 setIcon:@"daishoukuan" size:CGSizeMake(24, 24)];
    [label4 setIcon:@"dizhi" size:CGSizeMake(24, 28)];
    
    label1.titleLabel.text = model.shopName;
    label2.titleLabel.text = [NSString stringWithFormat:@"订单号：%@",model.orderId];
    label3.titleLabel.text = [NSString stringWithFormat:@"代收：%.2f元",model.collectMoney.floatValue/100.0];
    label4.titleLabel.text = [NSString stringWithFormat:@"地址：%@",model.targetAddr];
    
    [label3.titleLabel setAttributedText:[Factory setText:label3.titleLabel.text
                                                attribute:@{NSForegroundColorAttributeName:COLOR_PRICE}
                                                    range:NSMakeRange(3, label3.titleLabel.text.length - 3)]];
}


- (void)mapModelSwitch:(UIButton*)button {
    if (button.selected) {
        //地图模式
        self.segmentControl.hidden = YES;
        self.segmentLineView.hidden = YES;
        self.segmentContentView.hidden = YES;
        
        self.mapView.hidden = NO;
        self.view = self.mapView;
        
        [self.locService startUserLocationService];
        //以下_mapView为BMKMapView对象
        //_mapView.showsUserLocation = NO;
        _mapView.userTrackingMode = BMKUserTrackingModeNone;//设置定位的状态
        _mapView.showsUserLocation = YES;//显示定位图层
        
        
        if (self.deliveryingArray.count) {
            [self addAnnotationOnMap];
            
            [self.mapView addSubview:self.annotationDetailView];
            kWeakSelf(self);
            [self.annotationDetailView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(weakself.mapView).offset(10);
                make.right.equalTo(weakself.mapView).offset(-10);
                make.bottom.equalTo(weakself.mapView);
                make.height.greaterThanOrEqualTo(@250);
            }];
            if (_mapHaveLoad) {
                _annotationDetailView.hidden = NO;
            }else {
                _annotationDetailView.hidden = YES;
            }
            [self setContentView:_annotationDetailView model:self.deliveryingArray.firstObject];
        }
    }else {
        //列表模式
        self.segmentControl.hidden = NO;
        self.segmentLineView.hidden = NO;
        self.segmentContentView.hidden = NO;
        
        self.mapView.hidden = YES;
        self.view = self.orginView;
    }
}

- (void)setUI {
    [self.view addSubview:self.segmentControl];
    [self.view addSubview:self.segmentLineView];
    [self.view addSubview:self.segmentContentView];
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


- (void)segmentClickItem:(id)sender {
    NSInteger selectedIndex = _segmentControl.selectedSegmentIndex;
    [self slideAndSegItemSelectedIndex:selectedIndex];
}

- (void)slideAndSegItemSelectedIndex:(NSInteger)index {
    if (index == 1) {
        //
        _haveSlide = YES;
    }
    
    [_segmentContentView setPageIndex:index];
    [UIView animateWithDuration:0.7f animations:^{
        self.segmentLineView.x = (SCREEN_WIDTH/2.f)*index;
    }];
}

#pragma mark -tableViewDelegate-
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == _deliveryingView) {
        return self.deliveryingArray.count;
    }else if (tableView == _deliveryDoneView) {
        return self.deliveryDoneArray.count;
    }
    return 0;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString * deliveryCell = nil;
    //SHYDeliveryModel
    SHYDeliveryModel * model = nil;
    BOOL _isBottomBtn = NO;
    BOOL _showRight = NO;
    if (tableView == _deliveryingView) {
        //配送中
        deliveryCell = @"deliveryingCell";
        model = self.deliveryingArray[indexPath.row];
    }else if(tableView == _deliveryDoneView){
        //已配送
        deliveryCell = @"deliveryDoneCell";
        model = self.deliveryDoneArray[indexPath.row];
        _isBottomBtn = YES;
        _showRight = YES;
    }
    SHYTaskCell * cell = [tableView dequeueReusableCellWithIdentifier:deliveryCell];
    if (!cell) {
        cell = [SHYTaskCell.alloc initWithStyle:UITableViewCellStyleDefault reuseIdentifier:deliveryCell labelCount:4 enterBtnIndex:2 bottomBtn:_isBottomBtn];
        [cell.enterBtn setImage:nil forState:UIControlStateNormal];
        [cell.enterBtn setTitle:@"点击查看" forState:UIControlStateNormal];
        cell.enterBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
        
        [cell.startBtn setTitle:@"结束配送" forState:UIControlStateNormal];
    }
    cell.rightIconView.hidden = !_showRight;
    
    [self setContentView:cell model:model];
    
    kWeakSelf(self);
    cell.startBtnClickBlock = ^(SHYDeliveryModel*model){
        [weakself endDeliveryBtn:model];
    };
    cell.enterBtnClickBlock = ^(SHYDeliveryModel*model){
        [weakself clickToSeeOrderDetail:model];
    };
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 180.f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.1f;
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
    [self updateAnnotationDetailViewLocation];
    [self showAnnotationView];
}
/**
 *当选中一个annotation views时，调用此接口
 *@param mapView 地图View
 */
- (void)mapView:(BMKMapView *)mapView didSelectAnnotationView:(BMKAnnotationView *)view {
    [self updateAnnotationDetailViewLocation];
    SHYTaskAnnotationModel *annotation = (SHYTaskAnnotationModel*)view.annotation;
    if ([annotation.title isEqualToString:@"我的位置"]) {
        [self hideAnnotationView];
    }else {
        [self setContentView:_annotationDetailView model:annotation.deliveryModel];
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
        
        if (!self.deliveryingArray.count) {
            [_mapView setCenterCoordinate:_userLocation.location.coordinate animated:NO];
        }
    }
}


#pragma mark -Lazing-
- (UISegmentedControl *)segmentControl{
    if (!_segmentControl) {
        UISegmentedControl * segmentControl = [UISegmentedControl.alloc initWithItems:@[@"配送中",@"已配送"]];
        segmentControl.frame = CGRectMake(0, 0, SCREEN_WIDTH, 49);

        segmentControl.tintColor = COLOR_WHITE;
        [segmentControl setBackgroundImage:[UIImage imageWithColor:COLOR_WHITE] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
        [segmentControl setBackgroundImage:[UIImage imageWithColor:COLOR_WHITE] forState:UIControlStateHighlighted barMetrics:UIBarMetricsDefault];
        [segmentControl setBackgroundImage:[UIImage imageWithColor:COLOR_WHITE] forState:UIControlStateSelected barMetrics:UIBarMetricsDefault];
        [segmentControl setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor],
                                                 NSFontAttributeName:kFont(16)}
                                      forState:UIControlStateNormal];
        [segmentControl setTitleTextAttributes:@{NSForegroundColorAttributeName:NAVI_BACK_COLOR} forState:UIControlStateSelected];
        [segmentControl setDividerImage:[UIImage imageWithColor:LINE_COLOR] forLeftSegmentState:UIControlStateNormal rightSegmentState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
        
        [segmentControl addTarget:self
                           action:@selector(segmentClickItem:)
                 forControlEvents:UIControlEventValueChanged];
        [segmentControl setSelectedSegmentIndex:0];
        
        _segmentControl = segmentControl;
    }
    return _segmentControl;
}

//slide Line View
- (UIView *)segmentLineView {
    if (!_segmentLineView) {
        _segmentLineView = [UIView.alloc initWithFrame:CGRectMake(0, 49, SCREEN_WIDTH/2.f, 1.f)];
        _segmentLineView.backgroundColor = NAVI_BACK_COLOR;
    }
    return _segmentLineView;
}
- (SHYSegmentView *)segmentContentView {
    if (!_segmentContentView) {
        _segmentContentView = [SHYSegmentView.alloc initWithFrame:CGRectMake(0, 50, SCREEN_WIDTH, SCREEN_HEIGHT - kStatusBarH - kNavigationBarH - 50)];
        
        [_segmentContentView setViewArray:@[self.deliveryingView,
                                            self.deliveryDoneView]];
        
        
        kWeakSelf(self);
        _segmentContentView.scrollPageBlock = ^(NSInteger page) {
            [weakself slideAndSegItemSelectedIndex:page];
        };
    }
    return _segmentContentView;
}
- (SHYBaseTableView *)deliveryingView {
    if (!_deliveryingView) {
        _deliveryingView=[SHYBaseTableView.alloc initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, self.segmentContentView.height) style:UITableViewStyleGrouped target:self];
        _deliveryingView.mj_footer = [MJRefreshAutoFooter footerWithRefreshingTarget:self refreshingAction:@selector(transportingDataLoadMore)];
    }
    return _deliveryingView;
}
- (SHYBaseTableView *)deliveryDoneView {
    if (!_deliveryDoneView) {
        _deliveryDoneView = [SHYBaseTableView.alloc initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, self.segmentContentView.height) style:UITableViewStyleGrouped target:self];
        _deliveryDoneView.mj_footer = [MJRefreshAutoFooter footerWithRefreshingTarget:self refreshingAction:@selector(transportDoneDataLoadMore)];
    }
    return _deliveryDoneView;
}
- (NSMutableArray *)deliveryingArray {
    if (!_deliveryingArray) {
        _deliveryingArray = [NSMutableArray array];
    }
    return _deliveryingArray;
}
- (NSMutableArray *)deliveryDoneArray {
    if (!_deliveryDoneArray) {
        _deliveryDoneArray = [NSMutableArray array];
    }
    return _deliveryDoneArray;
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
        _annotationDetailView = [SHYTaskCell.alloc initWithFrame:CGRectZero labelCount:4 enterBtnIndex:2];
        
        _annotationDetailView.layer.cornerRadius=8.f;
        _annotationDetailView.clipsToBounds = YES;
        
        [_annotationDetailView.enterBtn setImage:nil forState:UIControlStateNormal];
        [_annotationDetailView.enterBtn setTitle:@"点击查看" forState:UIControlStateNormal];
        _annotationDetailView.enterBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
        
        [_annotationDetailView.startBtn setTitle:@"结束配送" forState:UIControlStateNormal];
        
        kWeakSelf(self);
        _annotationDetailView.startBtnClickBlock = ^(SHYDeliveryModel * model){
            [weakself endDeliveryBtn:model];
        };
        _annotationDetailView.enterBtnClickBlock = ^(SHYDeliveryModel*model) {
            [weakself clickToSeeOrderDetail:model];
        };
    }
    return _annotationDetailView;
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
