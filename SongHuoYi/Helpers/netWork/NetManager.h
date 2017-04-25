//
//  NetManager.h
//  SongHuoYi
//
//  Created by 王亚龙 on 2017/4/4.
//  Copyright © 2017年 TianXi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ReactiveObjC/ReactiveObjC.h>
#import "NetClient.h"
#import "UrlMacro.h"
//@"http://127.0.0.1"
#define BaseUrl BASE_URL

#define FAIL_REQUEST    @"fail"

@interface NetManager : NSObject

+ (nonnull RACSignal *)signalRequestUrl:(nonnull NSString *)url params:(nonnull NSDictionary *)params;

+(void)get:(nonnull NSString *)method
     param:(nonnull NSDictionary *)param
   success:(nonnull void(^)(NSURLSessionDataTask* _Nonnull task,id _Nullable responseObject))success
   failure:(nonnull void(^)(NSURLSessionDataTask*_Nullable task,NSError*_Nonnull error))failure;

+ (void)post:(nonnull NSString *)method
       param:(nonnull NSDictionary *)param
    progress:(nonnull void (^)(NSProgress * _Nonnull))uploadProgress
     success:(nonnull void(^)(NSURLSessionDataTask* _Nonnull task,id _Nullable responseObject))success
     failure:(nonnull void(^)(NSURLSessionDataTask*_Nullable task,NSError*_Nonnull error))failure;

+ (void)post:(nonnull NSString *)method
       param:(nonnull NSDictionary *)param
     success:(nonnull void(^)(NSDictionary*_Nonnull responseObj,NSString * _Nonnull failMessag,BOOL code))success
     failure:(nonnull void(^)(NSString* _Nonnull errorStr))failure;

@end
