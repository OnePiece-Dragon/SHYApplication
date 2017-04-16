//
//  AppDelegate.m
//  SongHuoYi
//
//  Created by 王亚龙 on 2017/3/31.
//  Copyright © 2017年 TianXi. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

{
    BMKMapManager* _mapManager;
}

@property (nonatomic, strong, nonnull) NSArray * tabBarArray;


@end

@implementation AppDelegate

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    UserDefaultSetObjectForKey(@"", DeviceToken);
}
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    // 获取deviceToken
    NSLog(@"-------%@",[[[[deviceToken description] stringByReplacingOccurrencesOfString: @"<" withString: @""]                  stringByReplacingOccurrencesOfString: @">" withString: @""]                 stringByReplacingOccurrencesOfString: @" " withString: @""]);
    NSString * deviceTokenString = [[[[deviceToken description] stringByReplacingOccurrencesOfString: @"<" withString: @""]                  stringByReplacingOccurrencesOfString: @">" withString: @""]                 stringByReplacingOccurrencesOfString: @" " withString: @""];
    // 将deviceToken保存在本地
    UserDefaultSetObjectForKey(deviceTokenString, DeviceToken);
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [self.window makeKeyAndVisible];
    
    
    _mapManager = [[BMKMapManager alloc]init];
    // 如果要关注网络及授权验证事件，请设定     generalDelegate参数
    BOOL ret = [_mapManager start:BM_AK generalDelegate:nil];
    if (!ret) {
        DLog(@"manager start failed!");
    }

    self.window.rootViewController = self.tabBarVC;
    
//    if ([UserDefaultObjectForKey(USER_LOGIN_STATUS) intValue] == 1 && [UserDefaultObjectForKey(USER_ISAUTO_LOGIN) intValue] == 1) {
//        //已经登录
//        self.window.rootViewController = self.tabBarVC;
//    }else {
//        SHYLoginModel * loginModel = [SHYLoginModel.alloc init];
//        loginModel.userPhone = UserDefaultObjectForKey(USER_PHONE);
//        loginModel.userPassword = UserDefaultObjectForKey(USER_PASSWORD);
//        loginModel.isAutoLogin = [UserDefaultObjectForKey(USER_ISAUTO_LOGIN) integerValue] == 1 ? YES : NO;
//        [self.loginVC setLoginModel:loginModel];
//        self.window.rootViewController = self.loginVC;
//    }
//    
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}



- (UIWindow *)window {
    if (!_window) {
        _window = [UIWindow.alloc initWithFrame:[UIScreen mainScreen].bounds];
        _window.backgroundColor = [UIColor whiteColor];
    }
    return _window;
}

- (NSArray *)tabBarArray {
    if (!_tabBarArray) {
        _tabBarArray = @[@"SHYIndexController",
                         @"SHYHistoryNoteController",
                         @"SHYPersonCenterController"];
    }
    return _tabBarArray;
}

- (SHYTabBarController *)tabBarVC {
    SHYTabBarController * tabBarVC = [SHYTabBarController tabBar:self.tabBarArray
                                                          titles:@[@"首页",@"历史运单",@"个人中心"]
                                                          images:@[@"shouye",@"lishiyundan1",@"gerenzhongxin1"]
                                                  selectedImages:@[@"shouye2",@"lishiyundan2",@"gerenzhongxin2"]];
    return tabBarVC;
}
- (SHYLoginController *)loginVC {
    if (!_loginVC) {
        SHYLoginController * loginVC = [SHYLoginController.alloc init];
        _loginVC = loginVC;
    }
    return _loginVC;
}

@end
