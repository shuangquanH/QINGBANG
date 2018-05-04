//
//  MeetingBookCell.h
//  QingYouProject
//
//  Created by zhaoao on 2017/10/20.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MeetingBookingModel.h"

@interface MeetingBookCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *meetingImageView;
@property (weak, nonatomic) IBOutlet UILabel *meetingNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *meetingAddressLabel;
@property (weak, nonatomic) IBOutlet UILabel *meetingPriceLabel;

@property(nonatomic,strong)MeetingBookingModel *model;

@end
