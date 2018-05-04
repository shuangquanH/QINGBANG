//
//  SeccondHandExchangeChooseTypeViewController.h
//  QingYouProject
//
//  Created by nefertari on 2017/12/14.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "RootViewController.h"

@protocol SeccondHandExchangeChooseTypeViewControllerDelegate <NSObject>

- (void)chooseTypeWithModelsArray:(NSArray *)modelsArray;

@end
@interface SeccondHandExchangeChooseTypeViewController : RootViewController
@property (nonatomic, copy) NSString            *pageType; //从哪个页面进来的 @“SeccondHandExchangeMain” 首页  @“SeccondHandExchangeCertify” 认证页面 @"SeccondHandExchangePublish" 发布页面  @“SeccondHandExchangeMainSearch” 首页进来搜索

@property(nonatomic,weak) id <SeccondHandExchangeChooseTypeViewControllerDelegate> delegate;
@property (nonatomic, strong) NSArray            *modelArray;
@end
