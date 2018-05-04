//
//  LDVipImageView.h
//  QingYouProject
//
//  Created by LDSmallCat on 2017/10/12.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LDVipImageView : UIImageView
+ (instancetype)vipImageViewWithCardType:(NSString *)cardType andPrice:(NSString *)cardPrice frame:(CGRect)rect;
@end
