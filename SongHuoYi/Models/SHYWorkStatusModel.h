//
//  SHYWorkStatusModel.h
//  SongHuoYi
//
//  Created by 王亚龙 on 2017/4/19.
//  Copyright © 2017年 TianXi. All rights reserved.
//

#import "SHYBaseModel.h"

@interface SHYWorkStatusModel : SHYBaseModel

@property (nonatomic, strong) NSString * offDutyTime;
@property (nonatomic, strong) NSNumber * status;
@property (nonatomic, strong) NSString * valStatusMsg;
@property (nonatomic, strong) NSString * workTime;

@end
