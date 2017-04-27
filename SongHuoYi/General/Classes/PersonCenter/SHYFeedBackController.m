//
//  SHYFeedBackController.m
//  SongHuoYi
//
//  Created by 王亚龙 on 2017/4/24.
//  Copyright © 2017年 TianXi. All rights reserved.
//

#import "SHYFeedBackController.h"

@interface SHYFeedBackController ()<UITextViewDelegate>

{
    BOOL _haveEdited;
}

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
    _haveEdited = NO;
    self.textView.layer.borderWidth = 1.f;
    self.textView.layer.borderColor = LINE_COLOR.CGColor;
    self.textView.clipsToBounds = YES;
    self.textView.layer.cornerRadius = 8.f;
    
    self.textView.delegate = self;
    
    self.submitBtn.layer.cornerRadius = 8.f;
    self.submitBtn.clipsToBounds = YES;
    [self.submitBtn addTarget:self action:@selector(submitAction) forControlEvents:UIControlEventTouchUpInside];
}

- (void)submitAction {
    if (!self.textView.text.length && !_haveEdited) {
        [self showToast:@"请填写反馈信息！"];
        return;
    }
    
    [self showNetTips:LOADING_DISPOSE];
    [NetManager post:URL_FEEDBACK_UPDATE
               param:@{@"userId":USER_ID,
                       @"fbMess":self.textView.text} success:^(NSDictionary * _Nonnull responseObj, NSString * _Nonnull failMessag, BOOL code) {
                           [self hideNetTips];
                           if (code) {
                               [self showToast:@"提交成功"];
                               dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                   [self.navigationController popViewControllerAnimated:YES];
                               });
                           }else {
                               [self showToast:failMessag];
                           }
                       } failure:^(NSString * _Nonnull errorStr) {
                           [self hideNetTips];
                           [self showToast:errorStr];
                       }];
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    if (!_haveEdited) {
        _haveEdited = YES;
        textView.text = @"";
    }
    
    return YES;
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
