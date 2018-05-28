//
//  SQRequest.h
//  QingYouProject
//
//  Created by qwuser on 2018/5/24.
//  Copyright © 2018年 ccyouge. All rights reserved.
//

#import <Foundation/Foundation.h>

#define KAPI_ADDRESS @"http://192.168.2.28:8081/mockjs/1/"

@interface SQRequest : NSObject


+ (void)post:(NSString  *)api param:(NSDictionary   *)param success:(void(^)(id response))success failure:(void(^)(NSError *error))failure;



@end
