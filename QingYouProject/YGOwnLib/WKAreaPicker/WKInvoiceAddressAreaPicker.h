//
//  YZLMeUserInfoCityPickerView.h
//  knight
//
//  Created by yzl on 17/3/18.
//  Copyright © 2017年 hongdongjie. All rights reserved.
//

@class ManageMailPostModel;

@interface WKInvoiceAddressAreaPicker : UIView

@property (nonatomic, copy) void(^ areaPickerBlock)(NSDictionary *addressDic);

@property (nonatomic, strong) ManageMailPostModel *invoceAddress;

@end
