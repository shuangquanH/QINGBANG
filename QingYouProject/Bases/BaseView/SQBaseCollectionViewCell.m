//
//  SQBaseCollectionViewCell.m
//  QingYouProject
//
//  Created by qwuser on 2018/5/23.
//  Copyright © 2018年 ccyouge. All rights reserved.
//

#import "SQBaseCollectionViewCell.h"

@implementation SQBaseCollectionViewCell

- (UICollectionView *)collectionView {
    float version = [[[UIDevice currentDevice] systemVersion] floatValue];
    if (version >= 7.0) {
        return  (UICollectionView *)self.superview.superview;
    } else {
        return (UICollectionView *)self.superview;
    }
}


+ (instancetype)cellWithCollectionView:(UICollectionView *)collectionView forIndexPath:(NSIndexPath *)indexPath {
    if (collectionView == nil) {
        return [[self alloc] init];
    }
    NSString *classname = NSStringFromClass([self class]);
    NSString *identifier = [classname stringByAppendingString:@"CollectionViewCell"];
    [collectionView registerClass:[self class] forCellWithReuseIdentifier:identifier];
    return [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
}


+ (instancetype)nibCellWithCollectionView:(UICollectionView *)collectionView forIndexPath:(NSIndexPath *)indexPath {
    if (collectionView == nil) {
        return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil].firstObject;
    }
    NSString *classname = NSStringFromClass([self class]);
    NSString *identifier = [classname stringByAppendingString:@"nibCellID"];
    UINib *nib = [UINib nibWithNibName:classname bundle:nil];
    [collectionView registerNib:nib forCellWithReuseIdentifier:identifier];
    return [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
}

- (UIViewController *)getCellViewController{
    for (UIView* next = [self superview]; next; next = next.superview) {
        UIResponder* nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController*)nextResponder;
        }
    }
    return nil;
}

- (void)startScrollAnimation {
    
    CATransform3D rotation;//3D旋转
    rotation = CATransform3DMakeTranslation(0 ,50 ,20);
//    rotation = CATransform3DRotate(rotation,M_PI, 0, 0.5, 0.0);
//    rotation = CATransform3DMakeRotation(M_PI, 0, 0.5, 0.0);
    //逆时针旋转
    //rotation =CATransform3DScale(rotation,0.9,0.9,1);
    
    //由远及近
    rotation.m34 =1.0/ -600;
    
    self.layer.transform = rotation;
    
    self.layer.shadowColor = [[UIColor blackColor] CGColor];
    self.layer.shadowOffset =CGSizeMake(10,10);
    self.alpha =0.8;
    
    [UIView animateWithDuration:0.3 animations:^{
        self.layer.transform =CATransform3DIdentity;
        self.alpha =1;
        self.layer.shadowOffset =CGSizeMake(0,0);
    }];
}

@end
