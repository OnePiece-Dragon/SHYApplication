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
        [self initialize];
    }
    return self;
}
- (instancetype)initWithTarget:(id)target {
    self.target = target;
    return [self init];
}
- (instancetype)initWithTarget:(id)target view:(id)view model:(id)model {
    return [self initWithTarget:target];
}
- (void)initialize{
    self.responseSignal = [RACSubject subject];
}
- (void)fetchResponse {
    
}

- (void)fetchResponse:(id)responseObj code:(BOOL)code fail:(NSString *)fail {
    if (code) {
        self.successResult = responseObj;
    }else {
        self.failResult = @{@"error":fail};
    }
}

- (SHYRequestApi *)requestBody{
    if (!_requestBody) {
        _requestBody = [SHYRequestApi.alloc init];
    }
    return _requestBody;
}


@end
