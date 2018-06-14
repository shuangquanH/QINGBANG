//
//  WKImageCollectionView.m
//  QingYouProject
//
//  Created by mac on 2018/6/13.
//  Copyright © 2018年 ccyouge. All rights reserved.
//

#import "WKImageCollectionView.h"

@implementation WKImageCollectionView
- (instancetype)initWithMaxCount:(NSInteger)maxCount hasDeleteAction:(BOOL)hasDeleteAction {
    if (self == [super init]) {
        [self setupCollectByCount:maxCount hasDeleteAction:hasDeleteAction];
    }
    return self;
}

- (void)setupCollectByCount:(NSInteger)count hasDeleteAction:(BOOL)hasDeleteAction {
    for (int i = 0; i < count; i++) {
        
        UIImageView *imageView = [UIImageView new];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.backgroundColor = kCOLOR_RGB(239, 239, 239);

        UIView *view;
        
        if (hasDeleteAction) {
            view = [UIView new];
            [view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap_imageView:)]];
            [self addSubview:view];
            
            [view addSubview:imageView];
            
            UIButton *deleteBtn = [UIButton buttonWithTitle:@"删除" titleFont:KSCAL(28) titleColor:kCOLOR_333];
            [deleteBtn addTarget:self action:@selector(click_deleteBtn:) forControlEvents:UIControlEventTouchUpInside];
            [view addSubview:deleteBtn];
            
            [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.top.mas_equalTo(0);
                make.height.mas_equalTo(KSCAL(130)).priorityHigh();
            }];
            
            [deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.mas_equalTo(0);
                make.top.equalTo(imageView.mas_bottom);
                make.bottom.mas_equalTo(0);
            }];
            
            view.tag = i;
            imageView.tag = i;
            deleteBtn.tag = i;
        }
        else {
            UIImageView *imageView = [UIImageView new];
            imageView.contentMode = UIViewContentModeScaleAspectFit;
            imageView.backgroundColor = kCOLOR_RGB(239, 239, 239);
            imageView.userInteractionEnabled = YES;
            [imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap_imageView:)]];
            [self addSubview:imageView];
            imageView.tag = i;
            
            view = imageView;
        }
        
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.mas_equalTo(0);
            make.width.mas_equalTo(KSCAL(130));
            if (i == 0) {
                make.left.mas_equalTo(0);
                if (!hasDeleteAction) {
                    make.height.mas_equalTo(KSCAL(130)).priorityHigh();
                }
                else {
                    make.height.mas_equalTo(KSCAL(190)).priorityHigh();
                }
            }
            else {
                make.left.mas_equalTo(i * (KSCAL(130) + KSCAL(20)));
            }
        }];
    }
}

- (void)click_deleteBtn:(UIButton *)sender {
    UIImageView *imageView = [self.subviews objectAtIndex:sender.tag].subviews.firstObject;
    if (!imageView.image) return;
    if (self.deleteClicker) {
        self.deleteClicker([self.subviews objectAtIndex:sender.tag], sender.tag);
    }
}

- (void)tap_imageView:(UITapGestureRecognizer *)tapper {
    if (self.viewClicker) {
        self.viewClicker(tapper.view, tapper.view.tag);
    }
}

- (void)setImage:(UIImage *)image forIndex:(NSInteger)index {
    if (index < 0 || index >= self.subviews.count) return;
    UIView *view = [self.subviews objectAtIndex:index];
    if ([view isKindOfClass:[UIImageView class]]) {
        ((UIImageView *)view).image = image;
    }
    else {
        ((UIImageView *)(view.subviews.firstObject)).image = image;
    }
}
- (void)setImageUrl:(NSString *)url forIndex:(NSInteger)index {
    if (index < 0 || index >= self.subviews.count) return;
    UIView *view = [self.subviews objectAtIndex:index];
    if ([view isKindOfClass:[UIImageView class]]) {
        [((UIImageView *)view) sd_setImageWithURL:[NSURL URLWithString:url]];
    }
    else {
        [((UIImageView *)(view.subviews.firstObject)) sd_setImageWithURL:[NSURL URLWithString:url]];
    }
}

- (void)setHidden:(BOOL)hidden forRange:(NSRange)range {

    for (NSUInteger i = range.location; i < (range.location + range.length); i++) {
        UIImageView *imageView;
        if (i >= self.subviews.count && !hidden) {
            imageView = [UIImageView new];
            imageView.contentMode = UIViewContentModeScaleAspectFit;
            imageView.backgroundColor = kCOLOR_RGB(239, 239, 239);
            imageView.userInteractionEnabled = YES;
            [imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap_imageView:)]];
            [self addSubview:imageView];
            imageView.tag = i;
            
            [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(i * KSCAL(150));
                make.width.mas_equalTo(KSCAL(130));
                make.top.bottom.mas_equalTo(0);
            }];
        }
        else {
            imageView = [self.subviews objectAtIndex:i];
        }
        
        imageView.hidden = hidden;
    }
}

@end
