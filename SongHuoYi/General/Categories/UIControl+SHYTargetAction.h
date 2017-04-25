//
//  UIControl+SHYTargetAction.h
//  SongHuoYi
//
//  Created by 王亚龙 on 2017/4/18.
//  Copyright © 2017年 TianXi. All rights reserved.
//

#import <UIKit/UIKit.h>

static const char * UIControl_acceptEventInterval= "UIControl_acceptEventInterval";
static const char * UIControl_ignoreEventTime = "UIControl_acceptEventTime";

@interface UIControl (SHYTargetAction)

@property (nonatomic, assign) NSTimeInterval action_acceptEventInterval;

@end
