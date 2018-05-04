//
//  FinancialAccountingCell.h
//  QingYouProject
//
//  Created by nefertari on 2017/9/22.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FinancialAccountingModel.h"

@interface FinancialAccountingCell : UITableViewCell

@property (nonatomic,strong) FinancialAccountingModel * model; //数据模型
@property (nonatomic, strong) NSString *isPush;
@end
