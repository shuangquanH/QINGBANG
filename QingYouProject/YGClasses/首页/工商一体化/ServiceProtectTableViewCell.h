//
//  ServiceProtectTableViewCell.h
//  QingYouProject
//
//  Created by nefertari on 2017/10/12.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ServiceProtectTableViewCell : UITableViewCell
@property (nonatomic, assign) BOOL isCreate;
- (void)createRecommendServiceViewsWithBottomList:(NSArray *)list withBaseImageUrl:(NSString *)url;

@end
