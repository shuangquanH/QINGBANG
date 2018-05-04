//
//  HistoryPayRecordModel.h
//  QingYouProject
//
//  Created by nefertari on 2017/10/31.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HistoryPayRecordModel : NSObject
@property(nonatomic,copy)NSString * id;
@property(nonatomic,copy)NSString *state; // 区分发票种类  在历史发票中的数据都是已开具或未发送
@property(nonatomic,copy)NSString * week;
@property(nonatomic,copy)NSString *money;
@property(nonatomic,copy)NSString * phone;
@property(nonatomic,copy)NSString * company;
@property(nonatomic,copy)NSString *mouth;
@property(nonatomic,copy)NSString * time;
@property(nonatomic,copy)NSString *type;
@property(nonatomic,assign)BOOL  isSelect;
@property(nonatomic,copy)NSString *email; // 区分发票种类  在历史发票中的数据都是已开具或未发送
@property(nonatomic,copy)NSString *status; // 区分发票种类  在历史发票中的数据都是已开具或未发送

@end
