//
//  SHYTaskAnnotationModel.m
//  SongHuoYi
//
//  Created by 王亚龙 on 2017/4/6.
//  Copyright © 2017年 TianXi. All rights reserved.
//

#import "SHYTaskAnnotationModel.h"

@implementation SHYTaskAnnotationModel

- (SHYTaskModel *)taskModel {
    if (!_taskModel) {
        _taskModel = [SHYTaskModel.alloc init];
    }
    return _taskModel;
}
- (SHYDeliveryModel*)deliveryModel {
    if (!_deliveryModel) {
        _deliveryModel = [SHYDeliveryModel.alloc init];
    }
    return _deliveryModel;
}

@end
