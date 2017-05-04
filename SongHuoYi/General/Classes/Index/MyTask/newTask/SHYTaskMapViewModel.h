//
//  SHYTaskMapViewModel.h
//  SongHuoYi
//
//  Created by 王亚龙 on 2017/5/2.
//  Copyright © 2017年 TianXi. All rights reserved.
//

#import "SHYTaskViewModel.h"
#import "SHYTaskAnnotationModel.h"

@interface SHYTaskMapViewModel : SHYTaskViewModel<BMKMapViewDelegate,BMKLocationServiceDelegate>

@property (nonatomic, strong) BMKMapView* mapView;
@property (nonatomic, strong) BMKLocationService * locService;
@property (nonatomic, strong) BMKUserLocation * userLocation;

@property (nonatomic, strong) SHYTaskCell * annotationDetailView;

@property (nonatomic, strong) NSMutableArray * mapAnnotationArray;

- (void)startLocation;

@end
