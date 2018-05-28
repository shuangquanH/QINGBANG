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
        cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:self.bounds delegate:self placeholderImage:[UIImage imageNamed:@"mine_instashot"]];
        cycleScrollView.autoScroll = YES;
        cycleScrollView.infiniteLoop = YES;
        [self addSubview:cycleScrollView];

        
    }
    return self;
}

- (void)loadImage {
    [YGNetService YGPOST:@"ProcurementIndex" parameters:@{} showLoadingView:YES scrollView:nil success:^(id responseObject) {
        NSMutableArray * imgArry = [NSMutableArray array];
        NSMutableArray * imgList = [responseObject valueForKey:@"imgList"];
        for (int i = 0; i < imgList.count ; i++) {
            NSDictionary * dict = imgList[i];
            [imgArry addObject:[dict objectForKey:@"img"]];
        }
        
        NSArray *userarr = @[@"http://img2.3lian.com/2014/f4/171/71.jpg",
                             @"https://ss0.bdstatic.com/70cFvHSh_Q1YnxGkpoWK1HF6hhy/it/u=1765474568,392718820&fm=27&gp=0.jpg",
                              @"https://ss0.bdstatic.com/70cFvHSh_Q1YnxGkpoWK1HF6hhy/it/u=3900680988,3018369610&fm=27&gp=0.jpg",
                              @"https://ss2.bdstatic.com/70cFvnSh_Q1YnxGkpoWK1HF6hhy/it/u=3413067445,3734096099&fm=27&gp=0.jpg",
                             @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1526636729682&di=17cb24dba05e69286d92f16606b23ad8&imgtype=0&src=http%3A%2F%2Fup.enterdesk.com%2Fedpic_source%2Ff7%2Ffb%2F1b%2Ff7fb1bd224c27f43d2ec3eaebedcf064.jpg"];
        cycleScrollView.imageURLStringsGroup = userarr;
        
    } failure: nil];
}




- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
    NSLog(@"点击了轮播图");
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
