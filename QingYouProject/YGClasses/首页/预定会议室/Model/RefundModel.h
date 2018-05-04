//
//  RefundModel.h
//  QingYouProject
//
//  Created by zhaoao on 2017/10/21.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RefundModel : NSObject

@property(nonatomic,copy)NSString *reason;
@property(nonatomic,copy)NSString *select; //0 :未选中 1：选中

@end
