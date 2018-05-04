//
//  FinacialAccountPopView.h
//  QingYouProject
//
//  Created by nefertari on 2017/9/27.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FinacialAccountPopViewDelegate <NSObject>

- (void)nextStepWithInfoDict:(NSDictionary *)dict;

- (void)confirmPayWithInfoDict:(NSDictionary *)dict;

- (void)cancleAllPopViews;

@end

@interface FinacialAccountPopView : UIView<UITextViewDelegate>

@property (nonatomic, assign) id<FinacialAccountPopViewDelegate>finacialAccountPopViewDelegate;

@property (nonatomic, strong) NSMutableDictionary *selectYearDict;
//弹出填写信息的页面
- (void)createFrame:(CGRect)frame withInfoArray:(NSArray *)infoArray andPageType:(NSString *)pageType;
//弹出选择信息的页面
//- (void)createFrame:(CGRect)frame withInfoDict:(NSDictionary *)infoDict andPageType:(NSString *)pageType;
- (void)createFrame:(CGRect)frame withInfoNSArry:(NSArray *)arry andPageType:(NSString *)pageType
;
- (void)selfDisappear;

@end
