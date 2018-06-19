//
//  WKCheckContactScaleCell.m
//  QingYouProject
//
//  Created by mac on 2018/6/19.
//  Copyright © 2018年 ccyouge. All rights reserved.
//

#import "WKCheckContactScaleCell.h"

@interface WKCheckContactScaleCell()<UIScrollViewDelegate>

@end

@implementation WKCheckContactScaleCell

- (instancetype)init {
    if (self == [super init]) {
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews {
    _imageContentScrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    _imageContentScrollView.showsVerticalScrollIndicator = NO;
    _imageContentScrollView.showsHorizontalScrollIndicator = NO;
    _imageContentScrollView.minimumZoomScale = 0.5;
    _imageContentScrollView.maximumZoomScale = 2.0;
    _imageContentScrollView.delegate = self;
    [self.contentView addSubview:_imageContentScrollView];
    
    _imageView = [UIImageView new];
    _imageView.contentMode = UIViewContentModeScaleAspectFit;
    [_imageContentScrollView addSubview:_imageView];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _imageContentScrollView.frame = self.bounds;
}

- (void)configImage:(id)image {
    
    if ([image isKindOfClass:[UIImage class]]) {
        [_imageView sd_cancelCurrentAnimationImagesLoad];
        _imageView.image = image;
        [self aspectFitImageViewForImage:image];
    }
    else {
        [_imageView sd_setImageWithURL:[NSURL URLWithString:image] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
            if (image) {
                [self aspectFitImageViewForImage:image];
            }
        }];
    }
}

- (void)aspectFitImageViewForImage:(UIImage *)image {
    CGFloat scale = MIN(self.frame.size.width / image.size.width, self.frame.size.height / image.size.height);
    CGFloat w = scale * image.size.width;
    CGFloat h = scale * image.size.height;
    _imageView.frame = CGRectMake((self.frame.size.width - w) / 2.0, (self.frame.size.height - h) / 2.0, w, h);
    _imageView.image = image;
}

#pragma mark - UIScrollViewDelegate
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return _imageView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    CGRect frame = _imageView.frame;
    frame.origin.y = scrollView.frame.size.height > _imageView.frame.size.height ? (scrollView.frame.size.height - _imageView.frame.size.height) * 0.5 : 0;
    frame.origin.x = scrollView.frame.size.width > _imageView.frame.size.width ? (scrollView.frame.size.width - _imageView.frame.size.width) * 0.5 : 0;
    _imageView.frame = frame;
    scrollView.contentSize = CGSizeMake(frame.size.width, frame.size.height);
}



@end
