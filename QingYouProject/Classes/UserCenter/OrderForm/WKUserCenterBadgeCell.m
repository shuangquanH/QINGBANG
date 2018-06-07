//
//  WKUserCenterBadgeCell.m
//  QingYouProject
//
//  Created by mac on 2018/6/7.
//  Copyright © 2018年 ccyouge. All rights reserved.
//

#import "WKUserCenterBadgeCell.h"

@implementation WKUserCenterBadgeCell
{
    UILabel *_badgeLab;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (!self.imageView.image) return;
    
    if (!_badgeLab) {
        _badgeLab = [UILabel labelWithFont:KSCAL(20) textColor:[UIColor whiteColor] textAlignment:NSTextAlignmentCenter];
        _badgeLab.backgroundColor = [UIColor redColor];
        [self.imageView addSubview:_badgeLab];
    }
    
    CGFloat radius = self.imageView.width / 2.0;
    CGFloat centerX = sqrt(radius * radius / 2);
    _badgeLab.center = CGPointMake(radius + centerX, radius - centerX);
    _badgeLab.size = CGSizeMake(15, 15);
    _badgeLab.layer.cornerRadius = 7.5;
    _badgeLab.layer.masksToBounds = YES;
    _badgeLab.text = @"1";
}


@end
