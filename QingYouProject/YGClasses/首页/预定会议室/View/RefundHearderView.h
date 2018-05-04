//
//  RefundHearderView.h
//  QingYouProject
//
//  Created by zhaoao on 2017/10/21.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RefundModel.h"

@interface RefundHearderView : UIView
@property (weak, nonatomic) IBOutlet UILabel *resonLabel;
@property (weak, nonatomic) IBOutlet UIButton *radioButton;
@property (weak, nonatomic) IBOutlet UIButton *rowButton;


@property(nonatomic,strong)RefundModel *refundModel;

@end
