//
//  WaitReplyViewController.h
//  QingYouProject
//
//  Created by LDSmallCat on 2017/10/25.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "RootViewController.h"
@class WaitReplyModel;

@interface WaitReplyViewController : RootViewController

@property (nonatomic, strong) NSString *controllFrame;

-(void)addModelToDataArray:(WaitReplyModel *) model;

@end

