//
//  ActivityDetailsViewController.h
//  QingYouProject
//
//  Created by zhaoao on 2017/11/14.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "RootViewController.h"

@protocol ActivityDetailsViewControllerDelegate <NSObject>

-(void)passdetailString:(NSString *)detailString andArray:(NSArray *)detailPicArray;

@end

@interface ActivityDetailsViewController : RootViewController

@property(nonatomic,strong) id <ActivityDetailsViewControllerDelegate> delegate;

@property(nonatomic,strong)NSString *detailString;//文字描述
@property(nonatomic,strong)NSMutableArray *detailPicArray;//图片数组

@end
