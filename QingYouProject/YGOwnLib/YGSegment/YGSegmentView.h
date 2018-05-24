//
//  YGSegmentView.h
//  FindingSomething
//
//  Created by apple on 16/1/5.
//  Copyright © 2016年 韩伟. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol YGSegmentViewDelegate <NSObject>

-(void)segmentButtonClickWithIndex:(int)buttonIndex;

@end

@interface YGSegmentView : UIView

/** 初始化  */
- (instancetype)initWithFrame:(CGRect)frame titlesArray:(NSArray *)titlesArray lineColor:(UIColor *)lineColor delegate:(id)delegate;

/** 点击按钮  */
-(void)selectButtonWithIndex:(int)buttonIndex;

/** 隐藏下划线  */
- (void)hiddenBottomLine;
/** 设置标题font  */
- (void)setTitleFont:(UIFont    *)font;

/** 代理 */
@property (nonatomic,assign) id <YGSegmentViewDelegate>delegate;





@property (nonatomic, readonly, strong) NSArray * titlesArray;
@property (nonatomic, readonly, strong) UIColor * lineColor;

@end
