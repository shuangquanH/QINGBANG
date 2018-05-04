//
//  ApplyAdvanceFundsView.h
//  QingYouProject
//
//  Created by zhaoao on 2017/11/14.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ApplyAdvanceFundsView : UIView
@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UIButton *cancelApplyButton;
@property (weak, nonatomic) IBOutlet UITextField *allFundsTextField;
@property (weak, nonatomic) IBOutlet UITextField *fundsPercentTextField;
@property (weak, nonatomic) IBOutlet UIButton *confirmApplyButton;
@property (weak, nonatomic) IBOutlet UILabel *percentWarnLabel;

@end
