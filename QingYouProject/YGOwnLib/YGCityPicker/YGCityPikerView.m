//
//  YGCityPikerView.m
//  FindingSomething
//
//  Created by apple on 15/12/24.
//  Copyright © 2015年 韩伟. All rights reserved.
//

#import "YGCityPikerView.h"
#import "AppDelegate.h"
#define baseViewHeight 240
@implementation YGCityPikerView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initUI];
    }
    return self;
}
-(void)initUI
{
    self.frame=[UIScreen mainScreen].bounds;
    self.backgroundColor=[[UIColor blackColor]colorWithAlphaComponent:0.0];
    
    UIButton *dismissButton = [[UIButton alloc]initWithFrame:self.frame];
    [dismissButton addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:dismissButton];

    NSBundle *bundle = [NSBundle mainBundle];
    NSString *plistPath = [bundle pathForResource:@"area" ofType:@"plist"];
    _areaDic = [[NSDictionary alloc] initWithContentsOfFile:plistPath];
    
    NSArray *components = [_areaDic allKeys];
    NSArray *sortedArray = [components sortedArrayUsingComparator: ^(id obj1, id obj2) {
        
        if ([obj1 integerValue] > [obj2 integerValue]) {
            return (NSComparisonResult)NSOrderedDescending;
        }
        
        if ([obj1 integerValue] < [obj2 integerValue]) {
            return (NSComparisonResult)NSOrderedAscending;
        }
        return (NSComparisonResult)NSOrderedSame;
    }];
    
    NSMutableArray *provinceTmp = [[NSMutableArray alloc] init];
    for (int i=0; i<[sortedArray count]; i++) {
        NSString *index = [sortedArray objectAtIndex:i];
        NSArray *tmp = [[_areaDic objectForKey: index] allKeys];
        [provinceTmp addObject: [tmp objectAtIndex:0]];
    }
    
    _province = [[NSArray alloc] initWithArray: provinceTmp];
    
    NSString *index = [sortedArray objectAtIndex:0];
    NSString *selected = [_province objectAtIndex:0];
    NSDictionary *dic = [NSDictionary dictionaryWithDictionary: [[_areaDic objectForKey:index]objectForKey:selected]];
    
    NSArray *cityArray = [dic allKeys];
    NSDictionary *cityDic = [NSDictionary dictionaryWithDictionary: [dic objectForKey: [cityArray objectAtIndex:0]]];
    _city = [[NSArray alloc] initWithArray: [cityDic allKeys]];
    
    
    NSString *selectedCity = [_city objectAtIndex: 0];
    _district = [[NSArray alloc] initWithArray: [cityDic objectForKey: selectedCity]];
    
    
    UIView *baseView=[[UIView alloc]initWithFrame:CGRectMake(0, YGScreenHeight - baseViewHeight, YGScreenWidth, baseViewHeight)];
    [self addSubview:baseView];
    baseView.backgroundColor=[UIColor whiteColor];
    self.baseView=baseView;
    
    _selectedProvince = [_province objectAtIndex: 0];
    
    UIView *topBaseView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, YGScreenWidth, 40)];
    [self.baseView addSubview:topBaseView];
    
    UIButton * OkButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [OkButton setTitleColor:colorWithMainColor forState:UIControlStateNormal];
    OkButton.frame = CGRectMake(topBaseView.width-0-40-10, 7, 45, topBaseView.height-14);
    [OkButton setTitle:@"确定" forState:UIControlStateNormal];
    [OkButton addTarget:self action:@selector(yesButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [topBaseView addSubview:OkButton];
    
    UIButton * cancelButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [cancelButton setTitleColor:colorWithLightGray forState:UIControlStateNormal];
    cancelButton.frame = CGRectMake(10,OkButton.y,OkButton.width, OkButton.height);
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    [topBaseView addSubview:cancelButton];
    
    _picker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, topBaseView.y+topBaseView.height, self.width, self.baseView.height-topBaseView.height-topBaseView.y)];
    _picker.dataSource = self;
    _picker.delegate = self;
    _picker.showsSelectionIndicator = YES;
    [_picker selectRow: 0 inComponent: 0 animated: YES];
    [baseView addSubview: _picker];
}

-(void)show
{
    [YGAppDelegate.window addSubview:self];
    _baseView.y = self.height;
    [UIView animateWithDuration:0.25 animations:^{
        _baseView.y = self.height - _baseView.height;
        self.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.5];
    }];
}
-(void)dismiss
{
    [UIView animateWithDuration:0.25 animations:^{
        _baseView.y = YGScreenHeight;
        self.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.5];
    }completion:^(BOOL finished) {
        [self removeFromSuperview];
    } ];
}

-(void)yesButtonClick
{
    NSInteger provinceIndex = [_picker selectedRowInComponent: PROVINCE_COMPONENT];
    NSInteger cityIndex = [_picker selectedRowInComponent: CITY_COMPONENT];
    NSInteger districtIndex = [_picker selectedRowInComponent: DISTRICT_COMPONENT];
    
    NSString *provinceStr = [_province objectAtIndex: provinceIndex];
    NSString *cityStr = [_city objectAtIndex: cityIndex];
    NSString *districtStr = [_district objectAtIndex:districtIndex];
    
    if ([provinceStr isEqualToString: cityStr] && [cityStr isEqualToString: districtStr]) {
        cityStr = @"";
        districtStr = @"";
    }
    else if ([cityStr isEqualToString: districtStr]) {
        districtStr = @"";
    }
    
    
    [self.delegate selectedProvince:provinceStr city:cityStr district:districtStr];
    [self dismiss];
}
-(void)noButtonClick
{
    [self dismiss];
}


#pragma mark- Picker Data Source Methods

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component == PROVINCE_COMPONENT) {
        return [_province count];
    }
    else if (component == CITY_COMPONENT) {
        return [_city count];
    }
    else {
        return [_district count];
    }
}


#pragma mark- Picker Delegate Methods

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (component == PROVINCE_COMPONENT) {
        return [_province objectAtIndex: row];
    }
    else if (component == CITY_COMPONENT) {
        return [_city objectAtIndex: row];
    }
    else {
        return [_district objectAtIndex: row];
    }
}


- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (component == PROVINCE_COMPONENT)
    {
        _selectedProvince = [_province objectAtIndex: row];
        NSDictionary *tmp = [NSDictionary dictionaryWithDictionary: [_areaDic objectForKey: [NSString stringWithFormat:@"%ld", (long)row]]];
        NSDictionary *dic = [NSDictionary dictionaryWithDictionary: [tmp objectForKey:_selectedProvince]];
        NSArray *cityArray = [dic allKeys];
        NSArray *sortedArray = [cityArray sortedArrayUsingComparator: ^(id obj1, id obj2) {
            
            if ([obj1 integerValue] > [obj2 integerValue]) {
                return (NSComparisonResult)NSOrderedDescending;//递减
            }
            
            if ([obj1 integerValue] < [obj2 integerValue]) {
                return (NSComparisonResult)NSOrderedAscending;//上升
            }
            return (NSComparisonResult)NSOrderedSame;
        }];
        
        NSMutableArray *array = [[NSMutableArray alloc] init];
        for (int i=0; i<[sortedArray count]; i++) {
            NSString *index = [sortedArray objectAtIndex:i];
            NSArray *temp = [[dic objectForKey: index] allKeys];
            [array addObject: [temp objectAtIndex:0]];
        }
        
        _city = [[NSArray alloc] initWithArray: array];
        
        NSDictionary *cityDic = [dic objectForKey: [sortedArray objectAtIndex: 0]];
        _district = [[NSArray alloc] initWithArray: [cityDic objectForKey: [_city objectAtIndex: 0]]];
        [_picker selectRow: 0 inComponent: CITY_COMPONENT animated: YES];
        [_picker selectRow: 0 inComponent: DISTRICT_COMPONENT animated: YES];
        [_picker reloadComponent: CITY_COMPONENT];
        [_picker reloadComponent: DISTRICT_COMPONENT];
        
    }
    else if (component == CITY_COMPONENT) {
        NSString *provinceIndex = [NSString stringWithFormat: @"%lu", (unsigned long)[_province indexOfObject: _selectedProvince]];
        NSDictionary *tmp = [NSDictionary dictionaryWithDictionary: [_areaDic objectForKey: provinceIndex]];
        NSDictionary *dic = [NSDictionary dictionaryWithDictionary: [tmp objectForKey: _selectedProvince]];
        NSArray *dicKeyArray = [dic allKeys];
        NSArray *sortedArray = [dicKeyArray sortedArrayUsingComparator: ^(id obj1, id obj2) {
            
            if ([obj1 integerValue] > [obj2 integerValue]) {
                return (NSComparisonResult)NSOrderedDescending;
            }
            
            if ([obj1 integerValue] < [obj2 integerValue]) {
                return (NSComparisonResult)NSOrderedAscending;
            }
            return (NSComparisonResult)NSOrderedSame;
        }];
        
        NSDictionary *cityDic = [NSDictionary dictionaryWithDictionary: [dic objectForKey: [sortedArray objectAtIndex: row]]];
        NSArray *cityKeyArray = [cityDic allKeys];
        
        _district = [[NSArray alloc] initWithArray: [cityDic objectForKey: [cityKeyArray objectAtIndex:0]]];
        [_picker selectRow: 0 inComponent: DISTRICT_COMPONENT animated: YES];
        [_picker reloadComponent: DISTRICT_COMPONENT];
    }
    
}


- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    if (component == PROVINCE_COMPONENT) {
        return 80;
    }
    else if (component == CITY_COMPONENT) {
        return 100;
    }
    else {
        return 115;
    }
}
- (void)setSelectProvince:(NSString *)province city:(NSString *)city district:(NSString *)district
{
    for (int i=0; i<_province.count; i++)
    {
        if ([province isEqualToString:_province[i]])
        {
            _selectedProvince=_province[i];
            NSDictionary *cityDic=_areaDic[[NSString stringWithFormat:@"%d",i]][province];
            NSMutableArray *cityArr = [NSMutableArray array];
            for (int i=0; i<cityDic.count; i++)
            {
                [cityArr addObjectsFromArray:[cityDic[[NSString stringWithFormat:@"%d",i]] allKeys]];
            }
            _city = cityArr;
            [self.picker reloadComponent:1];
            [self.picker selectRow:i inComponent:0 animated:YES];
            
            for (int j=0; j<cityDic.count; j++)
            {
                if ([_city[j] isEqualToString:city])
                {
                    
                    NSArray *disArray=cityDic[[NSString stringWithFormat:@"%d",j]][city];
                    _district=disArray;
                    [self.picker reloadComponent:2];
                    [self.picker selectRow:j inComponent:1 animated:YES];
                    for (int k=0; k<disArray.count; k++)
                    {
                        if ([district isEqualToString:_district[k]])
                        {
                            [self.picker selectRow:k inComponent:2 animated:YES];
                            [self.picker reloadAllComponents];
                            break;
                        }
                    }
                    break;
                }
            }
            break;
        }
    }
}
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel *myView = nil;
    
    if (component == PROVINCE_COMPONENT) {
        myView = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, 78, 30)];
        myView.textAlignment = NSTextAlignmentCenter;
        myView.text = [_province objectAtIndex:row];
        myView.font = [UIFont systemFontOfSize:YGFontSizeBigTwo];
        myView.textColor = colorWithMainColor;
        myView.backgroundColor = [UIColor clearColor];
    }
    else if (component == CITY_COMPONENT) {
        myView = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, 95, 30)];
        myView.textAlignment = NSTextAlignmentCenter;
        myView.text = [_city objectAtIndex:row];
        myView.font = [UIFont systemFontOfSize:YGFontSizeBigTwo];
        myView.textColor = colorWithMainColor;
        myView.backgroundColor = [UIColor clearColor];
    }
    else {
        myView = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, 110, 30)];
        myView.textAlignment = NSTextAlignmentCenter;
        myView.text = [_district objectAtIndex:row];
        myView.font = [UIFont systemFontOfSize:YGFontSizeBigTwo];
        myView.textColor = colorWithMainColor;
        myView.backgroundColor = [UIColor clearColor];
    }
    
    return myView;
}

@end
