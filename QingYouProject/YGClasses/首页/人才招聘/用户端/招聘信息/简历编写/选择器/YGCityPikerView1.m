//
//  YGCityPikerView.m
//  FindingSomething
//
//  Created by apple on 15/12/24.
//  Copyright © 2015年 韩伟. All rights reserved.
//

#import "YGCityPikerView1.h"
#import "AppDelegate.h"

#define baseViewHeight YGScreenHeight/3.0

@implementation YGCityPikerView1
{
    void(^_handler)(NSString *province, NSString *city);

    UIPickerView *_picker;
    NSDictionary *_areaDic;
    NSArray *_province;
    NSArray *_city;
    NSArray *_district;
    NSString *_selectedProvince;
    UIView *_baseView;
}

+ (instancetype)showWithHandler:(void (^)(NSString *province, NSString *city))handler
{
    YGCityPikerView1 *cityPikerView = [[YGCityPikerView1 alloc] initWithHandler:handler];
    [cityPikerView show];
    return cityPikerView;
}

- (instancetype)initWithHandler:(void (^)(NSString *province, NSString *city))handler
{
    self = [super init];
    if (self)
    {
        _handler = handler;
        [self configUI];
    }
    return self;
}

- (void)configUI
{
    self.frame = [UIScreen mainScreen].bounds;
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.0];

    UIButton *dismissButton = [[UIButton alloc] initWithFrame:self.frame];
    [dismissButton addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:dismissButton];

    NSBundle *bundle = [NSBundle mainBundle];
    NSString *plistPath = [bundle pathForResource:@"area" ofType:@"plist"];
    _areaDic = [[NSDictionary alloc] initWithContentsOfFile:plistPath];

    NSArray *components = [_areaDic allKeys];
    NSArray *sortedArray = [components sortedArrayUsingComparator:^(id obj1, id obj2)
    {

        if ([obj1 integerValue] > [obj2 integerValue])
        {
            return (NSComparisonResult) NSOrderedDescending;
        }

        if ([obj1 integerValue] < [obj2 integerValue])
        {
            return (NSComparisonResult) NSOrderedAscending;
        }
        return (NSComparisonResult) NSOrderedSame;
    }];

    NSMutableArray *provinceTmp = [[NSMutableArray alloc] init];
    for (int i = 0; i < [sortedArray count]; i++)
    {
        NSString *index = sortedArray[i];
        NSArray *tmp = [_areaDic[index] allKeys];
        [provinceTmp addObject:tmp[0]];
    }

    _province = [[NSArray alloc] initWithArray:provinceTmp];

    NSString *index = sortedArray[0];
    NSString *selected = _province[0];
    NSDictionary *dic = [NSDictionary dictionaryWithDictionary:[_areaDic[index] objectForKey:selected]];

    NSArray *cityArray = [dic allKeys];
    NSDictionary *cityDic = [NSDictionary dictionaryWithDictionary:dic[cityArray[0]]];
    _city = [[NSArray alloc] initWithArray:[cityDic allKeys]];


    NSString *selectedCity = _city[0];
    _district = [[NSArray alloc] initWithArray:cityDic[selectedCity]];


    UIView *baseView = [[UIView alloc] initWithFrame:CGRectMake(0, YGScreenHeight, YGScreenWidth, baseViewHeight)];
    [self addSubview:baseView];
    baseView.backgroundColor = [UIColor whiteColor];
    _baseView = baseView;

    _selectedProvince = _province[0];

    UIView *topBaseView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, YGScreenWidth, 40)];
    [_baseView addSubview:topBaseView];

    UIButton *OkButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [OkButton setTitleColor:colorWithMainColor forState:UIControlStateNormal];
    OkButton.frame = CGRectMake(topBaseView.width - 0 - 40 - 10, 7, 45, topBaseView.height - 14);
    [OkButton setTitle:@"确定" forState:UIControlStateNormal];
    [OkButton addTarget:self action:@selector(yesButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [topBaseView addSubview:OkButton];

    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [cancelButton setTitleColor:colorWithLightGray forState:UIControlStateNormal];
    cancelButton.frame = CGRectMake(10, OkButton.y, OkButton.width, OkButton.height);
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    [topBaseView addSubview:cancelButton];

    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.font = [UIFont systemFontOfSize:YGFontSizeNormal];
    titleLabel.text = @"请选择位置";
    titleLabel.textColor = colorWithBlack;
    [topBaseView addSubview:titleLabel];

    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make)
    {
        make.centerX.centerY.mas_equalTo(topBaseView);
    }];

    _picker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, topBaseView.y + topBaseView.height, self.width, _baseView.height - topBaseView.height - topBaseView.y)];
    _picker.dataSource = self;
    _picker.delegate = self;
    _picker.showsSelectionIndicator = YES;
    [_picker selectRow:0 inComponent:0 animated:YES];
    [baseView addSubview:_picker];
}

- (void)show
{
    self.hidden = NO;
    [YGAppDelegate.window addSubview:self];
    [UIView animateWithDuration:0.25 animations:^
    {
        _baseView.y = self.height - _baseView.height;
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    }];
}

- (void)dismiss
{
    [UIView animateWithDuration:0.25 animations:^
            {
                _baseView.y = self.height;
                self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];
            }
                     completion:^(BOOL finished)
                     {
                         [self removeFromSuperview];
                     }];
}

- (void)yesButtonClick
{
    NSInteger provinceIndex = [_picker selectedRowInComponent:PROVINCE_COMPONENT];
    NSInteger cityIndex = [_picker selectedRowInComponent:CITY_COMPONENT];

    NSString *provinceStr = _province[provinceIndex];
    NSString *cityStr = _city[cityIndex];

    [self dismiss];
    if (_handler)
    {
        _handler(provinceStr, cityStr);
    }
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component == PROVINCE_COMPONENT)
    {
        return [_province count];
    }
    else if (component == CITY_COMPONENT)
    {
        return [_city count];
    }
    else
    {
        return [_district count];
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (component == PROVINCE_COMPONENT)
    {
        return _province[row];
    }
    else if (component == CITY_COMPONENT)
    {
        return _city[row];
    }
    else
    {
        return _district[row];
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (component == PROVINCE_COMPONENT)
    {
        _selectedProvince = _province[row];
        NSDictionary *tmp = [NSDictionary dictionaryWithDictionary:_areaDic[[NSString stringWithFormat:@"%ld", (long) row]]];
        NSDictionary *dic = [NSDictionary dictionaryWithDictionary:tmp[_selectedProvince]];
        NSArray *cityArray = [dic allKeys];
        NSArray *sortedArray = [cityArray sortedArrayUsingComparator:^(id obj1, id obj2)
        {

            if ([obj1 integerValue] > [obj2 integerValue])
            {
                return (NSComparisonResult) NSOrderedDescending;//递减
            }

            if ([obj1 integerValue] < [obj2 integerValue])
            {
                return (NSComparisonResult) NSOrderedAscending;//上升
            }
            return (NSComparisonResult) NSOrderedSame;
        }];

        NSMutableArray *array = [[NSMutableArray alloc] init];
        for (int i = 0; i < [sortedArray count]; i++)
        {
            NSString *index = sortedArray[i];
            NSArray *temp = [dic[index] allKeys];
            [array addObject:temp[0]];
        }

        _city = [[NSArray alloc] initWithArray:array];

        NSDictionary *cityDic = dic[sortedArray[0]];
        _district = [[NSArray alloc] initWithArray:cityDic[_city[0]]];
        [_picker selectRow:0 inComponent:CITY_COMPONENT animated:YES];
        [_picker reloadComponent:CITY_COMPONENT];

    }
    else if (component == CITY_COMPONENT)
    {
        NSString *provinceIndex = [NSString stringWithFormat:@"%lu", (unsigned long) [_province indexOfObject:_selectedProvince]];
        NSDictionary *tmp = [NSDictionary dictionaryWithDictionary:_areaDic[provinceIndex]];
        NSDictionary *dic = [NSDictionary dictionaryWithDictionary:tmp[_selectedProvince]];
        NSArray *dicKeyArray = [dic allKeys];
        NSArray *sortedArray = [dicKeyArray sortedArrayUsingComparator:^(id obj1, id obj2)
        {

            if ([obj1 integerValue] > [obj2 integerValue])
            {
                return (NSComparisonResult) NSOrderedDescending;
            }

            if ([obj1 integerValue] < [obj2 integerValue])
            {
                return (NSComparisonResult) NSOrderedAscending;
            }
            return (NSComparisonResult) NSOrderedSame;
        }];

        NSDictionary *cityDic = [NSDictionary dictionaryWithDictionary:dic[sortedArray[row]]];
        NSArray *cityKeyArray = [cityDic allKeys];

        _district = [[NSArray alloc] initWithArray:cityDic[cityKeyArray[0]]];

    }

}


- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    if (component == PROVINCE_COMPONENT)
    {
        return 80;
    }
    else if (component == CITY_COMPONENT)
    {
        return 100;
    }
    else
    {
        return 115;
    }
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel *myView = nil;

    if (component == PROVINCE_COMPONENT)
    {
        myView = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, 78, 30)];
        myView.textAlignment = NSTextAlignmentCenter;
        myView.text = _province[row];
        myView.font = [UIFont systemFontOfSize:YGFontSizeBigOne];
        myView.textColor = colorWithMainColor;
        myView.backgroundColor = [UIColor clearColor];
    }
    else if (component == CITY_COMPONENT)
    {
        myView = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, 95, 30)];
        myView.textAlignment = NSTextAlignmentCenter;
        myView.text = _city[row];
        myView.font = [UIFont systemFontOfSize:YGFontSizeBigOne];
        myView.textColor = colorWithMainColor;
        myView.backgroundColor = [UIColor clearColor];
    }
    else
    {
        myView = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, 110, 30)];
        myView.textAlignment = NSTextAlignmentCenter;
        myView.text = _district[row];
        myView.font = [UIFont systemFontOfSize:YGFontSizeBigOne];
        myView.textColor = colorWithMainColor;
        myView.backgroundColor = [UIColor clearColor];
    }

    return myView;
}

- (void)selectProvince:(NSString *)province city:(NSString *)city
{
    for (int i = 0; i < _province.count; i++)
    {
        if ([province isEqualToString:_province[i]])
        {
            _selectedProvince = _province[i];
            NSDictionary *cityDic = _areaDic[[NSString stringWithFormat:@"%d", i]][province];
            NSMutableArray *cityArr = [NSMutableArray array];
            for (int i = 0; i < cityDic.count; i++)
            {
                [cityArr addObjectsFromArray:[cityDic[[NSString stringWithFormat:@"%d", i]] allKeys]];
            }
            _city = cityArr;
            [_picker reloadComponent:1];
            [_picker selectRow:i inComponent:0 animated:YES];

            for (int j = 0; j < cityDic.count; j++)
            {
                if ([_city[j] isEqualToString:city])
                {
                    [_picker selectRow:j inComponent:1 animated:YES];
                   
                    break;
                }
            }
            break;
        }
    }
}

@end
