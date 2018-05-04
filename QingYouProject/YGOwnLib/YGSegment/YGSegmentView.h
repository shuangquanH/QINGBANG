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

- (instancetype)initWithFrame:(CGRect)frame titlesArray:(NSArray *)titlesArray lineColor:(UIColor *)lineColor delegate:(id)delegate;

-(void)selectButtonWithIndex:(int)buttonIndex;

@property (nonatomic,strong) NSArray * titlesArray;
@property (nonatomic,strong) UIColor * lineColor;
@property (nonatomic,assign) id <YGSegmentViewDelegate>delegate;

@end
