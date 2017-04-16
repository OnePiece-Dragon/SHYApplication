//
//  SHYPersonCenterCell.m
//  SongHuoYi
//
//  Created by 王亚龙 on 2017/4/10.
//  Copyright © 2017年 TianXi. All rights reserved.
//

#import "SHYPersonCenterCell.h"

@implementation SHYPersonCenterCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if ([super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self addSubview:self.contentLabel];
        
        kWeakSelf(self);
        [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.bottom.equalTo(weakself);
        }];
    }
    return self;
}
- (SHYTwoSideLabel *)contentLabel {
    if (!_contentLabel) {
        _contentLabel = [SHYTwoSideLabel.alloc initWithFrame:CGRectZero];
    }
    return _contentLabel;
}

@end
