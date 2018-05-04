//
//  ApplySetupViewController.m
//  QingYouProject
//
//  Created by zhaoao on 2017/11/15.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "ApplySetupViewController.h"
#import "AllowRecommendCell.h"
#import "ApplySetupCell.h"
#import <IQUIView+IQKeyboardToolbar.h>

#define NMUBERS @"0123456789./*-+~!@#$%^&()_+-=,./;'[]{}:<>?`"

@interface ApplySetupViewController () <UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_tableView;
}
@property(nonatomic,strong)NSMutableArray *dataArray;//行的数据
@property(nonatomic,strong)NSMutableArray *dataBoobleArray;//记录是否是必选 1:必选 0:非必选
@property(nonatomic,strong)UITextField *customTextField;
@property(nonatomic,strong)UIDatePicker *datePicker;
@property(nonatomic,strong)NSString *selectTimeString; //选择的时间的字符串
@property(nonatomic,strong)UIView *blackView; //黑色透明遮罩
@property(nonatomic,strong)UIView *dateView; //弹出选择日期的view
@property(nonatomic,strong)UIButton *confirmButton;//选择日期view上面的确定按钮
@property(nonatomic,strong)UIButton *cancelButton;//选择日期view上面的取消按钮
@property(nonatomic,strong)NSMutableArray *commonInfoAray;//常用信息数据源

@end

@implementation ApplySetupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.naviTitle = @"报名设置";
    
    //关闭侧滑返回手势
    [self setFd_interactivePopDisabled:YES];
    
    UIButton *submitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    submitButton.frame = CGRectMake(0, 0, 35, 35);
    [submitButton setTitleColor:colorWithMainColor forState:UIControlStateNormal];
    [submitButton setTitle:@"完成" forState:normal];
    submitButton.titleLabel.font = [UIFont systemFontOfSize:15.0];
    [submitButton addTarget:self action:@selector(submitInfo:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightButtonItem = [[UIBarButtonItem alloc] initWithCustomView:submitButton];
    self.navigationItem.rightBarButtonItem = rightButtonItem;
    
    self.dataArray = [NSMutableArray arrayWithObjects:@{@"customName":@"姓名",@"isCheck":@"1"},@{@"customName":@"手机",@"isCheck":@"1"}, nil];
    if(!self.selectEndTimeString.length)
    {
        self.selectTimeString = @"活动结束前均可报名";
    }
    else
    {
        self.selectTimeString = [NSString stringWithFormat:@"%@之前均可报名",self.selectEndTimeString];
        self.dataArray = self.selectArray;
    }
    self.commonInfoAray = [NSMutableArray array];
    
    self.blackView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, YGScreenWidth, YGScreenHeight)];
    self.blackView.backgroundColor = [UIColor colorWithWhite:0.f alpha:0.5];
    
    [self configUI];
}

-(void)configUI
{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, YGScreenWidth, YGScreenHeight - YGStatusBarHeight - YGNaviBarHeight) style:UITableViewStyleGrouped];
    _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, YGScreenWidth, 0.001)];
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, YGScreenWidth, 0.001)];
    _tableView.sectionHeaderHeight = 0.001;
    _tableView.sectionFooterHeight = 0.001;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    [self loadData];
//    [self configFooterView];
}

-(void)loadData
{
    [YGNetService YGPOST:@"getActiveMessage" parameters:@{@"total":@"0",@"count":@"10"} showLoadingView:YES scrollView:_tableView success:^(id responseObject) {
        
        NSLog(@"%@",responseObject);
        
        NSMutableArray *listArray = responseObject[@"mList"];
        for (int i = 0; i < listArray.count; i++) {
            [self.commonInfoAray addObject:[listArray[i] valueForKey:@"messageName"]];
        }
        
        NSLog(@"%@",self.commonInfoAray);
        
        [self configFooterView];
        
        
        
        [_tableView reloadData];
        
    } failure:^(NSError *error) {
        
    }];
}

-(void)configFooterView
{
    UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, YGScreenWidth, YGScreenWidth * 0.46 + 10)];
    footerView.backgroundColor = [UIColor whiteColor];
    UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, YGScreenWidth - 30, 30)];
    nameLabel.textColor = colorWithDeepGray;
    nameLabel.text = @"常用信息 (可多选)";
    nameLabel.font = [UIFont systemFontOfSize:15.0];
    [footerView addSubview:nameLabel];
    
    UIView *labelView = [self text];
    UIView *bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, 30, YGScreenWidth, 100)];
    bottomView.frame = CGRectMake(0, 30, YGScreenWidth, labelView.height);
    [bottomView addSubview:labelView];
    [footerView addSubview:bottomView];
    
    self.customTextField = [[UITextField alloc]initWithFrame:CGRectMake(15, 30 + bottomView.height, YGScreenWidth - 30, YGScreenWidth * 0.46 - bottomView.height - 30)];
    self.customTextField.placeholder = @"自定义填写";
    self.customTextField.textColor = colorWithDeepGray;
    self.customTextField.font = [UIFont systemFontOfSize:14.0];
    [self.customTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self.customTextField addPreviousNextDoneOnKeyboardWithTarget:self previousAction:nil nextAction:nil doneAction:@selector(customDone)];
    [footerView addSubview:self.customTextField];
    
    _tableView.tableFooterView = footerView;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0)
    {
//        AllowRecommendCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AllowRecommendCell"];
//        if (!cell) {
//            cell = [[[NSBundle mainBundle]loadNibNamed:@"AllowRecommendCell" owner:self options:nil] firstObject];
//            cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        }
//        cell.questionButton.hidden = YES;
//        cell.nameLabel.text = @"活动结束前均可报名";
//        return cell;
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.textLabel.font = [UIFont systemFontOfSize:15.0];
        cell.textLabel.textColor = colorWithBlack;
        cell.textLabel.text = @"报名截止";
        cell.detailTextLabel.text = self.selectTimeString;
        cell.detailTextLabel.font = [UIFont systemFontOfSize:15.0];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        return cell;
    }
    else
    {
        if(indexPath.row == 0 || indexPath.row == 1)
        {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
            if (!cell) {
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            cell.textLabel.font = [UIFont systemFontOfSize:15.0];
            cell.textLabel.textColor = colorWithDeepGray;
            cell.textLabel.text = [self.dataArray[indexPath.row] valueForKey:@"customName"];
            return cell;
        }
        else
        {
            ApplySetupCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ApplySetupCell"];
            if (!cell) {
                cell = [[[NSBundle mainBundle]loadNibNamed:@"ApplySetupCell" owner:self options:nil] firstObject];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            cell.nameLabel.text = [self.dataArray[indexPath.row] valueForKey:@"customName"];
            if([[self.dataArray[indexPath.row] valueForKey:@"isCheck"] isEqualToString:@"1"])
            {
                cell.optionButton.selected = YES;
            }else
            {
                cell.optionButton.selected = NO;
            }
            [cell.optionButton addTarget:self action:@selector(optionButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            cell.optionButton.tag = indexPath.row;
            cell.removeButton.tag = indexPath.row;
            [cell.removeButton addTarget:self action:@selector(removeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            return cell;
        }
        
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0)
    {
        return 1;
    }
    return self.dataArray.count;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, YGScreenWidth, 30)];
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, YGScreenWidth - 30, 30)];
    titleLabel.font = [UIFont systemFontOfSize:14.0];
    titleLabel.textColor = colorWithDeepGray;
    if (section == 0) {
        titleLabel.text = @"设置报名截止时间";
    }else
    {
        titleLabel.text = @"设置用户报名时的填写信息";
    }
    [view addSubview:titleLabel];
    return view;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        [self.view addSubview:self.blackView];

        self.datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, YGScreenHeight - 250,YGScreenWidth, 250)];
        self.datePicker.backgroundColor = [UIColor whiteColor];
        //设置本地化支持的语言（在此是中文)
        self.datePicker.locale = [NSLocale localeWithLocaleIdentifier:@"zh"];
        
        self.datePicker.datePickerMode = UIDatePickerModeDateAndTime;
        NSDate *minDate = [self.datePicker date];        // 获取当前时间作为最大显示时间
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
        self.datePicker.minimumDate = minDate;       // picker中最小时间
        
        NSDate *maxDate = [dateFormatter dateFromString:self.endTimeString];
        self.datePicker.maximumDate = maxDate;
        
        [self.datePicker addTarget:self action:@selector(chooseTime:) forControlEvents:UIControlEventValueChanged];
        self.dateView = [[UIView alloc]init];
        self.dateView.backgroundColor = [UIColor whiteColor];
        self.dateView.frame = CGRectMake(0, YGScreenHeight - 290, YGScreenWidth, 40);
        
        
        self.cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.cancelButton.frame = CGRectMake(0, 0, 60, 40);
        [self.cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        self.cancelButton.titleLabel.font = [UIFont systemFontOfSize:15.0];
        [self.cancelButton setTitleColor:colorWithDeepGray forState:UIControlStateNormal];
        [self.cancelButton addTarget:self action:@selector(cancelButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(60, 0, YGScreenWidth - 120, 40)];
        nameLabel.text = @"报名截止时间";
        nameLabel.font = [UIFont systemFontOfSize:16.0];
        nameLabel.textColor = colorWithDeepGray;
        nameLabel.textAlignment = NSTextAlignmentCenter;
        
        self.confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.confirmButton.frame = CGRectMake(YGScreenWidth - 60, 0, 60, 40);
        [self.confirmButton setTitle:@"确定" forState:UIControlStateNormal];
        self.confirmButton.titleLabel.font = [UIFont systemFontOfSize:15.0];
        [self.confirmButton setTitleColor:colorWithDeepGray forState:UIControlStateNormal];
        [self.confirmButton addTarget:self action:@selector(confirmButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.dateView addSubview:self.cancelButton];
        [self.dateView addSubview:nameLabel];
        [self.dateView addSubview:self.confirmButton];
        
        [self.blackView addSubview:self.dateView];
        [self.blackView addSubview:self.datePicker];
    }
}

//时间选择器改变的时候
-(void)chooseTime:(UIDatePicker *)datePicker
{
    NSDate *date = datePicker.date;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
     [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    self.selectTimeString = [NSString stringWithFormat:@"%@之前均可报名",[dateFormatter stringFromDate:date]];
}
//取消选择日期
-(void)cancelButtonClick:(UIButton *)button
{
    [self.datePicker removeFromSuperview];
    [self.dateView removeFromSuperview];
    [self.blackView removeFromSuperview];
}
//确定选择日期
-(void)confirmButtonClick:(UIButton *)button
{
    if ([self.selectTimeString isEqualToString:@"活动结束前均可报名"]) {
        NSDate *date = [NSDate date];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
        self.selectTimeString = [NSString stringWithFormat:@"%@之前均可报名",[dateFormatter stringFromDate:date]];
    }
    UITableViewCell *cell = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    cell.detailTextLabel.text = self.selectTimeString;
    [self.datePicker removeFromSuperview];
    [self.dateView removeFromSuperview];
    [self.blackView removeFromSuperview];
}



-(UIView *)text{
    UIView *labelView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, YGScreenWidth, 100)];
    labelView.backgroundColor = [UIColor whiteColor];
    NSInteger toLeft = 10;
//    NSArray *array = [NSArray arrayWithObjects:@"公司",@"职位",@"行业",@"年龄",@"性别",@"邮箱",@"附近",@"备注", nil];
    NSArray *array = self.commonInfoAray;
    
    int k = 0;
    CGFloat widthCount = 0.0f;
    int j = 0;
    NSInteger position = 4;
    for (int i = 0;i<array.count;i++) {
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:array[i] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:YGFontSizeSmallOne];
        [button.titleLabel sizeToFit];
        [button setTitleColor:colorWithLightGray forState:UIControlStateNormal];
        [button setTitleColor:colorWithMainColor forState:UIControlStateSelected];
        button.backgroundColor = [UIColor clearColor];
        button.tag = 1000+i;
        [button addTarget:self action:@selector(titleChooseChangeContentAction:) forControlEvents:UIControlEventTouchUpInside];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 30)];
        label.font = [UIFont systemFontOfSize:YGFontSizeSmallOne];
        label.text = array[i];
        label.textColor = colorWithMainColor;
        [label sizeToFit];
        button.layer.borderColor = colorWithPlateSpacedColor.CGColor;
        for (int m = 0; m < self.dataArray.count; m++) {
            if ([[self.dataArray[m] valueForKey:@"customName"] isEqualToString:array[i]]) {
                button.layer.borderColor = colorWithMainColor.CGColor;
                button.selected = YES;
                
            }
        }
        
        CGFloat labeWidth = (YGScreenWidth-60)/4;
        button.frame = CGRectMake(toLeft+widthCount+k*10, 10+35*j, labeWidth, 30) ;
        
        widthCount = widthCount +labeWidth;
        
        if (i+1>position) {
            j=j+1;
            position = (j+1)*4;
            k=0;
            widthCount = 0.0f;
            button.frame = CGRectMake(toLeft+widthCount+k*10, 10+35*j, labeWidth, 30);
            widthCount = widthCount +labeWidth;
        }
        
        button.layer.cornerRadius = button.frame.size.height / 2;
//        button.layer.borderColor = colorWithPlateSpacedColor.CGColor;
        button.layer.borderWidth = 1;
        
        k++;
        
        [labelView addSubview:button];
        
    }
    labelView.frame = CGRectMake(0, 0, YGScreenWidth, 10+35*(j+1));
    return labelView;
}



//监听textField输入改变
- (void)textFieldDidChange:(UITextField *)textField
{
    CGFloat maxLength = 5;
    NSString *toBeString = textField.text;
    
    //获取高亮部分
    UITextRange *selectedRange = [textField markedTextRange];
    UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
    
    if (!position || !selectedRange)
    {
        if (toBeString.length > maxLength)
        {
            [YGAppTool showToastWithText:@"输入的长度不能超过5哦"];
            NSRange rangeIndex = [toBeString rangeOfComposedCharacterSequenceAtIndex:maxLength];
            if (rangeIndex.length == 1)
            {
                textField.text = [toBeString substringToIndex:maxLength];
            }
            else
            {
                NSRange rangeRange = [toBeString rangeOfComposedCharacterSequencesForRange:NSMakeRange(0, maxLength)];
                textField.text = [toBeString substringWithRange:rangeRange];
            }
        }
    }
}

//选择标签
-(void)titleChooseChangeContentAction:(UIButton *)button
{
    button.selected = !button.selected;
    NSIndexSet *indexSet;
    if (button.selected == YES) {
        button.layer.borderColor = colorWithMainColor.CGColor;
        [self.dataArray addObject:@{@"customName":button.titleLabel.text,@"isCheck":@"0"}.mutableCopy];
    }
    else
    {
        button.layer.borderColor = colorWithPlateSpacedColor.CGColor;
        for (int i = 0; i < self.dataArray.count; i++) {
            if([button.titleLabel.text isEqualToString:[self.dataArray[i] valueForKey:@"customName"]])
            {
                [self.dataArray removeObjectAtIndex:i];
            }
        }
        NSLog(@"%@",self.dataArray);
    }
    indexSet = [[NSIndexSet alloc]initWithIndex:1];
    [_tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
}

//选择
-(void)optionButtonClick:(UIButton *)button
{
    button.selected = !button.selected;
    if (button.selected == YES) {
        self.dataArray[button.tag][@"isCheck"] = @"1";
    }
    else
    {
        self.dataArray[button.tag][@"isCheck"] = @"0";
    }
}
//移除
-(void)removeButtonClick:(UIButton *)button
{
    for (int i = 0; i < self.commonInfoAray.count; i++) {
        UIButton *labelButton = [self.view viewWithTag:i + 1000];
        if ([labelButton.titleLabel.text isEqualToString:[self.dataArray[button.tag] valueForKey:@"customName"]]) {
            labelButton.selected = NO;
            labelButton.layer.borderColor = colorWithPlateSpacedColor.CGColor;
        }
    }
    [self.dataArray removeObjectAtIndex:button.tag];
//    [self.dataBoobleArray removeObjectAtIndex:button.tag];
    NSLog(@"%@",self.dataArray);
    
    NSIndexSet *indexSet = [[NSIndexSet alloc]initWithIndex:1];
    [_tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
}

//键盘上完成按钮点击事件
-(void)customDone
{
    [self.view endEditing:YES];
    for (int i = 0; i < self.commonInfoAray.count; i++) {
//        UIButton *labelButton = [self.view viewWithTag:i];
        if ([self.commonInfoAray[i] isEqualToString:self.customTextField.text]) {
            [YGAppTool showToastWithText:@"此条信息请去常用信息里面编辑"];
            self.customTextField.text = @"";
            return;
        }
    }
    if ([self.customTextField.text isEqualToString:@"姓名"] || [self.customTextField.text  isEqualToString:@"手机"]) {
        [YGAppTool showToastWithText:@"此条信息不可编辑"];
        self.customTextField.text = @"";
        return;
    }
    for(int i = 0;i < self.dataArray.count;i++)
    {
        if ([self.customTextField.text isEqualToString:[self.dataArray[i] valueForKey:@"customName"]]) {
            [YGAppTool showToastWithText:@"请勿添加重复信息"];
            self.customTextField.text = @"";
            return;
        }
    }
    NSString *regex = @"[A-Za-z0-9\u4e00-\u9fa5]+$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    if(![pred evaluateWithObject:self.customTextField.text])
    {
        [YGAppTool showToastWithText:@"只能输入中文,英文或数字哦!"];
        self.customTextField.text = @"";
        return;
    }
    
    if (self.customTextField.text.length) {
        [self.dataArray addObject:@{@"customName":self.customTextField.text,@"isCheck":@"0"}.mutableCopy];
        NSIndexSet *indexSet = [[NSIndexSet alloc]initWithIndex:1];
        [_tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
    }
    self.customTextField.text = @"";
}

//完成
-(void)submitInfo:(UIButton *)button
{
    if ([self.selectTimeString isEqualToString:@"活动结束前均可报名"]) {
        [YGAppTool showToastWithText:@"请选择结束报名时间!"];
        return;
    }
    NSString *selectString = [_selectTimeString substringToIndex:16];
    [self.delegate passSelectArray:_dataArray andSelectTimeString:selectString];
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
