//
//  SHYLoginViewModel.m
//  SongHuoYi
//
//  Created by 王亚龙 on 2017/4/18.
//  Copyright © 2017年 TianXi. All rights reserved.
//

#import "SHYLoginViewModel.h"

@implementation SHYLoginViewModel

- (instancetype)init {
    if ([super init]) {
        [self initialize];
    }
    return self;
}

- (void)initialize {
    self.usernameSignal = [RACObserve(self, userName) map:^id _Nullable(id  _Nullable value) {
        return @([(NSString*)value length] >= 6);
    }];
    self.passwordSignal = [RACObserve(self, password) map:^id _Nullable(id  _Nullable value) {
        return @([(NSString*)value length] >= 6);
    }];
    self.valueSignal = [RACSignal combineLatest:@[_usernameSignal,_passwordSignal] reduce:^id (NSNumber *userName,NSNumber *passWord){
        return @(userName.integerValue && passWord.integerValue);
    }];
    [self.loginBtnSignal subscribeNext:^(id  _Nullable x) {
        NSLog(@"button_x:%@",x);
    }];
}



@end
