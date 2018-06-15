//
//  OfficePurchaseDetailShowModel.h
//  QingYouProject
//
//  Created by apple on 2017/11/2.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "LDBaseModel.h"

@interface OfficePurchaseDetailShowModel : LDBaseModel
@property (nonatomic,strong) NSArray *commodityArry;
@property (nonatomic,strong) NSString *commentCount;
@property (nonatomic,strong) NSString *isCollect;
@property (nonatomic,strong) NSArray *commentListArry;
@property (nonatomic,strong) NSArray *labelList;


@end
@interface OfficePurchaseDetailCommodityModel : NSObject

@property (nonatomic,strong) NSString *commodityImgs;
@property (nonatomic,strong) NSString *commodityFreight;
@property (nonatomic,strong) NSString *commodityPrice;
@property (nonatomic,strong) NSString *commodityName;
@property (nonatomic,strong) NSString *commodityDetail;
@property (nonatomic,strong) NSString *commodityID;

@end

@interface OfficePurchaseDetailCommentListModel : NSObject

@property (nonatomic,strong) NSString *context;
@property (nonatomic,strong) NSString *userName;
@property (nonatomic,strong) NSString *createDate;
@property (nonatomic,strong) NSString *userImg;

@end
