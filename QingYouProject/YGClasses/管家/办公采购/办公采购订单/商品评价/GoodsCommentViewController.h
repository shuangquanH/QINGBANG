//
//  GoodsCommentViewController.h
//  QingYouProject
//
//  Created by LDSmallCat on 2017/10/24.
//  Copyright © 2017年 ccyouge. All rights reserved.
//商品评论

#import "RootViewController.h"
//@protocol GoodsCommentViewControllerDelegate <NSObject>//协议
//- (void)goodsCommentViewControllerJudgeBtnWithRow:(int) row;//协议方法
//
//@end
@interface GoodsCommentViewController : RootViewController
@property (nonatomic, strong) NSString *commodityID;
@property (nonatomic, assign) int row;
@property (nonatomic, strong) NSString *isPush;
//@property (nonatomic, assign) id <GoodsCommentViewControllerDelegate>delegate;
@end
