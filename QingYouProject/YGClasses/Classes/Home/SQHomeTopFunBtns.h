//
//  SQHomeTopFunBtns.h
//  QingYouProject
//
//  Created by qwuser on 2018/5/19.
//  Copyright © 2018年 ccyouge. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SQHomeTopFunBtn : UIButton
@property (nonatomic, strong) UIColor       *contentColor;
@end

@interface SQHomeLeftFunBtn : UIButton
@property (nonatomic, strong) UIColor       *contentColor;
@end

@interface SQHomeBottomFunBtn : UIButton
@property (nonatomic, strong) UIColor       *contentColor;
@end

@interface SQHomeRightFunBtn : UIButton
@property (nonatomic, strong) UIColor       *contentColor;
@end

@interface SQHomeCenterFunBtn : UIButton
@property (nonatomic, strong) UIColor       *contentColor;
@end






@interface SQHomeTopFunBtns : UIView

- (instancetype)initWithFrame:(CGRect)frame withCenterSize:(CGSize)thesize;

@end
