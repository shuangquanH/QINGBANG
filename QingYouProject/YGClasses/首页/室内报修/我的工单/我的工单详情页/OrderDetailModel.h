//
//  OrderDetailModel.h
//  QingYouProject
//
//  Created by apple on 2017/11/1.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "LDBaseModel.h"

@interface OrderDetailModel : LDBaseModel
/** 创建时间  */
@property (nonatomic,strong) NSString * createDate;
/** 更新时间 */
@property (nonatomic,strong) NSString * updateDate;
/** 企业名称   */
@property (nonatomic,strong) NSString * firmName;
/** 园区 */
@property (nonatomic,strong) NSString * garden;
@property (nonatomic,strong) NSString * ID;

/** 地址  */
@property (nonatomic,strong) NSString * repairAddress;
/** /联系人姓名 */
@property (nonatomic,strong) NSString * indoorName;
/** /联系电话 */
@property (nonatomic,strong) NSString * indoorPhone;

/** 描述内容   */
@property (nonatomic,strong) NSString * indoorMessage;
/** 返回图片集合   */
//@property (nonatomic,strong) NSMutableArray * indoorPicture;
/** 工单号 */
@property (nonatomic,strong) NSString * workNumber;

/** 工单状态  */
@property (nonatomic,strong) NSString * workState;
/** 处理中时间 */
@property (nonatomic,strong) NSString * processTime;
/** 工人ID   */
@property (nonatomic,strong) NSString * workId;

@property (nonatomic,strong) NSString * cause;
@property (nonatomic,strong) NSString * completedTime;


@end
