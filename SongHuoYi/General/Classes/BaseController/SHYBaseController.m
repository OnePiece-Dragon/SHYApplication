//
//  SHYBaseController.m
//  SongHuoYi
//
//  Created by 王亚龙 on 2017/4/4.
//  Copyright © 2017年 TianXi. All rights reserved.
//

#import "SHYBaseController.h"

@interface SHYBaseController ()

@end

@implementation SHYBaseController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ([super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = BACKGROUND_COLOR;
    
    self.navigationItem.titleView = self.titleLabel;
    [self setBackItem:@"back"];
    
}

#pragma mark -navi_set-

- (void)setNaviTitle:(NSString *)naviTitle {
    self.titleLabel.text = naviTitle;
}

- (void)setBackItem:(NSString *)backImage {
    UIBarButtonItem * leftItem = [UIBarButtonItem.alloc initWithImage:ImageNamed(backImage) style:UIBarButtonItemStylePlain target:self action:@selector(leftBackItemAction)];
    leftItem.imageInsets = UIEdgeInsetsMake(0, -10, 0, 0);
    self.navigationItem.leftBarButtonItems = @[leftItem];
}
- (void)cancelBackItem {
    self.navigationItem.leftBarButtonItem = nil;
}

- (void)setRightItem:(NSString *)imageName {
    UIBarButtonItem * rightItem = [UIBarButtonItem.alloc initWithImage:ImageNamed(imageName) style:UIBarButtonItemStylePlain target:self action:@selector(rightItemAction)];
    self.navigationItem.rightBarButtonItems = @[rightItem];
}
- (void)setRightItem:(NSString *)imageName rightBlock:(void (^)())rightBlock {
    [self setRightItem:imageName];
    self.rightBar = rightBlock;
}
- (void)setRightItem:(NSString *)imageName selectedImage:(NSString *)selectedImage rightBlock:(void (^)(id))rightBlock {
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 44, 44);
    [button setImage:ImageNamed(imageName) forState:UIControlStateNormal];
    [button setImage:ImageNamed(selectedImage) forState:UIControlStateSelected];
    [button addTarget:self action:@selector(rightBarButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * rightItem = [UIBarButtonItem.alloc initWithCustomView:button];
    self.navigationItem.rightBarButtonItems = @[rightItem];
    self.rightBarClick = rightBlock;
}

#pragma mark -navi_action-
- (void)leftBackItemAction {
    if (self.leftBar) {
        self.leftBar();
    }else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}
- (void)rightItemAction {
    //DLog(@"rightAction");
    if (self.rightBar) {
        self.rightBar();
    }
}
- (void)rightBarButtonAction:(id)sender {
    UIButton * btn = (UIButton*)sender;
    btn.selected = !btn.selected;
    if (self.rightBarClick) {
        self.rightBarClick(btn);
    }
}


#pragma mark -show alert-
/**
 * @ 弹框提示
 * @ titleStr：弹框的标题
 * @ infoStr：弹框信息提示的标题
 * @ cancelStr：取消按钮的标题，可给nil
 * @ okStr：确定按钮的标题，可给nil
 * @ cancelBlock：取消按钮的执行操作，可不写
 * @ okBlock：确定按钮的执行操作，可不写
 * @ author：liuli
 */
- (void)showAlertVCWithTitle:(NSString *)titleStr info:(NSString *)infoStr CancelTitle:(NSString *)cancelStr okTitle:(NSString *)okStr cancelBlock:(void (^)())cancelBlock okBlock:(void (^)())okBlock {
    // alertVC 初始化
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:titleStr message:infoStr preferredStyle:UIAlertControllerStyleAlert];
    
    // 如果取消按钮标题不为空，就添加
    if (cancelStr != nil && cancelStr.length > 0) {
        // cancel Action初始化
        UIAlertAction *cancelBtn = [UIAlertAction actionWithTitle:cancelStr style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            // 点击取消按钮执行的block
            if (cancelBlock) {
                cancelBlock();
            }
        }];
        [alertVC addAction:cancelBtn];
    }
    
    // 如果确定按钮标题不为空，就添加
    if (okStr != nil && okStr.length > 0) {
        // ok Action初始化
        UIAlertAction *okBtn = [UIAlertAction actionWithTitle:okStr style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            // 点击确定按钮执行的block
            if (okBlock) {
                okBlock();
            }
        }];
        
        [alertVC addAction:okBtn];
    }
    
    // 弹出视图
    [self presentViewController:alertVC animated:YES completion:nil];
}


#pragma mark -show Toast-
- (void)showToast:(NSString *)toast {
    [self.view makeToast:toast duration:2.0 position:CSToastPositionCenter];
    
    
    /*
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.detailsLabel.text = toast;
    hud.detailsLabel.font = [UIFont systemFontOfSize:14.0];
    [hud hideAnimated:YES afterDelay:2.f];*/
}
- (void)showNetTips:(NSString *)tips {
    //UIView * view = [[UIApplication sharedApplication].windows lastObject];
    // 快速显示一个提示信息
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.label.text = tips;
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    // YES代表需要蒙版效果
    //hud.dimBackground = NO;
}
- (void)hideNetTips {
    //UIView * view = [[UIApplication sharedApplication].windows lastObject];
    NSEnumerator *subviewsEnum = [self.view.subviews reverseObjectEnumerator];
    for (UIView *subview in subviewsEnum) {
        if ([subview isKindOfClass:NSClassFromString(@"MBProgressHUD")]) {
            [(MBProgressHUD*)subview hideAnimated:YES];
        }
    }
}









- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [UILabel.alloc initWithFrame:CGRectMake(0, 0, 120, 44)];
        _titleLabel.font = [UIFont boldSystemFontOfSize:16];
        _titleLabel.textColor = COLOR_WHITE;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
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
