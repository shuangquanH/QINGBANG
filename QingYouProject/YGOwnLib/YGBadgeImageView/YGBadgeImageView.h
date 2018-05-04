//
//  YGBadgeImageView.h
//  FindingSomething
//
//  Created by zhangkaifeng on 16/6/30.
//  Copyright © 2016年 韩伟. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YGBadgeImageView : UIImageView

@property (nonatomic,strong) NSString * badgeValue;
@property (nonatomic,assign) CGRect badgeFrame;




@property (nonatomic,strong) UIView * badgeView;
@property (nonatomic,strong) UILabel * badgeLabel;

@end
