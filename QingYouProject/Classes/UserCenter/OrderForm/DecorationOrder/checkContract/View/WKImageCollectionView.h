//
//  WKImageCollectionView.h
//  QingYouProject
//
//  Created by mac on 2018/6/13.
//  Copyright © 2018年 ccyouge. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WKImageCollectionView : UIView

@property (nonatomic, copy) void (^ viewClicker)(UIView *view, NSInteger index);

@property (nonatomic, copy) void (^ deleteClicker)(UIView *view, NSInteger index);

- (instancetype)initWithMaxCount:(NSInteger)maxCount hasDeleteAction:(BOOL)hasDeleteAction;

- (void)setImage:(UIImage *)image forIndex:(NSInteger)index;

- (void)setImageUrl:(NSString *)url forIndex:(NSInteger)index;

- (void)setHidden:(BOOL)hidden forRange:(NSRange)range;

@end
