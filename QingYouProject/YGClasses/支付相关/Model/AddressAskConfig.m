//
// Created by zhangkaifeng on 2017/9/29.
// Copyright (c) 2017 ccyouge. All rights reserved.
//

#import "AddressAskConfig.h"
#import "AddressAskModel.h"
#import "AddressAskAndRegisterModel.h"
#import "CommercialRegistrationModel.h"
#import "AddressAskAndRegisterModel.h"
#import "ADManagerModel.h"
#import "NetManagerModel.h"
#import "VIPServiceManagerModel.h"
#import "FinancialAccountingOrderModel.h"

@implementation AddressAskConfig

+ (NSDictionary *)infoDicWithPageType:(int)pageType subPageType:(int)subPageType target:(id)tartget
{
    __weak id weakTarget = tartget;
    //地址咨询footer高
    SectionFooterHeightBlock footerHeightAddressAskBlock = ^(NSInteger section,NSArray *listArray)
    {
        return 40.0;
    };

    SectionFooterHeightBlock footerHeightNoneBlock = ^(NSInteger section,NSArray *listArray)
    {
        return 0.0001;
    };

    SectionFooterViewBlock footerViewNoneBlock = ^(NSInteger section,NSArray *listArray)
    {
        return [[UIView alloc] init];
    };

    //带申请退款的footerView Block
    SectionFooterViewBlock footerViewAddressAskBlock0 = ^(NSInteger section,NSArray *listArray)
    {
        UIView *sectionFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, YGScreenWidth, 40)];
        sectionFooterView.backgroundColor = colorWithYGWhite;

        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, YGScreenWidth, 1)];
        lineView.backgroundColor = colorWithLine;
        [sectionFooterView addSubview:lineView];

        UIButton *giveMoneyButton = [[UIButton alloc] init];
        giveMoneyButton.layer.cornerRadius = (CGFloat) (23.0 / 2.0);
        giveMoneyButton.layer.borderColor = colorWithLine.CGColor;
        giveMoneyButton.layer.borderWidth = 1;
        [giveMoneyButton setTitle:@"申请退款" forState:UIControlStateNormal];
        [giveMoneyButton setTitleColor:colorWithBlack forState:UIControlStateNormal];
        giveMoneyButton.titleLabel.font = [UIFont systemFontOfSize:YGFontSizeSmallOne];
        giveMoneyButton.tag = 100 + section;
        [giveMoneyButton addTarget:weakTarget action:@selector(giveMoneyButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [sectionFooterView addSubview:giveMoneyButton];

        [giveMoneyButton mas_makeConstraints:^(MASConstraintMaker *make)
        {
            make.right.mas_equalTo(sectionFooterView).offset(-12);
            make.centerY.mas_equalTo(sectionFooterView);
            make.width.mas_equalTo(70);
            make.height.mas_equalTo(24);
        }];

        return sectionFooterView;
    };

    //带您的服务正在受理中的footerView Block
    SectionFooterViewBlock footerViewAddressAskBlock1 = ^(NSInteger section,NSArray *listArray)
    {
        UIView *sectionFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, YGScreenWidth, 40)];
        sectionFooterView.backgroundColor = colorWithYGWhite;

        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, YGScreenWidth, 1)];
        lineView.backgroundColor = colorWithLine;
        [sectionFooterView addSubview:lineView];

        AddressAskModel *model = listArray[section];
        UILabel *detailLabel = [[UILabel alloc] init];
        detailLabel.textColor = colorWithLightGray;
        detailLabel.font = [UIFont systemFontOfSize:YGFontSizeSmallTwo];
        detailLabel.text = [NSString stringWithFormat:@"您的服务正在受理中！ %@", model.orderProcessDate];
        [detailLabel sizeToFitHorizontal];
        detailLabel.x = 12;
        detailLabel.centery = sectionFooterView.height / 2;
        [sectionFooterView addSubview:detailLabel];

        return sectionFooterView;
    };

    //带删除订单，立即评价的footerView Block
    SectionFooterViewBlock footerViewAddressAskBlock2 = ^(NSInteger section,NSArray *listArray)
    {
        UIView *sectionFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, YGScreenWidth, 40)];
        sectionFooterView.backgroundColor = colorWithYGWhite;

        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, YGScreenWidth, 1)];
        lineView.backgroundColor = colorWithLine;
        [sectionFooterView addSubview:lineView];

        UIButton *deleteOrderButton = [[UIButton alloc] init];
        deleteOrderButton.layer.cornerRadius = (CGFloat) (23.0 / 2.0);
        deleteOrderButton.layer.borderColor = colorWithLine.CGColor;
        deleteOrderButton.layer.borderWidth = 1;
        [deleteOrderButton setTitle:@"删除订单" forState:UIControlStateNormal];
        [deleteOrderButton setTitleColor:colorWithBlack forState:UIControlStateNormal];
        deleteOrderButton.titleLabel.font = [UIFont systemFontOfSize:YGFontSizeSmallOne];
        deleteOrderButton.tag = 100 + section;
        [deleteOrderButton addTarget:weakTarget action:@selector(deleteOrderButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [sectionFooterView addSubview:deleteOrderButton];

        UIButton *evaluateButton = [[UIButton alloc] init];
        evaluateButton.layer.cornerRadius = (CGFloat) (23.0 / 2.0);
        evaluateButton.layer.borderColor = colorWithMainColor.CGColor;
        evaluateButton.layer.borderWidth = 1;
        [evaluateButton setTitle:@"立即评价" forState:UIControlStateNormal];
        [evaluateButton setTitleColor:colorWithMainColor forState:UIControlStateNormal];
        evaluateButton.titleLabel.font = [UIFont systemFontOfSize:YGFontSizeSmallOne];
        evaluateButton.tag = 200 + section;
        [evaluateButton addTarget:weakTarget action:@selector(evaluateButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [sectionFooterView addSubview:evaluateButton];

        [evaluateButton mas_makeConstraints:^(MASConstraintMaker *make)
        {
            make.right.mas_equalTo(sectionFooterView).offset(-12);
            make.centerY.mas_equalTo(sectionFooterView);
            make.width.mas_equalTo(70);
            make.height.mas_equalTo(24);
        }];

        [deleteOrderButton mas_makeConstraints:^(MASConstraintMaker *make)
        {
            make.right.mas_equalTo(evaluateButton.mas_left).offset(-8);
            make.centerY.mas_equalTo(evaluateButton);
            make.width.height.mas_equalTo(evaluateButton);
        }];

        return sectionFooterView;
    };

    NSArray *infoArray = @[
            @[
                    @{
                            @"modelClass"       : [AddressAskModel class],      //用的是哪个model
                            @"setModel"         : @"setAddressAskModel:",       //cell中setModel的方法
                            @"footerHeightBlock": footerHeightAddressAskBlock,  //footer高block
                            @"footerViewBlock"  : footerViewAddressAskBlock0,   //footerView Block
                            @"requestUrl"       : @"",                          //请求url
                            @"requestParam"     : @"",                          //请求参数（不要加count，total）
                    },
                    @{
                            @"modelClass"       : [AddressAskModel class],
                            @"setModel"         : @"setAddressAskModel:",
                            @"footerHeightBlock": footerHeightAddressAskBlock,
                            @"footerViewBlock"  : footerViewAddressAskBlock1,
                            @"requestUrl"       : @"",
                            @"requestParam"     : @"",
                    },
                    @{
                            @"modelClass"       : [AddressAskModel class],
                            @"setModel"         : @"setAddressAskModel:",
                            @"footerHeightBlock": footerHeightAddressAskBlock,
                            @"footerViewBlock"  : footerViewAddressAskBlock2,
                            @"requestUrl"       : @"",
                            @"requestParam"     : @"",
                    },
            ],
            @[
                    @{
                            @"modelClass"       : [FinancialAccountingOrderModel class],
                            @"setModel"         : @"setFinancialAccountingModel:",
                            @"footerHeightBlock": footerHeightAddressAskBlock,
                            @"footerViewBlock"  : footerViewAddressAskBlock0,
                            @"requestUrl"       : @"",
                            @"requestParam"     : @"",
                    },
                    @{
                            @"modelClass"       : [FinancialAccountingOrderModel class],
                            @"setModel"         : @"setFinancialAccountingModel:",
                            @"footerHeightBlock": footerHeightAddressAskBlock,
                            @"footerViewBlock"  : footerViewAddressAskBlock1,
                            @"requestUrl"       : @"",
                            @"requestParam"     : @"",
                    },
                    @{
                            @"modelClass"       : [FinancialAccountingOrderModel class],
                            @"setModel"         : @"setFinancialAccountingModel:",
                            @"footerHeightBlock": footerHeightAddressAskBlock,
                            @"footerViewBlock"  : footerViewAddressAskBlock2,
                            @"requestUrl"       : @"",
                            @"requestParam"     : @"",
                    },
            ],
            @[
                    @{
                            @"modelClass"       : [CommercialRegistrationModel class],
                            @"setModel"         : @"setCommercialRegistrationModel:",
                            @"footerHeightBlock": footerHeightAddressAskBlock,
                            @"footerViewBlock"  : footerViewAddressAskBlock0,
                            @"requestUrl"       : @"",
                            @"requestParam"     : @"",
                    },
                    @{
                            @"modelClass"       : [CommercialRegistrationModel class],
                            @"setModel"         : @"setCommercialRegistrationModel:",
                            @"footerHeightBlock": footerHeightAddressAskBlock,
                            @"footerViewBlock"  : footerViewAddressAskBlock1,
                            @"requestUrl"       : @"",
                            @"requestParam"     : @"",
                    },
                    @{
                            @"modelClass"       : [CommercialRegistrationModel class],
                            @"setModel"         : @"setCommercialRegistrationModel:",
                            @"footerHeightBlock": footerHeightAddressAskBlock,
                            @"footerViewBlock"  : footerViewAddressAskBlock2,
                            @"requestUrl"       : @"",
                            @"requestParam"     : @"",
                    },
            ],
            @[
                    @{
                            @"modelClass"       : [AddressAskAndRegisterModel class],
                            @"setModel"         : @"setAddressAskAndRegisterModel:",
                            @"footerHeightBlock": footerHeightAddressAskBlock,
                            @"footerViewBlock"  : footerViewAddressAskBlock0,
                            @"requestUrl"       : @"",
                            @"requestParam"     : @"",
                    },
                    @{
                            @"modelClass"       : [AddressAskAndRegisterModel class],
                            @"setModel"         : @"setAddressAskAndRegisterModel:",
                            @"footerHeightBlock": footerHeightAddressAskBlock,
                            @"footerViewBlock"  : footerViewAddressAskBlock1,
                            @"requestUrl"       : @"",
                            @"requestParam"     : @"",
                    },
                    @{
                            @"modelClass"       : [AddressAskAndRegisterModel class],
                            @"setModel"         : @"setAddressAskAndRegisterModel:",
                            @"footerHeightBlock": footerHeightAddressAskBlock,
                            @"footerViewBlock"  : footerViewAddressAskBlock2,
                            @"requestUrl"       : @"",
                            @"requestParam"     : @"",
                    },
            ],
            @[
                    @{
                            @"modelClass"       : [ADManagerModel class],
                            @"setModel"         : @"setAdManagerModel:",
                            @"footerHeightBlock": footerHeightAddressAskBlock,
                            @"footerViewBlock"  : footerViewAddressAskBlock0,
                            @"requestUrl"       : @"",
                            @"requestParam"     : @"",
                    },
                    @{
                            @"modelClass"       : [ADManagerModel class],
                            @"setModel"         : @"setAdManagerModel:",
                            @"footerHeightBlock": footerHeightAddressAskBlock,
                            @"footerViewBlock"  : footerViewAddressAskBlock1,
                            @"requestUrl"       : @"",
                            @"requestParam"     : @"",
                    },
                    @{
                            @"modelClass"       : [ADManagerModel class],
                            @"setModel"         : @"setAdManagerModel:",
                            @"footerHeightBlock": footerHeightAddressAskBlock,
                            @"footerViewBlock"  : footerViewAddressAskBlock2,
                            @"requestUrl"       : @"",
                            @"requestParam"     : @"",
                    },
            ],
            @[
                    @{
                            @"modelClass"       : [NetManagerModel class],
                            @"setModel"         : @"setNetManagerModel:",
                            @"footerHeightBlock": footerHeightNoneBlock,
                            @"footerViewBlock"  : footerViewNoneBlock,
                            @"requestUrl"       : @"",
                            @"requestParam"     : @"",
                    },
                    @{
                            @"modelClass"       : [NetManagerModel class],
                            @"setModel"         : @"setNetManagerModel:",
                            @"footerHeightBlock": footerHeightAddressAskBlock,
                            @"footerViewBlock"  : footerViewAddressAskBlock1,
                            @"requestUrl"       : @"",
                            @"requestParam"     : @"",
                    },
                    @{
                            @"modelClass"       : [NetManagerModel class],
                            @"setModel"         : @"setNetManagerModel:",
                            @"footerHeightBlock": footerHeightAddressAskBlock,
                            @"footerViewBlock"  : footerViewAddressAskBlock2,
                            @"requestUrl"       : @"",
                            @"requestParam"     : @"",
                    },
            ],
            @[
                    @{
                            @"modelClass"       : [VIPServiceManagerModel class],
                            @"setModel"         : @"setVipServiceManagerModel:",
                            @"footerHeightBlock": footerHeightNoneBlock,
                            @"footerViewBlock"  : footerViewNoneBlock,
                            @"requestUrl"       : @"",
                            @"requestParam"     : @"",
                    },
                    @{
                            @"modelClass"       : [VIPServiceManagerModel class],
                            @"setModel"         : @"setVipServiceManagerModel:",
                            @"footerHeightBlock": footerHeightAddressAskBlock,
                            @"footerViewBlock"  : footerViewAddressAskBlock1,
                            @"requestUrl"       : @"",
                            @"requestParam"     : @"",
                    },
                    @{
                            @"modelClass"       : [VIPServiceManagerModel class],
                            @"setModel"         : @"setVipServiceManagerModel:",
                            @"footerHeightBlock": footerHeightAddressAskBlock,
                            @"footerViewBlock"  : footerViewAddressAskBlock2,
                            @"requestUrl"       : @"",
                            @"requestParam"     : @"",
                    },
            ]
    ];

    NSMutableDictionary *infoDic = [[NSMutableDictionary alloc] init];

    infoDic[@"modelClass"] = infoArray[pageType][subPageType][@"modelClass"];
    infoDic[@"setModel"] = infoArray[pageType][subPageType][@"setModel"];
    infoDic[@"footerHeightBlock"] = infoArray[pageType][subPageType][@"footerHeightBlock"];
    infoDic[@"footerViewBlock"] = infoArray[pageType][subPageType][@"footerViewBlock"];
    infoDic[@"requestUrl"] = infoArray[pageType][subPageType][@"requestUrl"];
    infoDic[@"requestParam"] = infoArray[pageType][subPageType][@"requestParam"];
    return infoDic;
}

@end
