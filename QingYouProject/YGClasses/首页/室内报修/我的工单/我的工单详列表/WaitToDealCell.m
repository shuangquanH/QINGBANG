//
//  WaitToDealCell.m
//  QingYouProject
//
//  Created by LDSmallCat on 2017/10/26.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "WaitToDealCell.h"
#import "WaitToDealModel.h"


@interface WaitToDealCell ()

@property (weak, nonatomic) IBOutlet UILabel *topLine;

@property (weak, nonatomic) IBOutlet UIImageView *orderImageView;

@property (weak, nonatomic) IBOutlet UIButton *dealingButton;
@property (weak, nonatomic) IBOutlet UILabel *bottomLine;

@property (weak, nonatomic) IBOutlet UIButton *dealedButton;

@property (weak, nonatomic) IBOutlet UILabel *orderNUmber;

@property (weak, nonatomic) IBOutlet UILabel *orderName;

@property (weak, nonatomic) IBOutlet UILabel *orderTime;



@end


@implementation WaitToDealCell
#pragma mark - 处理中点击事件
- (IBAction)dealingButtonClick:(id)sender {
//    [YGAppTool showToastWithText:@"处理中"];
    [self.delegate WaitToDealCellDelegateDealIngBtnClick:sender withrow:self.row];
}
#pragma mark - 已处理点击事件
- (IBAction)dealedButtonClick:(id)sender {
//    [YGAppTool showToastWithText:@"已处理"];
    [self.delegate WaitToDealCellDelegateAlreadyDealBtnClick:sender withrow:self.row];
}

- (void)awakeFromNib {
    [super awakeFromNib];

    self.topLine.backgroundColor = LDEFPaddingColor;
    self.bottomLine.backgroundColor = LDEFPaddingColor;
        
    self.dealingButton.layer.cornerRadius = 15;
    self.dealingButton.layer.borderWidth = 1;
    self.dealingButton.layer.borderColor = KCOLOR_MAIN.CGColor;
    
    self.dealedButton.layer.cornerRadius = 15;
    self.dealedButton.layer.borderWidth = 1;
    self.dealedButton.layer.borderColor = KCOLOR_MAIN.CGColor;
   
    self.orderName.preferredMaxLayoutWidth = YGScreenWidth  - self.orderImageView.width - 28;

}
- (void)setModel:(WaitToDealModel *)model{
    _model = model;
    
    self.orderNUmber.text = [NSString stringWithFormat:@"服务工单号 %@",model.workNumber];
    self.orderName.text = model.indoorMessage;
    self.orderTime.text = [NSString stringWithFormat:@"下单时间: %@",model.createDate];
    [self.orderImageView sd_setImageWithURL:[NSURL URLWithString:model.indoorPicture] placeholderImage:YGDefaultImgFour_Three];
}



@end
