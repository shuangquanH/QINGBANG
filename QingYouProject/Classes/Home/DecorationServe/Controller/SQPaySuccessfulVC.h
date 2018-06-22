//
//  SQPaySuccessfulVC.h
//  QingYouProject
//
//  Created by qwuser on 2018/6/7.
//  Copyright © 2018年 ccyouge. All rights reserved.
//  付款成功页面

#import "RootViewController.h"

typedef enum : NSUInteger {
    SQDecorationBookSuccess,
    SQDecorationBookFailure,
    SQDecorationBookWaite,
} SQPaySuccessViewType;

@interface SQPaySuccessfulVC : RootViewController

/** 需要把navigationController传递过来  */
@property (nonatomic, weak) UINavigationController      *lastNav;

@property (nonatomic, assign) SQPaySuccessViewType       type;

@end
