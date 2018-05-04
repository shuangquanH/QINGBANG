//
//  ServiceIntroduceModel.h
//  QingYouProject
//
//  Created by LDSmallCat on 2017/10/30.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ServiceIntroduceModel : NSObject

/** 创建日期  */
@property (nonatomic,strong) NSString * createDate;
/** 介绍文字  */
@property (nonatomic,strong) NSString * serviceIntroduce;
/** 介绍文字  */
@property (nonatomic,strong) NSString * servicePicture;
/** updateDate  */
@property (nonatomic,strong) NSString * updateDate;

@end
