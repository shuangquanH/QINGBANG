//
//  YGShareView.h
//  YogeeLiveShop
//
//  Created by zhangkaifeng on 2016/10/21.
//  Copyright © 2016年 ccyouge. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YGShareView : UIView

-(void)buttonClickBlock:(void (^)(NSInteger buttonIndex))handler;

-(void)show;

@end
