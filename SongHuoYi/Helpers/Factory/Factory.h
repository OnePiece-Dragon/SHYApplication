//
//  Factory.h
//  MYChat
//
//  Created by ycd15 on 16/11/1.
//  Copyright © 2016年 YCD_WYL. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "AppMacro.h"

@interface Factory : NSObject

/**
 *  创建UIButton
 */
+ (nullable UIButton*)createBtn:(CGRect)frame
                 title:(nullable NSString *)title
                  type:(UIButtonType)type
                target:(nullable id)target
                action:(nullable SEL)action;

/**
 *  设置button样式
 */
+ (void)setBackgroundBtn:(nullable UIButton*)btn
                  normal:(nullable UIImage*)normal
               highlight:(nullable UIImage*)highlight
                selected:(nullable UIImage*)selected
                  enable:(nullable UIImage*)enable;


/**
 *  创建tableView的统一样式
 */
+ (UITableView*)createTableView:(CGRect)frame
                 target:(id<UITableViewDataSource,UITableViewDelegate>)target
                           cell:(id)cell
              reuseName:(NSString*)reuseName;



/**
 设置字体样式
 */
+(nonnull NSMutableAttributedString*)setText:(nonnull NSString *)text
                           attribute:(nonnull NSDictionary*)attributeDic
                               range:(NSRange)range;


/**
 给View添加线框
 */
+ (void)boraderLayer:(nonnull UIView*)view
                rect:(CGRect)rect
         roundCorner:(UIRectCorner)corners;


@end
