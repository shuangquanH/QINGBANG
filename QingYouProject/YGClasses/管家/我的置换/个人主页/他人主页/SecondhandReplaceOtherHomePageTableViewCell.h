//
//  SecondhandReplaceOtherHomePageTableViewCell.h
//  QingYouProject
//
//  Created by apple on 2017/12/21.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SecondhandReplaceOtherHomePageModel;

@interface SecondhandReplaceOtherHomePageTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *goodImg;
@property (weak, nonatomic) IBOutlet UILabel *goodsTitle;
@property (weak, nonatomic) IBOutlet UILabel *goodsDetail;

@property (nonatomic, strong) SecondhandReplaceOtherHomePageModel *model;
@end
