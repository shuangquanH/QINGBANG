//
//  AlreadyReplayCell.m
//  QingYouProject
//
//  Created by LDSmallCat on 2017/10/25.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "AlreadyReplayCell.h"
#import "AlreadyReplayModel.h"

@interface AlreadyReplayCell ()
/** 投诉label */
@property (weak, nonatomic) IBOutlet UILabel *suspendLabel;
/** 投诉时间 */
@property (weak, nonatomic) IBOutlet UILabel *suspendTimeLabel;
/** 回复内容 */
@property (weak, nonatomic) IBOutlet UILabel *replayLabel;
/** 回复时间 */
@property (weak, nonatomic) IBOutlet UILabel *replyTimeLabel;

@property (weak, nonatomic) IBOutlet UIButton *revokedButton;
@property (weak, nonatomic) IBOutlet UIView *topLine;
@property (weak, nonatomic) IBOutlet UILabel *bottomLine;

@end


@implementation AlreadyReplayCell
- (void)setModel:(AlreadyReplayModel *)model{
    _model = model;
    
    self.suspendLabel.text = model.message;
    self.replayLabel.text = model.replyContent;
    
    
    self.suspendTimeLabel.text = [NSString stringWithFormat:@"投诉时间:%@",model.createDate];
    self.replyTimeLabel.text = [NSString stringWithFormat:@"回复时间:%@",model.updateDate];
    self.suspendTimeLabel.textColor = colorWithDeepGray;
    self.replyTimeLabel.textColor = colorWithDeepGray;

}
- (void)awakeFromNib {
    [super awakeFromNib];
    self.bottomLine.backgroundColor = LDEEPaddingColor;

    self.topLine.backgroundColor = LDEEPaddingColor;
    self.revokedButton.layer.cornerRadius = 15;
    self.revokedButton.layer.borderWidth = 1;
    self.revokedButton.layer.borderColor = colorWithLine.CGColor;
    self.revokedButton.layer.masksToBounds = YES;

    self.replayLabel.preferredMaxLayoutWidth = YGScreenWidth -20;
    self.suspendLabel.preferredMaxLayoutWidth = YGScreenWidth -20;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
#pragma mark - 撤销按钮点击
- (IBAction)revokedButtonClick:(id)sender {
    [self.delegate alreadyReplayCellDeleteWithRow:self.row];
}

@end
