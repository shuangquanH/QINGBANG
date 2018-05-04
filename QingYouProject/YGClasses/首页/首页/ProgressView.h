//
//  ProgressView.h
//  Entertainer
//
//  Created by nefertari on 16/7/25.
//  Copyright © 2016年 王丹. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProgressView : UIView
@property (nonatomic, assign) CGFloat            progress;
@property (nonatomic, assign) CGFloat            total;
@property (nonatomic, assign) CGFloat            progressHeight;
@property (nonatomic, assign) CGFloat            progressWidth;
- (instancetype)initWithHeight:(CGFloat)progressHeight andWidth:(CGFloat)progressWidth;
- (void)setProgress:(double)progress andTotal:(double)total;
@end
