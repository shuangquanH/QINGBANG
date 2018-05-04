//
//  LDPendingCell.m
//  QingYouProject
//
//  Created by LDSmallCat on 2017/9/27.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "LDPendingCell.h"



@interface LDPendingCell ()
@property (weak, nonatomic) IBOutlet UILabel *orderNumber;
@property (weak, nonatomic) IBOutlet UILabel *orderType;
@property (weak, nonatomic) IBOutlet UIImageView *orderImageView;


@end
@implementation LDPendingCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.orderType.textColor = LDMainColor;
    self.orderNumber.textColor = LD9ATextColor;
    self.contentView.backgroundColor = LDEFPaddingColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
