//
//  BuyOrderViewController.h
//  FrienDo
//
//  Created by zhangkaifeng on 2017/9/25.
//  Copyright © 2017 ccyouge. All rights reserved.
//

#import "RootViewController.h"

@class ShopItemModel;

@interface BuyOrderViewController : RootViewController

@property (nonatomic, strong) ShopItemModel *model;
@property (nonatomic, strong) NSString *commerceID;
@property (nonatomic, strong) NSMutableDictionary *dict;
@property (nonatomic, strong) NSString *titleLabelStr;
@property (nonatomic, strong) NSString *pageType;

@end
