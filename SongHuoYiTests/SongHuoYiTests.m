//
//  SongHuoYiTests.m
//  SongHuoYiTests
//
//  Created by 王亚龙 on 2017/3/31.
//  Copyright © 2017年 TianXi. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "NetManager.h"
#import "AppMacro.h"

//waitForExpectationsWithTimeout是等待时间，超过了就不再等待往下执行。
#define WAIT do {\
[self expectationForNotification:@"RSBaseTest" object:nil handler:nil];\
[self waitForExpectationsWithTimeout:30 handler:nil];\
} while (0);

#define NOTIFY \
[[NSNotificationCenter defaultCenter]postNotificationName:@"RSBaseTest" object:nil];

@interface SongHuoYiTests : XCTestCase

@end

@implementation SongHuoYiTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
//    NSString *plistPath = PLIST_Name(@"userMessage");
//    NSDictionary * dic = [NSDictionary dictionaryWithContentsOfFile:plistPath];
//    NSLog(@"dic:%@",dic);
    
    NSTimeInterval startWorkTime = [TimeManager timeSwitchTimeString:@"2017/04/20 18:18:59" format:@"yyyy/MM/dd HH:mm:ss"];
    NSString * timeStr = [TimeManager timeWithTimeIntervalString:[NSString stringWithFormat:@"%f",(NSDate.date.timeIntervalSince1970 - startWorkTime)] format:@"HH:mm"];
    NSLog(@"time:%f",startWorkTime);
}

- (void)testNetRequest {
    [NetManager post:URL_Login param:@{@"mobile":@"18633338888",
                                       @"password":@"123456",
                                       @"clientId":@""} progress:^(NSProgress * _Nonnull uploadProgress) {
                                       } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                                           DLog(@"reslut:%@",responseObject);
                                           NOTIFY;
                                       } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                           DLog(@"error:%@",error);
                                           NOTIFY;
                                       }];
    WAIT;
}

- (void)testStartWork {
    [NetManager post:URL_WORK_UPDATE param:@{@"userId":@242,
                                             @"status":@1} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        DLog(@"reslut:%@",responseObject);
        NOTIFY;
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        DLog(@"error:%@",error);
        NOTIFY
    }];
    WAIT
}

- (void)testMyTaskList {
    [NetManager post:URL_WORK_UPDATE param:@{@"userId":@242,
                                             @"page":@1} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                                                 DLog(@"reslut:%@",responseObject);
                                                 NOTIFY;
                                                 
                                             } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                                 DLog(@"error:%@",error);
                                                 NOTIFY
                                             }];
    WAIT
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
