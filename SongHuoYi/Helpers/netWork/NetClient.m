//
//  NetClient.m
//  SongHuoYi
//
//  Created by 王亚龙 on 2017/4/17.
//  Copyright © 2017年 TianXi. All rights reserved.
//

#import "NetClient.h"

#define REQUEST_WAY @"http"

@implementation NetClient


//获取链接地址
-(NSString *) getUrl:(RequestWay)way {
    if (!_requestWay) {
        _requestWay = REQUEST_WAY;
    }
    if (!_ip) {
        _ip = BASE_URL;
    }
    if (!_port) {
        _port = IP_PORT;
    }
    if (_port.length) {
        _port = [NSString stringWithFormat:@":%@",IP_PORT];
    }
    
    NSString * defaultUrl = [NSString stringWithFormat:@"%@://%@%@",_requestWay,_ip,_port];
    if (way == GET) {
        NSString * split = @"?";
        for (NSString * key in _param) {
            defaultUrl = [NSString stringWithFormat:@"%@%@%@%@",defaultUrl,split,key,[_param valueForKey:key]];
            split = @"=";
        }
    }
    return defaultUrl;
}

+ (instancetype)shareClient {
    //只进行一次
    static NetClient * _instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [NetClient.alloc init];
        
        _instance.requestWay = REQUEST_WAY;
        _instance.ip = BaseUrl;
        _instance.port = IP_PORT;
    });
    return _instance;
}

@end
