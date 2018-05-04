//
//  MineIntergralRecordOrderModel.h
//  QingYouProject
//
//  Created by nefertari on 2017/12/20.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MineIntergralRecordOrderModel : NSObject
@property(nonatomic,copy)NSString *ID;
@property(nonatomic,copy)NSString *dName; //商品名称
@property(nonatomic,copy)NSString *dPicture;//商品图片
@property(nonatomic,copy)NSString *dNum;
@property(nonatomic,copy)NSString *dType;//订单状态，0代发货，1待收货，2已完成
@property(nonatomic,copy)NSString *dIntegral;//青币
@end
