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
@property (nonatomic, strong) SQBaseImageView                *ovalFuncsView;
@property (nonatomic, strong) SQCardScrollView       *scrollview;
@property (nonatomic, strong) UIButton       *infoButton;

//选中的model,有三种可能
@property (nonatomic, assign) id       selectedModel;

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
    CGRect frame = CGRectMake(0, 0, YGScreenWidth, KSCAL(320));
    self.cycleView = [SDCycleScrollView cycleScrollViewWithFrame:frame delegate:self placeholderImage:YGDefaultImgSixteen_Nine];
    [self addSubview:self.cycleView];
    
}
- (void)addOvalFuncView {
    CGRect frame = CGRectMake(0, self.cycleView.sqbottom+KSCAL(20), KAPP_WIDTH, KSCAL(320));
    self.ovalFuncsView = [[SQBaseImageView alloc] initWithFrame:frame];
    self.ovalFuncsView.userInteractionEnabled = YES;
    [self addSubview:self.ovalFuncsView];
    
    self.infoButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.infoButton.titleLabel.textColor = KCOLOR_WHITE;
    self.infoButton.titleLabel.font = KFONT(24);
    [self.ovalFuncsView addSubview:self.infoButton];
    [self.infoButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(KSCAL(495));
        make.height.mas_equalTo(KSCAL(80));
        make.top.mas_equalTo(KSCAL(60)+KSCAL(100)+14);
        make.centerX.equalTo(self.ovalFuncsView);
    }];
    [self.infoButton addTarget:self action:@selector(didselectButtonToPushNextPage) forControlEvents:UIControlEventTouchUpInside];
}

- (void)addScrollView {
    CGRect frame = CGRectMake(0, self.ovalFuncsView.sqbottom+KSCAL(20), KAPP_WIDTH, KSCAL(200));
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
    [self.ovalFuncsView setImageWithUrl:self.model.bgimg_url];
    NSMutableArray  *funcsBtnArr = [NSMutableArray array];
    for (int i = 0; i<model.heads.count; i++) {
        SQHomeHeadsModel    *headModel = model.heads[i];
        UIButton    *funcsBtn = [UIButton   buttonWithType:UIButtonTypeCustom];
        [funcsBtn sq_setButtonImageWithUrl:headModel.funcs_image_url];
        [funcsBtn sq_setSelectButtonImageWithUrl:headModel.funcs_image_url_sel];
        funcsBtn.tag = 1000+i;
        [funcsBtn addTarget:self action:@selector(btnaction:) forControlEvents:UIControlEventTouchUpInside];
        [funcsBtnArr addObject:funcsBtn];
        [self.ovalFuncsView addSubview:funcsBtn];
    }
    if (funcsBtnArr.count>3) {
        [funcsBtnArr mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedItemLength:KSCAL(126) leadSpacing:20 tailSpacing:20];
    } else {
        [funcsBtnArr mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedItemLength:KSCAL(126) leadSpacing:60 tailSpacing:60];
    }
    [funcsBtnArr mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(KSCAL(60));
        make.height.mas_equalTo(KSCAL(100));
    }];

    [self.infoButton setBackgroundImage:[UIImage imageNamed:@"rectangle"] forState:UIControlStateNormal];
    [self.infoButton setTitle:@"hello,XXX欢迎来到青邦!" forState:UIControlStateNormal];
}

- (void)setCusModel:(SQHomeCustomModel *)cusModel {
    _cusModel = cusModel;
    self.selectedModel = nil;
    //功能定制按钮数据
    NSMutableArray  *headsBtnArr = [NSMutableArray array];
    for (int i = 0; i<cusModel.banners.count; i++) {
        SQHomeBannerModel *bannerModel = cusModel.banners[i];
        UIButton    *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button sq_setButtonImageWithUrl:bannerModel.banner_image_url];
        button.tag = 2000+i;
        [button addTarget:self action:@selector(btnaction:) forControlEvents:UIControlEventTouchUpInside];
        [headsBtnArr addObject:button];
    }
    if (headsBtnArr.count>1) {
        [self.scrollview setItemArr:headsBtnArr
                          alongAxis:SQSAxisTypeHorizontal spacing:10
                          leadSpace:0 tailSpace:0
                           itemSize:CGSizeMake(KSCAL(580), KSCAL(200))];
    } else {
        UIButton    *cusbutton = headsBtnArr.firstObject;
        [self.scrollview addSubview:cusbutton];
        [cusbutton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.scrollview);
            make.width.equalTo(self.scrollview);
            make.height.mas_equalTo(KSCAL(200));
        }];
    }
}


#pragma actions
- (void)btnaction:(UIButton *)sender {
    if (sender.tag>=2000) {
        //定制功能按钮
        SQHomeBannerModel   *cusModel = self.cusModel.banners[sender.tag-2000];
        [self.delegate tapedFuncsWithModel:cusModel];
        
    } else {
        //头部功能按钮
        self.selectedModel = self.model.heads[sender.tag-1000];
        for (UIButton *button in self.ovalFuncsView.subviews) {
            if (button==sender) {
                sender.selected = YES;
            } else {
                button.selected = NO;
            }
        }
    }

}
#pragma delegates
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
    [self.delegate tapedFuncsWithModel:self.model.banners[index]];
}
- (void)didselectButtonToPushNextPage {
    if (self.selectedModel) {
        [self.delegate tapedFuncsWithModel:self.selectedModel];
    }
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
