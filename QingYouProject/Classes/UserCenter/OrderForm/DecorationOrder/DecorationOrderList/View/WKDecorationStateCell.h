//
//  WKDecorationStateCell.h
//  QingYouProject
//
//  Created by mac on 2018/6/7.
//  Copyright © 2018年 ccyouge. All rights reserved.
//

#import "SQBaseTableViewCell.h"
#import "WKDecorationDetailViewModel.h"

@interface WKDecorationStateCell : SQBaseTableViewCell<WKDecorationDetailViewProtocol>

@property (nonatomic, assign) BOOL isInDetail;

@end
