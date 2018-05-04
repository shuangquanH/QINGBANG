//
//  SecondhandReplaceLogisticeInforTableViewCell.h
//  QingYouProject
//
//  Created by apple on 2017/12/28.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SecondhandReplaceLogisticeInforModel;
@interface SecondhandReplaceLogisticeInforTableViewCell : UITableViewCell
@property (nonatomic, strong) SecondhandReplaceLogisticeInforModel *model;
-(void)setModel:(SecondhandReplaceLogisticeInforModel *)model withRow:(NSInteger )row withCount:(NSUInteger )count;

@end
