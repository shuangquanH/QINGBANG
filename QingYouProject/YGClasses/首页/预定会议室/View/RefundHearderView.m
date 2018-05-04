//
//  RefundHearderView.m
//  QingYouProject
//
//  Created by zhaoao on 2017/10/21.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "RefundHearderView.h"

@implementation RefundHearderView

- (void)drawRect:(CGRect)rect {
    self.radioButton.userInteractionEnabled = NO;
    self.rowButton.userInteractionEnabled = YES;
}

-(void)setRefundModel:(RefundModel *)refundModel
{
    _refundModel = refundModel;
    self.resonLabel.text = refundModel.reason;
    if ([refundModel.select isEqualToString:@"1"])
    {
        self.radioButton.selected = YES;
    }else
    {
        self.radioButton.selected = NO;
    }
    
}

@end
