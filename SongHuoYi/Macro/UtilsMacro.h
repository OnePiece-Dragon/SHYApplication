//
//  UtilsMacro.h
//  SongHuoYi
//
//  Created by 王亚龙 on 2017/4/4.
//  Copyright © 2017年 TianXi. All rights reserved.
//

#ifndef UtilsMacro_h
#define UtilsMacro_h

//一些常用的宏定义

//关于尺寸
#define kTabBarH        49.0f
#define kStatusBarH     [UIApplication sharedApplication].statusBarFrame.size.height
#define kNavigationBarH 44.0f

#define SCREEN_POINT (float)SCREEN_WIDTH/375.f
#define SCREEN_H_POINT (float)SCREEN_HEIGHT/667.f

#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)

#define LINE_VER_SPACE  6

//Get the OS version.       判断操作系统版本
#define IOS_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]
#define CurrentSystemVersion ([[UIDevice currentDevice] systemVersion])
#define CurrentLanguage ([[NSLocale preferredLanguages] objectAtIndex:0])

//颜色
#define COLOR_RGB(r,g,b) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]
#define COLOR_A_RGB(r,g,b,a) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]
#define COLOR_Hrex(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]


#define NAVI_BACK_COLOR     COLOR_RGB(29,168,251)
#define BACKGROUND_COLOR    COLOR_RGB(238, 238, 238)
#define LINE_COLOR          COLOR_RGB(221, 221, 221)
#define BUTTON_COLOR        COLOR_RGB(29,168,251)
#define COLOR_WHITE         [UIColor whiteColor]

#define COLOR_ADRESS       COLOR_RGB(57,179,252)
#define COLOR_PRICE         COLOR_RGB(255,131,73)

//字体
#define kFont(A) [UIFont systemFontOfSize:(A)]







#define ImageNamed(_pointer)                [UIImage imageNamed:_pointer]
#define String_Combine(str1,str2)           [NSString stringWithFormat:@"%@%@",str1,str2]


#endif /* UtilsMacro_h */
