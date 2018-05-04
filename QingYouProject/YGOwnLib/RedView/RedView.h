//
//  RedView.h
//  原点
//
//  Created by 管宏刚 on 16/12/9.
//  Copyright © 2016年 管宏刚. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RedView : UIView
@property (nonatomic, strong) UILabel * numberLabel;
@property (nonatomic,assign) int badge;

- (instancetype)initWithFrame:(CGRect)frame badge:(int)badge;
@end
