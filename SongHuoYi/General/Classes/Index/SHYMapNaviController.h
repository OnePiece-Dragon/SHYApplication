//
//  SHYMapNaviController.h
//  SongHuoYi
//
//  Created by 王亚龙 on 2017/4/7.
//  Copyright © 2017年 TianXi. All rights reserved.
//

#import "SHYBaseController.h"
#import "SHYCheckGoodsDetailModel.h"
#import "SHYDeliveryModel.h"

/**
 地图导航
 */
@interface SHYMapNaviController : SHYBaseController

@property (nonatomic, strong) BMKMapView* mapView;
@property (nonatomic, strong) BMKLocationService * locService;

@property (nonatomic, strong) SHYCheckGoodsDetailModel * model;
@property (nonatomic, strong) SHYDeliveryModel * deliverModel;

@end
