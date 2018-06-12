//
//  SQDecorationSeveTableHeader.h
//  QingYouProject
//
//  Created by qwuser on 2018/5/18.
//  Copyright © 2018年 ccyouge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SQDecorationHomeModel.h"

@protocol decorationSeveHeaderDelegate

- (void)didSelectedBannerWithIndex:(NSInteger)index;

@end

@interface SQDecorationSeveTableHeader : UIView <SDCycleScrollViewDelegate> 
@property (nonatomic, weak) id <decorationSeveHeaderDelegate> delegate;

@property (nonatomic, strong) SQDecorationHomeModel       *model;


@end
