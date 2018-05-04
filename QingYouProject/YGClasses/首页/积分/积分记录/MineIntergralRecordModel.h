//
//  MineIntergralRecordModel.h
//  QingYouProject
//
//  Created by nefertari on 2017/12/20.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MineIntergralRecordModel : NSObject
@property(nonatomic,copy)NSString *amount;//分数
@property(nonatomic,copy)NSString *changes; // + - 号
@property(nonatomic,copy)NSString *reason;//理由
@property(nonatomic,copy)NSString *createDate;//时间
@end
