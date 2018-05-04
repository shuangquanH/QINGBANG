//
//  MyResumeModel.h
//  QingYouProject
//
//  Created by nefertari on 2017/11/9.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyResumeModel : NSObject
@property (nonatomic, strong) NSString *id;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *sex;
@property (nonatomic, strong) NSString *birthday;
@property (nonatomic, strong) NSString *experience;
@property (nonatomic, strong) NSString *city;
@property (nonatomic, strong) NSString *phone;
@property (nonatomic, strong) NSString *park;
@property (nonatomic, strong) NSString *character;
@property (nonatomic, strong) NSString *jobcity;
@property (nonatomic, strong) NSString *salary;
@property (nonatomic, strong) NSString *job;
@property (nonatomic, strong) NSString *jobState;//工作状态 0离职可立即上岗 1 在职不找考虑工作 2 在职 考虑找工作
@property (nonatomic, strong) NSString *school; //学校名称
@property (nonatomic, strong) NSString *major; //专业名称
@property (nonatomic, strong) NSString *educational; //学位/学历
@property (nonatomic, strong) NSString *selfEvaluation; //自我评价
@property (nonatomic, strong) NSArray *list;
@property (nonatomic, strong) NSString *time; //自我评价

@property (nonatomic, strong) NSString *jobValue;
@property (nonatomic, strong) NSString *parkvalue;
@property (nonatomic, strong) NSString *jobStateValue;
@property (nonatomic, strong) NSString *educationalValue;
@property (nonatomic, strong) NSString *sexValue;
@property (nonatomic, strong) NSString *experienceValue;
@property (nonatomic, strong) NSString *salaryValue;
@property (nonatomic, strong) NSString *characterValue;

//工作经验
@property (nonatomic, strong) NSString *company;
@property (nonatomic, strong) NSString *startTime;
@property (nonatomic, strong) NSString *endTime;
@property (nonatomic, strong) NSString *experienceJob;
@property (nonatomic, strong) NSString *jobName;
@property (nonatomic, strong) NSString *price;
@property (nonatomic, strong) NSString *description;
@property (nonatomic, strong) NSString *experienceid;

@property (nonatomic, strong) NSString *experienceJobValue;




@end
