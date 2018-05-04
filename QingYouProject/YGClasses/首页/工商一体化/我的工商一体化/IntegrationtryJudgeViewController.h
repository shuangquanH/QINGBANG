//
//  IntegrationtryJudgeViewController.h
//  QingYouProject
//
//  Created by apple on 2017/12/1.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol IntegrationtryJudgeViewControllerDelegate <NSObject>

- (void)integrationtryJudgeWithRow:(NSInteger )row;

@end

@interface IntegrationtryJudgeViewController : RootViewController
@property (nonatomic, strong) NSString *orderID;
@property (nonatomic, strong) NSString *commerceID;

@property (nonatomic, assign) id <IntegrationtryJudgeViewControllerDelegate>delegate;
@property (nonatomic, assign) NSInteger row;
@property (nonatomic, strong) NSString *isPush;

@end
