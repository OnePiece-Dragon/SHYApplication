//
//  SHYBaseViewModel.h
//  SongHuoYi
//
//  Created by 王亚龙 on 2017/4/20.
//  Copyright © 2017年 TianXi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SHYBaseViewModel : NSObject

@property (nonatomic, strong) RACCommand * requestCommand;
@property (nonatomic, strong) NSDictionary * responseObject;
@property (nonatomic, strong) NSError * responseError;


- (void)signalRequestUrl:(NSString*)url params:(NSDictionary*)params;

@end
