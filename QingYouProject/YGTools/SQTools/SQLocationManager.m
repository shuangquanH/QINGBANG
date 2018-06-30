//
//  SQLocationManager.m
//  QingYouProject
//
//  Created by qwuser on 2018/5/4.
//  Copyright © 2018年 ccyouge. All rights reserved.
//

#import "SQLocationManager.h"

@implementation SQLocationManager

+ (instancetype)shareManager {
    static  SQLocationManager   *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[SQLocationManager alloc] init];
    });
    return manager;
}

- (void)startLocationWithDelegate:(id)delegate {
    
    if ([CLLocationManager locationServicesEnabled]) {
        if (_locationManager == nil) {
            _locationManager = [[CLLocationManager alloc]init];
            [_locationManager requestWhenInUseAuthorization];
            _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
            _locationManager.distanceFilter = 5.0;
            _locationManager.delegate = delegate;
        }
        [_locationManager startUpdatingLocation];
    }
}
+ (NSString *)getLocationCityId {
    NSString    *cityNumber = [[NSUserDefaults standardUserDefaults] objectForKey:@"cityNumber"];
    if (!cityNumber) {
        return @"000000";
    } else {
        return cityNumber;
    }
}

@end
