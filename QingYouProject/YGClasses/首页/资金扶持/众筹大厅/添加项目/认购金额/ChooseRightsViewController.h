//
//  ChooseRightsViewController.h
//  QingYouProject
//
//  Created by nefertari on 2017/10/25.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "RootViewController.h"

@protocol ChooseRightsViewControllerDelegate <NSObject>

- (void)takeTypeValueBackWithValue:(NSString *)value;

@end
@interface ChooseRightsViewController : RootViewController
@property (nonatomic, assign) id<ChooseRightsViewControllerDelegate>delegate;

@end
