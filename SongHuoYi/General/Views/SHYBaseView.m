//
//  SHYBaseView.m
//  SongHuoYi
//
//  Created by 王亚龙 on 2017/4/4.
//  Copyright © 2017年 TianXi. All rights reserved.
//

#import "SHYBaseView.h"

@interface SHYBaseView()

@property (nonatomic, strong) UITapGestureRecognizer * baseTap;

@end

@implementation SHYBaseView

- (instancetype)initWithFrame:(CGRect)frame {
    if ([super initWithFrame:frame]) {
        [self addBaseTapClickAction];
    }
    return self;
}

- (void)addBaseTapClickAction {
    [self addGestureRecognizer:self.baseTap];
}

- (void)baseTapAction {
    NSLog(@"baseView__tap:%@",self);
    if (self.clickBlock) {
        self.clickBlock();
    }
}

- (UITapGestureRecognizer *)baseTap {
    if (!_baseTap) {
        _baseTap = [UITapGestureRecognizer.alloc initWithTarget:self action:@selector(baseTapAction)];
    }
    return _baseTap;
}

@end
