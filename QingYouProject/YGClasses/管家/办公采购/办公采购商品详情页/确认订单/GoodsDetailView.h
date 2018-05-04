//
//  GoodsDetailView.h
//  QingYouProject
//
//  Created by LDSmallCat on 2017/10/22.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GoodsDetailView : UIView
- (void)reloadDataWithImage:(NSString *)imageString name:(NSString *)name rule:(NSString *)rule price:(NSString *)price count:(NSString *)count;
- (void)pushPurchaseReloadDataWithImage:(NSString *)imageString name:(NSString *)name price:(NSString *)price count:(NSString *)count;
@end
