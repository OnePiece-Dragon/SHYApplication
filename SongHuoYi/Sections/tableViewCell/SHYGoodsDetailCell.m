//
//  SHYGoodsDetailCell.m
//  SongHuoYi
//
//  Created by 王亚龙 on 2017/4/8.
//  Copyright © 2017年 TianXi. All rights reserved.
//

#import "SHYGoodsDetailCell.h"

@implementation SHYGoodsDetailCell

- (instancetype)initWithFrame:(CGRect)frame {
    if ([super initWithFrame:frame]) {
        [self setUI];
    }
    return self;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if ([super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setUI];
    }
    return self;
}

- (void)setUI {
    [self addSubview:self.leftTopLabel];
    [self addSubview:self.leftBottomLabel];
    [self addSubview:self.rightTopLabel];
    [self addSubview:self.rightBottomLabel];
    
    _rightTopLabel.textAlignment = NSTextAlignmentRight;
    _rightBottomLabel.textAlignment = NSTextAlignmentRight;
    
    kWeakSelf(self);
    [self.leftTopLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakself).offset(8);
        make.top.equalTo(weakself).offset(8);
        make.right.equalTo(weakself.rightTopLabel.mas_left);
        make.bottom.equalTo(weakself.leftBottomLabel.mas_top).offset(-8);
    }];
    [self.leftBottomLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakself.leftTopLabel.mas_left);
        make.bottom.equalTo(weakself).offset(-8);
        make.right.equalTo(weakself.mas_centerX);
        make.height.mas_equalTo(36);
    }];
    [self.rightTopLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakself).offset(-8);
        make.top.equalTo(weakself.leftTopLabel.mas_top);
        make.height.mas_equalTo(36);
        make.width.mas_equalTo(100);
    }];
    [self.rightBottomLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakself.rightTopLabel.mas_right);
        make.bottom.equalTo(weakself).offset(-8);
        make.height.mas_equalTo(36);
        make.left.equalTo(weakself.mas_centerX);
    }];
    
    
    //line
    [self addSubview:self.topLine];
    [self addSubview:self.bottomLine];
    _topLine.backgroundColor = LINE_COLOR;
    _bottomLine.backgroundColor = LINE_COLOR;
    
    [self.topLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakself).offset(8);
        make.right.equalTo(weakself).offset(-8);
        make.top.equalTo(weakself);
        make.height.mas_equalTo(@1);
    }];
    [self.bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakself).offset(8);
        make.right.equalTo(weakself).offset(-8);
        make.bottom.equalTo(weakself);
        make.height.mas_equalTo(@1);
    }];
    
    [self setTopLineHiden:YES bottomLineHiden:NO];
}


- (void)setTopLineHiden:(BOOL)topLine bottomLineHiden:(BOOL)bottomLine {
    _topLine.hidden = topLine;
    _bottomLine.hidden = bottomLine;
}

- (void)setLeftTopStr:(NSString *)leftTopStr
        leftBottomStr:(NSString *)leftBottomStr
          rightTopStr:(NSString *)rightTopStr
       rightBottomStr:(NSString *)rightBottomStr {
    _leftTopLabel.text = leftTopStr;
    _leftBottomLabel.text = leftBottomStr;
    _rightTopLabel.text = rightTopStr;
    _rightBottomLabel.text = rightBottomStr;
}

- (UILabel *)leftTopLabel {
    if (!_leftTopLabel) {
        _leftTopLabel = [UILabel.alloc init];
    }
    return _leftTopLabel;
}
- (UILabel *)leftBottomLabel {
    if (!_leftBottomLabel) {
        _leftBottomLabel = [UILabel.alloc init];
    }
    return _leftBottomLabel;
}
- (UILabel *)rightTopLabel {
    if (!_rightTopLabel) {
        _rightTopLabel = [UILabel.alloc init];
    }
    return _rightTopLabel;
}
- (UILabel *)rightBottomLabel {
    if (!_rightBottomLabel) {
        _rightBottomLabel = [UILabel.alloc init];
    }
    return _rightBottomLabel;
}
- (UIView *)topLine {
    if (!_topLine) {
        _topLine = [UIView.alloc init];
    }
    return _topLine;
}
- (UIView *)bottomLine {
    if (!_bottomLine) {
        _bottomLine = [UIView.alloc init];
    }
    return _bottomLine;
}
@end
