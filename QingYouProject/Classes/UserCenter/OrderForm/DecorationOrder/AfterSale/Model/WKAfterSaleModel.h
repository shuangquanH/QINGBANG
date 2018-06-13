//
//  WKAfterSaleModel.h
//  QingYouProject
//
//  Created by mac on 2018/6/7.
//  Copyright © 2018年 ccyouge. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WKAfterSaleModel : NSObject
/** 售后状态 1.等待处理 2.已回复 */
@property (nonatomic, assign) NSInteger afterSaleState;
/** 售后描述 */
@property (nonatomic, copy  ) NSString *afterSaleDesc;
/** 售后结果 */
@property (nonatomic, copy  ) NSString *afterSaleResult;
/** 发起时间 */
@property (nonatomic, copy  ) NSString *createTime;
/** 描述图片 */
@property (nonatomic, copy  ) NSString *images;

@property (nonatomic, copy  ) NSString *stateDesc;

@property (nonatomic, assign) CGFloat cellHeight;

@end

@interface WKAfterSaleCellFrameModel: NSObject

@property (nonatomic, assign, readonly) CGRect stateRect;

@property (nonatomic, assign, readonly) CGRect createTimeRect;

@property (nonatomic, assign, readonly) CGRect descRect;

@property (nonatomic, assign, readonly) CGRect resultRect;

@property (nonatomic, assign, readonly) CGRect imagesRect;

@property (nonatomic, assign, readonly) CGFloat cellHeight;

- (instancetype)initWithAfterSaleInfo:(WKAfterSaleModel *)afterSaleInfo;

@end
