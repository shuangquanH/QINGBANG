//
//  RushPurchaseSubModel.h
//  QingYouProject
//
//  Created by nefertari on 2017/12/5.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RushPurchaseSubModel : NSObject
//****
/*“coverUrl”//轮播图
 "commodityId": "", //商品ID
 "turnType": //是否跳转到图文混排页面 0 否 1是
 
*/
@property (nonatomic, copy) NSString        *coverUrl;
@property (nonatomic, copy) NSString        *commodityId;

@property (nonatomic, copy) NSString        *turnType;
@property (nonatomic, copy) NSString        *content;
@property (nonatomic, copy) NSString        *title;

@end
