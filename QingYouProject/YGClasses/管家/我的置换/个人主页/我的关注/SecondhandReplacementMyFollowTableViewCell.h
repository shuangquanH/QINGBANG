//
//  SecondhandReplacementMyFollowTableViewCell.h
//  QingYouProject
//
//  Created by apple on 2017/12/21.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SecondhandReplacementMyFollowModel;
@protocol SecondhandReplacementMyFollowTableViewCellDelegate <NSObject>//协议

@optional

- (void)secondhandReplacementMyFollowTableViewCellCannelButton:(UIButton *)btn withRow:(NSInteger)row;//协议方法

@end

@interface SecondhandReplacementMyFollowTableViewCell : UITableViewCell
@property (nonatomic, strong) SecondhandReplacementMyFollowModel *model;
@property (nonatomic, assign) id <SecondhandReplacementMyFollowTableViewCellDelegate>delegate;
@property (nonatomic, assign) NSInteger row;

@end
