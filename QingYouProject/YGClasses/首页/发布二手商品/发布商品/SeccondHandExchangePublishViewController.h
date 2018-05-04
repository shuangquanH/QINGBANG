//
//  SeccondHandExchangePublishViewController.h
//  QingYouProject
//
//  Created by 王丹 on 2017/12/14.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "RootViewController.h"
#import "SeccondHandExchangePublishModel.h"
#import "SecondhandReplacementICreateModel.h"

@interface SeccondHandExchangePublishViewController : RootViewController
@property (nonatomic, copy) NSString            *tyepId; //分类id
@property (nonatomic, copy) NSString            *pageType; //从哪个页面进来的 @“SeccondHandExchangeMain” 首页  @“SeccondHandExchangeCertify” 认证页面 @"SeccondHandExchangePublish" 发布页面  @“SeccondHandExchangeMainSearch” 首页进来搜索
@property (nonatomic, strong) NSDictionary        *editDictionary;
@property (nonatomic, strong) SecondhandReplacementICreateModel        *editModel;

@end
