//
//  GiftModel.h
//  presentAnimation
//
//  Created by 张楷枫 on 16/7/15.
//  Copyright © 2016年 张楷枫. All rights reserved.
//


#import <UIKit/UIKit.h>

@interface GiftModel : NSObject
@property (nonatomic,copy) NSString *headImageUrl; // 头像
@property (nonatomic,copy) NSString *giftImageUrl; // 礼物
@property (nonatomic,copy) NSString *name; // 送礼物者
@property (nonatomic,copy) NSString *giftName; // 礼物名称
@property (nonatomic,assign) NSInteger giftCount; // 礼物个数
@end
