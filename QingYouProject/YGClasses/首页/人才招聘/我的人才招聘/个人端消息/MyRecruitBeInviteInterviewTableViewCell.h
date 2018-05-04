//
//  MyRecruitBeInviteInterviewTableViewCell.h
//  QingYouProject
//
//  Created by 王丹 on 2017/11/16.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AdvertiseModel.h"

@protocol MyRecruitBeInviteInterviewTableViewCellDelegate <NSObject>

@optional
//删除
- (void)acceptInterviewButtonActionWithModel:(AdvertiseModel *)model;

@end
@interface MyRecruitBeInviteInterviewTableViewCell : UITableViewCell
@property (nonatomic, strong) AdvertiseModel            *model;
@property (nonatomic, assign) id<MyRecruitBeInviteInterviewTableViewCellDelegate>delegate;

@end
