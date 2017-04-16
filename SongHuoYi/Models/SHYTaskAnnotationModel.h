//
//  SHYTaskAnnotationModel.h
//  SongHuoYi
//
//  Created by 王亚龙 on 2017/4/6.
//  Copyright © 2017年 TianXi. All rights reserved.
//

#import "AppMacro.h"
#import "SHYTaskModel.h"
#import "SHYDeliveryModel.h"

@interface SHYTaskAnnotationModel : BMKPointAnnotation

@property (nonatomic, strong) SHYTaskModel * taskModel;

@property (nonatomic, strong) SHYDeliveryModel * deliveryModel;

@end
