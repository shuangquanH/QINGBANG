//
//  AllianceCircleTrendsModel.m
//  QingYouProject
//
//  Created by nefertari on 2017/10/16.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "AllianceCircleTrendsModel.h"

@implementation AllianceCircleTrendsModel
- (void)setImg:(NSString *)img
{
    _img = img;
    self.imgArr =[_img componentsSeparatedByString:@","];
}

@end
