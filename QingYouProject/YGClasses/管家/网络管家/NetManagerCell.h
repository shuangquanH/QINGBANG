//
//  NetManagerCell.h
//  QingYouProject
//
//  Created by LDSmallCat on 2017/9/22.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import <UIKit/UIKit.h>
@class NetVIPmodel;
@interface NetManagerCell : LDBaseViewCell
@property (nonatomic, strong) NetVIPmodel *model;
@property (nonatomic, strong) NSString *isVIP;
@end
