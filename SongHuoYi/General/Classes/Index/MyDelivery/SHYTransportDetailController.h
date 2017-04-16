//
//  SHYTransportDetailController.h
//  SongHuoYi
//
//  Created by 王亚龙 on 2017/4/8.
//  Copyright © 2017年 TianXi. All rights reserved.
//

#import "SHYBaseController.h"
#import "SHYTaskCell.h"
#import "SHYGoodsDetailCell.h"
#import "SHYDeliveryModel.h"

@interface SHYTransportDetailController : SHYBaseController

@property (nonatomic, strong) SHYTaskCell * headerDetailView;
@property (nonatomic, strong) SHYDeliveryModel * deliveryDetailModel;

@property (nonatomic, strong) SHYBaseTableView * deliveryDetailView;
@property (nonatomic, strong) NSMutableArray<SHYGoodsModel*> * dataArray;

@end
