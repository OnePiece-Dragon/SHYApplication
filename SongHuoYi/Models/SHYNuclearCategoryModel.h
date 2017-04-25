//
//  SHYNuclearCategoryModel.h
//  SongHuoYi
//
//  Created by 王亚龙 on 2017/4/7.
//  Copyright © 2017年 TianXi. All rights reserved.
//

#import "SHYBaseModel.h"

#import "SHYGoodsModel.h"

@interface SHYNuclearCategoryModel : SHYBaseModel

@property (nonatomic, strong) NSNumber * categoryId;
@property (nonatomic, strong) NSString * categoryName;
@property (nonatomic, strong) NSNumber * goodsTotal;
@property (nonatomic, strong) NSString * wayCategoryName;
@property (nonatomic, strong) NSMutableArray<SHYGoodsModel*> * goods;

/**
 核货状态
 */
@property (nonatomic, strong) NSNumber * nuclearStatus;

@end
