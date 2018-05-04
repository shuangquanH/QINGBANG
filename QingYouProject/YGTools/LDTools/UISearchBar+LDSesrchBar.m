//
//  UISearchBar+LDSesrchBar.m
//  GoldSalePartner
//
//  Created by LDSmallCat on 17/6/22.
//  Copyright © 2017年 曹来东. All rights reserved.
//

#import "UISearchBar+LDSesrchBar.h"

@implementation UISearchBar (LDSesrchBar)
-(void)setLeftPlaceholder:(NSString *)placeholder {
    
    self.placeholder = placeholder;
    
    SEL centerSelector = NSSelectorFromString([NSString stringWithFormat:@"%@%@", @"setCenter", @"Placeholder:"]);
    if ([self respondsToSelector:centerSelector]) {
        BOOL centeredPlaceholder = NO;
        NSMethodSignature *signature = [[UISearchBar class] instanceMethodSignatureForSelector:centerSelector];
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
        [invocation setTarget:self];
        [invocation setSelector:centerSelector];
        [invocation setArgument:&centeredPlaceholder atIndex:2];
        [invocation invoke];
    }
}
@end
