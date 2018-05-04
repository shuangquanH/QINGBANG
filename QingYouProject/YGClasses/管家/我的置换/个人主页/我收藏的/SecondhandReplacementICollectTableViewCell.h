//
//  SecondhandReplacementICollectTableViewCell.h
//  QingYouProject
//
//  Created by apple on 2017/12/21.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SecondhandPeplaceCollectModel;

@protocol SecondhandReplacementICollectTableViewCellDelegate <NSObject>//协议

@optional

- (void)secondhandReplacementICollectTableViewCellCancelButton:(UIButton *)btn withRow:(NSInteger)row;//协议方法

@end

@interface SecondhandReplacementICollectTableViewCell : UITableViewCell
@property (nonatomic,strong) UIButton *avatarButton;
@property (nonatomic,strong) UILabel *nameLabel;
@property (nonatomic,strong) UILabel *timeLabel;
@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UILabel *detailLabel;
@property (nonatomic,strong) UIView *baseView;
@property (nonatomic,strong) UILabel *playCountLabel;
@property (nonatomic,strong) UIButton *cancalButton;

@property (nonatomic,strong) UIImageView *videoImageView;

@property (nonatomic,strong) SecondhandPeplaceCollectModel *model;
@property (nonatomic,assign) id<SecondhandReplacementICollectTableViewCellDelegate> delegate;
@property (nonatomic, assign) NSInteger row;

@end
