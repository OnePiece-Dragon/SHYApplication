//
//  SHYTaskModel.h
//  SongHuoYi
//
//  Created by 王亚龙 on 2017/4/6.
//  Copyright © 2017年 TianXi. All rights reserved.
//

#import "SHYBaseModel.h"

@interface SHYTaskModel : SHYBaseModel


/**
 任务单号
 */
@property (nonatomic, strong) NSNumber * tasksId;
@property (nonatomic, strong) NSString * taskCode;

/**
 线路id
 */
@property (nonatomic, strong) NSNumber * lineId;
@property (nonatomic, strong) NSString * lineCode;

/**
 线路名称
 */
@property (nonatomic, strong) NSString * lineName;

/**
 始发地
 */
@property (nonatomic, strong) NSString * startAddr;
@property (nonatomic, strong) NSString * targetAddr;
@property (nonatomic, strong) NSNumber * dimension;
@property (nonatomic, strong) NSNumber * longitude;

/**
 商品描述
 */
@property (nonatomic, strong) NSNumber * orderNum;
//商品数
@property (nonatomic, strong) NSNumber * totalNum;

/**
 商品数量
 */
@property (nonatomic, strong) NSNumber * merchantNum;

/**
 任务详细共计
 */
@property (nonatomic, strong) NSString * taskDetail;

/**
 预计时间
 */
@property (nonatomic, strong) NSNumber * expectTime;

/**
 核货状态 0 未核货 1 核货完成 2  未配送 3 配送中 4   配送完成
 */
@property (nonatomic, strong) NSNumber * nuclearStatus;

@end
