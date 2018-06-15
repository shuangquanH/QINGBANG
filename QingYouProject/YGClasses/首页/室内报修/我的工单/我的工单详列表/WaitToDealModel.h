//
//  WaitToDealModel.h
//  QingYouProject
//
//  Created by apple on 2017/11/1.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "LDBaseModel.h"

@interface WaitToDealModel : LDBaseModel
/** 留言描述  */
@property (nonatomic,strong) NSString * indoorMessage;
/** 创建时间  */
@property (nonatomic,strong) NSString * createDate;
/** 工单号    */
@property (nonatomic,strong) NSString * workNumber;
/** 返回第一张图片  */
@property (nonatomic,strong) NSString * indoorPicture;
@property (nonatomic,strong) NSString * ID;
@property (nonatomic,strong) NSString * cause;//未处理原因
@property (nonatomic,strong) NSString * evaluateType;//是否已评价
@property (nonatomic,strong) NSString * completedTime;
@property (nonatomic,strong) NSString * processTime;


@end
