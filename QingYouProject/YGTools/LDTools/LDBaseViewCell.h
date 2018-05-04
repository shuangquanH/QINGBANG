//
//  LDBaseViewCell.h
//  QingYouProject
//
//  Created by LDSmallCat on 2017/9/25.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LDBaseViewCell : UITableViewCell
#pragma mark - 获取当前ViewController
- (UIViewController *)getCellViewController;
@end
