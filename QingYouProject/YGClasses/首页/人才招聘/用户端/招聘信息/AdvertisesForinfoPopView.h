//
//  AdvertisesForinfoPopView.h
//  QingYouProject
//
//  Created by nefertari on 2017/10/23.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AdvertisesForInfoModel.h"

typedef enum : NSUInteger {
    pageTypeChooseBusinessPark,
    pageTypeChoosePosition,
    pageTypeChooseSalary,
    pageTypeChooseWellbeing
} AdvertisesPageTypeChoos;

@protocol  AdvertisesForinfoPopViewDelegate <NSObject>

@optional
//删除
- (void)dismissChangeColor;

- (void)siftDataWithKeyModel:(AdvertisesForInfoModel *)model;

@end

@interface AdvertisesForinfoPopView : UIView<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, assign) AdvertisesPageTypeChoos            advertisesPageTypeChoos;
@property (nonatomic, assign) id<AdvertisesForinfoPopViewDelegate>delegate;

- (void)createPopChooseViewWithDataSorce:(NSArray *)dataSource andLeftDataArray:(NSMutableArray *)dataArray withType:(AdvertisesPageTypeChoos)advertisesPageTypeChoos  withLeftIndex:(int)leftIndex withRightIndex:(int)rightIndex ;
- (void)dismiss;


@end
