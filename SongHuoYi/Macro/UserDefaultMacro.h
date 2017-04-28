//
//  UserDefaultMacro.h
//  SongHuoYi
//
//  Created by 王亚龙 on 2017/4/4.
//  Copyright © 2017年 TianXi. All rights reserved.
//

#ifndef UserDefaultMacro_h
#define UserDefaultMacro_h

#import "SHYUserModel.h"

#define USER_MODEL          [SHYUserModel shareUserMsg]
#define USER_ID             [[SHYUserModel shareUserMsg] userId]
#define USER_WORK_STATUS    [[SHYUserModel shareUserMsg] status]
#define USER_WORK_TIME      @"work_time"

#define DeviceToken         @"DeviceToken"
#define USER_LOGIN_STATUS   @"1"
#define USER_PHONE          @"user_phone"
#define USER_PASSWORD       @"user_password"
#define USER_ISAUTO_LOGIN   @"user_auto_login"

#define USER_MESSAGE        @"usere_login_message"


/**
 *  the saving objects      存储对象
 *
 *  @param __VALUE__ V
 *  @param __KEY__   K
 *
 *  @return
 */
#define UserDefaultSetObjectForKey(__VALUE__,__KEY__) \
{\
[[NSUserDefaults standardUserDefaults] setObject:__VALUE__ forKey:__KEY__];\
[[NSUserDefaults standardUserDefaults] synchronize];\
}


/**
 *  get the saved objects       获得存储的对象
 */
#define UserDefaultObjectForKey(__KEY__)        [[NSUserDefaults standardUserDefaults] objectForKey:__KEY__]

/**
 *  delete objects      删除对象
 */
#define UserDefaultRemoveObjectForKey(__KEY__) \
{\
[[NSUserDefaults standardUserDefaults] removeObjectForKey:__KEY__];\
[[NSUserDefaults standardUserDefaults] synchronize];\
}

//归档和解档
#define ArchivedDataWithObject(__VALUE__)       [NSKeyedArchiver archivedDataWithRootObject:__VALUE__]
#define UnArchiveObjWithData(__VALUE__)         [NSKeyedUnarchiver unarchiveObjectWithData:__VALUE__]


#endif /* UserDefaultMacro_h */
