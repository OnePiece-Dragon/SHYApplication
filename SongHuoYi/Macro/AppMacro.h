//
//  AppMacro.h
//  SongHuoYi
//
//  Created by 王亚龙 on 2017/4/4.
//  Copyright © 2017年 TianXi. All rights reserved.
//

#ifndef AppMacro_h
#define AppMacro_h


#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
//文件引用
#import "VendorMacro.h"
#import "UtilsMacro.h"
#import "NotificationMacro.h"
#import "UserDefaultMacro.h"
#import "UrlMacro.h"


#import "AppDelegate.h"
#import "CustomLabel.h"

#import "TimeManager.h"
#import "SHYCategories.h"

#import "NetManager.h"
#import "Factory.h"

#import "SHYBaseViewModel.h"

#define APP_DELEGATE (AppDelegate*)[UIApplication sharedApplication].delegate

//Using dlog to print while in debug model.        调试状态下打印日志
#ifdef DEBUG
#define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#define NSLog(...) NSLog(__VA_ARGS__)
#else
#define DLog(...)
#define NSLog(...)  {}
#endif


//获取沙盒Document路径
#define kDocumentPath [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject]
#define kTempPath NSTemporaryDirectory()
#define kCachePath [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject]


#define PLIST_Name(name) [[NSBundle mainBundle] pathForResource:name ofType:@"plist"]

//强弱引用
#define kWeakSelf(type)  __weak typeof(type) weak##type = type;
#define kStrongSelf(type) __strong typeof(type) type = weak##type;


//GCD
#define GCDWithGlobal(block) dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), block)
#define GCDWithMain(block) dispatch_async(dispatch_get_main_queue(),block)




#endif /* AppMacro_h */
