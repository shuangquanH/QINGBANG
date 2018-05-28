//
//  SQHomeCollectionHeader.m
//  QingYouProject
//
//  Created by qwuser on 2018/5/23.
//  Copyright © 2018年 ccyouge. All rights reserved.
//

#import "SQHomeCollectionHeader.h"
//#import "SQOvalFuncButtons.h"
#import "SQCardScrollView.h"
#import "UIButton+SQWebImage.h"

@interface SQHomeCollectionHeader () <SDCycleScrollViewDelegate>

@property (nonatomic, strong) SDCycleScrollView       *cycleView;
//@property (nonatomic, strong) SQOvalFuncButtons       *ovalView;
@property (nonatomic, strong) UIView                *ovalFuncsView;
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
    CGRect frame = CGRectMake(0, self.cycleView.sqbottom+10, KAPP_WIDTH, 120);
    self.ovalFuncsView = [[UIView alloc] initWithFrame:frame];
    [self addSubview:self.ovalFuncsView];
}

- (void)addScrollView {
    CGRect frame = CGRectMake(0, self.ovalFuncsView.sqbottom+10, KAPP_WIDTH, 100);
    self.scrollview = [[SQCardScrollView alloc] initWithFrame:frame];
    [self addSubview:self.scrollview];
}

- (void)setModel:(SQHomeIndexPageModel *)model {
    _model = model;
    //轮播图数据
    NSMutableArray  *bannerImageArr = [NSMutableArray array];
    for (SQHomeBannerModel *bannerModel in model.banners) {
        [bannerImageArr addObject:bannerModel.banner_image_url];
    }
    _cycleView.imageURLStringsGroup = bannerImageArr;
    
    //头部功能性按钮
    NSMutableArray  *funcsBtnArr = [NSMutableArray array];
    for (int i = 0; i<model.funcs.count; i++) {
        SQHomeFuncsModel    *funcsModel = model.funcs[i];
        UIButton    *funcsBtn = [UIButton   buttonWithType:UIButtonTypeCustom];
        funcsBtn.backgroundColor = colorWithMainColor;
        [funcsBtn sq_setButtonImageWithUrl:funcsModel.funcs_image_url];
        funcsBtn.tag = 1000+i;
        [funcsBtn addTarget:self action:@selector(btnaction:) forControlEvents:UIControlEventTouchUpInside];
        [funcsBtnArr addObject:funcsBtn];
        [self.ovalFuncsView addSubview:funcsBtn];
    }
    if (funcsBtnArr.count==4) {
        [funcsBtnArr mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedItemLength:100 leadSpacing:20 tailSpacing:20];
    } else {
        [funcsBtnArr mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedItemLength:100 leadSpacing:60 tailSpacing:60];
    }
    [funcsBtnArr mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.ovalFuncsView);
        make.height.equalTo(@100);
    }];
    
    //功能定制按钮数据
    NSMutableArray  *headsBtnArr = [NSMutableArray array];
    for (int i = 0; i<model.heads.count; i++) {
        SQHomeHeadsModel *headModel = model.heads[i];
        UIButton    *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.backgroundColor = colorWithMainColor;
        [button sq_setButtonImageWithUrl:headModel.funcs_image_url];
        button.tag = 2000+i;
        [button addTarget:self action:@selector(btnaction:) forControlEvents:UIControlEventTouchUpInside];
        [headsBtnArr addObject:button];
    }
    [self.scrollview setItemArr:headsBtnArr alongAxis:SQSAxisTypeHorizontal spacing:10 leadSpace:0 tailSpace:0 itemSize:CGSizeMake(290, 100)];
}


#pragma actions
- (void)btnaction:(UIButton *)sender {
    if (sender.tag>=2000) {
        //定制功能按钮
    } else {
        //头部功能按钮
    }
    NSString    *string = [NSString stringWithFormat:@"点击了第%ld个个性定制", sender.tag-1000];
    [self.delegate tapedFuncsWithModel:string];
}
#pragma delegates
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
    NSString    *string = [NSString stringWithFormat:@"点击了第%ld个轮播图", index];
    [self.delegate tapedFuncsWithModel:string];
}














//    CGSize centerSize = CGSizeMake(30, 30);
//    UIImage *backImage = [UIImage imageNamed:@"ovalimage"];
//    self.ovalView = [[SQOvalFuncButtons alloc] initWithFrame:frame centBtnSize:centerSize backImage:backImage];
//    self.ovalView.delegate = self;
//    [self addSubview:self.ovalView];



//- (void)didselectWithClicktype:(ClickType)type {
//    NSString *str;
//    if (type==0) {
//        str = @"点击了上面";
//    } else if (type==1) {
//        str = @"点击了下面";
//    } else if (type==2) {
//        str = @"点击了左面";
//    } else if (type==3) {
//        str = @"点击了右面";
//    } else {
//        str = @"点击了中间";
//    }
//    [self.delegate tapedFuncsWithModel:str];
//}

@end
