//
//  BuyOrderTableViewCell.h
//  FrienDo
//
//  Created by zhangkaifeng on 2017/9/25.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BuyOrderPayWayModel;

@interface BuyOrderTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *selectButton;
@property (nonatomic, strong) BuyOrderPayWayModel *model;

@end
