//
//  SecondhandReplacementIBoughtTableViewCell.h
//  QingYouProject
//
//  Created by apple on 2017/12/14.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SecondhandReplacementIBoughtModel;
@protocol SecondhandReplacementIBoughtTableViewCellDelegate <NSObject>//协议

@optional

- (void)secondhandReplacementIBoughtTableViewCellPayButton:(UIButton *)paybtn withRow:(NSInteger)row;//协议方法
- (void)secondhandReplacementIBoughtTableViewCellCustomerServiceButton:(UIButton *)btn withRow:(NSInteger)row;//协议方法
- (void)secondhandReplacementIBoughtTableViewCellLogisticsButton:(UIButton *)btn withRow:(NSInteger)row;//协议方法

@end

@interface SecondhandReplacementIBoughtTableViewCell : UITableViewCell

- (void)setModelValeFalseWithType:(NSInteger )type;
- (void)setValeForSellOutWithModel:(SecondhandReplacementIBoughtModel *)model;

@property (nonatomic, assign) id <SecondhandReplacementIBoughtTableViewCellDelegate>delegate;
@property (nonatomic, assign) NSInteger row;
@property (nonatomic, strong) SecondhandReplacementIBoughtModel *model;
@end

