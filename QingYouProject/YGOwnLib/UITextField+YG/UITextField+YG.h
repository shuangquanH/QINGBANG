//
//  UITextField+YG.h
//  FrienDo
//
//  Created by zhangkaifeng on 2017/4/21.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextField (YG)

/**
 限制输入的长度
 */
@property (nonatomic, assign) NSInteger limitTextLength;

/**
 改变placeHolder颜色
 */
@property (nonatomic, strong) UIColor *placeHolderColor;

/**
 内部自用，不要管
 */
@property (nonatomic, assign, readonly) NSInteger tempInteger;

@end
