//
//  SHYCategoryModel.h
//  SongHuoYi
//
//  Created by 王亚龙 on 2017/4/10.
//  Copyright © 2017年 TianXi. All rights reserved.
//

#import "SHYBaseModel.h"
#import "SHYGoodsModel.h"
@interface SHYCategoryModel : SHYBaseModel

/**
 类别id
 */
@property (nonatomic, strong) NSNumber * categoryId;

/**
 箱
 */
@property (nonatomic, strong) NSString * unit;

/**
 商品数量
 */
@property (nonatomic, strong) NSNumber * goodsTotal;
@property (nonatomic, strong) NSArray * goods;

@end
