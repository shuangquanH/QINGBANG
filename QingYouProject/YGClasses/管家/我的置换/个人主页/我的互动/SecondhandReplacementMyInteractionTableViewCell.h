//
//  SecondhandReplacementMyInteractionTableViewCell.h
//  QingYouProject
//
//  Created by apple on 2017/12/21.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SecondhandReplacementMyInteractionModel;
@protocol SecondhandReplacementMyInteractionTableViewCellDelegate <NSObject>//协议

@optional

- (void)secondhandReplacementMyInteractionTableViewCellRefuseButtonButton:(UIButton *)btn withRow:(NSInteger)row;//协议方法
- (void)secondhandReplacementMyInteractionTableViewCellAgreeButtonButton:(UIButton *)btn withRow:(NSInteger)row;//协议方法
- (void)secondhandReplacementMyInteractionTableViewCellMyGoodsDetailWithRow:(NSInteger)row;//协议方法
- (void)secondhandReplacementMyInteractionTableViewCellOtherGoodsDetailWithRow:(NSInteger)row;//协议方法

@end

@interface SecondhandReplacementMyInteractionTableViewCell : UITableViewCell

@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UILabel *exchangeLabel;

@property (nonatomic,strong) UIButton *refuseButton;
@property (nonatomic,strong) UIButton *agreeButton;

@property (nonatomic, strong) SecondhandReplacementMyInteractionModel *model;

@property (nonatomic, assign) id <SecondhandReplacementMyInteractionTableViewCellDelegate>delegate;
@property (nonatomic, assign) NSInteger row;
@end
