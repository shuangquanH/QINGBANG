//
//  BuyOrderTableViewCell.m
//  FrienDo
//
//  Created by zhangkaifeng on 2017/9/25.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "BuyOrderTableViewCell.h"
#import "BuyOrderPayWayModel.h"

@implementation BuyOrderTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _titleLabel.textColor = colorWithBlack;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setModel:(BuyOrderPayWayModel *)model
{
    _model = model;
    _headImageView.image = [UIImage imageNamed:model.imageName];
    _titleLabel.text = model.payTitle;
    _selectButton.selected = model.isSelected;
}

- (IBAction)selectButtonClick:(UIButton *)sender
{
    self.selected = YES;
}

@end
