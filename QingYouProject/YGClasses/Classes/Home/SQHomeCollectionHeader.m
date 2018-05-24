//
//  SQHomeCollectionHeader.m
//  QingYouProject
//
//  Created by qwuser on 2018/5/23.
//  Copyright © 2018年 ccyouge. All rights reserved.
//

#import "SQHomeCollectionHeader.h"
#import "SQOvalFuncButtons.h"
#import "SQCardScrollView.h"

@interface SQHomeCollectionHeader () <SQOvalFuncButtonDelegate, SDCycleScrollViewDelegate>

@property (nonatomic, strong) SDCycleScrollView       *cycleView;
@property (nonatomic, strong) SQOvalFuncButtons       *ovalView;
@property (nonatomic, strong) SQCardScrollView       *scrollview;

@end

@implementation SQHomeCollectionHeader

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addCycleView];
        [self addOvalFuncView];
        [self addScrollView];
    }
    return self;
}


- (void)addCycleView {
    UIImage *backImage = [UIImage imageNamed:@"ovalimage"];
    CGRect frame = CGRectMake(0, 0, YGScreenWidth, 225);
    self.cycleView = [SDCycleScrollView cycleScrollViewWithFrame:frame delegate:self placeholderImage:backImage];
    [self addSubview:self.cycleView];
    
}
- (void)addOvalFuncView {
    
    CGRect frame = CGRectMake(0, self.cycleView.sqbottom+10, KAPP_WIDTH, 225);
    CGSize centerSize = CGSizeMake(30, 30);
    UIImage *backImage = [UIImage imageNamed:@"ovalimage"];
    self.ovalView = [[SQOvalFuncButtons alloc] initWithFrame:frame centBtnSize:centerSize backImage:backImage];
    self.ovalView.delegate = self;
    [self addSubview:self.ovalView];
}

- (void)addScrollView {
    CGRect frame = CGRectMake(0, self.ovalView.sqbottom+10, KAPP_WIDTH, 100);
    self.scrollview = [[SQCardScrollView alloc] initWithFrame:frame];
    [self addSubview:self.scrollview];
}

- (void)setCycleViewData:(NSArray *)cycleViewData {
    _cycleViewData = cycleViewData;
}
- (void)setScrollViewData:(NSArray *)scrollViewData {
    _scrollViewData = scrollViewData;
    NSArray *imageArr = @[@"https://ss0.bdstatic.com/70cFvHSh_Q1YnxGkpoWK1HF6hhy/it/u=1765474568,392718820&fm=27&gp=0.jpg",
                          @"https://ss0.bdstatic.com/70cFvHSh_Q1YnxGkpoWK1HF6hhy/it/u=3900680988,3018369610&fm=27&gp=0.jpg",
                          @"https://ss2.bdstatic.com/70cFvnSh_Q1YnxGkpoWK1HF6hhy/it/u=3413067445,3734096099&fm=27&gp=0.jpg"];
    _cycleView.imageURLStringsGroup = imageArr;
    
    
    NSMutableArray  *btnArr = [NSMutableArray array];
    NSArray *btnTitle = @[@"水电缴费", @"会议室预定", @"办公耗材",
                          @"财税代理", @"办公室装修", @"人才招聘",
                          @"工商代办", @"项目申报", @"办公",
                          @"物业服务", @"资金扶持", @"广告位招商"];
    for (NSString *title in btnTitle) {
        UIButton    *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:title forState:UIControlStateNormal];
        button.backgroundColor = colorWithMainColor;
        [button setBackgroundImage:[UIImage imageNamed:@"ovalimage"] forState:UIControlStateNormal];
        [btnArr addObject:button];
        [button addTarget:self action:@selector(btnaction) forControlEvents:UIControlEventTouchUpInside];
        [self.scrollview addSubview:button];
    }
    [self.scrollview setItemArr:btnArr alongAxis:SQSAxisTypeHorizontal spacing:20 leadSpace:0 tailSpace:0 itemSize:CGSizeMake(200, 100)];
    
}



#pragma actions
- (void)btnaction {
    NSLog(@"c");
}
#pragma delegates
- (void)didselectWithClicktype:(ClickType)type {
    NSLog(@"b");
}
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
    NSLog(@"a");
}
@end
