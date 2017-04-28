//
//  SHYGoodsModel.h
//  SongHuoYi
//
//  Created by 王亚龙 on 2017/4/7.
//  Copyright © 2017年 TianXi. All rights reserved.
//

#import "SHYBaseModel.h"

@interface SHYGoodsModel : SHYBaseModel

@property (nonatomic, strong) NSNumber * orderId;
@property (nonatomic, strong) NSNumber * orderItemId;
/**
 商品ID
 */
@property (nonatomic, strong) NSNumber * goodsId;
/**
 商品数量
 */
@property (nonatomic, strong) NSNumber * buyNum;

/**
 实际收箱数量
 */
@property (nonatomic, strong) NSNumber * actualNum;
@property (nonatomic, strong) NSNumber * goodsNum;
/**
 商品名称
 */
@property (nonatomic, strong) NSString * goodsName;
/**
 商品描述
 */
@property (nonatomic, strong) NSString * goodsDesc;

/**
 商品类别
 */
@property (nonatomic, strong) NSString * categoryName;
@property (nonatomic, strong) NSNumber * categoryId;
@property (nonatomic, strong) NSString * goodsBrand;
/**
 规格
 */
@property (nonatomic, strong) NSString * unit;

/**
 商品价格（分）
 */
@property (nonatomic, strong) NSNumber * goodsPrice;
@property (nonatomic, strong) NSNumber * price;

/**
 核货状态
 */
@property (nonatomic, strong) NSNumber * nuclearStatus;

@end
