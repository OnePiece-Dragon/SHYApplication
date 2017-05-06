//
//  SHYTaskCell.m
//  SongHuoYi
//
//  Created by 王亚龙 on 2017/4/6.
//  Copyright © 2017年 TianXi. All rights reserved.
//

#import "SHYTaskCell.h"

@interface SHYTaskCell()

{
    SHYTaskModel * taskModel;
    
    NSInteger _enterBtnIndex;
    BOOL _isBottomBtn;
}

@end

@implementation SHYTaskCell

- (instancetype)initWithFrame:(CGRect)frame labelCount:(NSInteger)count {
    if ([super initWithFrame:frame]) {
        [self setUI:count];
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame labelCount:(NSInteger)count enterBtnIndex:(NSInteger)enterBtnIndex {
    _enterBtnIndex = enterBtnIndex;
    return [self initWithFrame:frame labelCount:count];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier
                   labelCount:(NSInteger)count {
    if ([super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = BACKGROUND_COLOR;
        [self setUI:count];
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame labelCount:(NSInteger)count enterBtnIndex:(NSInteger)enterBtnIndex bottomBtn:(BOOL)hidenBottomBtn{
    _isBottomBtn = hidenBottomBtn;
    return [self initWithFrame:frame labelCount:count enterBtnIndex:enterBtnIndex];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier
                   labelCount:(NSInteger)count
                enterBtnIndex:(NSInteger)enterBtnIndex {
    _enterBtnIndex = enterBtnIndex;
    return [self initWithStyle:style reuseIdentifier:reuseIdentifier labelCount:count];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier
                   labelCount:(NSInteger)count
                enterBtnIndex:(NSInteger)enterBtnIndex
                    bottomBtn:(BOOL)hidenBottomBtn {
    _isBottomBtn = hidenBottomBtn;
    return [self initWithStyle:style
               reuseIdentifier:reuseIdentifier
                    labelCount:count
                 enterBtnIndex:enterBtnIndex];
}

- (void)setUI:(NSInteger)count {
    if (_enterBtnIndex == 0) {
        _enterBtnIndex = 3;
    }
    
    _backView.layer.cornerRadius = 8.f;
    _backView.clipsToBounds = YES;
    
    [self addSubview:self.backView];
    __weak typeof(self) wSelf = self;
    __weak typeof(UIView*)weakself = self.backView;
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(wSelf).offset(8);
        make.right.equalTo(wSelf).offset(-8);
        make.top.equalTo(wSelf).offset(3);
        make.bottom.equalTo(wSelf).offset(-3);
    }];
    
    
    [self.backView addSubview:self.rightIconView];
    [self.rightIconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.equalTo(wSelf.backView);
        make.size.mas_equalTo(CGSizeMake(56*SCREEN_POINT, 56*SCREEN_POINT));
    }];
    self.backView.layer.cornerRadius=8.f;
    self.backView.clipsToBounds = YES;
    _rightIconView.hidden = YES;
    
    CGFloat _bottomLabelOffset = 0;
    if (!_isBottomBtn) {
        _bottomLabelOffset = 60;
    }
    
    //_backView.backgroundColor = [UIColor greenColor];
    for (int i = 0; i < count; i++) {
        SHYIconLabel * iconLabel = [SHYIconLabel.alloc initWithFrame:CGRectZero icon:nil];
        //iconLabel.backgroundColor = [UIColor greenColor];
        
        [self.backView addSubview:iconLabel];
        [iconLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(weakself);
        }];
        if (i == 0) {
            [iconLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(weakself).offset(LINE_VER_SPACE);
                make.height.mas_greaterThanOrEqualTo(36);
            }];
        }else if(i == count - 1){
            SHYIconLabel * forwardLabel = self.labelArray.lastObject;
            [iconLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(forwardLabel.mas_bottom);
                make.bottom.equalTo(weakself).offset(-_bottomLabelOffset);
            }];
        }else {
            SHYIconLabel * forwardLabel = self.labelArray[i-1];
            [iconLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(forwardLabel.mas_bottom);
            }];
        }
        [self.labelArray addObject:iconLabel];
    }
    
    
    if (count > _enterBtnIndex) {
        SHYIconLabel * iconLabel = self.labelArray[_enterBtnIndex];
        [iconLabel addSubview:self.enterBtn];
        __weak typeof(SHYIconLabel*) wView = iconLabel;
        [self.enterBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(wView);
            make.right.equalTo(wView).offset(-10);
            make.width.mas_equalTo(100);
        }];
    }
    
    
    if (!_isBottomBtn) {
        [self.backView addSubview:self.startBtn];
        _startBtn.clipsToBounds = YES;
        _startBtn.layer.cornerRadius = 8.f;
        [_startBtn setBackgroundImage:[UIImage imageWithColor:BUTTON_COLOR] forState:UIControlStateNormal];
        [self.startBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakself).offset(8);
            make.right.equalTo(weakself).offset(-8);
            make.bottom.equalTo(weakself).offset(-8);
            make.height.mas_equalTo(44);
        }];
    }
}


- (void)setCellModel:(SHYBaseModel *)model {
    taskModel = (SHYTaskModel*)model;
    
    
}

- (void)startBtnClick {
    //DLog(@"开始配送");
    if (self.startBtnClickBlock) {
        self.startBtnClickBlock(taskModel);
    }
}
- (void)enterBtnClick {
    //DLog(@"进入核货");
    if (self.enterBtnClickBlock) {
        self.enterBtnClickBlock(taskModel);
    }
}

- (NSMutableArray *)labelArray {
    if (!_labelArray) {
        _labelArray=  [NSMutableArray array];
    }
    return _labelArray;
}
-(UIView *)backView {
    if (!_backView) {
        _backView = [UIView.alloc init];
        _backView.backgroundColor = COLOR_WHITE;
    }
    return _backView;
}
- (UIImageView *)rightIconView {
    if (!_rightIconView) {
        _rightIconView = [UIImageView.alloc init];
        _rightIconView.userInteractionEnabled = YES;
        
        _rightIconView.image = ImageNamed(@"yisongda");
    }
    return _rightIconView;
}
- (UIButton *)enterBtn {
    if (!_enterBtn) {
        _enterBtn = [Factory createBtn:CGRectZero title:@"进入核货" type:UIButtonTypeCustom target:self action:@selector(enterBtnClick)];
        [_enterBtn setImage:ImageNamed(@"dianji") forState:UIControlStateNormal];
        [_enterBtn setTitleColor:COLOR_RGB(104,69,251) forState:UIControlStateNormal];
        _enterBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 70, 0, 0);
        _enterBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -60, 0, 0);
    }
    return _enterBtn;
}
-(UIButton *)startBtn{
    if (!_startBtn) {
        _startBtn = [Factory createBtn:CGRectZero title:@"开始配送" type:UIButtonTypeCustom target:self action:@selector(startBtnClick)];
    }
    return _startBtn;
}

@end
