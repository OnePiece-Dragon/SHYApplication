//
//  SHYBaseViewModel.h
//  SongHuoYi
//
//  Created by 王亚龙 on 2017/4/20.
//  Copyright © 2017年 TianXi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SHYRequestApi.h"

typedef void(^RequestStatus)(BOOL status);

@interface SHYBaseViewModel : NSObject<RequestResultProtocol>


@property (nonatomic, strong) SHYRequestApi<RequestProtocol> * requestBody;

@property (nonatomic, strong) NSDictionary * successResult;
@property (nonatomic, strong) NSDictionary * failResult;

- (void)initialize;
- (void)fetchResponse;

@end
