//
//  BillsDetailViewController.h
//  QingYouProject
//
//  Created by nefertari on 2017/10/20.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "RootViewController.h"

@interface BillsDetailViewController : RootViewController
@property (nonatomic, strong) NSString            *pageType; //违约账单里没有立即支付按钮 待支付里有
@end
