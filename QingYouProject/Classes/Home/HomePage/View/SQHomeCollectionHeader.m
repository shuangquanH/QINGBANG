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
#import "UIView+SQGesture.h"
#import "NSString+SQStringSize.h"


@interface SQHomeCollectionHeader () <SDCycleScrollViewDelegate>

@property (nonatomic, strong) SDCycleScrollView       *cycleView;
//@property (nonatomic, strong) SQOvalFuncButtons       *ovalView;
@property (nonatomic, strong) SQBaseImageView                *ovalFuncsView;
@property (nonatomic, strong) UIView       *ovalContentView;

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


//首页banner
- (void)addCycleView {
    CGRect frame = CGRectMake(0, 0, YGScreenWidth, KSCAL(320));
    self.cycleView = [SDCycleScrollView cycleScrollViewWithFrame:frame delegate:self placeholderImage:[UIImage imageNamed:@"placeholderfigure_rectangle_600x300"]];
    self.cycleView.backgroundColor = colorWithTable;
    [self addSubview:self.cycleView];
    
}
//首页头部功能按钮
- (void)addOvalFuncView {
    CGRect frame = CGRectMake(0, self.cycleView.sqbottom+KSCAL(20), KAPP_WIDTH, KSCAL(320));
    self.ovalFuncsView = [[SQBaseImageView alloc] initWithFrame:frame];
    self.ovalFuncsView.userInteractionEnabled = YES;
    [self addSubview:self.ovalFuncsView];
    
    self.infoButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.infoButton.frame = CGRectMake((self.width-KSCAL(495))/2.0, KSCAL(60)+KSCAL(100)+14, KSCAL(495), KSCAL(80));
    self.infoButton.titleLabel.textColor = KCOLOR_WHITE;
    self.infoButton.titleLabel.font = KFONT(24);
    [self.ovalFuncsView addSubview:self.infoButton];
    [self.infoButton addTarget:self action:@selector(infobuttonAction) forControlEvents:UIControlEventTouchUpInside];
}
- (void)infobuttonAction {
    [self didselectButtonToPushNextPageWithModel:self.selectedModel];
}
//首页个性定制
- (void)addScrollView {
    CGRect frame = CGRectMake(0, self.ovalFuncsView.sqbottom+KSCAL(20), KAPP_WIDTH, KSCAL(200));
    self.scrollview = [[SQCardScrollView alloc] initWithFrame:frame];
    [self addSubview:self.scrollview];
}




#pragma mark addModels:
- (void)setModel:(SQHomeIndexPageModel *)model {
    _model = model;
    self.selectedModel = nil;
    //轮播图数据
    NSMutableArray  *bannerImageArr = [NSMutableArray array];
    for (SQHomeBannerModel *bannerModel in model.banners) {
        [bannerImageArr addObject:bannerModel.banner_image_url];
    }
    _cycleView.imageURLStringsGroup = bannerImageArr;
    
    //头部功能性按钮
    [self.ovalFuncsView setImageWithUrl:self.model.bgimg_url];
    UIView  *tempView = [[UIView alloc] initWithFrame:CGRectMake(0, KSCAL(60), self.width, KSCAL(100))];
    [self.ovalFuncsView addSubview:tempView];
    
    NSMutableArray  *funcsBtnArr = [NSMutableArray array];
    for (int i = 0; i<model.heads.count; i++) {
        SQHomeHeadsModel    *headModel = model.heads[i];
        UIButton    *funcsBtn = [UIButton   buttonWithType:UIButtonTypeCustom];
        [funcsBtn sq_setButtonImageWithUrl:headModel.funcs_image_url];
        [funcsBtn sq_setSelectButtonImageWithUrl:headModel.funcs_image_url_sel];
        funcsBtn.tag = 1000+i;
        [funcsBtn addTarget:self action:@selector(btnaction:) forControlEvents:UIControlEventTouchUpInside];
        [funcsBtnArr addObject:funcsBtn];
        [tempView addSubview:funcsBtn];
    }
    
    for (int i = 0; i<funcsBtnArr.count; i++) {
        UIButton    *btn = funcsBtnArr[i];
        CGFloat eachContentWidth = (KAPP_WIDTH-KSCAL(80))/funcsBtnArr.count;
        CGFloat btnOrginX = KSCAL(40)+i*eachContentWidth+(eachContentWidth-KSCAL(122))/2.0;
        [btn setFrame:CGRectMake(btnOrginX, 0, KSCAL(122), KSCAL(100))];
    }
    [self.ovalContentView removeFromSuperview];
    self.ovalContentView = tempView;
    [self.infoButton setBackgroundImage:[UIImage imageNamed:@"rectangle"] forState:UIControlStateNormal];
    
    
    NSString    *name = [YGSingleton sharedManager].user.userName;
    NSString    *title = [NSString string];
    if (name) {
        title = [NSString stringWithFormat:@"hello,%@欢迎来到青邦!", name];
    } else {
        title = [NSString stringWithFormat:@"hello,欢迎来到青邦!"];
    }
    [self.infoButton setTitle:title forState:UIControlStateNormal];
    [self.infoButton setImage:nil forState:UIControlStateNormal];
    
    
    [self.scrollview.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    NSMutableArray  *headsBtnArr = [NSMutableArray array];
    
    for (int i = 0; i<model.cusBanners.count; i++) {
        SQHomeBannerModel *bannerModel = model.cusBanners[i];
        SQBaseImageView *button = [[SQBaseImageView alloc] init];
        button.userInteractionEnabled = YES;
        [button setImageWithUrl:bannerModel.banner_image_url];
        button.tag = 2000+i;
        [headsBtnArr addObject:button];
        
        WeakSelf(weakself);
        [button sq_addTapActionWithBlock:^(UIGestureRecognizer *gestureRecoginzer) {
            [weakself cusBanTap:gestureRecoginzer];
        }];
    }
    if (headsBtnArr.count>1) {
        [self.scrollview setItemArr:headsBtnArr
                          alongAxis:SQSAxisTypeHorizontal spacing:10
                          leadSpace:0 tailSpace:0
                           itemSize:CGSizeMake(KSCAL(580), KSCAL(200))];
    } else {
        UIButton    *cusbutton = headsBtnArr.firstObject;
        [self.scrollview addSubview:cusbutton];
        cusbutton.frame = self.scrollview.bounds;
    }
}







#pragma actions
//头部功能按钮
- (void)btnaction:(UIButton *)sender {
    SQHomeHeadsModel *theSelectModel = self.model.heads[sender.tag-1000];
    
    if (![theSelectModel.funcs_target isEqualToString:@"17"]) {
        [self didselectButtonToPushNextPageWithModel:theSelectModel];
        return;
    }
    
    
    self.selectedModel = self.model.heads[sender.tag-1000];
    for (UIButton *button in self.ovalContentView.subviews) {
        if (button==sender) {
            sender.selected = YES;
        } else {
            button.selected = NO;
        }
    }
    
}

- (void)setSelectedModel:(id)selectedModel {
    _selectedModel = selectedModel;
    if ([YGSingleton sharedManager].user&&selectedModel) {
        [SQRequest post:KAPI_ORDERNUM param:@{@"type":@"home", @"userid":[YGSingleton sharedManager].user.userid} success:^(id response) {
            int orderCount = [response[@"ordernum"] intValue];
            if (orderCount>0) {
                NSString    *titlestr = [NSString stringWithFormat:@"您有%d笔订单待支付~ 去看看", orderCount];
                NSString    *sizeStr = [NSString stringWithFormat:@"您有%@笔订单待支付~", response[@"ordernum"]];
                CGSize titleSize = [sizeStr sizeWithFont:KFONT(24) andMaxSize:CGSizeMake(500, 20)];
                
                [self.infoButton setTitle:titlestr forState:UIControlStateNormal];
                [self.infoButton setImage:[UIImage imageNamed:@"order_list_btn_down"] forState:UIControlStateNormal];
                self.infoButton.imageEdgeInsets = UIEdgeInsetsMake(0, titleSize.width+self.infoButton.titleLabel.frame.origin.x, 0, 0);
            } else {
                [self.infoButton setImage:nil forState:UIControlStateNormal];
            }
            
        } failure:nil];
        
    }
    
}

//定制功能按钮
- (void)cusBanTap:(UIGestureRecognizer   *)tap {
    SQHomeBannerModel   *cusModel = self.model.cusBanners[tap.view.tag-2000];
    [self.delegate tapedFuncsWithModel:cusModel];
}

#pragma delegates
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
    if (self.delegate) {
        [self.delegate tapedFuncsWithModel:self.model.banners[index]];
    }
}
- (void)didselectButtonToPushNextPageWithModel:(id)model {
    if (self.delegate) {
        [self.delegate tapedFuncsWithModel:model];
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
