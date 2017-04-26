//
//  AppDelegate.m
//  SongHuoYi
//
//  Created by 王亚龙 on 2017/3/31.
//  Copyright © 2017年 TianXi. All rights reserved.
//

#import "AppDelegate.h"
#import "LaunchIntroductionView.h"

// iOS10 及以上需导入 UserNotifications.framework
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
#import <UserNotifications/UserNotifications.h>
#endif

@interface AppDelegate ()<GeTuiSdkDelegate, UNUserNotificationCenterDelegate>

{
    BMKMapManager* _mapManager;
}
// 用来判断是否是通过点击通知栏开启（唤醒）APP
@property (nonatomic) BOOL isLaunchedByNotification;
@property (nonatomic, strong, nonnull) NSArray * tabBarArray;


@end

@implementation AppDelegate

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    GCDWithGlobal(^{
        if (!UserDefaultObjectForKey(DeviceToken)) {
            UserDefaultSetObjectForKey(@"", DeviceToken);
        }
    });
}
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    // 获取deviceToken
    NSString *deviceTokenString = [[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    deviceTokenString = [deviceTokenString stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSLog(@"tokentoken:%@",deviceTokenString);
    // 向个推服务器注册deviceToken
    [GeTuiSdk registerDeviceToken:deviceTokenString];
    
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.isLaunchedByNotification = YES;
    // Override point for customization after application launch.
    [self.window makeKeyAndVisible];
    
    [GeTuiSdk startSdkWithAppId:kGtAppId appKey:kGtAppKey appSecret:kGtAppSecret delegate:self];
    //[GeTuiSdk runBackgroundEnable:YES];

    
    [self registerRemoteNotification];
    
    _mapManager = [[BMKMapManager alloc]init];
    // 如果要关注网络及授权验证事件，请设定     generalDelegate参数
    BOOL ret = [_mapManager start:BM_AK generalDelegate:nil];
    if (!ret) {
        DLog(@"manager start failed!");
    }
    
    //键盘
    [IQKeyboardManager sharedManager].enable = YES;
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
    
    if ([UserDefaultObjectForKey(USER_LOGIN_STATUS) intValue] == 1 && [UserDefaultObjectForKey(USER_ISAUTO_LOGIN) intValue] == 1) {
        SHYUserModel *model = UnArchiveObjWithData(UserDefaultObjectForKey(USER_MESSAGE));
        SHYUserModel *newModel = [SHYUserModel shareUserMsg];
        [newModel mj_setKeyValues:model.mj_keyValues];
        //已经登录
        self.window.rootViewController = self.tabBarVC;
    }else {
        [self.loginVC setLoginModel:self.loginModel];
        
        self.window.rootViewController = self.loginVC;
    }
    
    
    LaunchIntroductionView * launchView = [LaunchIntroductionView sharedWithImages:@[@"lunbo1",@"lunbo2",@"lunbo3"] buttonImage:@"dianjijinru" buttonFrame:CGRectMake(kScreen_width/2 - 551/4, kScreen_height - 120*SCREEN_POINT, 551/2, 45)];
    launchView.currentColor = [UIColor orangeColor];
    launchView.nomalColor = [UIColor grayColor];
    
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
/*
- (void)application:(UIApplication *)application performFetchWithCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    /// Background Fetch 恢复SDK 运行
    [GeTuiSdk resume];
    completionHandler(UIBackgroundFetchResultNewData);
}
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    // 将收到的APNs信息传给个推统计
    [GeTuiSdk handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
    
    self.isLaunchedByNotification = YES;
}*/


#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0

//  iOS 10: App在前台获取到通知
- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler {
    
    NSLog(@"willPresentNotification：%@", notification.request.content.userInfo);
    
    // 根据APP需要，判断是否要提示用户Badge、Sound、Alert
    completionHandler(UNNotificationPresentationOptionBadge | UNNotificationPresentationOptionSound | UNNotificationPresentationOptionAlert);
}

//  iOS 10: 点击通知进入App时触发，在该方法内统计有效用户点击数
- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    
    NSLog(@"didReceiveNotification：%@", response.notification.request.content.userInfo);
    
    // [ GTSdk ]：将收到的APNs信息传给个推统计
    [GeTuiSdk handleRemoteNotification:response.notification.request.content.userInfo];
    
    completionHandler();
}
#endif
- (void)GeTuiSdkDidReceivePayloadData:(NSData *)payloadData andTaskId:(NSString *)taskId andMsgId:(NSString *)msgId andOffLine:(BOOL)offLine fromGtAppId:(NSString *)appId {
    NSString *payloadMsg = nil;
    if (payloadData) {
        payloadMsg = [[NSString alloc] initWithBytes:payloadData.bytes
                                              length:payloadData.length
                                            encoding:NSUTF8StringEncoding];
    }
    NSLog(@"Payload Msg:%@", payloadMsg);
    // 汇报个推自定义事件
    //[GeTuiSdk sendFeedbackMessage:90001 taskId:taskId msgId:msgId];
}
- (void)GeTuiSdkDidSendMessage:(NSString *)messageId result:(int)result {
    NSLog(@"Payload Msh :%@",messageId);
}

/** SDK启动成功返回cid */
- (void)GeTuiSdkDidRegisterClient:(NSString *)clientId {
    //个推SDK已注册，返回clientId
    NSLog(@"\n>>>[GeTuiSdk RegisterClient]:%@\n\n", clientId);
    GCDWithGlobal(^{
        // 将deviceToken保存在本地
        UserDefaultSetObjectForKey(clientId, DeviceToken);
    });
}

/** SDK遇到错误回调 */
- (void)GeTuiSdkDidOccurError:(NSError *)error {
    //个推错误报告，集成步骤发生的任何错误都在这里通知，如果集成后，无法正常收到消息，查看这里的通知。
    NSLog(@"\n>>>[GexinSdk error]:%@\n\n", [error localizedDescription]);
    GCDWithGlobal(^{
        // 将deviceToken保存在本地
        UserDefaultSetObjectForKey(@"", DeviceToken);
    });
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    UserDefaultSetObjectForKey(ArchivedDataWithObject([SHYUserModel shareUserMsg]), USER_MESSAGE);
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
- (SHYLoginModel *)loginModel {
    SHYLoginModel * loginModel = [SHYLoginModel.alloc init];
    loginModel.userPhone = UserDefaultObjectForKey(USER_PHONE);
    loginModel.userPassword = UserDefaultObjectForKey(USER_PASSWORD);
    loginModel.isAutoLogin = [UserDefaultObjectForKey(USER_ISAUTO_LOGIN) integerValue] == 1 ? YES : NO;
    return loginModel;
}
/** 注册 APNs */
- (void)registerRemoteNotification {
    /*
     警告：Xcode8 需要手动开启"TARGETS -> Capabilities -> Push Notifications"
     */
    
    /*
     警告：该方法需要开发者自定义，以下代码根据 APP 支持的 iOS 系统不同，代码可以对应修改。
     以下为演示代码，注意根据实际需要修改，注意测试支持的 iOS 系统都能获取到 DeviceToken
     */
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 10.0) {
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0 // Xcode 8编译会调用
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        center.delegate = self;
        [center requestAuthorizationWithOptions:(UNAuthorizationOptionBadge | UNAuthorizationOptionSound | UNAuthorizationOptionAlert | UNAuthorizationOptionCarPlay) completionHandler:^(BOOL granted, NSError *_Nullable error) {
            if (!error) {
                NSLog(@"request authorization succeeded!");
            }
        }];
        
        [[UIApplication sharedApplication] registerForRemoteNotifications];
#else // Xcode 7编译会调用
        UIUserNotificationType types = (UIUserNotificationTypeAlert | UIUserNotificationTypeSound | UIUserNotificationTypeBadge);
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:types categories:nil];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
#endif
    } else if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        UIUserNotificationType types = (UIUserNotificationTypeAlert | UIUserNotificationTypeSound | UIUserNotificationTypeBadge);
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:types categories:nil];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    } else {
        UIRemoteNotificationType apn_type = (UIRemoteNotificationType)(UIRemoteNotificationTypeAlert |
                                                                       UIRemoteNotificationTypeSound |
                                                                       UIRemoteNotificationTypeBadge);
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:apn_type];
    }
}
-(void)dealloc{
    [GeTuiSdk destroy];
}
@end
