//
//  YZLHomeAreaModel.h
//  knight
//
//  Created by yzl on 17/2/16.
//  Copyright © 2017年 hongdongjie. All rights reserved.
//  路线搜索，出发地模型


@interface YZLAreaModel : NSObject
/* 用于记录当前地区模型的记录次数，个人添加，在司机端创建专线中使用 **/
@property (nonatomic, assign) NSInteger selectCount;

@property (nonatomic, copy) NSString *firstChar;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *short_name;
@property (nonatomic, assign) long long ID;
@property (nonatomic, assign) NSInteger level;
@property (nonatomic, assign) NSInteger parent_id;
@property (nonatomic, strong) NSMutableArray<YZLAreaModel *> *sons;
@end
