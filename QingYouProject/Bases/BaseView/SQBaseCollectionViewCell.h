//
//  SQBaseCollectionViewCell.h
//  QingYouProject
//
//  Created by qwuser on 2018/5/23.
//  Copyright © 2018年 ccyouge. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SQBaseCollectionViewCell : UICollectionViewCell

@property (nonatomic, weak) UICollectionView *collectionView;

/**
 *  快速创建一个不是从xib中加载的collectionView cell
 */
+ (instancetype)cellWithCollectionView:(UICollectionView *)collectionView forIndexPath:(NSIndexPath *)indexPath;

/**
 =/ *  快速创建一个从xib中加载的collectionView cell
 */
+ (instancetype)nibCellWithCollectionView:(UICollectionView *)collectionView forIndexPath:(NSIndexPath *)indexPath;


- (UIViewController *)getCellViewController;

/** 滑动动画  */
- (void)startScrollAnimation;

@end
