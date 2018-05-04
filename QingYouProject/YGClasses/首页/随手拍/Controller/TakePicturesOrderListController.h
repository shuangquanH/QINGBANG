//
//  TakePicturesOrderListController.h
//  QingYouProject
//
//  Created by zhaoao on 2017/10/18.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "RootViewController.h"
typedef NS_ENUM(NSUInteger, TakePicturesOrderListType) {
    takePicturesOrderListTypeWait = 0,
    takePicturesOrderListTypeIng = 1,
    takePicturesOrderListTypeEd = 2,
};

@interface TakePicturesOrderListController : RootViewController

@property (nonatomic, assign) TakePicturesOrderListType pageType;


@end
