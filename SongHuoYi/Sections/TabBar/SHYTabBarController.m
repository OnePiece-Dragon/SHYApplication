//
//  SHYTabBarController.m
//  SongHuoYi
//
//  Created by 王亚龙 on 2017/4/4.
//  Copyright © 2017年 TianXi. All rights reserved.
//

#import "SHYTabBarController.h"

@interface SHYTabBarController ()

@end

@implementation SHYTabBarController

+ (instancetype)tabBar:(NSArray*)tabBarArray
                        titles:(NSArray *)titles
                        images:(NSArray *)images
                selectedImages:(NSArray *)selectedImages {
    //设置tabBar
    SHYTabBarController * tabBar = [SHYTabBarController.alloc init];
    NSMutableArray * VCArray = [NSMutableArray array];
    int i = 0;
    for (NSString * tabBarTitle in tabBarArray) {
        UIViewController * VC = [NSClassFromString(tabBarTitle).alloc init];
        SHYNaviController * navi = [SHYNaviController.alloc initWithRootViewController:VC];
        
        VC.tabBarItem.title = [titles objectAtIndex:i];
        VC.tabBarItem.image = [UIImage imageNamed:[images objectAtIndex:i]];
        VC.tabBarItem.selectedImage = [UIImage imageNamed:[selectedImages objectAtIndex:i]];
        navi.title= [titles objectAtIndex:i++];
        [VCArray addObject:navi];
    }
    [tabBar setViewControllers:VCArray];
    
    
    //设置navi
    [SHYNaviConfig naviConfig];
    
    
    return tabBar;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
