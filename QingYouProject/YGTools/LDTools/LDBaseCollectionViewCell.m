//
//  LDBaseCollectionViewCell.m
//  QingYouProject
//
//  Created by LDSmallCat on 2017/10/17.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "LDBaseCollectionViewCell.h"

@implementation LDBaseCollectionViewCell
#pragma mark - 获取当前ViewController
- (UIViewController *)getCellViewController{
    
    for (UIView* next = [self superview]; next; next = next.superview) {
        
        UIResponder* nextResponder = [next nextResponder];
        
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            
            return (UIViewController*)nextResponder;
        }
    }
    return nil;
}

@end
