//
//  SQDecorationSeveTableHeader.m
//  QingYouProject
//
//  Created by qwuser on 2018/5/18.
//  Copyright © 2018年 ccyouge. All rights reserved.
//

#import "SQDecorationSeveTableHeader.h"

@implementation SQDecorationSeveTableHeader {
    SDCycleScrollView   *cycleScrollView;
}


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:self.bounds delegate:self placeholderImage:[UIImage imageNamed:@"placeholderfigure_rectangle_698x300"]];
        cycleScrollView.contentMode = UIViewContentModeScaleAspectFill;
        cycleScrollView.autoScroll = YES;
        cycleScrollView.infiniteLoop = YES;
        [self addSubview:cycleScrollView];

        
    }
    return self;
}

- (void)setModel:(SQDecorationHomeModel *)model {
    _model = model;
    
    NSMutableArray * imgArry = [NSMutableArray array];
    for (SQDecorationStyleModel *styleModel in model.banners) {
        [imgArry addObject:styleModel.imageUrl];
    }
    cycleScrollView.imageURLStringsGroup = imgArry;
}




- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
    if (self.delegate) {
        [self.delegate didSelectedBannerWithIndex:index];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
