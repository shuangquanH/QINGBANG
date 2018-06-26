//
//  YZLAreaPickerView.m
//  knight
//
//  Created by yzl on 17/3/1.
//  Copyright © 2017年 hongdongjie. All rights reserved.
//

#import "YZLAreaPickerView.h"
#import "YZLAreaModel.h"
#import "YZLAreaCacheTool.h"

@interface YZLAreaPickerView()<UITableViewDelegate, UITableViewDataSource>
{
    NSArray *_cityArr;
    NSArray *_countyArr;
    
    YZLAreaModel *_provinceInfo;
    YZLAreaModel *_cityInfo;
    YZLAreaModel *_countyInfo;
}
@property (nonatomic, strong) UITableView *provinceTableView;
@property (nonatomic, strong) UITableView *cityTableView;
@property (nonatomic, strong) UITableView *countyTableView;

@property (nonatomic, strong) NSMutableArray *serverAreaArr;//区域选择区数组
@property (nonatomic, strong) NSMutableArray *serviceCityArr;//区域选择市数组
@end

static NSString *areaCell = @"areaCell";

@implementation YZLAreaPickerView {
    NSDictionary *_limitDic;
}

#pragma mark - lazy load
- (UITableView *)provinceTableView {
    if (!_provinceTableView) {
        _provinceTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, (self.frame.size.width - 1) / 2, self.frame.size.height)];
        _provinceTableView.delegate = self;
        _provinceTableView.dataSource = self;
        _provinceTableView.backgroundColor = [UIColor whiteColor];
        [_provinceTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:areaCell];
        _provinceTableView.showsVerticalScrollIndicator = NO;
        [_provinceTableView setSeparatorInset:UIEdgeInsetsZero];
        _provinceTableView.tableFooterView = [[UIView alloc] init];
        [self addSubview:_provinceTableView];
    }
    return _provinceTableView;
}
- (UITableView *)cityTableView {
    if (!_cityTableView) {
        _cityTableView = [[UITableView alloc] initWithFrame:CGRectMake((self.frame.size.width - 1) / 2 + 1, 0, (self.frame.size.width - 1) / 2 , self.frame.size.height)];
        _cityTableView.delegate = self;
        _cityTableView.dataSource = self;
        [_cityTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:areaCell];
        _cityTableView.backgroundColor = [UIColor whiteColor];
        _cityTableView.showsVerticalScrollIndicator = NO;
        [_cityTableView setSeparatorInset:UIEdgeInsetsZero];
        _cityTableView.tableFooterView = [[UIView alloc] init];
        [self addSubview:_cityTableView];
    }
    return _cityTableView;
}
- (UITableView *)countyTableView {
    if (!_countyTableView) {
//        _countyTableView = [[UITableView alloc] initWithFrame:CGRectMake(self.frame.size.width / 3 * 2 + 1, 0, (self.frame.size.width - 1) / 3 , self.frame.size.height)];
//        _countyTableView.backgroundColor = [UIColor whiteColor];
//        _countyTableView.delegate = self;
//        _countyTableView.dataSource = self;
//        [_countyTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:areaCell];
//        _countyTableView.showsVerticalScrollIndicator = NO;
//        [_countyTableView setSeparatorInset:UIEdgeInsetsZero];
//        _countyTableView.tableFooterView = [[UIView alloc] init];
//        [self addSubview:_countyTableView];
    }
    return _countyTableView;
}

- (NSMutableArray *)serverAreaArr {
    if (!_serverAreaArr) {
        _serverAreaArr = [NSMutableArray array];
    }
    return _serverAreaArr;
}
- (NSMutableArray *)serviceCityArr {
    if (!_serviceCityArr) {
        _serviceCityArr = [NSMutableArray array];
    }
    return _serviceCityArr;
}
- (NSMutableArray *)serviceProvinceArr {
    if (!_serviceProvinceArr) {
        _serviceProvinceArr = [NSMutableArray array];
    }
    return _serviceProvinceArr;
}
//
//- (void)setInvoceAddress:(ManageMailPostModel *)invoceAddress {
//    _invoceAddress = invoceAddress;
//    
//    //清空记录
//    _provinceInfo = nil;
//    _countyInfo = nil;
//    _cityInfo = nil;
//    _cityArr = nil;
//    _countyArr = nil;
//    //遍历
//    if (invoceAddress != nil && self.provinceArr != nil) {
//        for (YZLAreaModel *province in self.provinceArr) {
//            if (province.ID == invoceAddress.provId) {
//                _provinceInfo = province;
//                _cityArr = province.sons;
//                for (YZLAreaModel *city in province.sons) {
//                    if (city.ID == invoceAddress.cityId) {
//                        _cityInfo = city;
//                        _countyArr = city.sons;
//                        for (YZLAreaModel *county in city.sons) {
//                            if (county.ID == invoceAddress.distId) {
//                                _countyInfo = county;
//                                break;
//                            }
//                        }
//                    }
//                }
//            }
//        }
//    }
//    
//    [self.provinceTableView reloadData];
//    [self.cityTableView reloadData];
//    [self.countyTableView reloadData];
//    
//    
//    if (_provinceArr && _provinceInfo) {
//        [self.provinceTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[_provinceArr indexOfObject:_provinceInfo] inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
//    }
//    
//    if (_cityArr && _cityInfo) {
//        [self.cityTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[_cityArr indexOfObject:_cityInfo] inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
//    }
//    if (_countyArr && _countyInfo) {
//        [self.countyTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[_countyArr indexOfObject:_countyInfo] inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
//    }
//}

//- (void)setRouteArr:(NSArray<YZLDriverRouteModel *> *)routeArr {
//    if (_provinceArr == nil) {
//        return;
//    }
//    
//    //仅仅是第一次时会使用，所以需要判断serviceProvinceArr
//    if ((routeArr != nil || routeArr.count > 0) && self.serviceProvinceArr.count == 0) {
//        NSMutableArray *routeArrs = [NSMutableArray arrayWithArray:routeArr];
////        [routeArrs removeLastObject];
////        [routeArrs removeObject:routeArrs.firstObject];
//        
//        NSMutableArray *selectProvinces = [NSMutableArray array];
//        for (YZLAreaModel *provin in self.provinceArr) {
//            for (YZLDriverRouteModel *route in routeArrs) {
//                if ([route.province_id integerValue] == provin.ID && ![selectProvinces containsObject:provin]) {
//                    [selectProvinces addObject:provin];
//                    [self.serviceProvinceArr addObject:provin];
//                }
//            }
//        }
//        
//        NSMutableArray *selectCitys = [NSMutableArray array];
//        for (YZLAreaModel *province in selectProvinces) {
//            NSInteger provinceSelectCount = 0;
//            for (YZLAreaModel *city in province.sonList) {
//                for (YZLDriverRouteModel *route in routeArrs) {
//                    if ([route.city_id integerValue] == city.ID && ![selectCitys containsObject:city]) {
//                        [selectCitys addObject:city];
//                        provinceSelectCount += 1;
//                    }
//                }
//            }
//            
//            if (provinceSelectCount == 0 && province.sonList.count > 0) {//选中了2级不限
//                provinceSelectCount = 1;
//                [province.sonList insertObject:[self limitAreaModelWithLevel:2] atIndex:0];
//                province.sonList.firstObject.selectCount = 1;
//            }
//            
//            province.selectCount = provinceSelectCount;
//        }
//        
//        for (YZLAreaModel *city in selectCitys) {
//            NSInteger citySelectCount = 0;
//            for (YZLAreaModel *county in city.sonList) {
//                for (YZLDriverRouteModel *route in routeArrs) {
//                    if ([route.county_id integerValue] == county.ID) {
//                        county.selectCount = 1;
//                        citySelectCount += 1;
//                    }
//                }
//            }
//            
//            if (citySelectCount == 0 && city.sonList.count > 0) {//选中了3级不限
//                citySelectCount = 1;
//                [city.sonList insertObject:[self limitAreaModelWithLevel:3] atIndex:0];
//                city.sonList.firstObject.selectCount = 1;
//            }
//            city.selectCount = citySelectCount;
//        }
//    }
//    
//    [self.provinceTableView reloadData];
//    [self.cityTableView reloadData];
//    [self.countyTableView reloadData];
//}

- (void)setProvinceArr:(NSArray<YZLAreaModel *> *)provinceArr {
    //外部传入之前选择的区域信息，与数据源进行比对，替换掉数据源中与之前选择的区域相同的地址信息，生成新的数据源，即可实现页面加载时能重新展示之前所选择的区域信息。
    
    _provinceArr = provinceArr;
    _cityArr = provinceArr.firstObject.sons;
    [self.provinceTableView reloadData];
    [self.cityTableView reloadData];
    
    //_limitDic = [USER_DEFAULT objectForKey:Area_Limit_Data];
    
//    if (self.isService && self.serviceProvinceArr.count > 0) {
//        NSMutableArray *tempProvinceArr = [NSMutableArray arrayWithArray:provinceArr];
//        NSInteger count = 0;
//        for (YZLAreaModel *serverArea in self.serviceProvinceArr) {
//            for (int i = 0; i < tempProvinceArr.count; i++) {
//                YZLAreaModel *sourceArea = tempProvinceArr[i];
//                count ++;
//                if ([serverArea.name isEqualToString:sourceArea.name]) {
//                    [tempProvinceArr replaceObjectAtIndex:i withObject:serverArea];
//                    continue;
//                }
//            }
//        }
//        _provinceArr = tempProvinceArr;
//        YZLAreaModel *provinceInfo = self.serviceProvinceArr.firstObject;
//        _cityArr = provinceInfo.sons;
//        for (YZLAreaModel *tempCityInfo in _cityArr) {
//            if (tempCityInfo.selectCount > 0) {
//                _countyArr = tempCityInfo.sons;
//                _cityInfo = tempCityInfo;
//                break;
//            }
//        }
//        _provinceInfo = provinceInfo;
//    } else {
//
//        if (_provinceArr == nil && self.areaPickerType == YZLAreaPickerTypeCountryAndLimit) {//添加全国组
//            YZLAreaModel *limitProvinceInfo = [YZLAreaModel new];
//            limitProvinceInfo.level = 1;
//            limitProvinceInfo.ID = -100;
//            limitProvinceInfo.name = @"全国";
//
//            NSMutableArray *tmpProvinceArr = [NSMutableArray arrayWithArray:provinceArr];
//            [tmpProvinceArr insertObject:limitProvinceInfo atIndex:0];
//            provinceArr = [NSArray arrayWithArray:tmpProvinceArr];
//        }
//
//        if (_provinceArr == nil && self.areaPickerType == YZLAreaPickerTypeLimit) {//给第一组添加不限
//            YZLAreaModel *province = provinceArr.firstObject;
//
//            YZLAreaModel *limitCityInfo = [YZLAreaModel new];
//            limitCityInfo.level = 2;
//            limitCityInfo.ID = -100;
//            limitCityInfo.name = @"不限";
//
//            [province.sons insertObject:limitCityInfo atIndex:0];
//        }
//
//        _provinceArr = provinceArr;
//        YZLAreaModel *provinceInfo = _provinceArr.firstObject;
//
//        _cityArr = provinceInfo.sons;
//        YZLAreaModel *cityInfo = _cityArr.firstObject;
//
//        _countyArr = cityInfo.sons;
//    }
//    [self.provinceTableView reloadData];
//    [self.countyTableView reloadData];
//    [self.cityTableView reloadData];
}

- (void)setIsService:(BOOL)isService {
    _isService = isService;
    if (isService) {
        self.serviceCityArr = [NSMutableArray array];
    }
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        self.frame = frame;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.provinceTableView.frame = CGRectMake(0, 0, (self.frame.size.width - 1) / 2, self.frame.size.height);
    self.cityTableView.frame = CGRectMake((self.frame.size.width - 1) / 2 + 1, 0, (self.frame.size.width - 1) / 2 , self.frame.size.height);
    
//    self.countyTableView.frame = CGRectMake(self.frame.size.width / 3 * 2 + 1, 0, (self.frame.size.width - 1) / 3 , self.frame.size.height);

}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.provinceTableView) {
        return self.provinceArr.count;
    }
    if (tableView == self.cityTableView) {
        return _cityArr.count;
    }
    return _countyArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:areaCell];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.textLabel.font = [UIFont systemFontOfSize:13];
    
    YZLAreaModel *tempArea;
    if (tableView == self.provinceTableView) {
        tempArea = _provinceArr[indexPath.row];
    } else if (tableView == self.cityTableView) {
        tempArea = _cityArr[indexPath.row];
    } else {
        tempArea = _countyArr[indexPath.row];
        cell.backgroundColor = kCOLOR_RGB(241, 242, 243);
    }

    if (tempArea == _provinceInfo || tempArea == _cityInfo || tempArea == _countyInfo) {
        cell.textLabel.textColor = KCOLOR_MAIN;
        cell.backgroundColor = kCOLOR_RGB(241, 242, 243);
    } else {
        cell.textLabel.textColor = [UIColor blackColor];
        if (tableView != self.countyTableView) {
            cell.backgroundColor = [UIColor whiteColor];
        }
    }
    
    if (self.isService) {
        if (tempArea.selectCount > 0) {
            if (tableView == self.countyTableView) {
                cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"me_check_icon"]];
                cell.textLabel.textColor = KCOLOR_MAIN;
            } else {
                UILabel *countLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 17, 17)];
                countLabel.backgroundColor = KCOLOR_MAIN;
                countLabel.layer.cornerRadius = 8.5;
                countLabel.clipsToBounds = YES;
                countLabel.textColor = [UIColor whiteColor];
                countLabel.text = [NSString stringWithFormat:@"%ld",tempArea.selectCount];
                countLabel.textAlignment = NSTextAlignmentCenter;
                countLabel.font = [UIFont systemFontOfSize:5];
                cell.accessoryView = countLabel;
            }
        } else {
            if (tableView == self.countyTableView) {
                cell.textLabel.textColor = [UIColor blackColor];
            }
            cell.accessoryView = nil;
        }
    }
    
    cell.textLabel.text = tempArea.name;
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //点击省
    if (tableView == self.provinceTableView) {
        
        YZLAreaModel *provinceInfo = self.provinceArr[indexPath.row];
        if (_provinceInfo != provinceInfo) {
            _cityInfo = nil;
            _countyInfo = nil;
        }
        
        if (self.serviceProvinceArr.count == [_limitDic[@"province"] integerValue] && provinceInfo.selectCount == 0 && self.isService) {
//            ProgressInfo(@"您选择的可服务省级区域已达到上限，如果需要继续选择请先清除之前的省级区域。")
            return;
        }
        
        _provinceInfo = provinceInfo;
        
        if (self.areaPickerType != YZLAreaPickerTypeBase) {//添加不限2级模型
            if (![_provinceInfo.sons.firstObject.name isEqualToString:@"不限"] && _provinceInfo.sons.count > 0) {
                [_provinceInfo.sons insertObject:[self limitAreaModelWithLevel:2] atIndex:0];
            }
        }
        
        _cityArr = _provinceInfo.sons;
        YZLAreaModel *cityInfo = _cityArr.firstObject;
        _countyArr = cityInfo.sons;
        
        [self handleSelectCountWithArr:@[_provinceInfo] isUp:(_provinceInfo.selectCount == 0)];
        return;
    }
    //点击市
    if (tableView == self.cityTableView) {
        YZLAreaModel *cityInfo = _cityArr[indexPath.row];
        if (_cityInfo != cityInfo) {
            _countyInfo = nil;
        }
        if (self.areaPickerType != YZLAreaPickerTypeBase && indexPath.row == 0 && self.isService && cityInfo.selectCount == 0) {//点击不限，将_cityArr内模型selectedCount清0，将_cityArr.sonlist内模型selectedCount清0，将_provinceInfo的selectCount设为1
            [self clearSelectCountWithSonList:self.serviceCityArr withCurAreaModel:cityInfo];
            _countyArr = cityInfo.sons;
            _cityInfo = cityInfo;
            [self.provinceTableView reloadData];
            [self.cityTableView reloadData];
            [self.countyTableView reloadData];
            return;
        }
        
        if (self.serviceCityArr.count == [_limitDic[@"city"] integerValue] && cityInfo.selectCount == 0 && self.isService) {
//            ProgressInfo(@"您选择的可服务市级区域已达到上限，如果需要继续选择请先清除之前的市级区域。")
            return;
        }
        _cityInfo = cityInfo;
        
        if (self.areaPickerType != YZLAreaPickerTypeBase) {//添加不限3级模型
            if (![_cityInfo.sons.firstObject.name isEqualToString:@"不限"] && _cityInfo.sons.count > 0) {
                [_cityInfo.sons insertObject:[self limitAreaModelWithLevel:3] atIndex:0];
            }
        }
        _countyArr = _cityInfo.sons;
        if (!_provinceInfo) {
            _provinceInfo = _provinceArr.firstObject;
        }

        [self handleSelectCountWithArr:@[_provinceInfo, _cityInfo] isUp:(_cityInfo.selectCount == 0)];
            
        YZLAreaModel *limitModel = _cityArr.firstObject;
        if (limitModel.selectCount > 0) {
            [self handleSelectCountWithArr:@[_provinceInfo, limitModel] isUp:(limitModel.selectCount == 0)];
        }
        
        return;
    }
    //点击区
    if (tableView == self.countyTableView) {
        YZLAreaModel *countyInfo = _countyArr[indexPath.row];
        if (self.areaPickerType != YZLAreaPickerTypeBase && indexPath.row == 0 && countyInfo.selectCount == 0 && self.isService) {//点击不限，将_countyArr内模型selectedCount清0，将_cityInfo的selectCount设为1
            [self clearSelectCountWithSonList:self.serverAreaArr withCurAreaModel:countyInfo];
            _countyInfo = countyInfo;
            [self.provinceTableView reloadData];
            [self.cityTableView reloadData];
            [self.countyTableView reloadData];
            return;
        }
        
        if (self.serverAreaArr.count == [_limitDic[@"county"] integerValue] && countyInfo.selectCount == 0 && self.isService) {
//            ProgressInfo(@"您选择的可服务区级区域已达到上限，如果需要继续选择请先清除之前的区级区域。")
            return;
        }
        _countyInfo = countyInfo;
        
        if (!_provinceInfo) {
            _provinceInfo = _provinceArr.firstObject;
        }
        
        if (!_cityInfo) {
            _cityInfo = _provinceInfo.sons.firstObject;
        }
        
        [self handleSelectCountWithArr:@[_provinceInfo, _cityInfo, _countyInfo]  isUp:(_countyInfo.selectCount == 0)];
            
        YZLAreaModel *limitModel = _countyArr.firstObject;
        if (limitModel.selectCount > 0) {
            [self handleSelectCountWithArr:@[_provinceInfo, _cityInfo, limitModel]  isUp:(limitModel.selectCount == 0)];
        }
        return;
    }
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
}

- (void)handleSelectCountWithArr:(NSArray *)services isUp:(BOOL)up {
    YZLAreaModel *temp = services.lastObject;
    if (self.isService && (temp.sons == nil || temp.sons.count == 0 || temp.level == 3)) {
        NSArray *serviceArr = @[self.serviceProvinceArr, self.serviceCityArr, self.serverAreaArr];
        for (NSInteger i = services.count - 1; i >= 0; i--) {
            YZLAreaModel *Area = services[i];
            if (up) {//添加记录
                Area.selectCount += 1;
                if (Area.selectCount == 1) {//+1后等于1，说明是添加
                    NSMutableArray *arr = serviceArr[i];
                    [arr addObject:Area];
                } else {
                    break;
                }
            } else {//删除记录
                Area.selectCount -= 1;
                if (Area.selectCount == 0) {//-1后为0，说明是删除
                    NSMutableArray *arr = serviceArr[i];
                    [arr removeObject:Area];
                } else {
                    break;
                }
            }
        }
    }
    
    [self rebackAreaWithAreaModel:temp];
    [self.provinceTableView reloadData];
    [self.cityTableView reloadData];
    [self.countyTableView reloadData];
}

- (void)clearSelectCountWithSonList:(NSMutableArray *)sonList withCurAreaModel:(YZLAreaModel *)areaModel {

    if (sonList == self.serviceCityArr) {//点击二级不限，清除当前
        for (YZLAreaModel *cityModel in _cityArr) {
            if (cityModel.selectCount > 0) {
                cityModel.selectCount = 0;
                for (YZLAreaModel *countyModel in cityModel.sons) {
                    if (countyModel.selectCount > 0) {
                        countyModel.selectCount = 0;
                        [self.serverAreaArr removeObject:countyModel];
                    }
                }
                [self.serviceCityArr removeObject:cityModel];
            }
        }
        if (_provinceInfo.selectCount == 0) {
            _provinceInfo.selectCount = 1;
            [self.serviceProvinceArr addObject:_provinceInfo];
        }
        
    } else {
        for (YZLAreaModel *countyModel in _countyArr) {
            if (countyModel.selectCount > 0) {//改county为选中county
                countyModel.selectCount = 0;
                [self.serverAreaArr removeObject:countyModel];
            }
        }
        
        if (_cityInfo.selectCount == 0) {
            _provinceInfo.selectCount += 1;
            if (_provinceInfo.selectCount == 1) {
                [self.serviceProvinceArr addObject:_provinceInfo];
            }
            [self.serviceCityArr removeObject:_cityInfo];
        }
        _cityInfo.selectCount = 1;
    }
    areaModel.selectCount = 1;
    [sonList addObject:areaModel];
}

- (YZLAreaModel *)limitAreaModelWithLevel:(NSInteger)level {
    YZLAreaModel *limitAreaModel = [YZLAreaModel new];
    limitAreaModel.name = @"不限";
    limitAreaModel.level = level;
    limitAreaModel.ID = -100;
    limitAreaModel.sons = [NSMutableArray array];
    return limitAreaModel;
}

- (void)rebackAreaWithAreaModel:(YZLAreaModel *)temp {
    if (temp.sons == nil || temp.sons.count == 0 || temp.level == 3) {
//        DLog(@"选择区域------%@ %@ %@", _provinceInfo.name, _cityInfo.name, _countyInfo.name);
        if (self.areaBlock) {
            NSDictionary *areaDic = @{@"province": _provinceInfo?@(_provinceInfo.ID):@(-100),
                                      @"city": _cityInfo?@(_cityInfo.ID):@(-100),
                                      @"county": _countyInfo?@(_countyInfo.ID):@(-100),
                                      @"province_name": _provinceInfo?_provinceInfo.name:@"",
                                      @"city_name": _cityInfo?_cityInfo.name:@"",
                                      @"county_name":_countyInfo?_countyInfo.name:@""};
            self.areaBlock(areaDic);
        }
    }
}

- (void)selectAdress:(areaPickerBlock)address {
    if (_countyInfo || (_cityInfo.sons.count == 0 && _cityInfo) || _provinceInfo.sons.count == 0) {
        if (address) {
            
            
            
            NSDictionary *areaDic = @{@"province": _provinceInfo?_provinceInfo:[YZLAreaModel new],
                                      @"city": _cityInfo?_cityInfo:[YZLAreaModel new],
                                      @"county": _countyInfo?_countyInfo:[YZLAreaModel new]};
            [YZLAreaCacheTool querySelectAreaIDWithDict:areaDic completed:^(NSDictionary *dict) {
                address(dict);
            }];
        }
    }
}

@end
