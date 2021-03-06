//
//  SHYGoodsCell.m
//  SongHuoYi
//
//  Created by 王亚龙 on 2017/4/7.
//  Copyright © 2017年 TianXi. All rights reserved.
//

#import "SHYGoodsCell.h"

@implementation SHYGoodsCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier
                        isAll:(BOOL)isAll
                    lineCount:(NSInteger)count{
    if ([super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        for (int i = 0; i < count; i++) {
            SHYTwoSideLabel * label = [SHYTwoSideLabel.alloc initWithFrame:CGRectZero];
            [self addSubview:label];
            [self.rowArray addObject:label];
        }
        kWeakSelf(self);
        for (int i = 0; i < _rowArray.count; i++) {
            SHYTwoSideLabel * label = [_rowArray objectAtIndex:i];
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.equalTo(weakself);
                make.height.mas_equalTo(60-LINE_VER_SPACE*2);
            }];
            if (i == 0) {
                [label mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(weakself).offset(LINE_VER_SPACE);
                }];
            }else {
                SHYTwoSideLabel * forLabel = [_rowArray objectAtIndex:i-1];
                [label mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(forLabel.mas_bottom).offset(LINE_VER_SPACE);
                }];
            }
            if (i == _rowArray.count - 1) {
                [label mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.bottom.equalTo(weakself).offset(-LINE_VER_SPACE);
                }];
            }
        }
    }
    return self;
}

- (void)addTopView {
    kWeakSelf(self);
    [self addSubview:self.topView];
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(weakself);
        make.height.mas_equalTo(@10);
    }];
    SHYTwoSideLabel * label = _rowArray.firstObject;
    [label mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakself.topView.mas_bottom);
    }];
}

- (NSMutableArray *)rowArray {
    if (!_rowArray) {
        _rowArray = [NSMutableArray array];
    }
    return _rowArray;
}
- (UIView *)topView {
    if (!_topView) {
        _topView = [UIView.alloc init];
        _topView.backgroundColor = BACKGROUND_COLOR;
    }
    return _topView;
}
@end
