//
//  DeliveryWayView.h
//  QingYouProject
//
//  Created by LDSmallCat on 2017/10/22.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DeliveryWayView : UIView

/**左右文字颜色 */
- (void)reloadDataWithLetfTitle:(NSString *)leftTitle rightTitle:(NSString *)rightTitle leftColor:(UIColor *)leftColor rightColor:(UIColor *)rightColor;


- (void)reloadDataWithLetfTitle:(NSString *)leftTitle rightTitle:(NSString *)rightTitle lineTopColor:(UIColor *)lineTopColor lineBottomColor:(UIColor *)lineBottomColor;
/** 富文本 */
- (void)reloadDataWithAttributedTextLetfTitle:(NSString *)leftTitle rightTitle:(NSString *)rightTitle lineTopColor:(UIColor *)lineTopColor lineBottomColor:(UIColor *)lineBottomColor;
@end
