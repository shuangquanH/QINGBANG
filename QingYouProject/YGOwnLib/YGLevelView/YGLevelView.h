//
//  YGLevelView.h
//  YogeeLiveShop
//
//  Created by zhangkaifeng on 16/8/31.
//  Copyright © 2016年 ccyouge. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YGLevelView : UIView

@property (nonatomic,copy) NSString * levelString;

- (instancetype)initWithFrame:(CGRect)frame levelString:(NSString *)levelString;

@end
