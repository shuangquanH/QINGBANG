//
//  DealedCell.m
//  QingYouProject
//
//  Created by LDSmallCat on 2017/10/27.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "DealedCell.h"
#import "WaitToDealModel.h"

@interface DealedCell ()

@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
@property (weak, nonatomic) IBOutlet UILabel *bottomLabel;

@property (weak, nonatomic) IBOutlet UILabel *orderTitle;
@property (weak, nonatomic) IBOutlet UILabel *orderNumber;
@property (weak, nonatomic) IBOutlet UILabel *orderTime;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;
@property (weak, nonatomic) IBOutlet UILabel *topLine;
@property (weak, nonatomic) IBOutlet UILabel *dealState;

@end


@implementation DealedCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.topLine.backgroundColor = LDEFPaddingColor;
    self.bottomLabel.backgroundColor = LDEFPaddingColor;
        
    self.deleteButton.layer.cornerRadius = 15;
    self.deleteButton.layer.borderWidth = 1;
    self.deleteButton.layer.borderColor = colorWithLine.CGColor;
    
    self.orderTitle.preferredMaxLayoutWidth = YGScreenWidth -28 - self.headerImageView.width;
    self.dealState.textColor = colorWithMainColor;
    self.dealState.hidden = YES;

}

#pragma mark - 删除工单 点击事件
- (IBAction)deleteButtonClick:(id)sender {
    
    [self.delegate DealedCellDelegateDeleteBtnClick:sender withrow:self.row];
}
- (void)setModel:(WaitToDealModel *)model{
    _model = model;
    
    self.orderNumber.text = [NSString stringWithFormat:@"服务工单号 %@",model.workNumber];
    self.orderTitle.text = model.indoorMessage;
    self.orderTime.text = [NSString stringWithFormat:@"下单时间: %@",model.createDate];
    [self.headerImageView sd_setImageWithURL:[NSURL URLWithString:model.indoorPicture] placeholderImage:YGDefaultImgFour_Three];
    if([self.tagStr isEqualToString:@"WaitToDealRepairOrder"])
    {
        [self.deleteButton setTitle:@"取消报修" forState:UIControlStateNormal];
        self.dealState.hidden = YES;
        return;
    }
  
    if(model.cause.length >0)
        self.dealState.hidden = NO;
    else
        self.dealState.hidden = YES;

}

@end
