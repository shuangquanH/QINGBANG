//
//  UIColor+Extension.h
//  Fascinate
//
//  Created by Simon on 2018/1/8.
//  Copyright © 2018年 Calvien. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (SQExtension)
+(UIColor *) hexStringToColor: (NSString *) stringToConvert;
+(UIColor *) hexStringToColor: (NSString *) stringToConvert andAlpha:(CGFloat)alpha;
@end
