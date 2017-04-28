//
//  SHYRequestApi.h
//  SongHuoYi
//
//  Created by 王亚龙 on 2017/4/27.
//  Copyright © 2017年 TianXi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RequestProtocol.h"

@interface SHYRequestApi : NSObject<RequestProtocol>

- (void)requestWithMethod:(NSString *)method
                    param:(NSDictionary *)param
                 observer:(id<RequestResultProtocol>)observer;

@end
