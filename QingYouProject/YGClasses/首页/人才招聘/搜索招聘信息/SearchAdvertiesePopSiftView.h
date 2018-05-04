//
//  SearchAdvertiesePopSiftView.h
//  QingYouProject
//
//  Created by nefertari on 2017/10/25.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AdvertisesForInfoModel.h"

@protocol  SearchAdvertiesePopSiftViewDelegate <NSObject>

@optional
//删除
- (void)dismissChangeColor;

- (void)siftDataWithKeyModelArray:(NSArray *)modelArray;

@end
@interface SearchAdvertiesePopSiftView : UIView<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, assign) id<SearchAdvertiesePopSiftViewDelegate>delegate;

- (void)createPopChooseViewWithDataSorce:(NSArray *)dataSource;
- (void)dismiss;
- (void)createOrderHouseCheckPopChooseViewWithDataSorce:(NSArray *)dataSource withTitle:(NSString *)title;

@end
