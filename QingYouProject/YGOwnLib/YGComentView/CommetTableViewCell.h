//
//  CommetTableViewCell.h
//  YogeeLiveShop
//
//  Created by zhangkaifeng on 16/8/19.
//  Copyright © 2016年 ccyouge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SocketNormalMessageModel.h"

@protocol CommetTableViewCellDelegate <NSObject>

-(void)commetTableViewCellDidClickNameButtonWithModel:(SocketBaseModel *)model nameButton:(UIButton *)nameButton;

@end

@interface CommetTableViewCell : UITableViewCell

@property (nonatomic,strong) SocketBaseModel * model;
@property (nonatomic,strong) NSString *showString;
@property (nonatomic,assign) id<CommetTableViewCellDelegate> delegate;
@property (nonatomic,assign) float realWidth;

@end
