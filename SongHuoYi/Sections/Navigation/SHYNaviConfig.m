//
//  SHYNaviConfig.m
//  SongHuoYi
//
//  Created by 王亚龙 on 2017/4/5.
//  Copyright © 2017年 TianXi. All rights reserved.
//

#import "SHYNaviConfig.h"

@implementation SHYNaviConfig

+ (void)naviConfig {
    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageWithColor:NAVI_BACK_COLOR] forBarMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setTintColor:COLOR_WHITE];
}

@end
