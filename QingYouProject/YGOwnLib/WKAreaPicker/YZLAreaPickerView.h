//
//  YZLAreaPickerView.h
//  knight
//
//  Created by yzl on 17/3/1.
//  Copyright © 2017年 hongdongjie. All rights reserved.
//

typedef enum {
    YZLAreaPickerTypeBase,//无全国、无不限
    YZLAreaPickerTypeLimit,//无全国、有不限
    YZLAreaPickerTypeCountryAndLimit,//有全国、有不限
    YZLAreaPickerTypeNoCounty//没有区，只有省市
}YZLAreaPickerType;

typedef void(^areaPickerBlock)(NSDictionary *);

@interface YZLAreaPickerView : UIView
@property (nonatomic, strong) NSArray *provinceArr;//数据源
@property (nonatomic, copy  ) areaPickerBlock areaBlock;
@property (nonatomic, assign) BOOL isService;

@property (nonatomic, strong) NSMutableArray *serviceProvinceArr;//区域选择省数组

@property (nonatomic, assign) YZLAreaPickerType areaPickerType;

- (void)selectAdress:(areaPickerBlock)address;

@end
