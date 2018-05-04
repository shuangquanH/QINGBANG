//
//  AllianceCircleTrendsCell.h
//  
//
//  Created by nefertari on 2017/10/16.
//

#import <UIKit/UIKit.h>
#import "AllianceCircleTrendsModel.h"

@class AllianceCircleTrendsCell;

@protocol AllianceCircleTrendsCellDelegate <NSObject>

- (void)circleTableViewCell:(AllianceCircleTrendsCell *)cell didClickImageButtonWithIndex:(int)index imageButton:(UIButton *)imageButton imageArray:(NSArray *)imageArray;
- (void)circleTableViewCell:(AllianceCircleTrendsCell *)cell didClickAvatarButtonWithModel:(AllianceCircleTrendsModel *)model;
- (void)circleTableViewCell:(AllianceCircleTrendsCell *)cell didClickCollectButtonWithModel:(AllianceCircleTrendsModel *)model collectButton:(UIButton *)button;
- (void)circleTableViewCell:(AllianceCircleTrendsCell *)cell didClickGoodButtonWithModel:(AllianceCircleTrendsModel *)model goodButton:(UIButton *)button;
- (void)circleTableViewCell:(AllianceCircleTrendsCell *)cell didClickCommentButtonWithModel:(AllianceCircleTrendsModel *)model;


@end

@interface AllianceCircleTrendsCell : UITableViewCell

//@property (nonatomic,strong) UIButton *avatarButton;
@property (nonatomic,strong) UILabel *nameLabel;
@property (nonatomic,strong) UILabel *timeLabel;
@property (nonatomic,strong) UILabel *detailLabel;
@property (nonatomic,strong) UIView *baseView;
@property (nonatomic,strong) UILabel *playCountLabel;
@property (nonatomic,strong) UIButton *goodButton;
@property (nonatomic,strong) UIButton *commentButton;
@property (nonatomic,strong) UIImageView *videoImageView;

@property (nonatomic,strong) AllianceCircleTrendsModel *model;
@property (nonatomic,assign) id<AllianceCircleTrendsCellDelegate> delegate;
@end
