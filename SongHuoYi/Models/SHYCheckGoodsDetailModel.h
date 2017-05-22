//
//  SHYCheckGoodsDetailModel.h
//  SongHuoYi
//
//  Created by 王亚龙 on 2017/4/7.
//  Copyright © 2017年 TianXi. All rights reserved.
//

#import "SHYBaseModel.h"

/**
 核货详情
 */
@interface SHYCheckGoodsDetailModel : SHYBaseModel


/**
 任务单号
 */
@property (nonatomic, strong) NSNumber * taskId;
/**
 始发地
 */
@property (nonatomic, strong) NSString * startAddr;
/**
 线路id
 */
@property (nonatomic, strong) NSNumber * lineId;
/**
 线路名称
 */
@property (nonatomic, strong) NSString * lineName;
/**
 类别数量
 */
@property (nonatomic, strong) NSNumber * categoryNum;
/**
 商户数量
 */
@property (nonatomic, strong) NSNumber * merchantNum;
/**
 任务详细共计
 */
@property (nonatomic, strong) NSNumber * taskDetail;
/**
 预计时间
 */
@property (nonatomic, strong) NSNumber * expectTime;
/**
 0 不显示代收货款 不为0显示代收货款及金额
 */
@property (nonatomic, strong) NSNumber * collectMoney;
/**
 寄件人地址
 */
@property (nonatomic, strong) NSString * senderAddr;
@property (nonatomic, strong) NSNumber * senderPhone;
@property (nonatomic, strong) NSString * senderName;

/**
 寄件人id
 */
@property (nonatomic, strong) NSNumber * senderId;

@property (nonatomic, strong) NSNumber * longitude;
@property (nonatomic, strong) NSNumber * dimension;

@end
