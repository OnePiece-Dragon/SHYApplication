//
//  SHYTabBarController.h
//  SongHuoYi
//
//  Created by 王亚龙 on 2017/4/4.
//  Copyright © 2017年 TianXi. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SHYTabBar.h"
#import "SHYTabBarItem.h"

#import "SHYNaviController.h"
#import "SHYNavigtionBar.h"

@interface SHYTabBarController : UITabBarController

+ (instancetype)tabBar:(NSArray*)tabBarArray
                titles:(NSArray *)titles
                images:(NSArray *)images
        selectedImages:(NSArray *)selectedImages;

@end
