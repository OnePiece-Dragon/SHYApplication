//
//  SHYActionManager.m
//  SongHuoYi
//
//  Created by 王亚龙 on 2017/4/27.
//  Copyright © 2017年 TianXi. All rights reserved.
//

#import "SHYActionManager.h"

@implementation SHYActionManager

- (void)pushVC_A:(UIViewController *)controllerA to:(UIViewController *)controllerB {
    [controllerA.navigationController pushViewController:controllerB animated:YES];
}

- (void)popVC_A:(UIViewController *)controllerA from:(UIViewController *)controllerB {
    if (controllerB) {
        NSArray * array = [(UINavigationController *)controllerA.parentViewController viewControllers];
        for (UIViewController * VC in array) {
            if ([VC isKindOfClass:[controllerB class]]) {
                [controllerA.navigationController popToViewController:VC animated:YES];
                return;
            }
        }
    }
    [controllerA.navigationController popViewControllerAnimated:YES];
}
- (void)ListReloadData:(NSMutableArray *)dataArray originData:(NSMutableArray *)originArray {
    originArray = [dataArray mutableCopy];
}
- (void)ListLoadMoreData:(NSMutableArray *)dataArray originData:(NSMutableArray *)originArray {
    [originArray addObjectsFromArray:[dataArray mutableCopy]];
}

@end
