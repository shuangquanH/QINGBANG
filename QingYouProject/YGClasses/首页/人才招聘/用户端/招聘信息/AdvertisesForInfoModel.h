//
//  AdvertisesForInfoModel.h
//  QingYouProject
//
//  Created by nefertari on 2017/10/23.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AdvertisesForInfoModel : NSObject
@property (nonatomic, copy) NSString            *title;
@property (nonatomic, copy) NSString            *name;
@property (nonatomic, assign) BOOL            isSelect;
@property (nonatomic, copy) NSString            *id;
@property (nonatomic, strong) NSIndexPath          *fatherIndexPath;
/** 封面图 */
@property (nonatomic, copy  ) NSString *content;

@property (nonatomic, assign) NSInteger          row;

@property (nonatomic, copy) NSString            *value;
@property (nonatomic, copy) NSString            *label;

//福利待遇
@property (nonatomic, copy) NSString            *delFlag;
@property (nonatomic, copy) NSString            *searchFromPage;
@end
