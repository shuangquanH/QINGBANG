//
//  AlreadyReplayCell.h
//  QingYouProject
//
//  Created by LDSmallCat on 2017/10/25.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "LDBaseViewCell.h"
@class AlreadyReplayModel;

@protocol AlreadyReplayCellDelegate <NSObject>//协议
- (void)alreadyReplayCellDeleteWithRow:(int)row;//协议方法
@end

@interface AlreadyReplayCell : LDBaseViewCell
/** WaitReplyModel  */
@property (nonatomic,strong) AlreadyReplayModel * model;
@property (nonatomic,assign) int  row;
@property (nonatomic, assign) id <AlreadyReplayCellDelegate>delegate;
@end
