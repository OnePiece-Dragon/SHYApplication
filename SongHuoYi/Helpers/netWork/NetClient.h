//
//  NetClient.h
//  SongHuoYi
//
//  Created by 王亚龙 on 2017/4/17.
//  Copyright © 2017年 TianXi. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger,RequestWay) {
    POST    =   0,
    GET
};

@interface NetClient : NSObject

@property (nonatomic, strong) NSString * requestWay;
@property (nonatomic, strong) NSString * ip;
@property (nonatomic, strong) NSString * port;
@property (nonatomic, strong) NSString * method;

@property (nonatomic, strong) NSDictionary * param;

+ (instancetype)shareClient;

//获取链接地址
-(NSString *) getUrl:(RequestWay)way;

@end
