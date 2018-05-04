//
//  ReservationController.m
//  QingYouProject
//
//  Created by zhaoao on 2017/10/23.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "ReservationController.h"
#import "ReserveHeaderView.h"
#import "YGSpreadView.h"
#import "AlreayReservedTimeCell.h"
#import "ReserveInputCell.h"
#import "ReserveChooseCell.h"
#import "ReserveRemarkCell.h"
#import "MeetingPayingViewController.h"

@interface ReservationController () <UITableViewDelegate,UITableViewDataSource,YGSpreadViewDelegate,UIPickerViewDataSource,UIPickerViewDelegate,UITextFieldDelegate,UITextViewDelegate>
{
    YGSpreadView *_mayNeedView; //展开折叠那个view
    NSInteger _mouth;
    NSInteger _year;
}

@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)UIView *bottomView;
@property(nonatomic,strong)UIPickerView *pickView;//时间选择器
@property(nonatomic,strong)NSArray *timeArray; //时间选择器弹出时间
@property(nonatomic,strong)ReserveHeaderView *dateHeaderView;
@property(nonatomic,strong)UIView *completeView;//选择完日期完成view
@property(nonatomic,strong)NSString *selectHourString;//选择的小时字符串
@property(nonatomic,strong)NSString *selectMinuteString;//选择的分钟字符串
@property(nonatomic,assign)NSInteger rowClickPicker;//标记一下是哪行叫出的选择器
@property(nonatomic,strong)UIView *blackView;//黑色透明遮罩
@property(nonatomic,strong)NSMutableArray *dataArray;//已经预定的时间段
@property(nonatomic,strong)NSMutableArray *equipsMutableArray; //设备数据源
@property(nonatomic,strong)NSMutableArray *timeMutableArray;//时间段数据源
@property(nonatomic,strong)NSDictionary *infoDictionary;
@property(nonatomic,strong)NSMutableString *equipString; //选择的设备的字符串
//@property(nonatomic,strong)NSString *pointString;//青币
//@property(nonatomic,strong)NSString *offPriceString;//青币

@end

@implementation ReservationController
-(NSArray *)timeArray
{
    if (_timeArray == nil) {
        NSString *timePath = [[NSBundle mainBundle]pathForResource:@"time" ofType:@".plist"];
        _timeArray = [NSArray arrayWithContentsOfFile:timePath];
    }
    return _timeArray;
}
-(UIView *)completeView
{
    if (_completeView == nil) {
        _completeView = [[UIView alloc]initWithFrame:CGRectMake(0, YGScreenHeight - 280, YGScreenWidth, 40)];
        UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [cancelButton setTitleColor:colorWithMainColor forState:UIControlStateNormal];
        cancelButton.titleLabel.font = [UIFont systemFontOfSize:20.0];
        cancelButton.frame = CGRectMake(15, 0, 50, 40);
        [cancelButton addTarget:self action:@selector(cancel:) forControlEvents:UIControlEventTouchUpInside];
        [_completeView addSubview:cancelButton];
        
        
        UIButton *completeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [completeButton setTitle:@"完成" forState:UIControlStateNormal];
        [completeButton setTitleColor:colorWithMainColor forState:UIControlStateNormal];
        completeButton.titleLabel.font = [UIFont systemFontOfSize:20.0];
        completeButton.frame = CGRectMake(YGScreenWidth - 65, 0, 50, 40);
        [completeButton addTarget:self action:@selector(complete:) forControlEvents:UIControlEventTouchUpInside];
        [_completeView addSubview:completeButton];
        _completeView.backgroundColor = colorWithTable;
    }
    return _completeView;
}
-(UIPickerView *)pickView
{
    if (_pickView == nil) {
        _pickView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, YGScreenHeight - 240, YGScreenWidth, 250)];
        _pickView.backgroundColor = colorWithTable;
    }
    return _pickView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.naviTitle = @"预定";
    _timeMutableArray = [NSMutableArray array];
    _equipsMutableArray = [NSMutableArray array];
    _infoDictionary =[NSDictionary dictionary];
    
    UIButton *submitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    submitButton.frame = CGRectMake(0, 0, 35, 35);
    [submitButton setTitleColor:colorWithMainColor forState:UIControlStateNormal];
    [submitButton setTitle:@"提交" forState:normal];
    submitButton.titleLabel.font = [UIFont systemFontOfSize:15.0];
    [submitButton addTarget:self action:@selector(submitInfo:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightButtonItem = [[UIBarButtonItem alloc] initWithCustomView:submitButton];
    self.navigationItem.rightBarButtonItem = rightButtonItem;
    
    self.blackView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, YGScreenWidth, YGScreenHeight)];
    self.blackView.backgroundColor = [UIColor colorWithWhite:0.f alpha:0.5];
    
    self.pickView.delegate = self;
    self.pickView.dataSource = self;
    self.pickView.showsSelectionIndicator=YES;
    [self pickerView:self.pickView didSelectRow:0 inComponent:0];
    [self pickerView:self.pickView didSelectRow:0 inComponent:1];
    
    [self configTimeHeaderView];
    
    [self configTableView];
    
    [self loadData];
}

-(void)loadData
{
    [YGNetService YGPOST:REQUEST_getHasOrderTime parameters:@{@"roomId":self.idString,@"orderDate":self.dateHeaderView.dateLabel.text,@"uId":YGSingletonMarco.user.userId} showLoadingView:YES scrollView:nil success:^(id responseObject) {
        
        NSLog(@"%@",responseObject);
        self.timeMutableArray = [responseObject valueForKey:@"timeList"];
        self.equipsMutableArray = [responseObject valueForKey:@"equipsList"];
        self.infoDictionary = [responseObject valueForKey:@"boardRoom"];
//        self.pointString = [responseObject valueForKey:@"point"];
//        self.offPriceString = [responseObject valueForKey:@"offPrice"];
        [self.tableView reloadData];
        
        self.equipString = [NSMutableString string];
        [self configBottomView];
        
    } failure:^(NSError *error) {
        
    }];
}

-(void)configTimeHeaderView
{
    self.dateHeaderView = [[[NSBundle mainBundle]loadNibNamed:@"ReserveHeaderView" owner:self options:nil]firstObject];
    self.dateHeaderView.frame = CGRectMake(0, 0, YGScreenWidth, 45);
    [self.dateHeaderView.leftDatebutton addTarget:self action:@selector(leftDateClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.dateHeaderView.rightDateButton addTarget:self action:@selector(rightDateClick:) forControlEvents:UIControlEventTouchUpInside];
    self.dateHeaderView.dateLabel.text = self.dateString;
    [self.view addSubview:self.dateHeaderView];
}

-(void)configTableView
{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 45, YGScreenWidth, YGScreenHeight - YGStatusBarHeight - YGNaviBarHeight - 45) style:UITableViewStyleGrouped];
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, YGScreenWidth, 0.001)];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, YGScreenWidth, 0.001)];
    self.tableView.sectionHeaderHeight = 0.001;
    self.tableView.sectionFooterHeight = 10;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 67, 0); //要不然滑不到最下面
    if (@available(iOS 11.0, *))
    {
        _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    else
    {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    [self.view addSubview:self.tableView];
}

-(void)configBottomView
{
    self.bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, YGScreenWidth, 200)];
    self.bottomView.backgroundColor = [UIColor whiteColor];
    
    
    UILabel *bottomTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 10, 90, 20)];
    bottomTitleLabel.text = @"您也许需要";
    bottomTitleLabel.font = [UIFont systemFontOfSize:15.0];
    [self.bottomView addSubview:bottomTitleLabel];
    
    UILabel *bottomTipLabel = [[UILabel alloc]initWithFrame:CGRectMake(105, 10, YGScreenWidth - 130, 20)];
    bottomTipLabel.text = @"(该服务为线下收费)";
    bottomTipLabel.textColor = colorWithMainColor;
    bottomTipLabel.font = [UIFont systemFontOfSize:14.0];
    [self.bottomView addSubview:bottomTipLabel];

    UIView *textView = [self text];
    self.bottomView.frame = CGRectMake(0, 0, YGScreenWidth, textView.size.height + 20 + 20);
    [self.bottomView addSubview:textView];
    
    self.tableView.tableFooterView = self.bottomView;

//    _mayNeedView = [[YGSpreadView alloc] initWithOrigin:CGPointMake(0, 0) inView:self.bottomView startHeight:130];
//    _mayNeedView.delegate = self;
//    [self.bottomView addSubview:_mayNeedView];
}
-(UIView *)text{
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, YGScreenWidth, 80)];
    footerView.backgroundColor = [UIColor whiteColor];
    NSInteger toLeft = 10;
//    NSArray *array = @[@"液晶电视",@"茶水饮品",@"电脑",@"茶水饮品",@"茶水饮品",@"茶水饮品",@"茶水饮品",@"茶水饮品",@"茶水饮品",@"设备物品",@"全面配套服务",@"价格体系公道",@"电脑",@"音响",@"电视",@"音响",@"电视",@"投影仪",@"麦克风"];
    
    NSMutableArray *array = [NSMutableArray array];
    for (int i = 0; i<self.equipsMutableArray.count; i++) {
        [array addObject:[self.equipsMutableArray[i] valueForKey:@"equipName"]];
    }
    int k = 0;
    CGFloat widthCount = 0.0f;
    int j = 0;
    for (int i = 0;i<array.count;i++) {
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:array[i] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:YGFontSizeSmallOne];
        [button.titleLabel sizeToFit];
        [button setTitleColor:colorWithDeepGray forState:UIControlStateNormal];
        [button setTitleColor:colorWithMainColor forState:UIControlStateSelected];
        button.backgroundColor = [UIColor clearColor];
        button.tag = 100+i;
        [button addTarget:self action:@selector(titleChooseChangeContentAction:) forControlEvents:UIControlEventTouchUpInside];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 24)];
        label.font = [UIFont systemFontOfSize:YGFontSizeSmallOne];
        label.text = array[i];
        label.textColor = colorWithMainColor;

        [label sizeToFit];
        
        CGFloat labeWidth = label.width+20;
        button.frame = CGRectMake(toLeft+widthCount+k*5, 10+30*j, labeWidth-10, 24) ;
        
        
        widthCount = widthCount +labeWidth;
        
        if (widthCount>(YGScreenWidth-toLeft-10-k*5)) {
            j=j+1;
            k=0;
            widthCount = 0.0f;
            button.frame = CGRectMake(toLeft+widthCount+k*5, 10+30*j, labeWidth-10, 24);
            widthCount = widthCount +labeWidth;
        }
        
        button.layer.cornerRadius = 3;
        button.layer.borderColor = colorWithLightGray.CGColor;
        button.layer.borderWidth = 0.8;
        k++;
        
        [footerView addSubview:button];
        
    }
    footerView.frame = CGRectMake(0, 30, YGScreenWidth, 10+30*(j+1));
    return footerView;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *titleArray = [NSArray arrayWithObjects:@"预定人数",@"开始时间",@"结束时间",@"费用共计",@"联系人",@"联系电话", nil];
    NSArray *placeholerArray = [NSArray arrayWithObjects:@"请输入人数",@"",@"",@"",@"请输入姓名",@"请输入电话号码", nil];
    if (indexPath.section == 0) {
        AlreayReservedTimeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AlreayReservedTimeCell"];
        if (!cell) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"AlreayReservedTimeCell" owner:self options:nil] firstObject];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, MAXFLOAT)];
        }

        if(self.timeMutableArray.count)
        {
            //cell.leftTimeLabel.text = [NSString stringWithFormat:@"%@   已预订",self.timeMutableArray[indexPath.row*2]];
            [cell.leftTimeLabel addAttributedWithString:[NSString stringWithFormat:@"%@   被预订",self.timeMutableArray[indexPath.row*2]] lineSpace:5];
            [cell.leftTimeLabel addAttributedWithString:[NSString stringWithFormat:@"%@   被预订",self.timeMutableArray[indexPath.row*2]] range:NSMakeRange(0, 11) color:colorWithBlack];
            if (self.timeMutableArray.count%2 != 0 && self.timeMutableArray.count/2 == indexPath.row) {
                cell.rightTimeLabel.hidden = YES;
            }else{
                cell.rightTimeLabel.hidden = NO;
//                cell.rightTimeLabel.text = [NSString stringWithFormat:@"%@   已预定",self.timeMutableArray[indexPath.row*2+1]];
                [cell.rightTimeLabel addAttributedWithString:[NSString stringWithFormat:@"%@   被预定",self.timeMutableArray[indexPath.row*2+1]] lineSpace:5];
                [cell.rightTimeLabel addAttributedWithString:[NSString stringWithFormat:@"%@   被预定",self.timeMutableArray[indexPath.row*2+1]] range:NSMakeRange(0, 11) color:colorWithBlack];
            }
        }
        return cell;
    }
    if (indexPath.section == 1) {
        if (indexPath.row == 0 || indexPath.row == 4 || indexPath.row == 5) {
            ReserveInputCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ReserveInputCell"];
            if (!cell) {
                cell = [[[NSBundle mainBundle]loadNibNamed:@"ReserveInputCell" owner:self options:nil] firstObject];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            if(indexPath.row == 0 || indexPath.row == 5)
            {
                cell.textField.keyboardType = UIKeyboardTypeNumberPad;
                cell.textField.delegate = self;
            }
            if (indexPath.row == 5) {
                 [cell setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, MAXFLOAT)];
            }
            cell.titleLabel.text = titleArray[indexPath.row];
            cell.textField.placeholder = placeholerArray[indexPath.row];
            return cell;
        }
        if (indexPath.row == 1 || indexPath.row == 2) {
            ReserveChooseCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ReserveChooseCell"];
            if (!cell) {
                cell = [[[NSBundle mainBundle]loadNibNamed:@"ReserveChooseCell" owner:self options:nil] firstObject];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            cell.titleLabel.text = titleArray[indexPath.row];
            return cell;
        }
        if (indexPath.row == 3) {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            cell.textLabel.font = [UIFont systemFontOfSize:15.0];
            cell.textLabel.frame = CGRectMake(15, 0, 150, 40);
            cell.textLabel.text = titleArray[indexPath.row];
//            cell.detailTextLabel.text = [NSString stringWithFormat:@"¥%@",[self.infoDictionary valueForKey:@"expense"]];
            cell.detailTextLabel.textColor = colorWithMainColor;
            return cell;
        }
        ReserveRemarkCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ReserveRemarkCell"];
        if (!cell) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"ReserveRemarkCell" owner:self options:nil] firstObject];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        [cell setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, MAXFLOAT)];
        cell.remarktextView.delegate = self;
        cell.countLabel.tag = 999;
        cell.placeholerLabel.tag = 998;
        return cell;
        
    }
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"PlayTogetherCell" owner:self options:nil] firstObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 1) {
        return 7;
    }
    return (self.timeMutableArray.count/2)+self.timeMutableArray.count%2;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        if (indexPath.row == 6) {
            return YGScreenWidth * 0.28;
        }
        return 45;
    }
    return 30;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section == 0) {
        if(self.timeMutableArray.count){
        UIView *tipFooterView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, YGScreenWidth, 40)];
        tipFooterView.backgroundColor = colorWithTable;
        UILabel *tipFooterLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, YGScreenWidth - 30, 40)];
        tipFooterLabel.textColor = colorWithLightGray;
//        tipFooterLabel.text = @"* 两场会议间预留半小时清扫时间";
        [tipFooterLabel addAttributedWithString:@"*两场会议间预留半小时清扫时间" lineSpace:8];
        [tipFooterLabel addAttributedWithString:@"*两场会议间预留半小时清扫时间" range:NSMakeRange(0, 1) color:[UIColor redColor]];
        tipFooterLabel.font = [UIFont systemFontOfSize:14.0];
        [tipFooterView addSubview:tipFooterLabel];
        return tipFooterView;
        }
        return nil;
    }else{
        return nil;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if(section == 0)
    {
        if(self.timeMutableArray.count){
            return 40;}
        return 0.0001;
    }
    return 7;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ((indexPath.section == 1 && indexPath.row == 1) || (indexPath.section == 1 && indexPath.row == 2) ) {
        [self.view addSubview:self.blackView];
        [self.blackView addSubview:self.pickView];
        [self.blackView addSubview:self.completeView];
        self.rowClickPicker = indexPath.row;
    }
}


- (void)textFieldDidEndEditing:(UITextField *)textField
{
    ReserveInputCell *cell1 = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
    if (textField == cell1.textField) {
        if ([cell1.textField.text integerValue] > [[self.infoDictionary valueForKey:@"personCount"] integerValue]) {
            [YGAlertView showAlertWithTitle:@"当前人数已超出可容纳人数,请联系客服" buttonTitlesArray:@[@"确定"] buttonColorsArray:@[colorWithMainColor] handler:^(NSInteger buttonIndex) {
                return ;
            }];
        }
    }
    
}

//提交
-(void)submitInfo:(UIButton *)button
{
    ReserveInputCell *peopleCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
    ReserveChooseCell *beginCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:1]];
    ReserveChooseCell *endCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:1]];
    UITableViewCell *moneyCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:1]];
    ReserveInputCell *nameCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:4 inSection:1]];
    ReserveInputCell *telCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:5 inSection:1]];
    ReserveRemarkCell *remarkCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:6 inSection:1]];
    
    if (!peopleCell.textField.text.length)
    {
        [YGAppTool showToastWithText:@"请输入人数！"];
        return;
    }
    if (!moneyCell.detailTextLabel.text.length)
    {
        [YGAppTool showToastWithText:@"请选择正确的时间段！"];
        return;
    }
    if (!nameCell.textField.text.length)
    {
        [YGAppTool showToastWithText:@"请输入联系人姓名！"];
        return;
    }
    if (!telCell.textField.text.length)
    {
        [YGAppTool showToastWithText:@"请输入电话号码！"];
        return;
    }
    if ([YGAppTool isNotPhoneNumber:telCell.textField.text])
    {
        return;
    }
    else
    {
        NSString *moneyString = [moneyCell.detailTextLabel.text substringFromIndex:1];
        [YGNetService YGPOST:REQUEST_commit parameters:@{@"roomId":self.idString,@"orderDate":self.dateHeaderView.dateLabel.text,@"roomName":[self.infoDictionary valueForKey:@"roomName"],@"personCount":peopleCell.textField.text,@"beginTime":beginCell.timeLabel.text,@"endTime":endCell.timeLabel.text,@"linkMan":nameCell.textField.text,@"linkPhone":telCell.textField.text,@"uId":YGSingletonMarco.user.userId,@"remarks":remarkCell.remarktextView.text,@"equip":self.equipString} showLoadingView:YES scrollView:nil success:^(id responseObject) {
            
            NSLog(@"%@",responseObject);
            
//            [YGAppTool showToastWithText:[responseObject valueForKey:@"msg"]];
            
            NSDictionary *boardRoomOrderDic = [responseObject valueForKey:@"boardRoomOrder"];
            
            if ([[responseObject valueForKey:@"timeFlag"] isEqualToString:@"true"]) {
                MeetingPayingViewController *vc = [[MeetingPayingViewController alloc]init];
//                vc.isPay = @"YES";
                vc.pointString = [responseObject valueForKey:@"point"];
                vc.offPriceString = [responseObject valueForKey:@"offPrice"];
                vc.orderDic = boardRoomOrderDic;
                [self.navigationController pushViewController:vc animated:YES];
            }
            else
            {
                [YGAppTool showToastWithText:@"该时间段不可选择,请重新选择！"];
            }
            
        } failure:^(NSError *error) {
            
        }];
    }
}


#pragma mark -UIPickerView数据源
#pragma mark 多少组
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return self.timeArray.count;
}
#pragma mark 每组多少行
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    NSArray *items=self.timeArray[component];
    return items.count;
}

#pragma mark -UIPickerView数据代理
#pragma mark 对应组对应行的数据
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSArray *items=self.timeArray[component];
    return items[row];
}
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    //获取对应组对应行的数据
    NSString *time = self.timeArray[component][row];
    switch (component) {
        case 0:
            self.selectHourString = time;
            break;
        case 1:
            self.selectMinuteString = time;
            break;
        default:
            break;
    }
}
-(CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    return 100;
}

//pickerview上面的取消按钮
-(void)cancel:(UIButton *)button
{
    [self.pickView removeFromSuperview];
    [self.completeView removeFromSuperview];
    [self.blackView removeFromSuperview];
}
//pickerview上面的完成按钮
-(void)complete:(UIButton *)button
{
    NSString *chooseString = [NSString stringWithFormat:@"%@:%@",self.selectHourString,self.selectMinuteString];
    ReserveChooseCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:self.rowClickPicker inSection:1]];
    cell.timeLabel.text = chooseString;
    [self.pickView removeFromSuperview];
    [self.completeView removeFromSuperview];
    [self.blackView removeFromSuperview];
    
    
    NSString *endString;//结束时间 如果选择 00：00 就变成 24：00
    ReserveChooseCell *cell1 = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:1]];
    ReserveChooseCell *cell2 = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:1]];
    endString = cell2.timeLabel.text;
    if ([cell2.timeLabel.text isEqualToString:@"00:00"]) {
        endString = @"24:00";
    }
    
    if (cell1.timeLabel.text.length == 5 && cell2.timeLabel.text.length == 5) {
        NSString *beginHour = [cell1.timeLabel.text substringWithRange:NSMakeRange(0, 2)];
        NSString *endHour = [endString substringWithRange:NSMakeRange(0, 2)];
        NSString *beginMinute = [cell1.timeLabel.text substringWithRange:NSMakeRange(3, 2)];
        NSString *endMinute = [endString substringWithRange:NSMakeRange(3, 2)];
        if ([beginHour integerValue] > [endHour integerValue] ||( [beginHour integerValue] == [endHour integerValue] && [beginMinute integerValue] > [endMinute integerValue])) {
            [YGAppTool showToastWithText:@"开始时间不能大于结束时间！"];
            cell.timeLabel.text = @"请选择";
        }
        else
        {
            UITableViewCell *monneyCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:1]];
            if ([beginHour integerValue] == [endHour integerValue] || (([endHour integerValue] - [beginHour integerValue] == 1) && beginMinute > endMinute))
                {
                    [YGAppTool showToastWithText:@"选择的时间不能小于1个小时"];
                    cell.timeLabel.text = @"请选择";
                    monneyCell.detailTextLabel.text = @"";
            }
            else
            {
                if([beginMinute isEqualToString:@"30"])
                {
                    beginMinute = @"5";
                }
                if([endMinute isEqualToString:@"30"])
                {
                    endMinute = @"5";
                }
                CGFloat beginNum = [[NSString stringWithFormat:@"%@.%@",beginHour,beginMinute] floatValue];
                CGFloat endNum = [[NSString stringWithFormat:@"%@.%@",endHour,endMinute] floatValue];
                
                if (beginMinute == endMinute) {
                    CGFloat timeInterval = endNum - beginNum;
                    monneyCell.detailTextLabel.text = [NSString stringWithFormat:@"¥%.lf",[self.unitPriceString integerValue] * timeInterval];
                }
                else
                {
                    [YGAppTool showToastWithText:@"选择的时间段只能是整数"];
                    cell.timeLabel.text = @"请选择";
                    monneyCell.detailTextLabel.text = @"";
                }
                
            }
        }
        
    }
    
}


//切换前一天日期
-(void)leftDateClick:(UIButton *)button
{
    NSString *dateYear = [self.dateHeaderView.dateLabel.text substringWithRange:NSMakeRange(0, 4)];
    _year = [dateYear integerValue];
    NSString *dateMouth = [self.dateHeaderView.dateLabel.text substringWithRange:NSMakeRange(5,2)];
    _mouth = [dateMouth integerValue];
    NSString *dateDay = [self.dateHeaderView.dateLabel.text substringWithRange:NSMakeRange(8, 2)];
    NSInteger day = [dateDay integerValue];
    
    
    //比较时间
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *nowDateStr = [formatter stringFromDate:date];
    
    NSString *dateOldYear = [nowDateStr substringWithRange:NSMakeRange(0, 4)];
    NSInteger oldYear = [dateOldYear integerValue];
    NSString *dateOldMouth = [nowDateStr substringWithRange:NSMakeRange(5,2)];
    NSInteger OldMouth = [dateOldMouth integerValue];
    NSString *dateOldDay = [nowDateStr substringWithRange:NSMakeRange(8, 2)];
    NSInteger oldDay = [dateOldDay integerValue];
    
    if (_year == oldYear && _mouth == OldMouth && day == oldDay) {
        
    }else{
        NSString *bigMouth = @"010305070801012";
        NSString *smallMouth = @"040609011";
        dateMouth = [NSString stringWithFormat:@"%@%ld",@"0",[dateMouth integerValue] -1];
        if ([bigMouth rangeOfString:dateMouth].location != NSNotFound) {
            [self getNewDateCut:day andmouthAllDay:31];
        }else if([smallMouth rangeOfString:dateMouth].location != NSNotFound){
            [self getNewDateCut:day andmouthAllDay:30];
        }else{
            if((_year%4==0 && _year%100 != 0) ||_year%400==0){
                [self getNewDateCut:day andmouthAllDay:29];
                
            }else{
                [self getNewDateCut:day andmouthAllDay:28];
            }
        }
    }
    self.timeMutableArray = nil;
    [self loadData];
    
}
-(void)getNewDateCut:(NSInteger)day andmouthAllDay:(NSInteger) mouthAllDay
{
    if (day == 1) {
        day = mouthAllDay;
        if (_mouth == 1) {
            _mouth = 12;
            _year = _year-1;
        }else{
            _mouth = _mouth - 1;
        }
        
    }else{
        day = day-1;
    }
    
    NSString *zeor = @"";
    if (day <10) {
        zeor = @"0";
    }
    NSString *monthZeor = @"";
    if (_mouth <10) {
        monthZeor = @"0";
    }
    self.dateHeaderView.dateLabel.text = [NSString stringWithFormat:@"%ld-%@-%@",_year,[NSString stringWithFormat:@"%@%ld",monthZeor,_mouth],[NSString stringWithFormat:@"%@%ld",zeor,day]];
    
}
//切换后一天日期
-(void)rightDateClick:(UIButton *)button
{
    NSString *dateYear = [self.dateHeaderView.dateLabel.text substringWithRange:NSMakeRange(0, 4)];
    _year = [dateYear integerValue];
    NSString *dateMouth = [self.dateHeaderView.dateLabel.text substringWithRange:NSMakeRange(5,2)];
    _mouth = [dateMouth integerValue];
    NSString *dateDay = [self.dateHeaderView.dateLabel.text substringWithRange:NSMakeRange(8, 2)];
    NSInteger day = [dateDay integerValue];
    
    
    NSString *bigMouth = @"01030507081012";
    NSString *smallMouth = @"04060911";
    if ([bigMouth rangeOfString:dateMouth].location != NSNotFound) {
        [self getNewDateAdd:day andmouthAllDay:31];
    }else if([smallMouth rangeOfString:dateMouth].location != NSNotFound){
        [self getNewDateAdd:day andmouthAllDay:30];
    }else{
        if((_year%4==0 && _year%100 != 0) ||_year%400==0){
            [self getNewDateAdd:day andmouthAllDay:29];
            
        }else{
            [self getNewDateAdd:day andmouthAllDay:28];
        }
    }
    self.timeMutableArray = nil;
    [self loadData];
}

-(void)getNewDateAdd:(NSInteger)day andmouthAllDay:(NSInteger) mouthAllDay
{
    if (day+1>mouthAllDay) {
        day = 1;
        if (_mouth == 12) {
            _mouth = 1;
            _year = _year+1;
        }else{
            _mouth = _mouth + 1;
        }
        
    }else{
        day = day+1;
    }
    
    NSString *zeor = @"";
    if (day <10) {
        zeor = @"0";
    }
    NSString *monthZeor = @"";
    if (_mouth <10) {
        monthZeor = @"0";
    }
    self.dateHeaderView.dateLabel.text = [NSString stringWithFormat:@"%ld-%@-%@",_year,[NSString stringWithFormat:@"%@%ld",monthZeor,_mouth],[NSString stringWithFormat:@"%@%ld",zeor,day]];
    
}

-(void)titleChooseChangeContentAction:(UIButton *)button
{
    button.selected = !button.selected;
    
    if (button.selected == YES) {
        
        button.layer.borderColor = colorWithMainColor.CGColor;
        if(!self.equipString.length)
        {
            [self.equipString appendString:button.titleLabel.text];
        }
        else
        {
            [self.equipString appendString:[NSString stringWithFormat:@",%@",button.titleLabel.text]];
        }
    }else
    {
        button.layer.borderColor = colorWithLightGray.CGColor;
        NSMutableArray *array = [self.equipString componentsSeparatedByString:@","].mutableCopy;
        for (int i = 0; i < array.count; i++) {
            if ([array[i] isEqualToString:button.titleLabel.text]) {
                [array removeObject:array[i]];
            }
        }
        NSString *string = [array componentsJoinedByString:@","];
        self.equipString = [NSMutableString stringWithFormat:@"%@",string];
//        NSString *string =[NSString stringWithFormat:@",%@",button.titleLabel.text];
//        NSRange range = [string rangeOfString:string];
//        [self.equipString deleteCharactersInRange:range];
    }
    
    NSLog(@"%@",self.equipString);
}

- (void)textViewDidChange:(UITextView *)textView
{
    UILabel *countLabel = [self.view viewWithTag:999];
    UITextRange *selectedRange = [textView markedTextRange];
    //获取高亮部分
    UITextPosition *pos = [textView positionFromPosition:selectedRange.start offset:0];
    //如果在变化中是高亮部分在变，就不要计算字符了
    if (selectedRange && pos) {
        return;
    }
    countLabel.text = [NSString stringWithFormat:@"%lu/200", (unsigned long)textView.text.length];
    if ( (unsigned long)textView.text.length > 200) {
        //        对超出的部分进行剪切
        textView.text = [textView.text substringToIndex:200];
        countLabel.text = @"200/200";
    }
    
    
}
//设置textView的placeholder
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    UILabel *placeHolerLabel = [self.view viewWithTag:998];
    //[text isEqualToString:@""] 表示输入的是退格键
    if (![text isEqualToString:@""])
    {
        placeHolerLabel.hidden = YES;
    }
    //range.location == 0 && range.length == 1 表示输入的是第一个字符
    if ([text isEqualToString:@""] && range.location == 0 && range.length == 1)
    {
        placeHolerLabel.hidden = NO;
    }
    return YES;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
