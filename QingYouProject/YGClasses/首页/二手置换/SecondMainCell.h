//
//  SecondMainCell.h
//  QingYouProject
//
//  Created by zhaoao on 2017/12/12.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WorthInModel.h"


@protocol SecondMainCellDelegate <NSObject>

//- (void)circleTableViewCell:(SecondMainCell *)cell didClickImageButtonWithIndex:(int)index imageButton:(UIButton *)imageButton imageArray:(NSArray *)imageArray;
//- (void)circleTableViewCell:(SecondMainCell *)cell didClickAvatarButtonWithModel:(AllianceCircleTrendsModel *)model;
//- (void)circleTableViewCell:(SecondMainCell *)cell didClickCollectButtonWithModel:(AllianceCircleTrendsModel *)model collectButton:(UIButton *)button;
//- (void)circleTableViewCell:(SecondMainCell *)cell didClickGoodButtonWithModel:(AllianceCircleTrendsModel *)model goodButton:(UIButton *)button;
//- (void)circleTableViewCell:(SecondMainCell *)cell didClickCommentButtonWithModel:(AllianceCircleTrendsModel *)model;


@end

@interface SecondMainCell : UITableViewCell

@property (nonatomic,strong) UIButton *avatarButton;
@property (nonatomic,strong) UIImageView *avatarImageView;
@property (nonatomic,strong) UILabel *nameLabel;
@property (nonatomic,strong) UILabel *timeLabel;
@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UILabel *detailLabel;
@property (nonatomic,strong) UIView *baseView;
@property (nonatomic,strong) UILabel *playCountLabel;
@property (nonatomic,strong) UIButton *goodButton;
@property (nonatomic,strong) UIButton *commentButton;
@property (nonatomic,strong) UIImageView *videoImageView;

@property (nonatomic,strong) WorthInModel *model;
@property (nonatomic,assign) id<SecondMainCellDelegate> delegate;

@end
