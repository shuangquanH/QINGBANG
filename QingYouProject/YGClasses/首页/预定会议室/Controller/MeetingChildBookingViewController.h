//
//  MeetingChildBookingViewController.h
//  QingYouProject
//
//  Created by zhaoao on 2017/10/20.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "RootViewController.h"

@protocol MeetingChildBookingViewControllerDelegate <NSObject>

- (void)scrollViewDidScrollWithHeight:(CGFloat)offset;

@end
@interface MeetingChildBookingViewController : RootViewController
@property (nonatomic, assign) CGRect            controllerFrame;
@property (nonatomic, copy) NSString        *superVCType; //上级页面是财务代记账还是网路管家

@property (nonatomic, assign) id<MeetingChildBookingViewControllerDelegate>meetingChildBookingViewControllerDelegate;

@property(nonatomic,strong)NSString *idString;
@property(nonatomic,strong)NSString *unitPriceString;//价格/小时

@end
