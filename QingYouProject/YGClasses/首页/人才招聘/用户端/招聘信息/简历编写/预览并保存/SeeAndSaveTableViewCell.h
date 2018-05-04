//
//  SeeAndSaveTableViewCell.h
//  FrienDo
//
//  Created by zhangkaifeng on 2017/10/26.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SeeAndSaveTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *subLabel;
@property (nonatomic, strong) NSDictionary *infoDic;

@end
