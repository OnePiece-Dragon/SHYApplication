//
//  SHYTaskViewModel.h
//  SongHuoYi
//
//  Created by 王亚龙 on 2017/5/2.
//  Copyright © 2017年 TianXi. All rights reserved.
//

#import "SHYBaseViewModel.h"
#import "SHYTaskCell.h"
#import "SHYTaskModel.h"

@interface SHYTaskViewModel : SHYBaseViewModel

@property (nonatomic, strong) RACSubject * enterBtnSignal;
@property (nonatomic, strong) RACSubject * startBtnSignal;

- (void)setContentView:(SHYTaskCell*)view model:(SHYTaskModel*)taskModel;

@end
