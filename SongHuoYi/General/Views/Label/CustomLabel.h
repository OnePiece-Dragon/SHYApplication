//
//  CustomLabel.h
//  Big_eye
//
//  Created by 王亚龙 on 2017/4/7.
//  Copyright © 2017年 WangYaLong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomLabel : UILabel

@property UIPasteboard *pBoard; 
- (void)attachTapGesture;

@end
