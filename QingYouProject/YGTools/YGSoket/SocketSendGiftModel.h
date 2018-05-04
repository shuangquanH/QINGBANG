//
//  SocketNormalSendGiftModel.h
//  YogeeLiveShop
//
//  Created by zhangkaifeng on 16/8/15.
//  Copyright © 2016年 ccyouge. All rights reserved.
//

#import "SocketBaseModel.h"

@interface SocketSendGiftModel : SocketBaseModel

@property (nonatomic,copy) NSString * giftimg;
@property (nonatomic,copy) NSString * giftname;
@property (nonatomic,copy) NSString * giftid;
@property (nonatomic,copy) NSString * gifttype;//0是没动画
@property (nonatomic,copy) NSString * userimg;
@property (nonatomic,copy) NSString * bean;


@end
