//
//  HistoryPayRecoredTableViewCell.h
//  QingYouProject
//
//  Created by 王丹 on 2017/10/19.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HistoryPayRecordModel.h"

@protocol HistoryPayRecoredTableViewCellDelegate <NSObject>

-(void)selectButtonClickWithIndexPath:(NSIndexPath *)indexPath;

@end
@interface HistoryPayRecoredTableViewCell : UITableViewCell
@property (nonatomic,assign) id <HistoryPayRecoredTableViewCellDelegate> delegate;
@property (nonatomic, copy) NSString            *cellType;
@property (nonatomic, strong) HistoryPayRecordModel            *model;
@property (nonatomic, strong) NSIndexPath            *indexPath;
-(void)setModel:(HistoryPayRecordModel *)model withIndexPath:(NSIndexPath *)indexPath;
@end
