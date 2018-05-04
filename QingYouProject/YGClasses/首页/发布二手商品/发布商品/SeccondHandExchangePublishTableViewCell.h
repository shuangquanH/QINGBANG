//
//  SeccondHandExchangePublishTableViewCell.h
//  QingYouProject
//
//  Created by 王丹 on 2017/12/14.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SeccondHandExchangePublishModel.h"

@protocol SeccondHandExchangePublishTableViewCellDelegate <NSObject>

- (void)SeccondHandExchangePublishTableViewCelltextfieldReturnValue:(NSString *)value withTextIndexPath:(NSIndexPath *)indexPath;

- (void)SeccondHandExchangePublishTableViewCellSelectButtonActionWithIndexPath:(NSIndexPath *)indexPath;

@end
@interface SeccondHandExchangePublishTableViewCell : UITableViewCell<UITextFieldDelegate>
@property (nonatomic, assign) id<SeccondHandExchangePublishTableViewCellDelegate>delegate;
@property (nonatomic, strong) SeccondHandExchangePublishModel             *model;
@property (nonatomic, strong) NSIndexPath             *indexPath;

-(void)setModel:(SeccondHandExchangePublishModel *)model withIndexPath:(NSIndexPath *)indexPath;
@end
