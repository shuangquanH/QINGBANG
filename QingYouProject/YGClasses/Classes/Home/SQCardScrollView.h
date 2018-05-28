//
//  SQCardScrollView.h
//  SQAPPSTART
//
//  Created by qwuser on 2018/5/16.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, SQSAxisType) {
    SQSAxisTypeHorizontal,
    SQSAxisTypeVertical
};

@interface SQCardScrollView : UIScrollView

/**
 快速设置一个可滑动的scrollview
 itemarr控件数组
 axistype滑动方向
 space间隔
 lead头部间隔
 tail尾部间隔
 itemsize内部控件大小
 
 */
- (void)setItemArr:(NSArray *)itemarr
                    alongAxis:(SQSAxisType)axistype
                      spacing:(CGFloat)space
                    leadSpace:(CGFloat)lead
                    tailSpace:(CGFloat)tail
                     itemSize:(CGSize) itemsize;


@end
