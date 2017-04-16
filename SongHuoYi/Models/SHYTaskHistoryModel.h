//
//  SHYTaskHistoryModel.h
//  SongHuoYi
//
//  Created by 王亚龙 on 2017/4/10.
//  Copyright © 2017年 TianXi. All rights reserved.
//

#import "SHYBaseModel.h"
#import "SHYCategoryModel.h"
@interface SHYTaskHistoryModel : SHYBaseModel


/**
 任务单号
 */
@property (nonatomic, strong) NSNumber * taskId;

/**
 线路名称
 */
@property (nonatomic, strong) NSString * lineName;

/**
 商品名称
 */
@property (nonatomic, strong) NSString * goodsName;

/**
 运单状态 0 未退货 1 直送
 */
@property (nonatomic, strong) NSNumber * status;

/**
 收件人名
 */
@property (nonatomic, strong) NSString * shopName;

/**
 目标地址
 */
@property (nonatomic, strong) NSString * targetAddr;

/**
 当前时间
 */
@property (nonatomic, strong) NSNumber * currentTime;

@property (nonatomic, strong) NSArray<SHYCategoryModel*> * category;

@end
