//
//  SHYLocationServer.m
//  SongHuoYi
//
//  Created by 王亚龙 on 2017/5/19.
//  Copyright © 2017年 TianXi. All rights reserved.
//

#import "SHYLocationServer.h"

@implementation SHYLocationServer

+ (instancetype)shareInstance{
    static SHYLocationServer * instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [SHYLocationServer.alloc init];
    });
    return instance;
}

- (instancetype)init{
    if ([super init]) {
        BTKServiceOption *sop = [[BTKServiceOption alloc] initWithAK:BM_AK mcode:BM_MCODE serviceID:BM_SERVICE_ID.integerValue keepAlive:false];
        [[BTKAction sharedInstance] initInfo:sop];
    }
    return self;
}

- (void)startServiceWithName:(NSString*)name{
    self.op = [[BTKStartServiceOption alloc] initWithEntityName:name];
    [[BTKAction sharedInstance] startService:self.op delegate:self];
}
- (void)stopService{
    [[BTKAction sharedInstance] stopService:self];
}


- (void)startGather{
     [[BTKAction sharedInstance] startGather:self];
}
- (void)stopGather{
    [[BTKAction sharedInstance] stopGather:self];
}

#pragma mark -delegate-

-(void)onStartService:(BTKServiceErrorCode)error {
    NSLog(@"start service response: %lu", (unsigned long)error);
}

-(void)onStopService:(BTKServiceErrorCode)error {
    NSLog(@"stop service response: %lu", (unsigned long)error);
}

-(void)onStartGather:(BTKGatherErrorCode)error {
    NSLog(@"start gather response: %lu", (unsigned long)error);
}

-(void)onStopGather:(BTKGatherErrorCode)error {
    NSLog(@"stop gather response: %lu", (unsigned long)error);
}

-(void)onChangeGatherAndPackIntervals:(BTKChangeIntervalErrorCode)error {
    NSLog(@"change gather and pack intervals response: %lu", (unsigned long)error);
}

@end
