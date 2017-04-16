//
//  NotificationMacro.h
//  SongHuoYi
//
//  Created by 王亚龙 on 2017/4/4.
//  Copyright © 2017年 TianXi. All rights reserved.
//

#ifndef NotificationMacro_h
#define NotificationMacro_h

/**
 *  通知中心
 */
#define NotiCenter [NSNotificationCenter defaultCenter]

#define NOTICENTER_Post(name,__VALUE__) [NotiCenter postNotificationName:name object:__VALUE__]

#define NOTICENTER_Register(sel, notif_name)                    \
if([obj respondsToSelector:sel])                            \
[[NSNotificationCenter defaultCenter]    addObserver:obj    \
selector:sel    \
name:notif_name    \
object:nil        \
];

#endif /* NotificationMacro_h */
