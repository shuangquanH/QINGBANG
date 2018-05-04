//
//  GoodsPlaceView.m
//  QingYouProject
//
//  Created by LDSmallCat on 2017/10/22.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "GoodsPlaceView.h"

@interface GoodsPlaceView()

/** 收货人  */
@property (nonatomic,strong) UILabel * receiveNameLable;
/** 电话  */
@property (nonatomic,strong) UILabel * phoneLable;
/** 收货地址  */
@property (nonatomic,strong) UILabel * placeLable;

/** 新建地址  */
@property (nonatomic,strong) UIButton * newerPlaceButton;
@property (nonatomic,strong) UIButton * changePlaceButton;

@end

@implementation GoodsPlaceView

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
       

        //收货人
        self.receiveNameLable = [UILabel ld_labelWithTextColor:kBlackColor textAlignment:NSTextAlignmentLeft font:LDFont(14) numberOfLines:1];
        [self addSubview:self.receiveNameLable];
        [self.receiveNameLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.offset(15);
            make.left.offset(LDHPadding);
            make.height.offset(15);
//            make.right.equalTo(self.phoneLable.mas_left);
        }];
        
        //右侧箭头
        self.arrowImageView = [UIImageView new];
        [self addSubview:self.arrowImageView];
        self.arrowImageView.image = LDImage(@"unfold_btn_gray");
        [self.arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.offset(-LDHPadding);
            make.top.offset((frame.size.height - 20) / 2 - 7.5);
            make.width.height.offset(15);
        }];
        
        //电话
        self.phoneLable = [UILabel ld_labelWithTextColor:kBlackColor textAlignment:NSTextAlignmentRight font:LDFont(14) numberOfLines:1];
        [self addSubview:self.phoneLable];
        [self.phoneLable mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.right.equalTo(self.arrowImageView.mas_left).offset(-LDHPadding);
            make.top.offset(15);
            make.height.offset(15);
            make.left.equalTo(self.receiveNameLable.mas_right).offset(4 * LDHPadding);

        }];
        


        
//        //电话
//        self.phoneLable = [UILabel ld_labelWithTextColor:kBlackColor textAlignment:NSTextAlignmentRight font:LDFont(13) numberOfLines:1];
//        [self addSubview:self.phoneLable];
//        [self.phoneLable mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.right.equalTo(self.arrowImageView.mas_left).offset(-LDHPadding);
//            make.top.offset(LDHPadding);
//            make.height.offset(15);
//        }];
//
//
//        //收货人
//        self.receiveNameLable = [UILabel ld_labelWithTextColor:kBlackColor textAlignment:NSTextAlignmentLeft font:LDFont(13) numberOfLines:1];
//        [self addSubview:self.receiveNameLable];
//        [self.receiveNameLable mas_makeConstraints:^(MASConstraintMaker *make) {
//
//            make.top.left.offset(LDHPadding);
//            make.height.offset(15);
//            make.right.equalTo(self.phoneLable.mas_left);
//        }];
        
        
        //收货地址
        self.placeLable = [UILabel ld_labelWithTextColor:kBlackColor textAlignment:NSTextAlignmentLeft font:LDFont(14) numberOfLines:2];
        
        [self addSubview:self.placeLable];
        [self.placeLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.arrowImageView.mas_left).offset(-LDHPadding);
            make.top.equalTo(self.receiveNameLable.mas_bottom).offset(0);
            make.left.offset(LDHPadding);
        }];
        
        self.bottomImageView = [UIImageView new];
//        self.bottomImageView.backgroundColor = kRedColor;
        self.bottomImageView.image =[UIImage imageNamed:@"steward_poffice_colourbar"];
        [self addSubview:self.bottomImageView];
        [self.bottomImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.offset(0);
            make.height.offset(LDVPadding/2);
            make.top.equalTo(self.placeLable.mas_bottom).offset(0);
        }];
        UIView * line = [UIView new];
        line.backgroundColor = colorWithLine;
        [self addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.offset(0);
            make.height.offset(LDVPadding);
            make.top.equalTo(self.bottomImageView.mas_bottom).offset(0);
        }];
        
        self.newerPlaceButton = [UIButton buttonWithType:UIButtonTypeCustom normalImage:nil selectedImage:nil normalTitle:@"新建地址" selectedTitle:@"新建地址" normalTitleColor:kBlackColor selectedTitleColor:kBlackColor backGroundColor:kWhiteColor normalBackGroundImageStr:nil selectedBackGroundImageStr:nil titleFont:15];
        [self.newerPlaceButton addTarget:self action:@selector(newerPlaceButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        self.newerPlaceButton.hidden = YES;
        [self addSubview:self.newerPlaceButton];
        self.newerPlaceButton.backgroundColor =[UIColor clearColor];
        
        self.changePlaceButton = [UIButton buttonWithType:UIButtonTypeCustom normalImage:nil selectedImage:nil normalTitle:nil selectedTitle:nil normalTitleColor:kBlackColor selectedTitleColor:kBlackColor backGroundColor:[UIColor clearColor] normalBackGroundImageStr:nil selectedBackGroundImageStr:nil titleFont:13];
        [self.changePlaceButton addTarget:self action:@selector(newerPlaceButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        self.changePlaceButton.hidden = YES;
        [self addSubview:self.changePlaceButton];
        
        [self.newerPlaceButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.offset(0);
            make.bottom.equalTo(self.bottomImageView.mas_top);
            
//            make.right.equalTo(self.arrowImageView.mas_right + LDHPadding);
        }];
        
        [self.changePlaceButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.offset(0);
            make.bottom.equalTo(self.bottomImageView.mas_top);
            make.right.equalTo(self.arrowImageView.mas_left);
        }];
        
    }
    
    return self;
    
}
#pragma mark - newPlaceButtonClick
- (void)newerPlaceButtonClick:(UIButton *)newerPlaceButton{
    
    [self.delegate goodsPlaceViewNewerPlaceButtonClick];
    
}
- (void)reloadDataWithName:(NSString *)name phone:(NSString *)phone place:(NSString *)place{
    
    self.receiveNameLable.text = name;
    self.phoneLable.text = phone;
    self.placeLable.text = place;
//    [self.placeLable sizeToFit];
//    [self layoutIfNeeded];
    
}

- (void)setIsShowNewButton:(BOOL)isShowNewButton{
    
    _isShowNewButton = isShowNewButton;
    self.newerPlaceButton.hidden = !isShowNewButton;
    self.receiveNameLable.hidden = isShowNewButton ? YES : NO;
    self.phoneLable.hidden = isShowNewButton ? YES : NO;
    self.placeLable.hidden = isShowNewButton ? YES : NO;
    self.changePlaceButton.hidden = isShowNewButton;
}

-(void)lableWithThick
{
    self.phoneLable.font = [UIFont boldSystemFontOfSize:14];
    self.receiveNameLable.font = [UIFont boldSystemFontOfSize:14];
}
@end

























