//
//  OfficePurchaseHeaderView.h
//  QingYouProject
//
//  Created by LDSmallCat on 2017/10/18.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol OfficePurchaseHeaderViewDelegate
/**返回按钮点击*/
- (void)OfficePurchaseHeaderViewBackButtonClick:(UIButton *)backButton;
/**收藏按钮点击*/
- (void)OfficePurchaseHeaderViewCollectButtonClick:(UIButton *)collectButton;
/**分享按钮点击*/
- (void)OfficePurchaseHeaderViewShareButtonClick:(UIButton *)shareButton;
/**轮播器代理事件*/
- (void)OfficePurchaseHeaderViewcycleScrollViewDidSelectItemAtIndex:(NSInteger)index;

@end


@interface OfficePurchaseHeaderView : UIView
/**代理*/
@property (nonatomic,assign) id<OfficePurchaseHeaderViewDelegate>  delegate;
@property (nonatomic, strong)  UIButton * collectionButton;


/**刷新数据*/
- (void)reloadDataWith:(NSArray *)imageArray goodsName:(NSString *)goodsName goodsPrice:(NSString *)price deliveryPrice:(NSString *)deliveryPrice withisCollect:(NSString *)isCollect;

- (void)reloadDataWithisCollect:(NSString *)isCollect;
@end
