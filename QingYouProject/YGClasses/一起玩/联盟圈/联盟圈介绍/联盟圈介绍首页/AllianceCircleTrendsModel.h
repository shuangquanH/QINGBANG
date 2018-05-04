//
//  AllianceCircleTrendsModel.h
//  QingYouProject
//
//  Created by nefertari on 2017/10/16.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AllianceCircleTrendsModel : NSObject
@property (nonatomic,strong) NSString * userImg;
@property (nonatomic,strong) NSString * userName;
@property (nonatomic,strong) NSString * content;
@property (nonatomic,strong) NSString * img;
@property (nonatomic,strong) NSArray * imgArr;
@property (nonatomic,strong) NSString * likeCount;
@property (nonatomic,strong) NSString * commentCount;
@property (nonatomic,strong) NSString * createDate;
@property (nonatomic,assign) NSString * isLike;
@property (nonatomic,assign) NSString * dynamicID;

@end
