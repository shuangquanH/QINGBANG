//
//  FundSupportModel.h
//  QingYouProject
//
//  Created by nefertari on 2017/10/17.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FundSupportModel : NSObject
@property (nonatomic,strong) NSString * picture;
@property (nonatomic,strong) NSString * title;
@property (nonatomic,strong) NSString * keyWord;
@property (nonatomic,strong) NSString * id;
/** 标题 */
@property (nonatomic, copy  ) NSString *createDate;
/** 描述 */
@property (nonatomic, copy  ) NSString *updateDate;
@end
