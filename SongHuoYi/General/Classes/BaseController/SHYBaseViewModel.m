//
//  SHYBaseViewModel.m
//  SongHuoYi
//
//  Created by 王亚龙 on 2017/4/20.
//  Copyright © 2017年 TianXi. All rights reserved.
//

#import "SHYBaseViewModel.h"

@interface SHYBaseViewModel()



@end

@implementation SHYBaseViewModel

- (instancetype)init {
    if ([super init]) {
        
    }
    return self;
}

- (void)signalRequestUrl:(NSString*)url params:(NSDictionary*)params {
    self.requestCommand = [RACCommand.alloc initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        return [[[NetManager signalRequestUrl:url params:params] map:^id _Nullable(id  _Nullable value) {
            NSLog(@"command_Value:%@",value);
            _responseObject = value;
            return value;
        }] doError:^(NSError * _Nonnull error) {
            _responseError = error;
        }];
    }];
    [self.requestCommand.executionSignals.switchToLatest subscribeNext:^(id  _Nullable x) {
        self.responseObject = x;
        NSLog(@"x:%@",x);
    }];
}

@end
