//
//  SQDecorationDetailFunctionView.h
//  QingYouProject
//
//  Created by mac on 2018/6/1.
//  Copyright © 2018年 ccyouge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SQDecorationDetailViewModel.h"

@interface SQDecorationDetailFunctionView : UIView<SQDecorationDetailViewProtocol>

@property (nonatomic, copy) void (^ functionBlock)(NSInteger tag);

@end