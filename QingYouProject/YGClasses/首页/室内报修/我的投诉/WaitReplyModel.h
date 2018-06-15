//
//  WaitReplyModel.h
//  QingYouProject
//
//  Created by LDSmallCat on 2017/10/25.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "LDBaseModel.h"

@interface WaitReplyModel : LDBaseModel
///** 文字内容  */
//@property (nonatomic,strong) NSString * text;
///** 时间  */
@property (nonatomic,strong) NSString * ID;
@property (nonatomic,strong) NSString * message;
@property (nonatomic,strong) NSString * createDate;
@property (nonatomic,strong) NSString * updateDate;
@property (nonatomic,strong) NSString * replyContent;
//@property (nonatomic,strong) NSString * message;


@end
