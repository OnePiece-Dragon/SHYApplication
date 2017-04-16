//
//  SHYTaskController.h
//  SongHuoYi
//
//  Created by 王亚龙 on 2017/4/6.
//  Copyright © 2017年 TianXi. All rights reserved.
//

#import "SHYBaseController.h"

#import "SHYTaskCell.h"
#import "SHYTaskAnnotationModel.h"

//核货详情
#import "SHYCheckGoodsDetailController.h"

@interface SHYTaskController : SHYBaseController

@property (nonatomic, strong) UIView * orginView;

@property (nonatomic, strong) BMKMapView* mapView;
@property (nonatomic, strong) BMKLocationService * locService;

@property (nonatomic, strong) SHYTaskCell * annotationDetailView;

@property (nonatomic, strong) SHYBaseTableView * taskTableView;
@property (nonatomic, strong) NSMutableArray * dataArray;


@end
