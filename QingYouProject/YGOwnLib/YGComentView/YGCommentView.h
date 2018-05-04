//
//  YGCommentView.h
//  zhibotest
//
//  Created by zhangkaifeng on 16/7/21.
//  Copyright © 2016年 ccyouge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SocketEnterRoomModel.h"
#import "SocketNormalMessageModel.h"
#import "SocketSendGiftModel.h"
#import "SocketConcernModel.h"
#import "SocketNoTalkModel.h"
#import "SocketAddGoodModel.h"
#import "CommetTableViewCell.h"

@protocol YGCommentViewDelegate <NSObject>

-(void)YGCommentViewDidClickNameWithModel:(SocketBaseModel *)model nameButton:(UIButton *)nameButton;

@end

@interface YGCommentView : UIView<UITableViewDelegate,UITableViewDataSource,CommetTableViewCellDelegate>

@property (nonatomic,strong) UIScrollView * scrollView;
@property (nonatomic,strong) NSMutableArray * dataSource;
@property (nonatomic,assign) NSInteger maxCount;
@property (nonatomic,assign) id<YGCommentViewDelegate> delegate;

-(void)addWithModel:(SocketBaseModel *)model;
//清理屏幕
-(void)clearCommentView;

@end
