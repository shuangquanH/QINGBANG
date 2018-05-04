//
//  RecommendCollectionCell.m
//  QingYouProject
//
//  Created by zhaoao on 2017/9/22.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "RecommendCollectionCell.h"

@implementation RecommendCollectionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.recommendImageView.clipsToBounds = YES;
    self.recommendImageView.layer.cornerRadius = 6;
}

@end
