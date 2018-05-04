//
//  ReplyView.h
//  FindingSomething
//
//  Created by ; on 16/3/26.
//  Copyright © 2016年 韩伟. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YGCommon.h"
#import "UIView+LG.h"

@class ReplyView;

@protocol ReplyViewDelegate <NSObject>

- (void)replyView:(ReplyView*)replyView willReturnWithTextfield:(UITextField *)textField;

@optional

- (void)replyView:(ReplyView*)replyView willChangeLocationY:(float)locationY;

@end

@interface ReplyView : UIView<UITextFieldDelegate>

@property (nonatomic,assign) float keyboardHeight;

@property (nonatomic,assign) id <ReplyViewDelegate>delegate;

-(void)show;

- (void)dismiss;

@end
