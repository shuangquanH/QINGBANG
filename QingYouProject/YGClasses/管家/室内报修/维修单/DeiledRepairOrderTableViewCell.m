//
//  DeiledRepairOrderTableViewCell.m
//  QingYouProject
//
//  Created by apple on 2017/11/8.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "DeiledRepairOrderTableViewCell.h"
#import "WaitToDealModel.h"
#import "RepairOrderJudgeViewController.h"

@interface DeiledRepairOrderTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *topLine;
@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
@property (weak, nonatomic) IBOutlet UILabel *orderTitle;
@property (weak, nonatomic) IBOutlet UILabel *orderTime;
@property (weak, nonatomic) IBOutlet UILabel *stateLabelOne;
@property (weak, nonatomic) IBOutlet UILabel *stateLabelTwo;
@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;
@property (weak, nonatomic) IBOutlet UIButton *judgeBtn;
@property (weak, nonatomic) IBOutlet UILabel *lineOne;
@property (weak, nonatomic) IBOutlet UILabel *lineTwo;
@property (weak, nonatomic) IBOutlet UILabel *orderNumber;
@property (weak, nonatomic) IBOutlet UILabel *dealstateLable;


@end

@implementation DeiledRepairOrderTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.topLine.backgroundColor = LDEFPaddingColor;
    self.lineOne.backgroundColor = LDEFPaddingColor;
    self.lineTwo.backgroundColor = LDEFPaddingColor;
    self.stateLabelOne.textColor = colorWithDeepGray;
    self.stateLabelTwo.textColor = colorWithDeepGray;
    self.dealstateLable.textColor = colorWithMainColor;
    
    self.deleteBtn.layer.cornerRadius = 15;
    self.deleteBtn.layer.borderWidth = 1;
    self.deleteBtn.layer.borderColor = colorWithLine.CGColor;
    
    self.judgeBtn.layer.cornerRadius = 15;
    self.judgeBtn.layer.borderWidth = 1;
    self.judgeBtn.layer.borderColor = LDMainColor.CGColor;
    [self.judgeBtn setTitleColor:colorWithMainColor forState:UIControlStateNormal];
    
}
- (IBAction)deleBtnClick:(id)sender {
    [self.delegate DeiledRepairOrderTableViewCellDelegateDeleteBtnClick:sender withrow:self.row];
}

- (IBAction)judgeBtnClick:(id)sender {
    
    if([_model.evaluateType isEqualToString:@"1"])
    {
        [self.delegate DeiledRepairOrderTableViewCellDelegateDeleteBtnClick:sender withrow:self.row];
        return;
    }
    
    [self.delegate DeiledRepairOrderTableViewCellDelegateJudgeBtnClick:sender withrow:self.row];
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
    [self.headerImageView sd_setImageWithURL:[NSURL URLWithString:model.indoorPicture] placeholderImage:YGDefaultImgFour_Three];
    self.stateLabelOne.text = [NSString stringWithFormat:@"您的工单正在处理中！%@",model.processTime];
    self.stateLabelTwo.text = [NSString stringWithFormat:@"您的工单已经处理完！%@",model.completedTime];

    if(_model.cause.length >0)
        self.dealstateLable.hidden = NO;
    else
        self.dealstateLable.hidden = YES;

    if([_model.evaluateType isEqualToString:@"1"])
    {
        self.deleteBtn.hidden = YES;
        [self.judgeBtn setTitle:@"删除工单" forState:UIControlStateNormal];
        self.judgeBtn.layer.borderColor = colorWithLine.CGColor;
        [self.judgeBtn setTitleColor:colorWithBlack forState:UIControlStateNormal];
    }
    else
    {
        self.deleteBtn.hidden = NO;
        [self.judgeBtn setTitle:@"立即评价" forState:UIControlStateNormal];
        self.judgeBtn.layer.borderColor = colorWithMainColor.CGColor;
        [self.judgeBtn setTitleColor:colorWithMainColor forState:UIControlStateNormal];
    }
    
}
@end
