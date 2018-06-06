//
//  SQChooseDecorationAddressView.h
//  QingYouProject
//
//  Created by qwuser on 2018/6/6.
//  Copyright © 2018年 ccyouge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SQDecorationAddressModel.h"

@protocol decorationAddressTapDelegate

- (void)tapedAddressWithType:(BOOL)hadAddress;

@end

@interface SQChooseDecorationAddressView : UIView

@property (nonatomic, weak) id <decorationAddressTapDelegate> delegate;

@property (nonatomic, strong) SQDecorationAddressModel       *model;

@end
