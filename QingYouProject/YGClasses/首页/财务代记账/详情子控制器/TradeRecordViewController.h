//
//  TradeRecordViewController.h
//  QingYouProject
//
//  Created by nefertari on 2017/9/22.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "RootViewController.h"

@protocol TradeRecordViewControllerDelegate <NSObject>

- (void)scrollViewDidScrollWithHeight:(CGFloat)offset;

@end

@interface TradeRecordViewController : RootViewController
@property (nonatomic, assign) id<TradeRecordViewControllerDelegate>tradeRecordViewControllerDelegate;
@property (nonatomic, assign) CGRect            controllerFrame;
@property (nonatomic, copy) NSString        *superVCType; //上级页面是财务代记账还是网路管家
@property (nonatomic, copy) NSString           *serviceID;


@end
