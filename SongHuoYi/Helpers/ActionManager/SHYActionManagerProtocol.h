//
//  SHYActionManager.h
//  SongHuoYi
//
//  Created by 王亚龙 on 2017/4/27.
//  Copyright © 2017年 TianXi. All rights reserved.
//

#ifndef SHYActionManagerDelegate_h
#define SHYActionManagerDelegate_h


@protocol SHYActionManagerDelegate<NSObject>

- (void)pushVC_A:(UIViewController*)controllerA to:(UIViewController*)controllerB;
- (void)popVC_A:(UIViewController*)controllerA from:(UIViewController*)controllerB;

- (void)ListReloadData:(NSMutableArray*)dataArray originData:(NSMutableArray*)originArray;
- (void)ListLoadMoreData:(NSMutableArray*)dataArray originData:(NSMutableArray*)originArray;

@end

#endif /* RequestProtocol_h */
