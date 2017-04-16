//
//  CustomTextField.m
//  SongHuoYi
//
//  Created by 王亚龙 on 2017/4/5.
//  Copyright © 2017年 TianXi. All rights reserved.
//

#import "CustomTextField.h"

@implementation CustomTextField

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame {
    if ([super initWithFrame:frame]) {
        _leftSpace = 48;
    }
    return self;
}

- (CGRect)leftViewRectForBounds:(CGRect)bounds {
    CGRect iconRect = [super leftViewRectForBounds:bounds];
    iconRect.origin.x += 8;// 右偏10
    return iconRect;
}
- (CGRect)rightViewRectForBounds:(CGRect)bounds {
    CGRect iconRect = [super rightViewRectForBounds:bounds];
    iconRect.origin.x -= 8;// 右偏10
    return iconRect;
}

- (CGRect)editingRectForBounds:(CGRect)bounds {
    CGRect rect = [super editingRectForBounds:bounds];
    rect.origin.x = _leftSpace; // 这个数字与textRect相同
    return rect;
}

- (CGRect)placeholderRectForBounds:(CGRect)bounds {
    CGRect rect = [super placeholderRectForBounds:bounds];
    rect.origin.x = _leftSpace; // 这个数字与textRect相同
    return rect;
}

- (CGRect)textRectForBounds:(CGRect)bounds {
    CGRect rect = [super textRectForBounds:bounds];
    rect.origin.x = _leftSpace; // 这个数字与textRect相同
    return rect;
}

@end
