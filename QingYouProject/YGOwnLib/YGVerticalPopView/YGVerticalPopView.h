//
//  YGVerticalPopView.h
//  YogeeLiveShop
//
//  Created by zhangkaifeng on 16/8/17.
//  Copyright © 2016年 ccyouge. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol YGVerticalPopViewDelegate <NSObject>

-(void)YGVerticalPopViewDidClickWithIndex:(NSInteger)index button:(UIButton *)button;

@end

@interface YGVerticalPopView : UIView

@property (nonatomic,strong) UIImage * mainButtonImage;
@property (nonatomic,strong) UIImage * mainButtonSelectedImage;
@property (nonatomic,strong) NSArray * buttonImagesArray;
@property (nonatomic,strong) NSArray * buttonSelectedImagesArray;
@property (nonatomic,assign) id <YGVerticalPopViewDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)frame mainButtonImage:(UIImage *)mainButtonImage mainButtonSelectedImage:(UIImage *)mainButtonSelectedImage buttonImagesArray:(NSArray *)buttonImagesArray buttonSelectedImagesArray:(NSArray *)buttonSelectedImagesArray;
-(void)configUI;
@end
