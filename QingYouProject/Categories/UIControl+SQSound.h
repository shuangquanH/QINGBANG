//
//  UIControl+SQSound.h
//  QingYouProject
//
//  Created by qwuser on 2018/5/30.
//  Copyright © 2018年 ccyouge. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIControl (SQSound)

/// Set the sound for a particular control event (or events).
/// @param name The name of the file. The method looks for an image with the specified name in the application’s main bundle.
/// @param controlEvent A bitmask specifying the control events for which the action message is sent. See “Control Events” for bitmask constants.
//不同事件增加不同声音
- (void)sq_setSoundNamed:(NSString *)name forControlEvent:(UIControlEvents)controlEvent;


@end
