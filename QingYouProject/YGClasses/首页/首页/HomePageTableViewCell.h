//
//  HomePageTableViewCell.h
//  FrienDo
//
//  Created by zhangkaifeng on 2017/2/6.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomePageModel.h"

@protocol HomePageTableViewCellDelegate

- (void)HomePageTableViewCellTapImageViewWithIndex:(int)index;
@end
@interface HomePageTableViewCell : UITableViewCell

@property (nonatomic,strong) NSArray * modelArray;
@property (nonatomic, weak) id <HomePageTableViewCellDelegate>delegate;

@end
