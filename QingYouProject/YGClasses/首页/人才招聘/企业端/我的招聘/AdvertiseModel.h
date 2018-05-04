//
//  AdvertiseModel.h
//  QingYouProject
//
//  Created by nefertari on 2017/10/22.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AdvertiseModel : NSObject
@property (nonatomic, copy) NSString            *id;
@property (nonatomic, copy) NSString            *name;
@property (nonatomic, copy) NSString            *price;
@property (nonatomic, copy) NSString            *company;
@property (nonatomic, copy) NSString            *job;
@property (nonatomic, copy) NSString            *salary;
@property (nonatomic, copy) NSString            *educational;


@property (nonatomic, copy) NSString            *sex;
@property (nonatomic, copy) NSString            *experience;
@property (nonatomic, copy) NSString            *birthday;
/** 封面图 */
@property (nonatomic, copy) NSString *content;
@property (nonatomic, strong) NSIndexPath *indexPath;


@property (nonatomic, copy) NSString            *benefits;
//我的人才招聘消息
@property (nonatomic, copy) NSString            *time;
@property (nonatomic, copy) NSString            *address;
@property (nonatomic, copy) NSString            *state;

//我的人才招聘消息
@property (nonatomic, copy) NSString            *count;

@end
