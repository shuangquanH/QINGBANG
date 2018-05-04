//
//  TakePhotosOrderModel.h
//  QingYouProject
//
//  Created by zhaoao on 2017/10/27.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TakePhotosOrderModel : NSObject

@property(nonatomic,strong)NSString *orderNum;
@property(nonatomic,strong)NSString *ID;
@property(nonatomic,strong)NSString *createDate;
@property(nonatomic,strong)NSString *orderState;
@property(nonatomic,strong)NSString *descript;
@property(nonatomic,strong)NSString *img;
@property(nonatomic,strong)NSString *processTime;
@property(nonatomic,strong)NSString *completedTime;

@end
