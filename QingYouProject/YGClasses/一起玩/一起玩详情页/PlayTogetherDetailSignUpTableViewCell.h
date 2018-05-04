//
//  PlayTogetherDetailSignUpTableViewCell.h
//  QingYouProject
//
//  Created by apple on 2017/12/22.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ServiceEvalutionModel;
@interface PlayTogetherDetailSignUpTableViewCell : UITableViewCell
@property (nonatomic, strong) ServiceEvalutionModel  *model;
@property (nonatomic, strong) NSString * typeStr;
@end
