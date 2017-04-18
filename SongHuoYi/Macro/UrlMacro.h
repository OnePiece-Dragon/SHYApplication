//
//  UrlMacro.h
//  SongHuoYi
//
//  Created by 王亚龙 on 2017/4/4.
//  Copyright © 2017年 TianXi. All rights reserved.
//

#ifndef UrlMacro_h
#define UrlMacro_h

#import "TipMacro.h"

//192.168.31.197:8080
#define BASE_URL                    @"120.27.238.62"
#define IP_PORT                     @""
//登录
#define URL_Login                   @"/app/user/login"
//开始上班
#define URL_WORK_UPDATE             @"/app/work/oper/update"
//我的任务单
#define URL_TASK_LIST               @"/app/task/list"
//任务状态更新接口
#define URL_TASK_STATUS_UPDATE      @"/app/task/status/update"
//核货详情类别
#define URL_TASK_NUCLEAR_CATEGORY   @"/app/task/nuclear/category"
//核货详情
#define URL_TASK_NUCLEAR_LIST       @"/app/task/nuclear/list"
//核货接口一键核货（按任务编号）
#define URL_TASK_ONCENUCLEAR_UPDATE @"/app/task/oncenuclear/update"
//收箱
#define URL_TASK_NUCLEAR_CGTUPDATE  @"/app/ task/nuclear/ cgtUpdate"
//提交问题
#define URL_TASK_CREATEPRO          @"/app/task/nuclear/ createPro"
//我的配送
#define URL_DISTRIBUTE_LIST         @"/app/distribute /order/list"
//我的配送（地图模式）
#define URL_DISTRIBUTE_MAP          @"/app/distribute/map/list"

//消息中心
#define URL_MESSAGE_INFO            @"/app/sys/messInfo/list"
//历史运单
#define URL_TASK_HISTORY            @"/app/task/history/list"
//历史运单详情
#define URL_TASK_HISTORY_DETAIL     @"/app/task/wayorder/list"

//帮助中心
#define URL_HELPER_CENTER           @"/app/personal/helper/list"
//消息设置查询
#define URL_MESSAGE_REMIND          @"/app/personal/remind/list"

//意见反馈
#define URL_FEEDBACK_UPDATE         @"/app/personal/feedback/update"

//密码修改
#define URL_UPDATE_PASSWORD         @"/app/personal/password/update"

#endif /* UrlMacro_h */
