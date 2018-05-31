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
        self.layer.masksToBounds = YES;
        self.imageView = [[SQBaseImageView alloc] init];
        [self addSubview:self.imageView];
        [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
    }
    return self;
}


- (void)setModel:(SQHomeFuncsModel *)model {
    _model = model;
    [self.imageView setImageWithUrl:model.funcs_image_url];
}

@end
