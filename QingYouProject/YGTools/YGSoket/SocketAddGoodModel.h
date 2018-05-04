//
//  SocketAddGoodModel.h
//  YogeeLiveShop
//
//  Created by zhangkaifeng on 2016/10/25.
//  Copyright © 2016年 ccyouge. All rights reserved.
//

#import "SocketBaseModel.h"

@interface SocketAddGoodModel : SocketBaseModel

@property (nonatomic,copy) NSString * goodid;
@property (nonatomic,copy) NSString * goodname;
@property (nonatomic,copy) NSString * goodprice;
@property (nonatomic,copy) NSString * goodimg;
@property (nonatomic,copy) NSString * goodurl;


@end
