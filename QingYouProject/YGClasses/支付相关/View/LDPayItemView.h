//
//  LDPayItemView.h
//  QingYouProject
//
//  Created by LDSmallCat on 2017/10/12.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol LDPayItemViewDelegate <NSObject>
/** 点击事件 */
- (void)payItemViewDidSelectedWitchItem:(NSInteger)itemNumber;

@end
@interface LDPayItemView : UIView
/** 高度为: 定值220 */
- (instancetype)showPayItemViewWithY:(CGFloat)Y;
/** 代理  */
@property (nonatomic,weak) id<LDPayItemViewDelegate> delegate;
@property (nonatomic, strong) NSMutableArray *titleArry;
@end
