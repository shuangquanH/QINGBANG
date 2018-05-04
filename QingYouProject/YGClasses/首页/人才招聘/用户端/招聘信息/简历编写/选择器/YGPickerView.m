//
//  YGPickerView.m
//
//  Created by 张楷枫 on 16/3/4.
//  Copyright © 2016年 ccyouge. All rights reserved.
//

#import "YGPickerView.h"

#define baseViewHeight YGScreenHeight/3.0

@implementation YGPickerView
{
    void(^_handler)(NSInteger selectedRow, NSString *selectedString);

    UIView *_baseView;
    UIPickerView *_pickerView;
}

+ (instancetype)showWithPickerViewDataSource:(NSArray *)pickerViewDataSource titleString:(NSString *)titleString handler:(void (^)(NSInteger selectedRow, NSString *selectedString))handler
{
    YGPickerView *pickerView = [[YGPickerView alloc] initWithPickerViewDataSource:pickerViewDataSource titleString:titleString handler:handler];
    [pickerView show];
    return pickerView;
}

- (instancetype)initWithPickerViewDataSource:(NSArray *)pickerViewDataSource titleString:(NSString *)titleString handler:(void (^)(NSInteger selectedRow, NSString *selectedString))handler
{
    self = [super init];
    if (self)
    {
        self.hidden = YES;
        self.frame = CGRectMake(0, 0, YGScreenWidth, YGScreenHeight);
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];
        _titleString = titleString;
        _pickerViewDataSource = pickerViewDataSource;
        _handler = handler;
        [self configUI];
    }
    return self;
}

- (void)configUI
{
    UIButton *dismissBigButton = [[UIButton alloc] initWithFrame:self.frame];
    [dismissBigButton addTarget:self action:@selector(dismissBtnClick) forControlEvents:UIControlEventTouchDown];
    [self addSubview:dismissBigButton];

    _baseView = [[UIView alloc] initWithFrame:CGRectMake(0, self.height, self.width, baseViewHeight)];
    _baseView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_baseView];

    UIView *topBaseView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, YGScreenWidth, 40)];
    [_baseView addSubview:topBaseView];


    UIButton *OkButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [OkButton setTitleColor:colorWithMainColor forState:UIControlStateNormal];
    OkButton.frame = CGRectMake(topBaseView.width - 0 - 40 - 10, 7, 45, topBaseView.height - 14);
    [OkButton setTitle:@"确定" forState:UIControlStateNormal];
    [OkButton addTarget:self action:@selector(OkButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [topBaseView addSubview:OkButton];

    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [cancelButton setTitleColor:colorWithLightGray forState:UIControlStateNormal];
    cancelButton.frame = CGRectMake(10, OkButton.y, OkButton.width, OkButton.height);
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(dismissBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [topBaseView addSubview:cancelButton];

    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.font = [UIFont systemFontOfSize:YGFontSizeNormal];
    titleLabel.text = _titleString;
    titleLabel.textColor = colorWithBlack;
    [topBaseView addSubview:titleLabel];

    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make)
    {
        make.centerX.centerY.mas_equalTo(topBaseView);
    }];

    _pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, topBaseView.y + topBaseView.height, self.width, _baseView.height - topBaseView.height - topBaseView.y)];
    _pickerView.dataSource = self;
    _pickerView.delegate = self;
    [_baseView addSubview:_pickerView];


}

- (void)OkButtonClick
{
    [self dismiss];

    if (_handler)
    {
        _handler([_pickerView selectedRowInComponent:0], _pickerViewDataSource[[_pickerView selectedRowInComponent:0]]);
        _handler = nil;
    }
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return _pickerViewDataSource.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return _pickerViewDataSource[row];
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel *myView = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, YGScreenWidth, 30)];
    myView.textAlignment = NSTextAlignmentCenter;
    myView.text = _pickerViewDataSource[row];
    myView.font = [UIFont systemFontOfSize:YGFontSizeBigTwo];
    myView.textColor = colorWithMainColor;
    myView.backgroundColor = [UIColor clearColor];
    return myView;
}

- (void)selectWithTitleString:(NSString *)titleString
{
    if ([titleString isEqualToString:@""])
    {
        return;
    }
    int i = 0;
    for (NSString *title in _pickerViewDataSource)
    {
        if ([titleString isEqualToString:title])
        {
            [_pickerView selectRow:i inComponent:0 animated:YES];
            break;
        }
        i++;
    }
}

- (void)selectWithRow:(NSInteger)row
{
    [_pickerView selectRow:row inComponent:0 animated:YES];
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

- (void)dismissBtnClick
{
    [self dismiss];
}

@end
