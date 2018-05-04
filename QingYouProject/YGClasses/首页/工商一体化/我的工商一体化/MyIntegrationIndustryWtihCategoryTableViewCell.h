//
//  MyIntegrationIndustryWtihCategoryTableViewCell.h
//  QingYouProject
//
//  Created by apple on 2017/11/30.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import <UIKit/UIKit.h>
@class IntegrationIndustryModel;
@interface MyIntegrationIndustryWtihCategoryTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *OrderNumber;
@property (weak, nonatomic) IBOutlet UILabel *topLine;

@property (weak, nonatomic) IBOutlet UILabel *line;


@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *contactLabel;
@property (weak, nonatomic) IBOutlet UILabel *createTime;
@property (weak, nonatomic) IBOutlet UILabel *categoryLabel;

@property (nonatomic, strong) IntegrationIndustryModel *model;

@end
