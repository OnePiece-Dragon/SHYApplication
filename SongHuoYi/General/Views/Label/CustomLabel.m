//
//  CustomLabel.m
//  Big_eye
//
//  Created by 王亚龙 on 2017/4/7.
//  Copyright © 2017年 WangYaLong. All rights reserved.
//

#import "CustomLabel.h"

@interface CustomLabel()

@property (nonatomic, strong) UITapGestureRecognizer *tap;

@end

@implementation CustomLabel

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.numberOfLines = 0;
        //[self attachTapGesture];
        self.pBoard = [UIPasteboard generalPasteboard];
    }
    return self;
}

- (void)attachTapGesture{
    self.userInteractionEnabled = YES;
    
    [self addGestureRecognizer:self.tap];
}

- (void)handleTapAction:(UITapGestureRecognizer *)sender {
    [self becomeFirstResponder];
    UIMenuItem *copyMenuItem = [[UIMenuItem alloc]initWithTitle:@"复制" action:@selector(copyAction:)];
    //UIMenuItem *pasteMenueItem = [[UIMenuItem alloc]initWithTitle:@"粘贴" action:@selector(pasteAction:)];
    //UIMenuItem *cutMenuItem = [[UIMenuItem alloc]initWithTitle:@"剪切" action:@selector(cutAction:)];
    
    UIMenuController *menuController = [UIMenuController sharedMenuController];
    
    
    [menuController setMenuItems:[NSArray arrayWithObjects:copyMenuItem, nil]];
    [menuController setTargetRect:self.frame inView:self.superview];
    [menuController setMenuVisible:YES animated: YES];
    
}

-(BOOL)canBecomeFirstResponder {
    return YES;
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    if (action == @selector(copyAction:)) {
        return YES;
    }
    if (action == @selector(pasteAction:)) {
        return YES;
    }
    if (action == @selector(cutAction:)) {
        return YES;
    }
    return NO; //隐藏系统默认的菜单项
}

#pragma mark 实现方法

- (void)copyAction:(id)sender {
    self.pBoard.string = self.text;
    NSLog(@"粘贴的内容为%@", self.pBoard.string);
}

- (void)pasteAction:(id)sender {
    self.text = self.pBoard.string;
}

- (void)cutAction:(id)sender {
    self.pBoard.string = self.text;
    self.text = nil;
}


- (UITapGestureRecognizer *)tap {
    if (!_tap) {
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleTapAction:)];
        tap.numberOfTouchesRequired = 1;
        _tap = tap;
    }
    return _tap;
}

@end
