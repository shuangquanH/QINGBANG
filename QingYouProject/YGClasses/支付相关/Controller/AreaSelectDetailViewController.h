//
//  AreaSelectDetailViewController.h
//  QingYouProject
//
//  Created by apple on 2017/11/6.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "RootViewController.h"

@interface AreaSelectDetailViewController : RootViewController
@property (nonatomic, strong) NSArray *cityArry;
@property (nonatomic, strong) NSString * selectedProvince;
@property (nonatomic, assign) int  tag;

@end
