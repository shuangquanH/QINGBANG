//
//  PictureLeftTextRightCell.h
//  QingYouProject
//
//  Created by zhaoao on 2017/10/13.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TakePhotosOrderModel.h"

@interface PictureLeftTextRightCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *leftimageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property(nonatomic,strong)TakePhotosOrderModel *orderModel;

@end
