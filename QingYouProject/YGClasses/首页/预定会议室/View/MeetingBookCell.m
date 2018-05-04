//
//  MeetingBookCell.m
//  QingYouProject
//
//  Created by zhaoao on 2017/10/20.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "MeetingBookCell.h"

@implementation MeetingBookCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)setModel:(MeetingBookingModel *)model
{
    _model = model;
    self.meetingNameLabel.text = model.roomName;
    self.meetingAddressLabel.text = model.address;
    self.meetingPriceLabel.text = [NSString stringWithFormat:@"%@元/小时",model.expense];

    NSURL *picUrl = [NSURL URLWithString:model.imgUrl];
    [self.meetingImageView sd_setImageWithURL:picUrl placeholderImage:YGDefaultImgSixteen_Nine];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
