//
//  WKCheckContactScaleView.h
//  QingYouProject
//
//  Created by mac on 2018/6/12.
//  Copyright © 2018年 ccyouge. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WKCheckContactScaleView : UIView

- (void)showWithImageUrls:(NSArray<NSString *> *)imageUrls selectIndex:(NSInteger)selectIndex captureView:(UIView *)captureView;

- (void)dismiss;

@end
