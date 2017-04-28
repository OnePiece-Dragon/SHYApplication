//
//  SHYIndexCell.m
//  SongHuoYi
//
//  Created by 王亚龙 on 2017/4/6.
//  Copyright © 2017年 TianXi. All rights reserved.
//

#import "SHYIndexCell.h"

@implementation SHYIndexCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if ([super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = BACKGROUND_COLOR;
        [self addSubview:self.indexView];
        _indexView.titleLabel.font = [UIFont boldSystemFontOfSize:24];
        _indexView.titleLabel.textAlignment = NSTextAlignmentRight;
        _indexView.titleLabel.textColor = COLOR_RGB(1, 25, 148);
        
        _indexView.descLabel.font = [UIFont boldSystemFontOfSize:30];
        _indexView.descLabel.textAlignment = NSTextAlignmentRight;
        _indexView.descLabel.textColor = COLOR_RGB(255, 255, 255);
        
        __weak typeof(self) weakSelf = self;
        [self.indexView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf).offset(10);
            make.right.equalTo(weakSelf).offset(-10);
            make.top.equalTo(weakSelf).offset(10);
            make.bottom.equalTo(weakSelf);
        }];
    }
    return self;
}

- (void)setCellModel:(SHYBaseModel *)model {
    
    
    SHYIndexItemModel*currentModel = (SHYIndexItemModel*)model;
    
    _indexView.backgroundImage.image = ImageNamed(currentModel.imageName);
    _indexView.titleLabel.text = currentModel.titleName;
    _indexView.descLabel.text = currentModel.descName;
    
    kWeakSelf(self);
    _indexView.clickBlock = ^(){
        if (weakself.tapActionBlock) {
            weakself.tapActionBlock(model);
        }
    };
}

- (SHYIndexItemView *)indexView {
    if (!_indexView) {
        _indexView = [SHYIndexItemView.alloc init];
    }
    return _indexView;
}

@end
