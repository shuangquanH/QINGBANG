//
//  WKCheckContactScaleCell.h
//  QingYouProject
//
//  Created by mac on 2018/6/19.
//  Copyright © 2018年 ccyouge. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WKCheckContactScaleCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *imageView;

@property (nonatomic, strong) UIScrollView *imageContentScrollView;

- (void)configImage:(id)image;

@end
