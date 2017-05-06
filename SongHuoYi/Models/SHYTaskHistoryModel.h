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
@property (nonatomic, strong) NSString * taskCode;
/**
 线路名称
 */
@property (nonatomic, strong) NSString * lineName;
@property (nonatomic, strong) NSNumber * lineId;
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
@property (nonatomic, strong) NSNumber * shopId;


/**
 目标地址
 */
@property (nonatomic, strong) NSString * targetAddr;
@property (nonatomic, strong) NSString * startAddr;


/**
 当前时间
 */
@property (nonatomic, strong) NSNumber * currentTime;
@property (nonatomic, strong) NSString * exceptTime;
@property (nonatomic, strong) NSString * gmtModifly;
@property (nonatomic, strong) NSArray * category;

//取件任务数
@property (nonatomic, strong) NSNumber * orderNum;
//商户数量
@property (nonatomic, strong) NSNumber * merchantNum;


@property (nonatomic, strong) NSString * taskDetail;

@property (nonatomic, strong) NSString * senderName;
@property (nonatomic, strong) NSNumber * senderPhone;
@property (nonatomic, strong) NSString * senderAddr;

@property (nonatomic, strong) NSNumber * collectMoney;

@end
