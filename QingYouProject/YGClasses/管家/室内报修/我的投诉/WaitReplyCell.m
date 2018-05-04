//
//  WaitReplyCell.m
//  QingYouProject
//
//  Created by LDSmallCat on 2017/10/25.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "WaitReplyCell.h"
#import "WaitReplyModel.h"
@interface WaitReplyCell ()
@property (weak, nonatomic) IBOutlet UIView *topline;

@property (weak, nonatomic) IBOutlet UILabel *topTextLabel;

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (weak, nonatomic) IBOutlet UIButton *revokedButton;
@property (weak, nonatomic) IBOutlet UILabel *bottomLine;

@end



@implementation WaitReplyCell
- (void)setModel:(WaitReplyModel *)model{
    _model = model;
    
    self.topTextLabel.text = model.message;
    self.timeLabel.text =[NSString stringWithFormat:@"投诉时间:%@",model.createDate];
    self.timeLabel.textColor = colorWithDeepGray;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    self.bottomLine.backgroundColor = LDEEPaddingColor;
    self.topline.backgroundColor = LDEEPaddingColor;
    self.revokedButton.layer.cornerRadius = 15;
    self.revokedButton.layer.borderWidth = 1;
    self.revokedButton.layer.borderColor = colorWithLine.CGColor;
    self.revokedButton.layer.masksToBounds = YES;
    self.topTextLabel.preferredMaxLayoutWidth = YGScreenWidth -20;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
#pragma mark - 撤销按钮点击
- (IBAction)revokedButtonClick:(id)sender {

    [self.delegate WaitReplyCellDelegateDeletewithrow:self.row];
}

@end
