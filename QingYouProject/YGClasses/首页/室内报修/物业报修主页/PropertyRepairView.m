//
//  PropertyRepairView.m
//  QingYouProject
//
//  Created by LDSmallCat on 2017/10/24.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "PropertyRepairView.h"

@interface PropertyRepairView ()

/** 头部imageView  */
@property (nonatomic,strong) UIImageView * headerImageView;
/** 底部label  */
@property (nonatomic,strong) UILabel * bottomLabel;
@end


@implementation PropertyRepairView
- (void)reloadDataWithImage:(NSString *)url andTitle:(NSString *)title{
    
    self.bottomLabel.text = title;
    self.headerImageView.image = LDImage(url);
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.cornerRadius = 5;
        self.layer.masksToBounds = YES;
        
        self.backgroundColor = kWhiteColor;
        self.headerImageView = [[UIImageView alloc] init];
//        self.headerImageView.layer.cornerRadius = 30;
//        self.headerImageView.layer.masksToBounds = YES;
        [self addSubview:self.headerImageView];
        self.bottomLabel = [[UILabel alloc] init];
        [self addSubview:self.bottomLabel];
        
        [self.headerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.centerY.offset(-30);
//            make.width.height.offset(40);
//            make.centerX.offset(0);
//            make.centerY.offset(-self.height/2);
            make.centerY.equalTo(self).with.offset(-15);
            make.width.height.offset(54);
            make.centerX.offset(0);
        }];
        
        self.bottomLabel.textAlignment = NSTextAlignmentCenter;
        self.bottomLabel.font = [UIFont systemFontOfSize:YGFontSizeBigOne];
        [self.bottomLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(self.headerImageView.mas_bottom).offset(15);
            make.left.right.offset(0);
        }];
    }
    return self;
}

@end
