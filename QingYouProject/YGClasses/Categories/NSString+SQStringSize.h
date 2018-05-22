//
//  NSString+SQStringSize.h
//  QingYouProject
//
//  Created by qwuser on 2018/5/21.
//  Copyright © 2018年 ccyouge. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (SQStringSize)

- (CGSize)sizeWithFont:(UIFont*)font andMaxSize:(CGSize)size;

@end
