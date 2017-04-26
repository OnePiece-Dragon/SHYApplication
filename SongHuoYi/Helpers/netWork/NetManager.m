
//
//  NetManager.m
//  SongHuoYi
//
//  Created by 王亚龙 on 2017/4/4.
//  Copyright © 2017年 TianXi. All rights reserved.
//

#import "NetManager.h"

@implementation NetManager

//HTTP manager
+ (AFHTTPSessionManager*)manager {
    //NSURLSessionConfiguration * config = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFHTTPSessionManager * manager = [AFHTTPSessionManager.alloc initWithBaseURL:[NSURL URLWithString:[[NetClient shareClient] getUrl:POST]]];
    //AFHTTPResponseSerializer * responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"application/xml",@"text/html",@"text/json",@"text/javascript",@"text/plain",nil];
    manager.requestSerializer.timeoutInterval = 15.0;
    return manager;
}

+(void)get:(NSString *)method
     param:(NSDictionary *)param
   success:(void(^)(NSURLSessionDataTask* _Nonnull task,id _Nullable responseObject))success
   failure:(void(^)(NSURLSessionDataTask*_Nullable task,NSError*_Nonnull error))failure{
    [[NetManager manager] GET:method parameters:param progress:nil success:success failure:failure];
}


+ (void)post:(nonnull NSString *)method
       param:(nonnull NSDictionary *)param
    progress:(void (^)(NSProgress * _Nonnull))uploadProgress
     success:(void(^)(NSURLSessionDataTask* _Nonnull task,id _Nullable responseObject))success
     failure:(void(^)(NSURLSessionDataTask*_Nullable task,NSError*_Nonnull error))failure{
    [[NetManager manager] POST:method parameters:param progress:uploadProgress success:success failure:failure];
}

+ (void)post:(NSString *)method
       param:(NSDictionary *)param
     success:(nonnull void(^)(NSDictionary*_Nonnull responseObj,NSString * _Nonnull failMessag,BOOL code))success
     failure:(nonnull void(^)(NSString* _Nonnull errorStr))failure {
    [[NetManager manager] POST:method
                    parameters:param
                      progress:nil
                       success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                           BOOL s_code = NO;
                           NSString * faileString = nil;
                           NSDictionary * response = nil;
                           if ([responseObject[@"errcode"] integerValue] == 0) {
                               s_code = YES;
                               if ([responseObject[@"errcode"] isEqualToString:@"sys.error"]) {
                                   s_code = NO;
                               }
                           }
                           if (responseObject[@"errmsg"] && ![responseObject[@"errmsg"] isEqual:[NSNull null]]) {
                               faileString = responseObject[@"errmsg"];
                           }
                           if (![responseObject[@"data"] isEqual:[NSNull null]]){
                               response = responseObject[@"data"];
                           }
                           success(response,faileString,s_code);
                           /*
                           if ([responseObject[@"errcode"] integerValue] == 0) {
                               if ([responseObject[@"data"] isEqual:[NSNull null]]) {
                                   success(nil,nil,YES);
                               }else {
                                   success(responseObject[@"data"],nil,YES);
                               }
                           }else {
                               NSString * errMsg = nil;
                               if (responseObject[@"errmsg"] && ![responseObject[@"errmsg"] isEqual:[NSNull null]]) {
                                   errMsg = responseObject[@"errmsg"];
                               }
                               success(@{FAIL_REQUEST:errMsg},NO);
                           }*/
                       } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                           if ([error.userInfo[@"NSLocalizedDescription"] isEqualToString:@"The request timed out."]) {
                               failure(@"服务器连接超时");
                           }else {
                               failure(NET_ERROR_TIP);
                           }
                       }];
}

+ (RACSignal *)signalRequestUrl:(NSString *)url params:(NSDictionary *)params {
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        [NetManager post:url param:params progress:^(NSProgress * _Nonnull progress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            [subscriber sendNext:responseObject];
            [subscriber sendCompleted];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [subscriber sendError:error];
        }];
        return [RACDisposable disposableWithBlock:^{
            
        }];
    }];
}

@end
