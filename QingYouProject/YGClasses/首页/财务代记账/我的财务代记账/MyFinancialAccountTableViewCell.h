//
//  MyFinancialAccountTableViewCell.h
//  QingYouProject
//
//  Created by apple on 2017/11/23.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyFinancialAccountDetailModel.h"

@interface MyFinancialAccountTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *classiFication;
@property (weak, nonatomic) IBOutlet UILabel *titleLable;
@property (weak, nonatomic) IBOutlet UILabel *createTime;
@property (weak, nonatomic) IBOutlet UILabel *contactLabel;
@property (weak, nonatomic) IBOutlet UILabel *payMoney;
@property (weak, nonatomic) IBOutlet UILabel *yearsLabel;
@property (weak, nonatomic) IBOutlet UILabel *topLabel;
@property (weak, nonatomic) IBOutlet UILabel *line;
@property (weak, nonatomic) IBOutlet UILabel *orderNumber;

@property (nonatomic, strong) MyFinancialAccountDetailModel *model;

@end
