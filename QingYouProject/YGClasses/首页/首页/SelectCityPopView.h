//
//  SelectCityPopView.h
//  FrienDo
//
//  Created by zhangkaifeng on 2017/2/6.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SelectCityPopView : UIView

@property (nonatomic,strong) NSArray *titleArray;
@property (nonatomic,strong) NSString *selectTitleString;
+ (void)showPopViewWithTitleArray:(NSArray *)titleArray selectedTitleString:(NSString *)selectedTitleString handler:(void (^)(NSInteger buttonIndex))handler;

@end
