//
//  WKUserInfoMessageCell.h
//  QingYouProject
//
//  Created by mac on 2018/6/7.
//  Copyright © 2018年 ccyouge. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WKUserCenterMessageModel;

@interface WKUserCenterMessageCell : UITableViewCell

- (void)configMessageInfo:(WKUserCenterMessageModel *)messageInfo;

@end
