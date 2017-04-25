//
//  AppDelegate.h
//  SongHuoYi
//
//  Created by 王亚龙 on 2017/3/31.
//  Copyright © 2017年 TianXi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SHYTabBarController.h"
#import "SHYLoginController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic, strong) SHYTabBarController * tabBarVC;
@property (nonatomic, strong) SHYLoginController * loginVC;

@end

