//
//  WaitToNetManagerTableViewCell.h
//  QingYouProject
//
//  Created by apple on 2017/11/9.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "LDBaseViewCell.h"
@class WaitToNetManagerModel;

@interface WaitToNetManagerTableViewCell : LDBaseViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *contactLable;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *createDateLabel;

@property (nonatomic,strong) WaitToNetManagerModel * model;

@end
