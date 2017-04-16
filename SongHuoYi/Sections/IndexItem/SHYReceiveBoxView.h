//
//  SHYReceiveBoxView.h
//  SongHuoYi
//
//  Created by 王亚龙 on 2017/4/7.
//  Copyright © 2017年 TianXi. All rights reserved.
//

#import "SHYBaseView.h"

@interface SHYReceiveBoxView : SHYBaseView

@property (nonatomic, strong) UILabel * leftLabel;
@property (nonatomic, strong) UITextField * leftTextField;
@property (nonatomic, strong) UILabel * midLabel;
@property (nonatomic, strong) UIButton * midBtn;
@property (nonatomic, strong) UILabel * rightLabel;

@property (nonatomic, copy) void (^midBtnClickBlock)();

@end
