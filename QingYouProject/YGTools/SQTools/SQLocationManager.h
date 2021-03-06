//
//  SQLocationManager.h
//  QingYouProject
//
//  Created by qwuser on 2018/5/4.
//  Copyright © 2018年 ccyouge. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AMapLocationKit/AMapLocationKit.h>



@interface SQLocationManager : NSObject


+ (instancetype)shareManager;

@property(nonatomic,strong)CLLocationManager *locationManager;

- (void)startLocationWithDelegate:(id)delegate;

@end
