//
//  CrowdFundingAddProjectModel.h
//  QingYouProject
//
//  Created by nefertari on 2017/10/19.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CrowdFundingAddProjectModel : NSObject
/** 标题 */
@property (nonatomic, copy  ) NSString *title;
/** 内容 */
@property (nonatomic, copy  ) NSString *content;

@property (nonatomic, strong  ) UIImage *image;
@property (nonatomic, copy  ) NSString *placehoder;
@end
