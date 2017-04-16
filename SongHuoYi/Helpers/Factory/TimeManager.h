//
//  TimeManager.h
//  MYChat
//
//  Created by ycd15 on 16/11/3.
//  Copyright © 2016年 YCD_WYL. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface TimeManager : NSObject

@property (nonatomic, strong) dispatch_source_t timer;

+ (instancetype)shareInstance;

+ (void)startTime:(CGFloat)count countTime:(nullable void(^)(CGFloat))countTime;
+ (void)cancelTimer;


+(CGFloat)timeSwitchTimeString:(nullable NSString*)timeString format:(nullable NSString*)format;
+ (nullable NSString *)timeWithTimeIntervalString:(nullable NSString *)timeString format:(nullable NSString*)format;

@end
