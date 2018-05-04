//
//  UpLoadPersonTableViewCell.h
//  FrienDo
//
//  Created by apple on 2017/10/19.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UpLoadModel.h"

@interface UpLoadPersonTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *upLoadButton;

@property (weak, nonatomic) IBOutlet UIImageView *idImageView;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;


@property(nonatomic,strong)UpLoadModel * mainModel;

@end
