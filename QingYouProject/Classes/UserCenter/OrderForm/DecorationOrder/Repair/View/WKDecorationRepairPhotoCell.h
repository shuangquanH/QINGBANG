//
//  WKDecorationRepairPhotoCell.h
//  QingYouProject
//
//  Created by mac on 2018/6/8.
//  Copyright © 2018年 ccyouge. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WKDecorationRepairPhotoCell;

@protocol WKDecorationRepairPhotoCellDelegate<NSObject>

- (void)photoCellDidClickDelete:(WKDecorationRepairPhotoCell *)photoCell;

@end

@interface WKDecorationRepairPhotoCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIButton    *deleteBtn;
@property (nonatomic, assign, getter=isPhotoSelect) BOOL photoSelect;

@property (nonatomic, weak  ) id<WKDecorationRepairPhotoCellDelegate> delegate;

@end
