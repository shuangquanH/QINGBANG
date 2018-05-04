//
//  ServiceIntroduceViewController.h
//  QingYouProject
//
//  Created by nefertari on 2017/9/22.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "RootViewController.h"

@protocol ServiceIntroduceViewControllerDelegate <NSObject>

- (void)scrollViewDidScrollWithHeight:(CGFloat)offset;
-(void)serviceIntroduceViewControllerSelectBtnClick:(UIButton *)btn;

@end
@interface ServiceIntroduceViewController : RootViewController
@property (nonatomic, assign) CGRect            controllerFrame;
@property (nonatomic, copy) NSString        *superVCType; //上级页面是财务代记账还是网路管家
@property (nonatomic, copy) NSString           *commerceID;
@property (nonatomic, assign) id<ServiceIntroduceViewControllerDelegate>serviceIntroduceViewControllerDelegate;
@property (nonatomic, strong) NSArray *serviceArray;
@end
