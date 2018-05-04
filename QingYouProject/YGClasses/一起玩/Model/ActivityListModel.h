//
//  ActivityListModel.h
//  QingYouProject
//
//  Created by zhaoao on 2017/12/8.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ActivityListModel : NSObject

@property(nonatomic,strong)NSString *ID;
@property(nonatomic,strong)NSString *name;
@property(nonatomic,strong)NSString *coverUrl;
@property(nonatomic,strong)NSString *beginTime;
@property(nonatomic,strong)NSString *address;
@property(nonatomic,strong)NSString *price;
@property(nonatomic,strong)NSString *official;
@property(nonatomic,strong)NSString *userName;
@property(nonatomic,strong)NSString *userImg;

@end
