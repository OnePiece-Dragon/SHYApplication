//
//  SHYUserModel.h
//  SongHuoYi
//
//  Created by 王亚龙 on 2017/4/5.
//  Copyright © 2017年 TianXi. All rights reserved.
//

#import "SHYBaseModel.h"

@interface SHYUserModel : SHYBaseModel<NSCoding>

+ (instancetype)shareUserMsg;

@property (nonatomic, strong) NSNumber * userId;
@property (nonatomic, strong) NSString * userName;
@property (nonatomic, strong) NSNumber * roleId;
@property (nonatomic, strong) NSNumber * lastLoginTime;
@property (nonatomic, strong) NSNumber * messNum;
@property (nonatomic, strong) NSNumber * taskNum;
@property (nonatomic, strong) NSNumber * status;
@property (nonatomic, strong) NSNumber * workTime;
@property (nonatomic, strong) NSNumber * offDutyTime;

@property (nonatomic, strong) NSNumber * addressId;
@property (nonatomic, strong) NSNumber * categoryId;
@property (nonatomic, strong) NSNumber * companyId;
@property (nonatomic, strong) NSNumber * createTime;
@property (nonatomic, strong) NSNumber * levelId;
@property (nonatomic, strong) NSNumber * loginTimes;

@property (nonatomic, strong) NSNumber * mobile;
@property (nonatomic, strong) NSNumber * password;
@property (nonatomic, strong) NSNumber * operators;

@property (nonatomic, strong) NSString * position;
@property (nonatomic, strong) NSString * qrcode;
@property (nonatomic, strong) NSString * qrcodeShow;

@property (nonatomic, strong) NSNumber * updateTime;

@end
