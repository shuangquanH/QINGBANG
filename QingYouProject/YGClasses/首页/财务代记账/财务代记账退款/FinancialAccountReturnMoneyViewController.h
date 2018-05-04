//
//  FinancialAccountReturnMoneyViewController.h
//  QingYouProject
//
//  Created by apple on 2017/11/24.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "RootViewController.h"
@class IntegrationIndustryModel;
@class MyFinancialAccountDetailModel;

@protocol FinancialAccountReturnMoneyViewControllerDelegate <NSObject>
-(void)reloadViewWithReturnMonryWithReson:(NSString *)reason withTime:(NSString *)time withRow:(NSInteger)row;

@end
@interface FinancialAccountReturnMoneyViewController : RootViewController
@property (nonatomic, strong) NSString *isPush;
@property (nonatomic, assign) NSInteger row;

@property (nonatomic, strong) IntegrationIndustryModel *integrationModel;
@property (nonatomic, strong) MyFinancialAccountDetailModel *financialAccountDetailModel;

@property (nonatomic, assign) id <FinancialAccountReturnMoneyViewControllerDelegate>delegate;
@end
