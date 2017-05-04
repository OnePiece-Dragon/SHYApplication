//
//  SHYTaskMapViewModel.m
//  SongHuoYi
//
//  Created by 王亚龙 on 2017/5/2.
//  Copyright © 2017年 TianXi. All rights reserved.
//

#import "SHYTaskMapViewModel.h"

@interface SHYTaskMapViewModel()

{
    BOOL _isUserLocation;
    BOOL _mapHaveLoad;
}

@end

@implementation SHYTaskMapViewModel

- (void)initialize {
    [super initialize];
    _mapHaveLoad = NO;
    _isUserLocation = NO;
    kWeakSelf(self);
    
    [self.mapView addSubview:self.annotationDetailView];
    [self.annotationDetailView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakself.mapView).offset(10);
        make.right.equalTo(weakself.mapView).offset(-10);
        make.bottom.equalTo(weakself.mapView);
        make.height.greaterThanOrEqualTo(@250);
    }];
}

- (void)startLocation {
    [self.locService startUserLocationService];
    //以下_mapView为BMKMapView对象
    _mapView.userTrackingMode = BMKUserTrackingModeNone;//设置定位的状态
    _mapView.showsUserLocation = YES;//显示定位图层
}

- (void)setMapAnnotationArray:(NSMutableArray *)mapAnnotationArray {
    if (!mapAnnotationArray.count) {
        _annotationDetailView.hidden = YES;
        return;
    }
    
    NSMutableArray * annotationArray = [NSMutableArray array];
    for (SHYTaskModel *model in self.mapAnnotationArray) {
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
    
    [self setContentView:_annotationDetailView model:self.mapAnnotationArray.firstObject];
    [_mapView setCenterCoordinate:[(SHYTaskAnnotationModel*)_mapView.annotations.firstObject coordinate] animated:NO];
    _annotationDetailView.hidden = NO;
}
- (void)updateAnnotationDetailViewLocation {
    [self.mapView addSubview:self.annotationDetailView];
    kWeakSelf(self);
    [self.annotationDetailView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(weakself.mapView);
    }];
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

#pragma mark -MP_Delegate-
/**
 *地图初始化完毕时会调用此接口
 */
- (void)mapViewDidFinishLoading:(BMKMapView *)mapView {
    _mapHaveLoad = YES;
}
- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[BMKPointAnnotation class]]) {
        BMKPinAnnotationView *newAnnotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"myAnnotation"];
        newAnnotationView.pinColor = BMKPinAnnotationColorRed;
        newAnnotationView.image = ImageNamed(@"dingwei");
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
        _annotationDetailView.hidden = YES;
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
        if (!self.mapAnnotationArray.count) {
            [_mapView setCenterCoordinate:_userLocation.location.coordinate animated:NO];
        }
    }
}

#pragma mark -Lazing-
- (BMKMapView *)mapView {
    if (!_mapView) {
        _mapView = [BMKMapView.alloc init];
        _mapView.delegate = self.target;
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
            [weakself.startBtnSignal sendNext:model];
        };
        _annotationDetailView.enterBtnClickBlock = ^(SHYTaskModel*model) {
            [weakself.enterBtnSignal sendNext:model];
        };
    }
    return _annotationDetailView;
}
@end
