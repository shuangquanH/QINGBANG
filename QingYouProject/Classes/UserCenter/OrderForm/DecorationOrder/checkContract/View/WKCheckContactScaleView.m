//
//  WKCheckContactScaleView.m
//  QingYouProject
//
//  Created by mac on 2018/6/12.
//  Copyright © 2018年 ccyouge. All rights reserved.
//

#import "WKCheckContactScaleView.h"

static const CGFloat kScaleAnimationDuraction = 0.7;

@interface WKCheckContactScaleView()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UIImageView *maskImageView;

@property (nonatomic, strong) NSArray<NSString *> *imageUrls;

@property (nonatomic, assign) NSInteger selectIndex;

@property (nonatomic, assign) CGRect fromRect;

@property (nonatomic, strong) UICollectionView *collectionView;

@end

@implementation WKCheckContactScaleView


#pragma mark - lazy load
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
        layout.itemSize = CGSizeMake(kScreenW, kScreenH-KNAV_HEIGHT-KTAB_HEIGHT+49.0);
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.minimumInteritemSpacing = 0.0;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.pagingEnabled = YES;
        [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"imageCell"];
        [self addSubview:_collectionView];
        [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.top.mas_equalTo(KNAV_HEIGHT);
            make.bottom.mas_equalTo(KTAB_HEIGHT-49.0);
        }];
    }
    return _collectionView;
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.imageUrls.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"imageCell" forIndexPath:indexPath];
    
    UIImageView *imageView;
    if (!cell.contentView.subviews.count) {
        imageView = [UIImageView new];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        [cell.contentView addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(0);
        }];
    }
    else {
        imageView = cell.contentView.subviews.firstObject;
    }
    [imageView sd_setImageWithURL:[NSURL URLWithString:self.imageUrls[indexPath.item]] placeholderImage:nil options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
        
    } completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        
    }];
    
    return cell;
}

#pragma mark - public
- (void)showWithImageUrls:(NSArray<NSString *> *)imageUrls selectIndex:(NSInteger)selectIndex captureView:(UIView *)captureView {
    
    _imageUrls = imageUrls;
    _selectIndex = selectIndex;
    
    
    if ([captureView isKindOfClass:[UIImageView class]] && captureView) {
        UIImageView *imageView = (UIImageView *)captureView;
        if (imageView.image) {
            CGRect fromRect = [captureView.superview convertRect:captureView.frame toView:YGAppDelegate.window];
            _fromRect = fromRect;
            
            if (!_maskImageView) {
                _maskImageView = [[UIImageView alloc] init];
                [self addSubview:_maskImageView];
            }
            
            UIGraphicsBeginImageContext(captureView.bounds.size);
            [captureView.layer renderInContext:UIGraphicsGetCurrentContext()];
            UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();

            _maskImageView.hidden = NO;
            _maskImageView.frame = fromRect;
            _maskImageView.image = viewImage;
        }
        else {
            _fromRect = CGRectZero;
        }
    }
    else {
        _fromRect = CGRectZero;
    }

    self.frame = YGAppDelegate.window.bounds;
    self.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.1];
    self.collectionView.hidden = YES;
    if (!self.superview) {
        [[UIApplication sharedApplication].windows.firstObject addSubview:self];
    }
    [self layoutIfNeeded];
    
    captureView.hidden = YES;
    [UIView animateWithDuration:kScaleAnimationDuraction animations:^{
        self.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0];
        self.maskImageView.center = CGPointMake(self.frame.size.width / 2.0, (self.frame.size.height - KSTATU_HEIGHT) / 2.0);
    } completion:^(BOOL finished) {
        captureView.hidden = NO;
        self.collectionView.hidden = NO;
        [self.collectionView reloadData];
    }];
    
}

- (void)dismiss {
    
}




@end
