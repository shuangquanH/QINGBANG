//
//  LDVIPButton.h
//  QingYouProject
//
//  Created by LDSmallCat on 2017/10/10.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LDVIPButton : UIButton
/** leftLable  */
@property (nonatomic,strong) UILabel * leftLabel;
/** rightLable  */
@property (nonatomic,strong) UILabel * rightLable;

+ (instancetype)buttonWithType:(UIButtonType)buttonType leftTitle:(NSString *)leftTitle rightTitle:(NSString *)rightTitle frame:(CGRect)rect;
@end
