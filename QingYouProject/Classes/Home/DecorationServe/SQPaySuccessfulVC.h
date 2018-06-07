//
//  SQPaySuccessfulVC.h
//  QingYouProject
//
//  Created by qwuser on 2018/6/7.
//  Copyright © 2018年 ccyouge. All rights reserved.
//

#import "RootViewController.h"

typedef enum : NSUInteger {
    SQDecorationBookSuccess,
    SQDecorationBookFailure,
    SQDecorationBookWaite,
} SQPaySuccessViewType;

@interface SQPaySuccessfulVC : RootViewController

@property (nonatomic, assign) SQPaySuccessViewType       type;

@end
