//
//  HistoryPayRecordModel.m
//  QingYouProject
//
//  Created by nefertari on 2017/10/31.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "HistoryPayRecordModel.h"

@implementation HistoryPayRecordModel
@synthesize id;
- (id)copyWithZone:(NSZone *)zone {
    HistoryPayRecordModel *copyInstance = [[[self class] allocWithZone:zone] init];
    copyInstance.week = self.week;
    copyInstance.money = self.money;
    copyInstance.company = self.company;
    copyInstance.mouth = self.mouth;
    copyInstance.time = self.time;
    copyInstance.company = self.company;
    copyInstance.type = self.type;
    copyInstance.id = self.id;
    copyInstance.status = self.status;
    copyInstance.email = self.email;
    copyInstance.state = self.state;
    copyInstance.phone = self.phone;
    return copyInstance;
}
@end
