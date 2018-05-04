//
//  AdvertisementLocationCell.m
//  QingYouProject
//
//  Created by zhaoao on 2017/11/1.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "AdvertisementLocationCell.h"

@implementation AdvertisementLocationCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.blackView.backgroundColor = [UIColor colorWithWhite:0.f alpha:0.5];
    
    self.areaImageView.layer.cornerRadius = 5;
    self.areaImageView.clipsToBounds = YES;
    
    self.blackView.layer.cornerRadius = 5;
    self.blackView.clipsToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
