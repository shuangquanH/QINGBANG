//
//  PanoramicViewController.h
//  QingYouProject
//
//  Created by zhaoao on 2017/11/1.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "RootViewController.h"
//#import "CardboardSDK.h"
#import <GLKit/GLKit.h>

@interface PanoramicViewController : GLKViewController

@property(nonatomic,strong)NSString *picPathString;
@property(nonatomic,strong)UIImage *zImage;

@end
