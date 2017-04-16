//
//  SHYMapNaviController.m
//  SongHuoYi
//
//  Created by 王亚龙 on 2017/4/7.
//  Copyright © 2017年 TianXi. All rights reserved.
//

#import "SHYMapNaviController.h"

@interface SHYMapNaviController ()<BMKMapViewDelegate,BMKLocationServiceDelegate>

{
    BOOL _isUserLocation;
}

@end

@implementation SHYMapNaviController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.naviTitle = @"地图导航";
    _isUserLocation = NO;
    
    [self.view addSubview:self.mapView];
    [self.locService startUserLocationService];
    _mapView.userTrackingMode = BMKUserTrackingModeNone;//设置定位的状态
    _mapView.showsUserLocation = YES;//显示定位图层
    
    BMKPointAnnotation* annotation = [[BMKPointAnnotation alloc]init];
    CLLocationCoordinate2D coor;
    
    if (_model) {
        coor.latitude = [_model.dimension floatValue];
        coor.longitude = [_model.longitude floatValue];
        annotation.title = _model.lineName;
    }else if(_deliverModel){
        coor.latitude = [_deliverModel.latitude floatValue];
        coor.longitude = [_deliverModel.longitude floatValue];
        annotation.title = _deliverModel.shopName;
    }
    
    annotation.coordinate = coor;
    
    [_mapView addAnnotation:annotation];
}


#pragma mark -MP_Delegate-
/**
 *地图初始化完毕时会调用此接口
 */
- (void)mapViewDidFinishLoading:(BMKMapView *)mapView {

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
}
/**
 *当选中一个annotation views时，调用此接口
 *@param mapView 地图View
 */
- (void)mapView:(BMKMapView *)mapView didSelectAnnotationView:(BMKAnnotationView *)view {
    
}
/**
 *点中底图空白处会回调此接口
 *@param coordinate 空白处坐标点的经纬度
 */
- (void)mapView:(BMKMapView *)mapView onClickedMapBlank:(CLLocationCoordinate2D)coordinate {
    DLog(@"点中底图空白处会回调此接口");
}

#pragma mark -BMKLocationServiceDelegate-
//实现相关delegate 处理位置信息更新
//处理方向变更信息
- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation
{
    //NSLog(@"heading is %@",userLocation.heading);
    [_mapView updateLocationData:userLocation];
}
//处理位置坐标更新
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    //NSLog(@"didUpdateUserLocation lat %f,long %f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
    [_mapView updateLocationData:userLocation];
    if (!_isUserLocation) {
        _isUserLocation = !_isUserLocation;
        [_mapView setCenterCoordinate:userLocation.location.coordinate animated:NO];
    }
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
