//
//  LDBaseCollectionViewCell.h
//  QingYouProject
//
//  Created by LDSmallCat on 2017/10/17.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LDBaseCollectionViewCell : UICollectionViewCell
#pragma mark - 获取当前ViewController
- (UIViewController *)getCellViewController;
@end
