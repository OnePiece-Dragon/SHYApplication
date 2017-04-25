//
//  TimeManager.m
//  MYChat
//
//  Created by ycd15 on 16/11/3.
//  Copyright © 2016年 YCD_WYL. All rights reserved.
//

#import "TimeManager.h"

@implementation TimeManager

+ (instancetype)shareInstance {
    static TimeManager * manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [TimeManager.alloc init];
    });
    return manager;
}

+ (void)startTime:(CGFloat)count countTime:(void (^)(CGFloat))countTime {
    __block CGFloat originalCount = 0;
    
    dispatch_queue_t queue = dispatch_get_main_queue();
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_time_t start = dispatch_time(DISPATCH_TIME_NOW, 0 * NSEC_PER_SEC);
    dispatch_source_set_timer(timer, start, count * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
    dispatch_source_set_event_handler(timer, ^{
        originalCount += count;
        countTime(originalCount);
    });
    dispatch_resume(timer);
    
    [TimeManager shareInstance].timer = timer;
}

+ (void)cancelTimer {
    if ([TimeManager shareInstance].timer) {
        dispatch_source_cancel([TimeManager shareInstance].timer);
        [TimeManager shareInstance].timer = nil;
    }
}

+ (CGFloat)timeSwitchTimeString:(NSString *)timeString format:(NSString *)format {
    //CGFloat date = [[NSDate date] timeIntervalSince1970];
    //NSString * string = @"2017/04/01 14:02:00";
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:format];//@"yyyy/MM/dd HH:mm:ss"
    //[formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Beijing"];
    [formatter setTimeZone:timeZone];
    NSDate * timeDate = [formatter dateFromString:timeString];
    CGFloat time = [timeDate timeIntervalSince1970];//ss
    return time;
}
+ (NSString *)timeWithTimeIntervalString:(NSString *)timeString format:(NSString*)format
{
    // 格式化时间
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    formatter.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:format];
    
    // 毫秒值转化为秒
    NSDate* date = [NSDate dateWithTimeIntervalSince1970:[timeString doubleValue]];
    NSString* dateString = [formatter stringFromDate:date];
    return dateString;
}

@end
