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

- (void)fetchResponse {
    
}

- (void)fetchResponse:(id)responseObj code:(BOOL)code fail:(NSString *)fail {
    self.successResult = responseObj;
}

- (SHYRequestApi *)requestBody{
    if (!_requestBody) {
        _requestBody = [SHYRequestApi.alloc init];
    }
    return _requestBody;
}


@end
