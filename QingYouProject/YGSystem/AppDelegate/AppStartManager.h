//
//  AppStartManager.h
//  QingYouProject
//
//  Created by qwuser on 2018/5/4.
//  Copyright © 2018年 ccyouge. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface AppStartManager : NSObject

+ (AppStartManager  *)shareManager;

/** 启动时调用 */
- (void)startApplication:(UIApplication *)appcation withOptions:(NSDictionary *)launchOptions;

@end
