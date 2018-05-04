//
//  AddressAskTableViewCell.h
//  FrienDo
//
//  Created by zhangkaifeng on 2017/9/27.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AddressAskModel;
@class FinancialAccountingOrderModel;
@class NetManagerModel;
@class ADManagerModel;
@class CommercialRegistrationModel;
@class AddressAskAndRegisterModel;
@class VIPServiceManagerModel;

@interface AddressAskTableViewCell : UITableViewCell

@property (nonatomic, strong) AddressAskModel *addressAskModel;
@property (nonatomic, strong) FinancialAccountingOrderModel *financialAccountingOrderModel;
@property (nonatomic, strong) NetManagerModel *netManagerModel;
@property (nonatomic, strong) VIPServiceManagerModel *vipServiceManagerModel;
@property (nonatomic, strong) ADManagerModel *adManagerModel;
@property (nonatomic, strong) CommercialRegistrationModel *commercialRegistrationModel;
@property (nonatomic, strong) AddressAskAndRegisterModel *addressAskAndRegisterModel;

@end
