//
//  AdvertisementLocationViewCell.m
//  QingYouProject
//
//  Created by zhaoao on 2017/9/21.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "AdvertisementLocationViewCell.h"

@implementation AdvertisementLocationViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.oneAdvertiseLocationImageView.clipsToBounds = YES;
    self.twoAdvertiseLocationImageView.clipsToBounds = YES;
    self.threeAdvertiseLocationImageView.clipsToBounds = YES;
    self.fourAdvertiseLocationImageView.clipsToBounds = YES;
    self.fiveAdvertiseLocationImageView.clipsToBounds = YES;
    
    self.oneAdvertiseLocationImageView.layer.cornerRadius = 5;
    self.twoAdvertiseLocationImageView.layer.cornerRadius = 5;
    self.threeAdvertiseLocationImageView.layer.cornerRadius = 5;
    self.fourAdvertiseLocationImageView.layer.cornerRadius = 5;
    self.fiveAdvertiseLocationImageView.layer.cornerRadius = 5;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
