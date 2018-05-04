//
//  YGSpreadView.h
//  FindingSomething
//
//  Created by zhangkaifeng on 16/5/27.
//  Copyright © 2016年 韩伟. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YGSpreadView;
@protocol YGSpreadViewDelegate <NSObject>

@optional
/**
 *  当控件高度变化调用此函数（用于控件展开后改变相邻控件的y，自带动画，直接+height就好，如blueView.frame = CGRectMake(blueView.x, blueView.y+height, blueView.width, blueView.height);）
 *
 *  @param spreadView 本控件
 *  @param height     改变的高度（如果是往回收height为负数）
 *  @param down       down为YES为展开，否则为收缩
 */
-(void)YGSpreadView:(YGSpreadView *)spreadView willChangeHeight:(float)height down:(BOOL)down;
@end

@interface YGSpreadView : UIView

@property (nonatomic,strong) UIView *inView;
@property (nonatomic,assign) float startHeight;
@property (nonatomic,strong) UIButton * arrowButton;
@property (nonatomic,strong) UIImageView *arrowImageView;
@property (nonatomic,strong) UIView *bottomBaseView;
@property (nonatomic,strong) UILabel * textLabel;
@property (nonatomic,assign) CGPoint origin;
@property (nonatomic,assign) id<YGSpreadViewDelegate> delegate;

/**
 *  初始化方法
 *
 *  @param origin      本控件的x，y
 *  @param inView      传进显示在本控件中的View
 *  @param startHeight 控件起始高度（不包括下面的箭头）
 *
 *  @return 初始化方法
 */
- (instancetype)initWithOrigin:(CGPoint)origin inView:(UIView *)inView startHeight:(float)startHeight;

//更新控件高
- (void)reloadData;

@end
