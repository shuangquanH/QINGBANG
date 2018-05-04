//
//  PlayTogetherMoreActiveCollectionViewCell.m
//  QingYouProject
//
//  Created by apple on 2017/11/15.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "PlayTogetherMoreActiveCollectionViewCell.h"
#import "PlayTogetherDetailRecommendListModel.h"

@interface PlayTogetherMoreActiveCollectionViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *activeImage;
@property (weak, nonatomic) IBOutlet UILabel *activeTitle;
@property (weak, nonatomic) IBOutlet UILabel *activeAddress;
@property (weak, nonatomic) IBOutlet UILabel *activeTime;


@end
@implementation PlayTogetherMoreActiveCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.activeAddress.textColor =colorWithDeepGray;
    self.activeTime.textColor =colorWithDeepGray;
}
-(void)setModel:(PlayTogetherDetailRecommendListModel *)model
{
    _model =model;
    [self.activeImage sd_setImageWithURL:[NSURL URLWithString:model.activityCoverUrl] placeholderImage:YGDefaultImgThree_Four];
    self.activeTitle.text = model.activityName;
    self.activeAddress.text = model.activityAddress;
    self.activeTime.text = model.activityBeginTime;
}
@end
