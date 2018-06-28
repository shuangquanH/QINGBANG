//
//  WKCheckContactScaleView.m
//  QingYouProject
//
//  Created by mac on 2018/6/12.
//  Copyright © 2018年 ccyouge. All rights reserved.
//

#import "WKCheckContactScaleView.h"
#import <Photos/Photos.h>
#import <MBProgressHUD/MBProgressHUD.h>

#import "WKCheckContactScaleCell.h"

static const CGFloat kScaleAnimationDuraction = 0.7;

@interface WKCheckContactScaleView()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UIImageView *maskImageView;

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) UIButton *dismissBtn;

@property (nonatomic, strong) UIButton *saveBtn;

@property (nonatomic, strong) UILabel  *pageLabel;


@property (nonatomic, strong) NSArray<NSString *> *imageUrls;

@property (nonatomic, assign) NSInteger selectIndex;

@property (nonatomic, assign) CGRect fromRect;

@property (nonatomic, assign) NSInteger firstIndex;

@end

@implementation WKCheckContactScaleView

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.imageUrls.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    WKCheckContactScaleCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"imageCell" forIndexPath:indexPath];
    
    if (indexPath.item == self.firstIndex && self.maskImageView.image) {
        [cell configImage:self.maskImageView.image];
    }
    else {
        [cell configImage:self.imageUrls[indexPath.item]];
    }
    return cell;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSInteger index = (scrollView.contentOffset.x / KAPP_WIDTH);
    self.selectIndex = index;
    self.pageLabel.text = [NSString stringWithFormat:@"%zd/%zd", index + 1, _imageUrls.count];
}

#pragma mark - action
- (void)click_dismiss {
    [self dismiss];
}
- (void)click_save {
    
    WKCheckContactScaleCell *cell = (WKCheckContactScaleCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:self.selectIndex inSection:0]];

    if (!cell.imageView.image) return;
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self animated:YES];
    hud.bezelView.backgroundColor =  [[UIColor blackColor] colorWithAlphaComponent:0.6];
    UIImage *saveImage = cell.imageView.image;
    [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
        [PHAssetChangeRequest creationRequestForAssetFromImage:saveImage];
    } completionHandler:^(BOOL success, NSError * _Nullable error) {
        dispatch_sync(dispatch_get_main_queue(), ^{
            [hud hideAnimated:NO];
            [YGAppTool showToastWithText:(success ? @"已保存图片到相册" : @"保存失败")];
        });
    }];
}

#pragma mark - public
- (void)showWithImageUrls:(NSArray<NSString *> *)imageUrls selectIndex:(NSInteger)selectIndex captureView:(UIView *)captureView {
    //初始化数据
    _imageUrls = imageUrls;
    _selectIndex = selectIndex;
    _fromRect = CGRectMake(KAPP_WIDTH/2.0, KNAV_HEIGHT + (KAPP_HEIGHT - KNAV_HEIGHT - KTAB_HEIGHT + 5.0) / 2.0, 80, 80);
    _maskImageView.image = nil;
    _firstIndex = selectIndex;
    
    //来源位置
    if (captureView) {
        CGRect fromRect = [captureView.superview convertRect:captureView.frame toView:YGAppDelegate.window];
        _fromRect = fromRect;
    }

    //设置动画蒙版图片
    if ([captureView isKindOfClass:[UIImageView class]] && captureView) {
        UIImageView *imageView = (UIImageView *)captureView;
        if (imageView.image) {//存在图片时，才显示mask
            if (!_maskImageView) {
                _maskImageView = [[UIImageView alloc] init];
                [self addSubview:_maskImageView];
            }
            _maskImageView.contentMode = imageView.contentMode;
            _maskImageView.frame = _fromRect;
            _maskImageView.image = imageView.image;
            _maskImageView.hidden = NO;
        }
    }

    [[UIApplication sharedApplication].windows.firstObject addSubview:self];

    self.frame = self.superview.bounds;
    
    self.collectionView.hidden = YES;
    self.pageLabel.text = [NSString stringWithFormat:@"%zd/%zd", selectIndex + 1, imageUrls.count];

    self.alpha = 1.0;
    self.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.1];
    
    if (!self.maskImageView.hidden) {
        [self bringSubviewToFront:self.maskImageView];
    }
    [self layoutIfNeeded];

    captureView.hidden = YES;
    [UIView animateWithDuration:kScaleAnimationDuraction animations:^{
        self.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0];
        if (self.maskImageView.image) {
            self.maskImageView.frame = self.collectionView.frame;
        }
    } completion:^(BOOL finished) {
        captureView.hidden = NO;
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:selectIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
        self.collectionView.hidden = NO;
        self.maskImageView.hidden = YES;
        [self.collectionView reloadData];
    }];
}

- (void)dismiss {

    UIImage *image;
    UICollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:self.selectIndex inSection:0]];
    if (cell && cell.contentView.subviews.count) {
        image = ((UIImageView *)cell.contentView.subviews.firstObject.subviews.firstObject).image;
    }
    
    if (image) {
        self.maskImageView.image = image;
        self.maskImageView.frame = self.collectionView.frame;
        self.maskImageView.hidden = NO;
        cell.contentView.subviews.firstObject.hidden = YES;
    }
    
    [self layoutIfNeeded];
    [UIView animateWithDuration:kScaleAnimationDuraction animations:^{
        if (image) {
            self.maskImageView.frame = self.fromRect;
            self.maskImageView.alpha = 0.2;
        }
        self.alpha = 0.0;
    } completion:^(BOOL finished) {
        cell.contentView.subviews.firstObject.hidden = NO;
        self.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.1];
        self.maskImageView.alpha = 1.0;
        [self removeFromSuperview];
    }];
}

#pragma mark - lazy load
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
        layout.itemSize = CGSizeMake(KAPP_WIDTH, KAPP_HEIGHT-KNAV_HEIGHT-KTAB_HEIGHT+5);
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.minimumInteritemSpacing = 0.0;
        layout.minimumLineSpacing = 0.0;
        layout.sectionInset = UIEdgeInsetsZero;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.pagingEnabled = YES;
        [_collectionView registerClass:[WKCheckContactScaleCell class] forCellWithReuseIdentifier:@"imageCell"];
        [self addSubview:_collectionView];
        
        _pageLabel = [UILabel labelWithFont:15.0 textColor:[UIColor whiteColor]];
        [self addSubview:_pageLabel];
        
        _saveBtn = [UIButton buttonWithTitle:@"保存" titleFont:15.0 titleColor:[UIColor whiteColor]];
        _saveBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [_saveBtn addTarget:self action:@selector(click_save) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_saveBtn];
        
        _dismissBtn = [UIButton buttonWithTitle:@"关闭" titleFont:15.0 titleColor:[UIColor whiteColor]];
        _dismissBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [_dismissBtn addTarget:self action:@selector(click_dismiss) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_dismissBtn];
        
        [_dismissBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(KSTATU_HEIGHT);
            make.left.mas_equalTo(20);
            make.height.mas_equalTo(44);
            make.width.mas_equalTo(80);
        }];
        
        [_pageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_dismissBtn);
            make.bottom.mas_equalTo(-KTAB_HEIGHT+49);
            make.height.mas_equalTo(44);
        }];
        
        [_saveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.height.equalTo(_pageLabel);
            make.right.mas_equalTo(-20);
            make.width.mas_equalTo(80);
        }];
        
        [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.top.equalTo(_dismissBtn.mas_bottom);
            make.bottom.equalTo(_pageLabel.mas_top);
        }];
    }
    return _collectionView;
}


@end
