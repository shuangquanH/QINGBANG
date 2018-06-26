//
//  YZLMeUserInfoCityPickerView.m
//  knight
//
//  Created by yzl on 17/3/18.
//  Copyright © 2017年 hongdongjie. All rights reserved.
//

#import "WKInvoiceAddressAreaPicker.h"

#import "YZLAreaPickerView.h"
#import "YZLAreaModel.h"
#import "YZLAreaCacheTool.h"
#import "WKAnimationAlert.h"

@interface WKInvoiceAddressAreaPicker()
@property (nonatomic, strong) YZLAreaPickerView *cityPicker;
@end

@implementation WKInvoiceAddressAreaPicker
- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        
        UIButton* cancelButton = [UIButton new];
        [self addSubview:cancelButton];
        cancelButton.titleLabel.font = KFONT(34);
        [cancelButton setTitleColor:kCOLOR_999 forState:UIControlStateNormal];
        [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [cancelButton sizeToFit];
        [cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(KSCAL(100));
            make.top.mas_equalTo(0);
            make.left.mas_equalTo(KSCAL(30));
        }];
        
        UIButton* confirmButton = [UIButton new];
        [self addSubview:confirmButton];
        confirmButton.titleLabel.font = KFONT(34);
        [confirmButton setTitleColor:KCOLOR_MAIN forState:UIControlStateNormal];
        [confirmButton setTitle:@"确定" forState:UIControlStateNormal];
        [confirmButton sizeToFit];
        [confirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(KSCAL(100));
            make.top.mas_equalTo(0);
            make.right.mas_equalTo(-KSCAL(30));
        }];
        
        [confirmButton addTarget:self action:@selector(confirmButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [cancelButton addTarget:self action:@selector(cancelButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        self.cityPicker = [[YZLAreaPickerView alloc] init];
        self.cityPicker.provinceArr = [YZLAreaCacheTool getAreaData];
        [self addSubview:self.cityPicker];
        [self.cityPicker mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.mas_equalTo(0);
            make.top.mas_equalTo(KSCAL(100) + 1);
        }];
    }
    return self;
}

- (void)setInvoceAddress:(ManageMailPostModel *)invoceAddress {
    _invoceAddress = invoceAddress;
    self.cityPicker.invoceAddress = invoceAddress;
}

//- (void)setUserModel:(YZLUserBeanModel *)userModel {
//    _userModel = userModel;
//    self.cityPicker.userModel = userModel;
//}

#pragma mark - SEL
- (void)confirmButtonClick:(UIButton *)sender {
    @weakify(self)
    [self.cityPicker selectAdress:^(NSDictionary *address) {
        @strongify(self)
        if (self.areaPickerBlock) {
            self.areaPickerBlock(address);
        }
    }];
    [WKAnimationAlert dismiss];
}

- (void)cancelButtonClick:(UIButton *)sender {
    [WKAnimationAlert dismiss];
}

@end
