//
//  MeetingOrderCell.m
//  QingYouProject
//
//  Created by zhaoao on 2017/10/20.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "MeetingOrderCell.h"

@implementation MeetingOrderCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.picImageView.layer.cornerRadius = 8;
    self.picImageView.clipsToBounds = YES;
}

-(void)setModel:(MyOrderModel *)model
{
    _model = model;
    
    NSString *beginHour = [model.beginTime substringWithRange:NSMakeRange(0, 2)];
    NSString *beginMinute = [model.beginTime substringWithRange:NSMakeRange(3, 2)];
    NSString *endHour = [model.endTime substringWithRange:NSMakeRange(0, 2)];
    NSString *endMinute = [model.endTime substringWithRange:NSMakeRange(3, 2)];
    if([beginMinute isEqualToString:@"30"])
    {
        beginMinute = @"5";
    }
    if([endMinute isEqualToString:@"30"])
    {
        endMinute = @"5";
    }
    if ([endHour isEqualToString:@"00"]) {
        endHour = @"24";
    }
    CGFloat beginNum = [[NSString stringWithFormat:@"%@.%@",beginHour,beginMinute] floatValue];
    CGFloat endNum = [[NSString stringWithFormat:@"%@.%@",endHour,endMinute] floatValue];
    CGFloat timeInterval = endNum - beginNum;
    
    self.roomNameLabel.text = model.boardroomName;
    self.timeLabel.text = [NSString stringWithFormat:@"时间: %.lf小时",timeInterval];
    self.timeDetailLabel.text = [NSString stringWithFormat:@"%@ %@ 至 %@",model.orderDate,model.beginTime,model.endTime];
    self.moneyLabel.text = [NSString stringWithFormat:@"¥%@",model.price];
    NSURL *picUrl = [NSURL URLWithString:model.roomImg];
    [self.picImageView sd_setImageWithURL:picUrl placeholderImage:YGDefaultImgSquare];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
