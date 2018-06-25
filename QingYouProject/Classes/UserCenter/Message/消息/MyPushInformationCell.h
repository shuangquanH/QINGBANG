//
//  MyPushInformationCell.h
//  QingYouProject
//
//  Created by zhaoao on 2017/12/27.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyInformationModel.h"

@interface MyPushInformationCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *createDateLabel;

@property(nonatomic,strong)MyInformationModel *model;

@end
