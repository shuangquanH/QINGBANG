//
//  YGPopCycleView.h
//  YogeeLiveShop
//
//  Created by zhangkaifeng on 16/8/29.
//  Copyright © 2016年 ccyouge. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YGPopCycleView;
@protocol YGPopCycleViewDelegate <NSObject>

-(void)YGPopCycleView:(YGPopCycleView *)popCycleView didClickButtonWithIndex:(NSInteger)index;

@end

@interface YGPopCycleView : UIView

@property (nonatomic,strong) NSArray * dataSource;
@property (nonatomic,assign) id<YGPopCycleViewDelegate> delegate;
- (instancetype)initWithImageArray:(NSArray *)imageArray;
-(void)show;

@end
