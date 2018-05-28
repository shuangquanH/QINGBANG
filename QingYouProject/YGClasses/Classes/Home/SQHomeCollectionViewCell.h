//
//  SQHomeCollectionViewCell.h
//  QingYouProject
//
//  Created by qwuser on 2018/5/24.
//  Copyright © 2018年 ccyouge. All rights reserved.
//

#import "SQBaseCollectionViewCell.h"
/** Model  */
#import "SQHomeIndexPageModel.h"



@interface SQHomeCollectionViewCell : SQBaseCollectionViewCell

@property (nonatomic, strong) SQHomeIndexPageModel       *model;


@property (nonatomic, strong) UIImageView       *imageView;
@end
