//
//  WKUserCenterMessageModel.h
//  QingYouProject
//
//  Created by mac on 2018/6/7.
//  Copyright © 2018年 ccyouge. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WKUserCenterMessageModel : NSObject

@property (nonatomic, copy) NSString *messageTitle;

@property (nonatomic, copy) NSString *messageDetail;

@property (nonatomic, copy) NSString *messageTime;

@property (nonatomic, assign) CGFloat cellHeight;

@end
