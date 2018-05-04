//
//  GoodsPlaceView.h
//  QingYouProject
//
//  Created by LDSmallCat on 2017/10/22.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GoodsPlaceViewDelegate <NSObject>
/**新建地址ButtonClick*/
- (void)goodsPlaceViewNewerPlaceButtonClick;
@end


@interface GoodsPlaceView : UIView
/** 是否显示新建地址  */
@property (nonatomic,assign) BOOL isShowNewButton;
/** 代理  */
@property (nonatomic,strong)  id<GoodsPlaceViewDelegate> delegate;
- (void)reloadDataWithName:(NSString *)name phone:(NSString *)phone place:(NSString *)place;
-(void)lableWithThick;

/** 右侧箭头  */
@property (nonatomic,strong) UIImageView * arrowImageView;
@property (nonatomic, strong)  UIImageView * bottomImageView;


@end
