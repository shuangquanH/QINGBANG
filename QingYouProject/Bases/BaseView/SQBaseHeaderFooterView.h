//
//  SQBaseHeaderFooterView.h
//  SQAPPSTART
//
//  Created by qwuser on 2018/5/4.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SQBaseHeaderFooterView : UITableViewHeaderFooterView

/**
 *  快速创建一个不是从xib中加载的tableview header footer
 */
+ (instancetype)headerFooterViewWithTableView:(UITableView *)tableView;
/**
 *  快速创建一个从xib中加载的tableview header footer
 */
+ (instancetype)nibHeaderFooterViewWithTableView:(UITableView *)tableView;


@end
