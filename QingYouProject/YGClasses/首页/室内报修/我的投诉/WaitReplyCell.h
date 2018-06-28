//
//  WaitReplyCell.h
//  QingYouProject
//
//  Created by LDSmallCat on 2017/10/25.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "SQBaseTableViewCell.h"
@class WaitReplyModel;
@protocol WaitReplyCellDelegate <NSObject>//协议
- (void)WaitReplyCellDelegateDeletewithrow:(int)row;//协议方法
@end

@interface WaitReplyCell : SQBaseTableViewCell
/** WaitReplyModel  */
@property (nonatomic,strong) WaitReplyModel * model;
@property (nonatomic, assign) id <WaitReplyCellDelegate>delegate;
@property (nonatomic,assign) int  row;

@end
