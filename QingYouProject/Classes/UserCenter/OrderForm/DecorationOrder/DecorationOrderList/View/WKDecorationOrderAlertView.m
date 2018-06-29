//
//  WKDecorationOrderAlertView.m
//  QingYouProject
//
//  Created by mac on 2018/6/7.
//  Copyright © 2018年 ccyouge. All rights reserved.
//

#import "WKDecorationOrderAlertView.h"
#import "WKAnimationAlert.h"
#import "NSString+SQStringSize.h"

@interface WKDecorationOrderAlertView()

@property (nonatomic, copy) void (^ handlerBlock)(NSInteger index);

@end

static WKDecorationOrderAlertView *_instance;

@implementation WKDecorationOrderAlertView
{
    UILabel *_detailLabel;
    NSMutableArray<UIButton *> *_buttons;
}

+ (WKDecorationOrderAlertView *)alertWithDetail:(NSString *)detail titles:(NSArray<NSString *> *)titles bgColors:(NSArray<UIColor *> *)bgColor handler:(void (^)(NSInteger))handler {
    
    if (!_instance) {
        _instance = [[WKDecorationOrderAlertView alloc] init];
    }
    [_instance setDetail:detail titles:titles bgColors:bgColor];
    _instance.handlerBlock = handler;
    
    [WKAnimationAlert showAlertWithInsideView:_instance animation:WKAlertAnimationTypeCenter canTouchDissmiss:YES superView:nil offset:0];
    return _instance;
}

- (instancetype)init {
    if (self == [super init]) {
        self.backgroundColor = [UIColor whiteColor];
        self.layer.cornerRadius = KSCAL(20);
        self.layer.masksToBounds = YES;
        _buttons = [NSMutableArray array];
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews {
    _detailLabel = [UILabel labelWithFont:KSCAL(38) textColor:KCOLOR(@"000000") textAlignment:NSTextAlignmentCenter];
    [_detailLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    [self addSubview:_detailLabel];
    
    [_detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(KSCAL(15));
        make.centerX.mas_equalTo(0);
        make.top.mas_equalTo(KSCAL(98));
    }];
}

- (void)setDetail:(NSString *)detail titles:(NSArray<NSString *> *)titles bgColors:(NSArray<UIColor *> *)bgColors {
    
    _detailLabel.text = detail;
    
    while (_buttons.count > titles.count) {
        UIButton *btn = _buttons.lastObject;
        [btn removeFromSuperview];
        [_buttons removeLastObject];
    }
    
    CGFloat itemW = (KSCAL(547) - 2 * KSCAL(15) - (titles.count - 1) * KSCAL(20)) / titles.count;
    CGFloat itemH = KSCAL(98);
    for (int i = 0; i < titles.count; i++) {
        UIButton *btn;
        if (_buttons.count > i) {
            btn = [_buttons objectAtIndex:i];
        }
        else {
            btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.titleLabel.font = KFONT(38);
            btn.layer.cornerRadius = KSCAL(20);
            btn.layer.masksToBounds = YES;
            [btn setTitleColor:KCOLOR_WHITE forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(click_actionButton:) forControlEvents:UIControlEventTouchUpInside];
            [_buttons addObject:btn];
            [self addSubview:btn];
        }
        [btn setTitle:titles[i] forState:UIControlStateNormal];
        [btn setBackgroundColor:bgColors[i]];
        btn.tag = i;
        
        [btn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_detailLabel.mas_bottom).offset(KSCAL(50));
            make.left.mas_equalTo(KSCAL(15)+i*(KSCAL(15)+itemW));
            make.size.mas_equalTo(CGSizeMake(itemW, itemH));
        }];
    }
    
    CGFloat labelH = [_detailLabel.text sizeWithFont:KFONT(38) andMaxSize:CGSizeMake(KSCAL(517), MAXFLOAT)].height;
    self.frame = CGRectMake(0, 0, KSCAL(547), labelH+KSCAL(246)+itemH);
}

- (void)click_actionButton:(UIButton *)sender {
    if (self.handlerBlock) {
        self.handlerBlock(sender.tag);
    }
    
    [WKAnimationAlert dismiss];
}


@end
