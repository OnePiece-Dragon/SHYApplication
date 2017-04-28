//
//  SHYActionManager.h
//  SongHuoYi
//
//  Created by 王亚龙 on 2017/4/27.
//  Copyright © 2017年 TianXi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SHYActionManagerProtocol.h"

@interface SHYActionManager : NSObject<SHYActionManagerDelegate>

- (void)pushVC_A:(UIViewController *)controllerA to:(UIViewController *)controllerB;
- (void)popVC_A:(UIViewController *)controllerA from:(UIViewController *)controllerB;
- (void)ListReloadData:(NSMutableArray *)dataArray originData:(NSMutableArray *)originArray;
- (void)ListLoadMoreData:(NSMutableArray *)dataArray originData:(NSMutableArray *)originArray;

@end
