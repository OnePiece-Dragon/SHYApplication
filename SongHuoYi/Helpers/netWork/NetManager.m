
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

@end
