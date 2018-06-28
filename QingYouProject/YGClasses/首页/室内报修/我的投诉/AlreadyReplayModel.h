//
//  AlreadyReplayModel.h
//  QingYouProject
//
//  Created by LDSmallCat on 2017/10/25.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "SQBaseModel.h"

@interface AlreadyReplayModel : SQBaseModel
/** 投诉内容  */
@property (nonatomic,strong) NSString * message;
/** 投诉时间  */
@property (nonatomic,strong) NSString * createDate;
/** 回复内容  */
@property (nonatomic,strong) NSString * replyContent;
/** 回复时间  */
@property (nonatomic,strong) NSString * updateDate;
@property (nonatomic,strong) NSString * ID;

@end
