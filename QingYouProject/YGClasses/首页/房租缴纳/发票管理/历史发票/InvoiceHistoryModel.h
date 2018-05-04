//
//  InvoiceHistoryModel.h
//  QingYouProject
//
//  Created by nefertari on 2017/10/30.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface InvoiceHistoryModel : NSObject

@property(nonatomic,copy)NSString * content;//发票类型 0 增值税普通发票（电子发票） 1 增值税专用发票

@property(nonatomic,copy)NSString *time; //时间

@property(nonatomic,copy)NSString *id ;// 发票金额

@property(nonatomic,copy)NSString *week;// 

@property(nonatomic,copy)NSString *company ;//

@property(nonatomic,copy)NSString *type ;//

@property(nonatomic,copy)NSString *money ;//

@property(nonatomic,copy)NSString *status ;// 2纸质 1 电子

@property(nonatomic,copy)NSString *email ;// email

@property(nonatomic,copy)NSString *state ;// 2纸质 1 电子

//我的房租缴纳详情
@property(nonatomic,copy)NSString *number;// 订单编号

@property(nonatomic,copy)NSString *address;// 胡浩

@end
