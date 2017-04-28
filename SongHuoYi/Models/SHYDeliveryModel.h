//
//  SHYDeliveryModel.h
//  SongHuoYi
//
//  Created by 王亚龙 on 2017/4/8.
//  Copyright © 2017年 TianXi. All rights reserved.
//

#import "SHYBaseModel.h"
#import "SHYGoodsModel.h"

@interface SHYDeliveryModel : SHYBaseModel

/**
 门店名称,收件人名
 */
@property (nonatomic, strong) NSString * shopName;

/**
 总店名称
 */
@property (nonatomic, strong) NSString * totalShopN;

/**
 门店Id
 */
@property (nonatomic, strong) NSNumber * shopId;

/**
 目标地址
 */
@property (nonatomic, strong) NSString * targetAddr;

/**
 0不显示代收货款不为0显示代收货款及金额
 */
@property (nonatomic, strong) NSNumber * collectMoney;
/**
 订单号
 */
@property (nonatomic, strong) NSNumber * orderId;

/**
 收件人电话
 */
@property (nonatomic, strong) NSNumber * shopPhone;

/**
 总价格
 */
@property (nonatomic, strong) NSNumber * totalMoney;

/**
 goods_Model
 */
@property (nonatomic, strong) NSArray<SHYGoodsModel*> * goods;

@property (nonatomic, strong) NSNumber * dimension;
@property (nonatomic, strong) NSNumber * longitude;

@end
