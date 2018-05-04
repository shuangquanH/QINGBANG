//
//  SecondhandReplacementICreateTableViewCell.h
//  QingYouProject
//
//  Created by apple on 2017/12/21.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SecondhandReplacementICreateModel;
@protocol SecondhandReplacementICreateTableViewCellDelegate <NSObject>//协议

@optional

- (void)secondhandReplacementICreateTableViewCellPlatformButton:(UIButton *)btn withRow:(NSInteger)row;//协议方法
- (void)secondhandReplacementICreateTableViewCellEditBtn:(UIButton *)btn withRow:(NSInteger)row;//协议方法
- (void)secondhandReplacementICreateTableViewCellDeleteBtn:(UIButton *)btn withRow:(NSInteger)row;//协议方法

@end

@interface SecondhandReplacementICreateTableViewCell : UITableViewCell
@property (nonatomic, assign) id <SecondhandReplacementICreateTableViewCellDelegate>delegate;
@property (nonatomic, assign) NSInteger row;
@property (nonatomic, strong) SecondhandReplacementICreateModel *model;
- (void)setModelValeSellOutWithType:(NSInteger )type;



@end
