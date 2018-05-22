//
//  SQOvalFuncButtons.h
//  QingYouProject
//
//  Created by qwuser on 2018/5/21.
//  Copyright © 2018年 ccyouge. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    SQTopFunc = 0,
    SQBottomFunc = 1,
    SQLeftFunc = 2,
    SQRightFunc = 3,
    SQCenterFunc = 4
} ClickType;

@protocol SQOvalFuncButtonDelegate

- (void)didselectWithClicktype:(ClickType)type;

@end

@interface SQOvalFuncButtons : UIView

@property (nonatomic, weak) id <SQOvalFuncButtonDelegate>       delegate;

- (instancetype)initWithFrame:(CGRect)frame centBtnSize:(CGSize)centerSize backImage:(UIImage   *)image;

@end
