//
//  MeetingChildIndructionController.h
//  QingYouProject
//
//  Created by zhaoao on 2017/10/20.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "RootViewController.h"

@protocol MeetingChildIndructionControllerDelegate <NSObject>

- (void)scrollViewDidScrollWithHeight:(CGFloat)offset;

@end
@interface MeetingChildIndructionController : RootViewController
@property (nonatomic, assign) CGRect            controllerFrame;
@property (nonatomic, copy) NSString        *superVCType; //上级页面是财务代记账还是网路管家

@property (nonatomic, assign) id<MeetingChildIndructionControllerDelegate>meetingChildIndructionControllerrDelegate;

@property(nonatomic,strong)NSString *noteString;

@end
