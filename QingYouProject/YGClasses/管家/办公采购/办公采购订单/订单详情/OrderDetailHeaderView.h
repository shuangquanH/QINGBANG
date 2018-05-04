//
//  OrderDetailHeaderView.h
//  QingYouProject
//
//  Created by LDSmallCat on 2017/10/23.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderDetailHeaderView : UIView
- (void)reloadDataWithOrderStatus:(NSString *)orderStatus orderTime:(NSString *)OrderTime;
@end
