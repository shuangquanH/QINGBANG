//
//  WKDecorationRepairPhotoCell.m
//  QingYouProject
//
//  Created by mac on 2018/6/8.
//  Copyright © 2018年 ccyouge. All rights reserved.
//

#import "WKDecorationRepairPhotoCell.h"

@implementation WKDecorationRepairPhotoCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews {
    _imageView = [UIImageView new];
    _imageView.contentMode = UIViewContentModeScaleAspectFill;
    _imageView.layer.borderWidth = 0.0;
    _imageView.backgroundColor = [UIColor whiteColor];
    _imageView.layer.borderColor = KCOLOR_MAIN.CGColor;
    _imageView.layer.masksToBounds = YES;
    [self.contentView addSubview:_imageView];
    
    _deleteBtn = [UIButton buttonWithTitle:@"删除" titleFont:KSCAL(28) titleColor:kCOLOR_333];
    [_deleteBtn addTarget:self action:@selector(click_deleteButton) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_deleteBtn];
    
    [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(0);
        make.height.mas_equalTo(KSCAL(180));
    }];
    
    [_deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.imageView.mas_bottom);
        make.left.right.bottom.mas_equalTo(0);
    }];
}

- (void)setPhotoSelect:(BOOL)photoSelect {
    if (_photoSelect == photoSelect) return;
    _photoSelect = photoSelect;
    _imageView.layer.borderWidth = _photoSelect ? 1.0 : 0.0;
}

- (void)click_deleteButton {
    if (!_imageView.image) return;
    
    if ([self.delegate respondsToSelector:@selector(photoCellDidClickDelete:)]) {
        [self.delegate photoCellDidClickDelete:self];
    }
}

@end
