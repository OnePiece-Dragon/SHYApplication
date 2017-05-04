//
//  SHYTaskViewModel.m
//  SongHuoYi
//
//  Created by 王亚龙 on 2017/5/2.
//  Copyright © 2017年 TianXi. All rights reserved.
//

#import "SHYTaskViewModel.h"

@implementation SHYTaskViewModel

- (void)initialize {
    [super initialize];
    self.startBtnSignal = [RACSubject subject];
    self.enterBtnSignal = [RACSubject subject];
}

- (void)setContentView:(SHYTaskCell*)view model:(SHYTaskModel*)taskModel {
    [view setCellModel:taskModel];
    SHYIconLabel*label1 = view.labelArray[0];
    SHYIconLabel*label2 = view.labelArray[1];
    SHYIconLabel*label3 = view.labelArray[2];
    SHYIconLabel*label4 = view.labelArray[3];
    SHYIconLabel*label5 = view.labelArray[4];
    SHYIconLabel*label6 = view.labelArray[5];
    
    [label2 setIcon:@"renwudan" size:CGSizeMake(24, 24)];
    [label3 setIcon:@"dizhi" size:CGSizeMake(24, 28)];
    
    label1.titleLabel.text = taskModel.lineName;
    label2.titleLabel.text = [NSString stringWithFormat:@"任务单号：%@",taskModel.tasksId];
    label3.titleLabel.text = [NSString stringWithFormat:@"地址：%@",taskModel.startAddr];
    label4.titleLabel.text = [NSString stringWithFormat:@"取件任务数：%@",taskModel.orderNum];
    label5.titleLabel.text = [NSString stringWithFormat:@"商户数量：%@",taskModel.merchantNum];
    label6.titleLabel.text = [NSString stringWithFormat:@"共计：%@",taskModel.taskDetail];
    
    
    if ([taskModel.nuclearStatus integerValue] == 0) {
        //未核货
        [view.enterBtn setTitle:@"进入核货" forState:UIControlStateNormal];
    }else if ([taskModel.nuclearStatus integerValue] == 1){
        //核货完成
        [view.enterBtn setTitle:@"核货完成" forState:UIControlStateNormal];
    }
}

@end
