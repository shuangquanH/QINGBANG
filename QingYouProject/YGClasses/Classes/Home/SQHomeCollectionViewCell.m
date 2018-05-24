//
//  SQHomeCollectionViewCell.m
//  QingYouProject
//
//  Created by qwuser on 2018/5/24.
//  Copyright © 2018年 ccyouge. All rights reserved.
//

#import "SQHomeCollectionViewCell.h"

@implementation SQHomeCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.borderColor = kGrayColor.CGColor;
        self.layer.borderWidth = 1;
        self.imageView = [[UIImageView alloc] init];
        self.imageView.image = [UIImage imageNamed:@"ovalimage"];
        [self addSubview:self.imageView];
        [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
    }
    return self;
}


@end
