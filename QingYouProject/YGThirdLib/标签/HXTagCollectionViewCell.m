//
//  HXTagCollectionViewCell.m
//  黄轩 https://github.com/huangxuan518
//
//  Created by 黄轩 on 16/1/13.
//  Copyright © 2015年 IT小子. All rights reserved.
//

#import "HXTagCollectionViewCell.h"
#import "UIView+LDFrame.h"
@implementation HXTagCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        _titleLabel = [[UILabel alloc] initWithFrame:self.bounds];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_titleLabel];
        
        self.delegateImageView = [[UIImageView alloc] init];
        [self.contentView addSubview:self.delegateImageView];
        self.delegateImageView.image = LDImage(@"product_close_red");
    }
    
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.titleLabel.frame = self.bounds;
    self.delegateImageView.frame = CGRectMake(self.titleLabel.ld_right - 8, -8, 16, 16);
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    
    self.titleLabel.text = @"";
}

@end
