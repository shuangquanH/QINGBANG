//
//  DeailingRepairOrderTableViewCell.m
//  QingYouProject
//
//  Created by apple on 2017/11/8.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "DeailingRepairOrderTableViewCell.h"
#import "WaitToDealModel.h"

@interface DeailingRepairOrderTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *topLine;
@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
@property (weak, nonatomic) IBOutlet UILabel *bottomLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderTitle;
@property (weak, nonatomic) IBOutlet UILabel *orderNumber;
@property (weak, nonatomic) IBOutlet UILabel *orderTime;
@property (weak, nonatomic) IBOutlet UILabel *stateLabel;


@end

@implementation DeailingRepairOrderTableViewCell


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.topLine.backgroundColor = LDEFPaddingColor;
    self.bottomLabel.backgroundColor = LDEFPaddingColor;
    self.stateLabel.textColor = colorWithDeepGray;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setModel:(WaitToDealModel *)model{
    _model = model;
    
    self.orderNumber.text = [NSString stringWithFormat:@"服务工单号 %@",model.workNumber];
    self.orderTitle.text = model.indoorMessage;
    self.orderTime.text = [NSString stringWithFormat:@"下单时间: %@",model.createDate];
    [self.headerImageView sd_setImageWithURL:[NSURL URLWithString:model.indoorPicture] placeholderImage:YGDefaultImgAvatar];
    self.stateLabel.text = [NSString stringWithFormat:@"您的工单正在处理中！%@",model.processTime];
}

@end
