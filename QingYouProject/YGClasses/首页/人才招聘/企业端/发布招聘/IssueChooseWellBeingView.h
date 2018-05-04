//
//  IssueChooseWellBeingView.h
//  QingYouProject
//
//  Created by nefertari on 2017/10/24.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "AdvertisesForInfoModel.h"

@protocol  IssueChooseWellBeingViewDelegate <NSObject>

@optional
//删除
- (void)dismissChangeColor;

- (void)siftDataWithKeyModelArray:(NSArray *)modelArray;

@end
@interface IssueChooseWellBeingView : UIView
@property (nonatomic, assign) id<IssueChooseWellBeingViewDelegate>delegate;

- (void)createPopChooseViewWithDataSorce:(NSArray *)dataSource;
- (void)dismiss;
@end
