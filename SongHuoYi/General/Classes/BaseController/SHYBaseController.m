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
    self.view.backgroundColor = LINE_COLOR;
    
    self.navigationItem.titleView = self.titleLabel;
    [self setBackItem:@"back"];
    
}

#pragma mark -navi_set-

- (void)setNaviTitle:(NSString *)naviTitle {
    self.titleLabel.text = naviTitle;
}

- (void)setBackItem:(NSString *)backImage {
    UIBarButtonItem * leftItem = [UIBarButtonItem.alloc initWithImage:ImageNamed(backImage) style:UIBarButtonItemStylePlain target:self action:@selector(leftBackItemAction)];
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


#pragma mark -show Toast-
- (void)showToast:(NSString *)toast {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.detailsLabel.text = toast;
    hud.detailsLabel.font = [UIFont systemFontOfSize:14.0];;
    [hud hideAnimated:YES afterDelay:2.f];
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