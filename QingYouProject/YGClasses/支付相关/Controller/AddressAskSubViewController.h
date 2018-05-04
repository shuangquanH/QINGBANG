//
//  AddressAskSubViewController.h
//  FrienDo
//
//  Created by zhangkaifeng on 2017/9/27.
//  Copyright © 2017 ccyouge. All rights reserved.
//

#import "RootViewController.h"
#import "AddressAskViewController.h"
#import "AddressAskConfig.h"

@interface AddressAskSubViewController : RootViewController



@property (nonatomic, assign) CGRect controlFrame;

@property (nonatomic, assign) AddressAskPageType pageType;
@property (nonatomic, assign) AddressAskSubPageType subPageType;

@end
