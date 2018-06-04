//
//  SQDecorationDetailModel.h
//  QingYouProject
//
//  Created by mac on 2018/6/1.
//  Copyright © 2018年 ccyouge. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SQDecorationDetailModel : NSObject

/** 1:待付款 2:已关闭 3:受理中 4:装修中 5:已完成 */
@property (nonatomic, assign) NSInteger orderState;

@end
