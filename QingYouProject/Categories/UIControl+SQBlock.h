//
//  UIControl+SQBlock.h
//  QingYouProject
//
//  Created by qwuser on 2018/5/30.
//  Copyright © 2018年 ccyouge. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIControl (SQBlock)

- (void)sq_touchDown:(void (^)(void))eventBlock;
- (void)sq_touchDownRepeat:(void (^)(void))eventBlock;
- (void)sq_touchDragInside:(void (^)(void))eventBlock;
- (void)sq_touchDragOutside:(void (^)(void))eventBlock;
- (void)sq_touchDragEnter:(void (^)(void))eventBlock;
- (void)sq_touchDragExit:(void (^)(void))eventBlock;
- (void)sq_touchUpInside:(void (^)(void))eventBlock;
- (void)sq_touchUpOutside:(void (^)(void))eventBlock;
- (void)sq_touchCancel:(void (^)(void))eventBlock;
- (void)sq_valueChanged:(void (^)(void))eventBlock;
- (void)sq_editingDidBegin:(void (^)(void))eventBlock;
- (void)sq_editingChanged:(void (^)(void))eventBlock;
- (void)sq_editingDidEnd:(void (^)(void))eventBlock;
- (void)sq_editingDidEndOnExit:(void (^)(void))eventBlock;

@end
