//
//  ManageMailPostViewController.h
//  QingYouProject
//
//  Created by 王丹 on 2017/10/26.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "RootViewController.h"
#import "ManageMailPostModel.h"

@protocol ManageMailPostViewControllerDelegate <NSObject>

-(void)passModel:(ManageMailPostModel *)model;

@end

@interface ManageMailPostViewController : RootViewController
@property (nonatomic,assign) id <ManageMailPostViewControllerDelegate> shippingAddressViewControllerdelegate;
@property (nonatomic, copy) NSString            *invoiceId;
@property (nonatomic, copy) NSString            *pageType;

@end
