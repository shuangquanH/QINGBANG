//
//  SQDecorationDetailBottomView.h
//  QingYouProject
//
//  Created by qwuser on 2018/5/25.
//  Copyright © 2018年 ccyouge. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol decorationDetailBottomViewDelegate

- (void)clickedCollectionBtn;
- (void)clickedContactButton;
- (void)clickedPayButton;

@end

@interface SQDecorationDetailBottomView : UIView

@property (nonatomic, weak) id <decorationDetailBottomViewDelegate> delegate;

@end
