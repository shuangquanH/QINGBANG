//
//  SecondhandReplacementSubstitutionWaitToGoodsTableViewCell.h
//  QingYouProject
//
//  Created by apple on 2017/12/20.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SecondhandReplacementIBoughtModel;
@protocol SecondhandReplacementSubstitutionWaitToGoodsTableViewCellDelegate <NSObject>//协议

@optional

- (void)secondhandReplacementSubstitutionWaitToGoodsTableViewCellPayButton:(UIButton *)paybtn withRow:(NSInteger)row;//协议方法
- (void)secondhandReplacementSubstitutionWaitToGoodsTableViewCellCustomerServiceButton:(UIButton *)btn withRow:(NSInteger)row;//协议方法
- (void)secondhandReplacementSubstitutionWaitToGoodsTableViewCellLogisticsButton:(UIButton *)btn withRow:(NSInteger)row;//协议方法

- (void)secondhandReplacementSubstitutionWaitToGoodsTableViewCelladdressButton:(UIButton *)btn withRow:(NSInteger)row;//协议方法

@end

@interface SecondhandReplacementSubstitutionWaitToGoodsTableViewCell : UITableViewCell
@property (nonatomic, assign) id <SecondhandReplacementSubstitutionWaitToGoodsTableViewCellDelegate>delegate;
@property (nonatomic, assign) NSInteger row;
@property (nonatomic, strong) SecondhandReplacementIBoughtModel *model;
@property (nonatomic, strong) NSString *relopType;


@end
