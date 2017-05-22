//
//  SHYLocationServer.h
//  SongHuoYi
//
//  Created by 王亚龙 on 2017/5/19.
//  Copyright © 2017年 TianXi. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <BaiduTraceSDK/BaiduTraceSDK.h>

@interface SHYLocationServer : NSObject<BTKTraceDelegate, BTKFenceDelegate, BTKTrackDelegate, BTKEntityDelegate, BTKAnalysisDelegate>

@property (nonatomic, strong) BTKStartServiceOption *op;

+(instancetype)shareInstance;


- (void)startServiceWithName:(NSString*)name;
- (void)startGather;

- (void)stopService;
- (void)stopGather;

@end
