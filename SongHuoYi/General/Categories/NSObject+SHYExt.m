//
//  NSObject+SHYExt.m
//  SongHuoYi
//
//  Created by 王亚龙 on 2017/4/19.
//  Copyright © 2017年 TianXi. All rights reserved.
//

#import "NSObject+SHYExt.h"

@implementation NSObject (SHYExt)

- (BOOL)isNull {
    if ([self isEqual:[NSNull null]]) {
        return YES;
    }
    return NO;
}

@end
