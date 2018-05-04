//
//  HomePageSeccondTableViewCell.h
//  QingYouProject
//
//  Created by nefertari on 2017/9/14.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomePageModel.h"

@interface HomePageSeccondTableViewCell : UITableViewCell
@property (nonatomic,strong) HomePageModel * model;
- (void)setModel:(HomePageModel *)model withType:(NSString *)type; //推荐 “remmend”  新鲜事 “news”
@end
