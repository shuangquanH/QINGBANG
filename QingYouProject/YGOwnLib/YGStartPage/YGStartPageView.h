//
//  YGStartPageView.h
//  YogeeLiveShop
//
//  Created by zhangkaifeng on 16/7/27.
//  Copyright © 2016年 ccyouge. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YGStartPageView : UIView<UIScrollViewDelegate>

@property (nonatomic,strong) NSArray * localPhotoNamesArray;

/**
 *  初始化方法
 *
 *  @param array 图片名字数组
 */
+(void)showWithLocalPhotoNamesArray:(NSArray *)array;

@end
