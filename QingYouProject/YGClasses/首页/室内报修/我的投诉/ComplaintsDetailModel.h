//
//  ComplaintsDetailModel.h
//  QingYouProject
//
//  Created by apple on 2017/10/31.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "SQBaseModel.h"

@interface ComplaintsDetailModel : SQBaseModel
@property (nonatomic,strong) NSString * ID;
@property (nonatomic,strong) NSString * message;
@property (nonatomic,strong) NSString * createDate;
@property (nonatomic,strong) NSString * updateDate;
@property (nonatomic,strong) NSString * replyContent;
@property (nonatomic,strong) NSString * replyType;

@end
