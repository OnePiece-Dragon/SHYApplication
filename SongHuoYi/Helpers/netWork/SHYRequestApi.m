//
//  SHYRequestApi.m
//  SongHuoYi
//
//  Created by 王亚龙 on 2017/4/27.
//  Copyright © 2017年 TianXi. All rights reserved.
//

#import "SHYRequestApi.h"

@implementation SHYRequestApi

- (void)requestWithMethod:(NSString *)method param:(NSDictionary *)param observer:(id<RequestResultProtocol>)observer {
    [NetManager post:method
               param:param success:^(NSDictionary * _Nonnull responseObj, NSString * _Nonnull failMessag, BOOL code) {
                   [observer fetchResponse:responseObj code:code fail:failMessag];
               } failure:^(NSString * _Nonnull errorStr) {
                   [observer fetchResponse:nil code:NO fail:errorStr];
               }];
}

@end
