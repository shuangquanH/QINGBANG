//
//  RoadShowHallAddVideoImageViewController.h
//  QingYouProject
//
//  Created by nefertari on 2017/11/13.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "RootViewController.h"

@protocol RoadShowHallAddVideoImageViewDelegate <NSObject>


-(void)selectVideoImagesWithArray:(NSArray *)fileArray;

- (void)takeBackWithCoverImage:(UIImage *)coverImage andVideoData:(NSData *)videoData;

@end

@interface RoadShowHallAddVideoImageViewController : RootViewController
@property (nonatomic, assign) id<RoadShowHallAddVideoImageViewDelegate>delegate;
@property (nonatomic, copy) NSString            *pageType;
@end
