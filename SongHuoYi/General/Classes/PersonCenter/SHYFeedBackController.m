//
//  SHYFeedBackController.m
//  SongHuoYi
//
//  Created by 王亚龙 on 2017/4/24.
//  Copyright © 2017年 TianXi. All rights reserved.
//

#import "SHYFeedBackController.h"

@interface SHYFeedBackController ()

@end

@implementation SHYFeedBackController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ([super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.naviTitle = @"意见反馈";
    
    self.textView.layer.borderWidth = 1.f;
    self.textView.layer.borderColor = LINE_COLOR.CGColor;
    self.textView.clipsToBounds = YES;
    self.textView.layer.cornerRadius = 8.f;
    
    
    self.submitBtn.layer.cornerRadius = 8.f;
    self.submitBtn.clipsToBounds = YES;
    [self.submitBtn addTarget:self action:@selector(submitAction) forControlEvents:UIControlEventTouchUpInside];
}

- (void)submitAction {

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
