//
//  SQBaseCollectionView.m
//  QingYouProject
//
//  Created by qwuser on 2018/5/23.
//  Copyright © 2018年 ccyouge. All rights reserved.
//

#import "SQBaseCollectionView.h"

@implementation SQBaseCollectionView

- (void)setHeaderView:(UIView *)headerView {
    _headerView = headerView;
    CGRect viewFrame = headerView.frame;
    self.contentInset = UIEdgeInsetsMake(headerView.frame.size.height, 0, 0, 0);
    headerView.frame = CGRectMake(viewFrame.origin.x, -viewFrame.size.height+viewFrame.origin.y, viewFrame.size.width, viewFrame.size.height);
    [self addSubview:headerView];
}

- (void)setFooterView:(UIView *)footerView {
    _footerView = footerView;
    CGRect viewFrame = footerView.frame;
    self.contentInset = UIEdgeInsetsMake(0, 0, 0, footerView.frame.size.height);
    footerView.frame = CGRectMake(viewFrame.origin.x, self.contentSize.height+viewFrame.origin.y, viewFrame.size.width, viewFrame.size.height);
    [self addSubview:footerView];
    
}

@end
