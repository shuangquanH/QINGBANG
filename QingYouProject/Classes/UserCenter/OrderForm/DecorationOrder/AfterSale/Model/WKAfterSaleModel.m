//
//  WKAfterSaleModel.m
//  QingYouProject
//
//  Created by mac on 2018/6/7.
//  Copyright © 2018年 ccyouge. All rights reserved.
//

#import "WKAfterSaleModel.h"
#import "NSString+SQStringSize.h"

static const CGFloat kLeftMargin = 30;
static const CGFloat kTopMargin  = 20;
static const CGFloat kImageHorizontalSpace = 20;
static const CGFloat kImageVerticalSpace   = 20;


@implementation WKAfterSaleModel

- (void)setAfterSaleState:(NSInteger)afterSaleState {
    _afterSaleState = afterSaleState;
    if (afterSaleState == 0) {
        _stateDesc = @"售后申请已提交，等待系统处理。";
    }
    else {
        _stateDesc = @"系统已回复";
    }
}

@end

@implementation WKAfterSaleCellFrameModel

- (instancetype)initWithAfterSaleInfo:(WKAfterSaleModel *)afterSaleInfo {
    if (self == [super init]) {
        
        CGFloat maxW = KAPP_WIDTH - 2 * KSCAL(kLeftMargin);
        CGFloat y = KSCAL(kTopMargin);
        
        CGSize stateDescSize = [afterSaleInfo.stateDesc sizeWithFont:KFONT(36) andMaxSize:CGSizeMake(maxW, MAXFLOAT)];
        _stateRect = CGRectMake(KSCAL(kLeftMargin), y, stateDescSize.width, stateDescSize.height);
        y += KSCAL(kTopMargin);
        
        CGSize createTimeSize = [afterSaleInfo.createTime sizeWithFont:KFONT(28) andMaxSize:CGSizeMake(maxW, MAXFLOAT)];
        _createTimeRect = CGRectMake(KSCAL(kLeftMargin), y, createTimeSize.width, createTimeSize.height);
        y += KSCAL(kTopMargin);
        
        NSArray *images = [afterSaleInfo.images componentsSeparatedByString:@","];
        if (images.count) {
            CGFloat col = images.count % 3 == 0 ? images.count / 3 : images.count / 3 + 1;
            CGFloat imageW = (maxW - 2 * KSCAL(kImageHorizontalSpace)) / 3.0;
            CGFloat imageTotalH = col * imageW + (col - 1) * KSCAL(kImageVerticalSpace);
            _imagesRect = CGRectMake(KSCAL(kLeftMargin), y, maxW, imageTotalH);
            y += KSCAL(kTopMargin);
        }
        
        if (afterSaleInfo.afterSaleState == 2) {
            NSString *result = [NSString stringWithFormat:@"处理结果：%@", afterSaleInfo.afterSaleResult?:@"暂无结果"];
            CGSize resultSize = [result sizeWithFont:KFONT(28) andMaxSize:CGSizeMake(maxW, MAXFLOAT)];
            _resultRect = CGRectMake(KSCAL(kLeftMargin), y, resultSize.width, resultSize.height);
            y += KSCAL(kTopMargin);
        }
    
        _cellHeight = y;
    }
    return self;
}

@end
