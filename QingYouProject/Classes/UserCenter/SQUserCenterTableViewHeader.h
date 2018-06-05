//
//  SQUserCenterTableViewHeader.h
//  QingYouProject
//
//  Created by qwuser on 2018/5/16.
//  Copyright © 2018年 ccyouge. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SQUserCenterTableViewHeader : UIView

@property (nonatomic, copy) void (^ tapToPersonalInfo)(void);

- (void)configUserInfo:(YGUser *)user;

@end
