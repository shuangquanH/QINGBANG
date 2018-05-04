//
//  LDBaseNetManagerVC.h
//  QingYouProject
//
//  Created by LDSmallCat on 2017/9/26.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "RootViewController.h"

@interface LDBaseNetManagerVC : RootViewController

/**
 快速创建方法

 @param titleArray 文字字符串 数组
 @param classArray 控制器类名数组
 */
- (instancetype)initWithTitleArray:(NSArray *)titleArray viewControllerClassStringArray:(NSArray *)classArray navgationTitle : (NSString *)title;
@end
