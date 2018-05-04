//
//  RushPurchaseClassifyView.h
//  QingYouProject
//
//  Created by nefertari on 2017/12/22.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol  RushPurchaseClassifyViewDelegate <NSObject>

- (void)rushPurchaseClassifyViewSiftDataWithKeyModelArray:(NSArray *)modelArray;
@end

@interface RushPurchaseClassifyView : UIView

@property (nonatomic, assign) id<RushPurchaseClassifyViewDelegate>delegate;

- (void)dismiss;
- (void)createOrderHouseCheckPopChooseViewWithDataSorce:(NSArray *)dataSource withTitle:(NSString *)title;
@end
