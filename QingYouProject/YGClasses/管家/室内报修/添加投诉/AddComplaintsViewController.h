//
//  AddComplaintsViewController.h
//  QingYouProject
//
//  Created by LDSmallCat on 2017/10/26.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "RootViewController.h"
#import "WaitReplyModel.h"

@protocol AddComplaintsViewControllerDelegate <NSObject>//协议
- (void)addComplaintsViewController:(UIViewController *)controller didClickSaveButtonWithModel:(WaitReplyModel *)model;//协议方法
@end

@interface AddComplaintsViewController : RootViewController
@property (nonatomic, assign) id <AddComplaintsViewControllerDelegate>delegate;
@end
