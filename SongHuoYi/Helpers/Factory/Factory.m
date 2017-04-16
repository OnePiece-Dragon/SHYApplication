//
//  Factory.m
//  MYChat
//
//  Created by ycd15 on 16/11/1.
//  Copyright © 2016年 YCD_WYL. All rights reserved.
//

#import "Factory.h"

@implementation Factory

//快速创建基本的button
+ (UIButton *)createBtn:(CGRect)frame
                  title:(NSString *)title
                   type:(UIButtonType)type
                 target:(id)target
                 action:(SEL)action {
    UIButton * button = [UIButton buttonWithType:type];
    button.frame = frame;
    [button setTitle:title forState:UIControlStateNormal];
    if (type != UIButtonTypeSystem) {
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    //action
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    return button;
}

+ (void)setBackgroundBtn:(UIButton *)btn
                  normal:(UIImage *)normal
               highlight:(UIImage *)highlight
                selected:(UIImage *)selected
                  enable:(UIImage *)enable {
    [btn setBackgroundImage:normal forState:UIControlStateNormal];
    [btn setBackgroundImage:highlight forState:UIControlStateHighlighted];
    [btn setBackgroundImage:selected forState:UIControlStateSelected];
    [btn setBackgroundImage:enable forState:UIControlStateDisabled];
}


+ (UITableView*)createTableView:(CGRect)frame
                 target:(id<UITableViewDelegate,UITableViewDataSource>)target
                           cell:(id)cell
              reuseName:(NSString *)reuseName {
    UITableView * tableView = [UITableView.alloc initWithFrame:frame style:UITableViewStylePlain];
    tableView.delegate = target;
    tableView.dataSource = target;
    [tableView registerClass:cell forCellReuseIdentifier:reuseName];
    return tableView;
}


/**
 设置字体样式
 */
+ (NSMutableAttributedString*)setText:(NSString *)text
                            attribute:(NSDictionary *)attributeDic
                                range:(NSRange)range {
    NSMutableAttributedString * attributeStr = [NSMutableAttributedString.alloc initWithString:text];
    [attributeStr setAttributes:attributeDic range:range];
    return attributeStr;
}

+ (void)boraderLayer:(UIView*)view rect:(CGRect)rect roundCorner:(UIRectCorner)corners {
    CAShapeLayer *border = [CAShapeLayer layer];
    border.strokeColor = LINE_COLOR.CGColor;
    border.fillColor = nil;
    border.path = [UIBezierPath bezierPathWithRect:rect].CGPath;
    border.lineWidth = 1.f;
    border.lineCap = @"round";
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:corners cornerRadii:CGSizeMake(8, 8)];
    border.path = path.CGPath;
    //border.frame = rect;
    //border.lineDashPattern = @[@4, @4];
    [view.layer addSublayer:border];
}

@end
