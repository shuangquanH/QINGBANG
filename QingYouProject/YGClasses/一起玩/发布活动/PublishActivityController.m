//
//  PublishActivityController.m
//  QingYouProject
//
//  Created by zhaoao on 2017/11/13.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "PublishActivityController.h"
#import "AddPosterHeaderView.h"
#import "ActivityInputCell.h"
#import "ActivityChooseCell.h"
#import "ApplyCostCell.h"
#import "ActivityDetailsDescriptionCell.h"
#import "ActivityPeopleCell.h"
#import "AllowRecommendCell.h"
#import "ActivityLabelCell.h"
#import "ApplyAdvanceFundsView.h"
#import "AboutRecommendController.h"
#import "ActivityDetailsViewController.h"
#import "ApplySetupViewController.h"
#import "QiniuSDK.h"
#import "UploadImageTool.h"
#import "YGActionSheetView.h"
#import "PlayTogetherAgreementController.h"

@interface PublishActivityController ()<UITableViewDelegate,UITableViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate,ApplySetupViewControllerDelegate,ActivityDetailsViewControllerDelegate,UITextFieldDelegate,UIActionSheetDelegate>
{
    UITableView *_tableView;
    CGFloat _labelRowHeight;//标签那栏高度
    NSString *_isCostOnce;//记录是不是第一次点报名费用 默认是0
}
@property(nonatomic,strong)AddPosterHeaderView *posterHeaderView; //海报头视图
@property(nonatomic,strong)NSArray *titleArray;
@property(nonatomic,strong)UIView *blackView;
@property(nonatomic,strong)UIDatePicker *datePicker;//日期选择器
@property(nonatomic,strong)UIView *datemenuView;//时间选择器上的确定取消栏
@property(nonatomic,strong)UILabel *dateTitleLabel;//dateView上的标题
@property(nonatomic,strong)UIView *labelView; //活动标签的view
@property(nonatomic,strong)NSString *beginTimeString; //活动结束时间
@property(nonatomic,strong)NSString *endTimeString; //活动结束时间
@property(nonatomic,strong)NSMutableArray *selectArray;//设置报名活动标签的数组
@property(nonatomic,strong)NSString *selectEndTimeString;//设置报名活动报名截止时间
@property(nonatomic,strong)UIImage *selectImage;//选择的图片
@property(nonatomic,strong)NSMutableArray *detailPicArray;//活动详情描述里面选择的图片数组
@property(nonatomic,strong)NSString *detailString;//活动详情描述里的文字
@property(nonatomic,strong)NSMutableArray *activityTagArray;//活动标签数组
@property(nonatomic,strong)ApplyAdvanceFundsView *applyFundsView;//申请预支经费弹出的view
@property(nonatomic,strong)NSString *activityTag; //活动标签
@property(nonatomic,strong)NSString *activityPeople; //活动人群 0所有人可见，1联盟人可见
@property(nonatomic,strong)NSString *allowRecommend; //允许推荐 0不推荐，1推荐
@property(nonatomic,strong)NSString *allFunds;//活动共需预支经费
@property(nonatomic,strong)NSString *fundsPercent;//预支经费百分比
@property(nonatomic,strong)NSString *advancePercent;//获取的后台返回的百分比
@property(nonatomic,strong)NSString *activitytheme;//活动主题
@property(nonatomic,strong)NSString *activitysite;//活动地点
@property(nonatomic,strong)NSString *peoplelimit;//名额限制
@property(nonatomic,strong)NSString *applyfee;//报名费用

@end

@implementation PublishActivityController

-(UIView *)datemenuView
{
    if (_datemenuView == nil) {
        _datemenuView = [[UIView alloc]initWithFrame:CGRectMake(0, YGScreenHeight - 45 - 300, YGScreenWidth, 45)];
        _datemenuView.backgroundColor = [UIColor whiteColor];
        UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        cancelButton.frame = CGRectMake(0, 0, 60, 45);
        [cancelButton setTitleColor:colorWithBlack forState:UIControlStateNormal];
        [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        cancelButton.titleLabel.font = [UIFont systemFontOfSize:15.0];
        [cancelButton addTarget:self action:@selector(cancelClick:) forControlEvents:UIControlEventTouchUpInside];
        [_datemenuView addSubview:cancelButton];
        
        UIButton *confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
        confirmButton.frame = CGRectMake(YGScreenWidth - 60, 0, 60, 45);
        [confirmButton setTitleColor:colorWithBlack forState:UIControlStateNormal];
        [confirmButton setTitle:@"确定" forState:UIControlStateNormal];
        confirmButton.titleLabel.font = [UIFont systemFontOfSize:15.0];
        [confirmButton addTarget:self action:@selector(confirmClick:) forControlEvents:UIControlEventTouchUpInside];
        [_datemenuView addSubview:confirmButton];
        
        UILabel *lineLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 44.5, YGScreenWidth, 0.5)];
        lineLabel.text = @"";
        lineLabel.backgroundColor = colorWithLine;
        [_datemenuView addSubview:lineLabel];
    }
    return _datemenuView;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.naviTitle = @"发布活动";
    
    //关闭侧滑返回手势
    [self setFd_interactivePopDisabled:YES];
    
    _labelRowHeight = 50.0;
    
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
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(blackViewTap)];
//    [self.blackView addGestureRecognizer:tap];
    
    _isCostOnce = @"0";

    self.titleArray = [NSArray arrayWithObjects:@"活动主题",@"活动开始时间",@"活动结束时间",@"活动举办地点",@"报名费用",@"活动详细描述",@"预支经费",@"名额限制",@"报名设置",@"活动标签",@"活动人群",@"允许青友推荐", nil];
    self.selectArray = [NSMutableArray array];
    self.activityTagArray = [NSMutableArray array];
    
    
    self.allowRecommend = @"1";//允许推荐
    
    [self configUI];
}

-(void)configUI
{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, YGScreenWidth, YGScreenHeight - YGNaviBarHeight - YGStatusBarHeight) style:UITableViewStyleGrouped];
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, YGScreenWidth, 0.001)];
    _tableView.sectionHeaderHeight = 0.001;
    _tableView.sectionFooterHeight = 0.001;
    _tableView.estimatedRowHeight = 50;
    
    [_tableView registerNib:[UINib nibWithNibName:@"ActivityInputCell" bundle:nil] forCellReuseIdentifier:@"ActivityInputCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"ActivityChooseCell" bundle:nil] forCellReuseIdentifier:@"ActivityChooseCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"ApplyCostCell" bundle:nil] forCellReuseIdentifier:@"ApplyCostCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"ActivityDetailsDescriptionCell" bundle:nil] forCellReuseIdentifier:@"ActivityDetailsDescriptionCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"ActivityPeopleCell" bundle:nil] forCellReuseIdentifier:@"ActivityPeopleCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"AllowRecommendCell" bundle:nil] forCellReuseIdentifier:@"AllowRecommendCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"ActivityLabelCell" bundle:nil] forCellReuseIdentifier:@"ActivityLabelCell"];
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    self.posterHeaderView = [[[NSBundle mainBundle]loadNibNamed:@"AddPosterHeaderView" owner:self options:nil] firstObject];
    self.posterHeaderView.frame = CGRectMake(0, 0, YGScreenWidth, YGScreenWidth * 0.5);
    _tableView.tableHeaderView = self.posterHeaderView;
    [self.posterHeaderView.addPosterButton addTarget:self action:@selector(addPoster:) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *aggrementView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, YGScreenWidth, 50)];
    UIButton *checkButton = [UIButton buttonWithType:UIButtonTypeCustom];
    checkButton.frame = CGRectMake(15, 10, 20, 20);
    checkButton.tag = 1994;
    [checkButton setImage:[UIImage imageNamed:@"nochoice_btn_gray"] forState:UIControlStateNormal];
    [checkButton setImage:[UIImage imageNamed:@"choice_btn_green"] forState:UIControlStateSelected];
    [checkButton addTarget:self action:@selector(isAgreeClick:) forControlEvents:UIControlEventTouchUpInside];
    [aggrementView addSubview:checkButton];
    
    UILabel *alreadyLabel = [[UILabel alloc]initWithFrame:CGRectMake(30, 10, 90, 20)];
    alreadyLabel.text = @"已阅读并同意";
    alreadyLabel.textAlignment = NSTextAlignmentRight;
    alreadyLabel.textColor = colorWithDeepGray;
    alreadyLabel.font = [UIFont systemFontOfSize:13.0];
    [aggrementView addSubview:alreadyLabel];
    
    UIButton *agreementButton = [UIButton buttonWithType:UIButtonTypeCustom];
    agreementButton.frame = CGRectMake(120, 10, 180, 20);
    agreementButton.titleLabel.font = [UIFont systemFontOfSize:13.0];
    agreementButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [agreementButton setTitleColor:colorWithMainColor forState:UIControlStateNormal];
    [agreementButton setTitle:@"《青网服务协议》" forState:UIControlStateNormal];
    [agreementButton addTarget:self action:@selector(agreementButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [aggrementView addSubview:agreementButton];
    
    _tableView.tableFooterView = aggrementView;
    
    [self loadActivityTagData];
    
}

-(void)loadActivityTagData
{
    [YGNetService YGPOST:@"getActiveTag" parameters:@{} showLoadingView:YES scrollView:_tableView success:^(id responseObject) {
        
        NSLog(@"%@",responseObject);
        
        self.activityTagArray = responseObject[@"tList"];
        
        self.labelView = [self text];
        
        [_tableView reloadData];
        
    } failure:^(NSError *error) {
        
    }];
}

-(void)loadPercentData
{
    [YGNetService YGPOST:@"getAdvancePercent" parameters:@{} showLoadingView:YES scrollView:_tableView success:^(id responseObject) {
        
        NSLog(@"%@",responseObject);
        
        self.advancePercent = responseObject[@"advancePercent"];
        
        self.applyFundsView = [[[NSBundle mainBundle]loadNibNamed:@"ApplyAdvanceFundsView" owner:self options:nil]firstObject];
        self.applyFundsView.frame = CGRectMake(0, YGScreenHeight - YGScreenWidth * 0.74 - YGNaviBarHeight - YGStatusBarHeight, YGScreenWidth, YGScreenWidth * 0.74);
        self.applyFundsView.percentWarnLabel.text = [NSString stringWithFormat:@"*最多预支活动经费金额%@%%",self.advancePercent];
        [self.applyFundsView.cancelApplyButton addTarget:self action:@selector(applyCancel:) forControlEvents:UIControlEventTouchUpInside];
        self.applyFundsView.confirmApplyButton.backgroundColor = colorWithDeepGray;
        self.applyFundsView.confirmApplyButton.userInteractionEnabled = NO;
        self.applyFundsView.allFundsTextField.delegate = self;
        self.applyFundsView.fundsPercentTextField.delegate = self;
        [self.view addSubview:self.blackView];
        [self.blackView addSubview:self.applyFundsView];
        
    } failure:^(NSError *error) {
        
    }];
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if((indexPath.section == 0 && indexPath.row == 0 )||(indexPath.section == 0 && indexPath.row ==3)||(indexPath.section == 1 && indexPath.row == 1))
    {
        ActivityInputCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ActivityInputCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (indexPath.section == 0) {
            cell.nameLabel.text = self.titleArray[indexPath.row];
        }else
        {
            cell.nameLabel.text = self.titleArray[6+indexPath.row];
            cell.inputTextField.placeholder = @"默认无限制";
            cell.inputTextField.keyboardType = UIKeyboardTypePhonePad;
        }
        cell.inputTextField.delegate = self;
        return cell;
    }
    if ((indexPath.section == 0 && indexPath.row == 1) || (indexPath.section == 0 && indexPath.row == 2) || (indexPath.section == 1 && indexPath.row == 0) || (indexPath.section == 1 && indexPath.row == 2))
    {
        ActivityChooseCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ActivityChooseCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        if (indexPath.section == 0) {
            cell.nameLabel.text = self.titleArray[indexPath.row];
        }else
        {
            cell.nameLabel.text = self.titleArray[6+indexPath.row];
        }
        return cell;
    }

    if (indexPath.section == 0 && indexPath.row == 4)
    {
        ApplyCostCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ApplyCostCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.inputTextField.keyboardType = UIKeyboardTypePhonePad;
        cell.inputTextField.delegate = self;
        return cell;
    }
    if (indexPath.section == 0 && indexPath.row == 5)
    {
        ActivityDetailsDescriptionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ActivityDetailsDescriptionCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    if (indexPath.section == 1 && indexPath.row == 3)
    {
        ActivityLabelCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ActivityLabelCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        cell.showView = labelView;
        [cell.showView addSubview:self.labelView];
        cell.showView.frame = self.labelView.frame;
        _labelRowHeight = self.labelView.frame.size.height;
        return cell;
    }
    if (indexPath.section == 1 && indexPath.row == 4) {
        ActivityPeopleCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ActivityPeopleCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (cell.onlyseeButton.selected == NO) {
            cell.allseeButton.selected = YES;
            cell.onlyseeButton.selected = NO;
            self.activityPeople = @"0";
        }
        [cell.allseeButton addTarget:self action:@selector(activityPeopleChoose:) forControlEvents:UIControlEventTouchUpInside];
        [cell.onlyseeButton addTarget:self action:@selector(activityPeopleChoose:) forControlEvents:UIControlEventTouchUpInside];
        
        return cell;
    }
    AllowRecommendCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AllowRecommendCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell.questionButton addTarget:self action:@selector(Question:) forControlEvents:UIControlEventTouchUpInside];
    [cell.isAllowSwitch addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
    return cell;
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 6;
    }
    return 6;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0 && indexPath.row == 5)
    {
        return YGScreenWidth * 0.37;
    }
    if (indexPath.section == 1 && indexPath.row == 3)
    {
        return _labelRowHeight + 45;
    }
    return 50;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view;
    view.backgroundColor = colorWithTable;
    return view;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ((indexPath.section == 0 && indexPath.row == 1) || (indexPath.section == 0 && indexPath.row == 2))
    {
        [self.view addSubview:self.blackView];
        
        self.datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0,YGScreenHeight - 300,YGScreenWidth,300)];
        self.datePicker.backgroundColor = [UIColor whiteColor];
        self.datePicker.datePickerMode = UIDatePickerModeDateAndTime;
        self.datePicker.locale = [NSLocale localeWithLocaleIdentifier:@"zh_CN"];
        NSDate *minDate = [self.datePicker date];        // 获取当前时间作为最大显示时间
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
        self.datePicker.minimumDate = minDate;       // picker中最小时间
//        [datePicker addTarget:self action:@selector(dateChange:) forControlEvents:UIControlEventValueChanged];
        
        self.dateTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(60, 0, YGScreenWidth - 120, 45)];
        self.dateTitleLabel.textAlignment = NSTextAlignmentCenter;
        self.dateTitleLabel.font = [UIFont systemFontOfSize:15.0];
        if(indexPath.row == 1)
        {
            self.dateTitleLabel.text = @"活动开始时间";
        }else
        {
            self.dateTitleLabel.text = @"活动结束时间";
        }
        [self.datemenuView addSubview:self.dateTitleLabel];
        [self.blackView addSubview:self.datemenuView];
        [self.blackView addSubview:self.datePicker];
    }
    if(indexPath.section == 0 && indexPath.row == 5)
    {
        ActivityDetailsViewController *vc = [[ActivityDetailsViewController alloc]init];
        if(self.detailString.length)
        {
            vc.detailString = self.detailString;
            vc.detailPicArray = self.detailPicArray;
        }
        vc.delegate = self;
        [self.navigationController pushViewController:vc animated:YES];
    }
    
    if (indexPath.section == 1 && indexPath.row == 0) {
        
        [self loadPercentData];
    }
    if (indexPath.section == 1 && indexPath.row == 2) {
       
        if (!self.endTimeString.length) {
            [YGAppTool showToastWithText:@"请选择活动结束时间"];
            return ;
        }
        ApplySetupViewController *vc = [[ApplySetupViewController alloc]init];
        vc.endTimeString = self.endTimeString;
        if(self.selectEndTimeString.length)
        {
            vc.selectEndTimeString = self.selectEndTimeString;
            vc.selectArray = self.selectArray;
        }
        vc.delegate = self;
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}
//报名设置协议方法
-(void)passSelectArray:(NSMutableArray *)selectArray andSelectTimeString:(NSString *)timeString
{
    NSLog(@"%@",selectArray);
    NSLog(@"%@",timeString);
    
    self.selectArray = selectArray;//设置报名活动标签的数组
    self.selectEndTimeString = timeString;
    
    ActivityChooseCell *applyCell = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:1]];//报名设置
    applyCell.showLabel.text = @"已设置";
}
//活动详情描述协议方法
-(void)passdetailString:(NSString *)detailString andArray:(NSArray *)detailPicArray
{
    NSLog(@"%@",detailString);
    NSLog(@"%@",detailPicArray);
    
    self.detailPicArray = [NSMutableArray array];
    self.detailString = detailString;
    self.detailPicArray = (NSMutableArray *)detailPicArray;
    
    ActivityDetailsDescriptionCell *detailCell = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:5 inSection:0]];//报名设置
    detailCell.showLabel.text = detailString;
    [detailCell.showLabel sizeToFit];
    
}


//是否允许青友推荐开关
-(void)switchAction:(UISwitch *)sender
{
    if([sender isOn])
    {
        self.allowRecommend = @"1";
    }
    else
    {
        self.allowRecommend = @"0";
    }
}


//添加海报
-(void)addPoster:(UIButton *)button
{
    UIActionSheet *act = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"拍照" otherButtonTitles:@"从手机选择", nil];
    [act showInView:self.view];

}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    // 创建并弹出警示框, 选择获取图片的方式(相册和通过相机拍照)
    // 创建UIImagePickerController实例
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    // 设置代理
    imagePickerController.delegate = self;
    // 是否允许编辑（默认为NO）
    imagePickerController.allowsEditing = YES;
    
    // 创建一个警告控制器
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"选取图片" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    // 设置警告响应事件
    UIAlertAction *cameraAction = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        // 设置照片来源为相机
        imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
        // 设置进入相机时使用前置或后置摄像头
        imagePickerController.cameraDevice = UIImagePickerControllerCameraDeviceRear;
        // 展示选取照片控制器
        [self presentViewController:imagePickerController animated:YES completion:^{}];
    }];
    
    // 判断是否支持相机
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        // 添加警告按钮
        [alert addAction:cameraAction];
    }
    if (buttonIndex == 0)
    {
        // 设置照片来源为相机
        imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
        // 设置进入相机时使用前置或后置摄像头
        imagePickerController.cameraDevice = UIImagePickerControllerCameraDeviceRear;
        // 展示选取照片控制器
        [self presentViewController:imagePickerController animated:YES completion:^{}];
        
    }
    if (buttonIndex == 1) {
        imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:imagePickerController animated:YES completion:^{}];
        
    }
}


#pragma mark - UIImagePickerControllerDelegate
// 完成图片的选取后调用的方法
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    // 选取完图片后跳转回原控制器
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    // 从info中将图片取出，并加载到imageView当中
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    //    [self handlePicturedata];
    self.posterHeaderView.posterImageView.image = image;
    self.posterHeaderView.addPosterButton.hidden = YES;
    self.selectImage = image;
}

// 取消选取调用的方法
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:nil];
}

//是否已阅读并同意《青网服务协议》
-(void)isAgreeClick:(UIButton *)button
{
    button.selected = !button.selected;
}
//时间选择器上的取消按钮
-(void)cancelClick:(UIButton *)button
{
    [self.dateTitleLabel removeFromSuperview];
    [self.datemenuView removeFromSuperview];
    [self.datePicker removeFromSuperview];
    [self.blackView removeFromSuperview];
}
//时间选择器上的确定按钮
-(void)confirmClick:(UIButton *)button
{
    NSDate *theDate = self.datePicker.date;
    NSLog(@"%@",[theDate descriptionWithLocale:[NSLocale currentLocale]]);
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"YYYY-MM-dd HH:mm";
    NSString *selectDateString = [dateFormatter stringFromDate:theDate];
    
    ActivityChooseCell *begincell = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    ActivityChooseCell *endcell = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
    
    if ([self.dateTitleLabel.text isEqualToString:@"活动开始时间"]) {
        begincell.showLabel.text = selectDateString;
        self.beginTimeString = begincell.showLabel.text;
    }else
    {
        endcell.showLabel.text = selectDateString;
        self.endTimeString = endcell.showLabel.text;
    }
    
    if(begincell.showLabel.text.length && endcell.showLabel.text.length)
    {
        NSDate *begindate = [dateFormatter dateFromString:begincell.showLabel.text];
        NSDate *enddate = [dateFormatter dateFromString:endcell.showLabel.text];
        NSInteger compare = [self compareOneDay:begindate withAnotherDay:enddate];
        if (compare == 1) {
            [YGAppTool showToastWithText:@"选择的开始时间不能大于结束时间,请重新选择!"];
            if ([self.dateTitleLabel.text isEqualToString:@"活动开始时间"]) {
                begincell.showLabel.text = @"";
                self.beginTimeString = @"";
            }else
            {
                endcell.showLabel.text = @"";
                self.endTimeString = @"";
            }
        }
    }
    
//    if(begincell.showLabel.text.length && endcell.showLabel.text.length)
//    {
//        NSDate *begindate = [dateFormatter dateFromString:begincell.showLabel.text];
//        NSDate *enddate = [dateFormatter dateFromString:endcell.showLabel.text];
//        NSInteger compare = [self compareOneDay:begindate withAnotherDay:enddate];
//        if (compare == 1) {
//            NSString *changeString;
//            changeString = begincell.showLabel.text;
//            begincell.showLabel.text = endcell.showLabel.text;
//            endcell.showLabel.text = changeString;
//            self.beginTimeString = begincell.showLabel.text;
//            self.endTimeString = endcell.showLabel.text;
//        }
//    }
    if (self.selectEndTimeString.length) {
        [YGAlertView showAlertWithTitle:@"您修改了活动结束时间,请去报名设置里面重新修改报名截止时间,如您不去修改,报名截止时间将默认为活动结束时间！" buttonTitlesArray:@[@"取消",@"确定"] buttonColorsArray:@[colorWithBlack,colorWithMainColor] handler:^(NSInteger buttonIndex) {
            if (buttonIndex == 0) {
                return ;
            }else
            {
                return ;
            }
        }];
        self.selectEndTimeString = self.endTimeString;
    }
    
    [self.dateTitleLabel removeFromSuperview];
    [self.datemenuView removeFromSuperview];
    [self.datePicker removeFromSuperview];
    [self.blackView removeFromSuperview];
}

//选择活动人群
-(void)activityPeopleChoose:(UIButton *)button
{
    ActivityPeopleCell *cell = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:4 inSection:1]];
    cell.allseeButton.selected = NO;
    cell.onlyseeButton.selected = NO;
    button.selected = YES;
    if (button == cell.allseeButton) {
        self.activityPeople = @"0";
    }
    else
    {
        self.activityPeople = @"1";
    }
}

//关于青友推荐
-(void)Question:(UIButton *)button
{
    AboutRecommendController *vc = [[AboutRecommendController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

-(UIView *)text{
    UIView *labelView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, YGScreenWidth, 100)];
    labelView.backgroundColor = [UIColor whiteColor];
    NSInteger toLeft = 0;
//    NSArray *array = [NSArray arrayWithObjects:@"潮玩",@"旅游",@"骑行",@"演唱会",@"电竞",@"越野",@"厨艺赛",@"运动",@"漂流",@"其他", nil];
    NSMutableArray *mutableArray = [NSMutableArray array];
    for (int i = 0; i < self.activityTagArray.count; i++) {
        [mutableArray addObject:[self.activityTagArray[i] valueForKey:@"tagName"]];
    }
    NSArray *array = mutableArray;
    
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
        button.tag = 100+i;
        [button addTarget:self action:@selector(titleChooseChangeContentAction:) forControlEvents:UIControlEventTouchUpInside];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 30)];
        label.font = [UIFont systemFontOfSize:YGFontSizeSmallOne];
        label.text = array[i];
        label.textColor = colorWithMainColor;
        [label sizeToFit];
        
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
        button.layer.borderColor = colorWithLightGray.CGColor;
        button.layer.borderWidth = 1;
        k++;
        
        [labelView addSubview:button];
    }
    labelView.frame = CGRectMake(0, 0, YGScreenWidth, 10+35*(j+1));
    return labelView;
}

-(int)compareOneDay:(NSDate *)oneDay withAnotherDay:(NSDate *)anotherDay
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-MM-dd HH:mm"];
    NSString *oneDayStr = [dateFormatter stringFromDate:oneDay];
    NSString *anotherDayStr = [dateFormatter stringFromDate:anotherDay];
    NSDate *dateA = [dateFormatter dateFromString:oneDayStr];
    NSDate *dateB = [dateFormatter dateFromString:anotherDayStr];
    NSComparisonResult result = [dateA compare:dateB];
    if (result == NSOrderedDescending) {
        //NSLog(@"oneDay比 anotherDay时间晚");
        return 1;
    }
    else if (result == NSOrderedAscending){
        //NSLog(@"oneDay比 anotherDay时间早");
        return -1;
    }
    //NSLog(@"两者时间是同一个时间");
    return 0;
}

//申请预支经费取消
-(void)applyCancel:(UIButton *)button
{
    [self.blackView removeFromSuperview];
}
//申请预支经费确定
-(void)applyConfirm:(UIButton *)button
{
    self.allFunds = self.applyFundsView.allFundsTextField.text;
    self.fundsPercent = self.applyFundsView.fundsPercentTextField.text;
    ActivityChooseCell *fundsCell = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];//预支经费
    NSInteger cost = [self.allFunds integerValue] * [self.fundsPercent intValue] / 100;
    fundsCell.showLabel.text = [NSString stringWithFormat:@"%ld",cost];
    [self.blackView removeFromSuperview];
}

//点击选择标签
-(void)titleChooseChangeContentAction:(UIButton *)button
{
//    NSArray *array = [NSArray arrayWithObjects:@"潮玩",@"旅游",@"骑行",@"演唱会",@"电竞",@"越野",@"厨艺赛",@"运动",@"漂流",@"其他", nil];
    NSMutableArray *mutableArray = [NSMutableArray array];
    for (int i = 0; i < self.activityTagArray.count; i++) {
        [mutableArray addObject:[self.activityTagArray[i] valueForKey:@"tagName"]];
    }
    NSArray *array = mutableArray;
    
    for (int i = 0; i < array.count; i++) {
        UIButton *abutton = [self.view viewWithTag:100 + i];
        abutton.selected = NO;
        abutton.layer.borderColor = colorWithLightGray.CGColor;
    }
    button.selected = !button.selected;
    if (button.selected == YES) {
        button.layer.borderColor = colorWithMainColor.CGColor;
        self.activityTag = [self.activityTagArray[button.tag - 100] valueForKey:@"id"];
    }
    else
    {
        button.layer.borderColor = colorWithLightGray.CGColor;
    }
}

-(void)back
{
    [YGAlertView showAlertWithTitle:@"确认放弃发布活动吗？" buttonTitlesArray:@[@"取消",@"确定"] buttonColorsArray:@[colorWithBlack,colorWithMainColor] handler:^(NSInteger buttonIndex) {
        if (buttonIndex == 0) {
            return ;
        }else
        {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    ApplyCostCell *costCell = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:4 inSection:0]];
    if (textField == costCell.inputTextField && [_isCostOnce isEqualToString:@"0"]) {
        [YGAlertView showAlertWithTitle:@"收取的费用暂存青网账户,活动结束,后台确定后打入您的账户！" buttonTitlesArray:@[@"确定"] buttonColorsArray:@[colorWithMainColor] handler:^(NSInteger buttonIndex) {
            if (buttonIndex == 0) {
                _isCostOnce = @"1";
                return ;
            }
        }];
    }
    
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    //预支经费
    if (textField == self.applyFundsView.allFundsTextField || textField == self.applyFundsView.fundsPercentTextField) {
        
        NSInteger isSmall = [self.advancePercent integerValue] >= [self.applyFundsView.fundsPercentTextField.text integerValue]?1:0;
        
        if (self.applyFundsView.allFundsTextField.text.length && self.applyFundsView.fundsPercentTextField.text.length && isSmall) {
            
            self.applyFundsView.confirmApplyButton.backgroundColor = colorWithMainColor;
            self.applyFundsView.confirmApplyButton.userInteractionEnabled = YES;
            [self.applyFundsView.confirmApplyButton addTarget:self action:@selector(applyConfirm:) forControlEvents:UIControlEventTouchUpInside];
            
        }
        else
        {
            self.applyFundsView.confirmApplyButton.backgroundColor = colorWithDeepGray;
            self.applyFundsView.confirmApplyButton.userInteractionEnabled = NO;
        }
        
    }
    ActivityInputCell *themeCell = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];//活动主题
    if (textField == themeCell.inputTextField)
    {
        UITextRange *selectedRange = [themeCell.inputTextField markedTextRange];
        //获取高亮部分
        UITextPosition *pos = [themeCell.inputTextField positionFromPosition:selectedRange.start offset:0];
        //如果在变化中是高亮部分在变，就不要计算字符了
        if (selectedRange && pos) {
            return;
        }
        if ( (unsigned long)themeCell.inputTextField.text.length > 30) {
            //        对超出的部分进行剪切
            themeCell.inputTextField.text = [themeCell.inputTextField.text substringToIndex:30];
        }
        self.activitytheme = themeCell.inputTextField.text;//活动主题
    }
    ActivityInputCell *siteCell = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]];//活动地点
    if (textField == siteCell.inputTextField)
    {
        self.activitysite = siteCell.inputTextField.text;//活动地点
    }
    ActivityInputCell *peopleNumberCell = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:1]];//名额限制
    if (textField == peopleNumberCell.inputTextField)
    {
        self.peoplelimit = peopleNumberCell.inputTextField.text;//名额限制
    }
    ApplyCostCell *costCell = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:4 inSection:0]];//报名费用
    if (textField == costCell.inputTextField)
    {
        self.applyfee = costCell.inputTextField.text;//报名费用
    }
    
    
    
}

//提交
-(void)submitInfo:(UIButton *)button
{
    ActivityDetailsDescriptionCell *detailCell = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:5 inSection:0]];//活动详情描述
    UIButton *checkButton = [self.view viewWithTag:1994];
    if (checkButton.selected == NO) {
        [YGAppTool showToastWithText:@"请勾选《青网服务协议》!"];
        return ;
    }
    
    if (!self.selectImage) {
        [YGAppTool showToastWithText:@"请添加活动海报!"];
        return ;
    }
    if (!self.activitytheme.length) {
        [YGAppTool showToastWithText:@"请输入活动主题!"];
        return ;
    }
    if (!self.beginTimeString.length) {
        [YGAppTool showToastWithText:@"请选择活动开始时间!"];
        return ;
    }
    if (!self.endTimeString.length) {
        [YGAppTool showToastWithText:@"请选择活动结束时间!"];
        return ;
    }
    if (!self.activitysite.length) {
        [YGAppTool showToastWithText:@"请输入活动举办地点!"];
        return ;
    }
    if (!self.applyfee.length) {
        [YGAppTool showToastWithText:@"请输入报名费用!"];
        return ;
    }
    if (!detailCell.showLabel.text.length) {
        [YGAppTool showToastWithText:@"请输入活动详情描述!"];
        return ;
    }
    if (!self.selectEndTimeString.length) {
        [YGAppTool showToastWithText:@"请填写报名设置!"];
        return ;
    }
    if (!self.activityTag.length) {
        [YGAppTool showToastWithText:@"请选择活动标签!"];
        return ;
    }

    [YGAlertView showAlertWithTitle:@"确定发布活动吗?" buttonTitlesArray:@[@"取消",@"确定"] buttonColorsArray:@[colorWithBlack,colorWithMainColor] handler:^(NSInteger buttonIndex) {
        if (buttonIndex == 0) {
            return ;
        }else
        {
            [YGNetService showLoadingViewWithSuperView:YGAppDelegate.window];
            
            [UploadImageTool uploadImage:self.selectImage progress:^(NSString *key, float percent) {
                
            } success:^(NSString *url) {
                
                if (self.detailPicArray.count) {
                    [UploadImageTool uploadImages:self.detailPicArray progress:^(CGFloat progress) {
                        
                    } success:^(NSArray *urlArray) {
                        
                        NSString *imgString = [urlArray componentsJoinedByString:@","];
                        
                        [self uploadInformation:url andManyImgString:imgString];
                        
                    } failure:^{
                        NSLog(@"传图失败");
                        [YGNetService dissmissLoadingView];
                        
                    }];
                }
                else
                {
                    [self uploadInformation:url andManyImgString:nil];
                }
                
            } failure:^{
                NSLog(@"传图失败");
            }];
        }
        
    }];
}

-(void)uploadInformation:(NSString *)url andManyImgString:(NSString *)imgString;
{
    if (!self.allFunds.length) {
        self.allFunds = @"";
    }
    if (!self.fundsPercent.length) {
        self.fundsPercent = @"";
    }
    if (!self.peoplelimit.length) {
        self.peoplelimit = @"";
    }
    if ([self.peoplelimit integerValue] > 100000) {
        [YGAppTool showToastWithText:@"报名人数过多!"];
        return;
    }
    if (!imgString.length) {
        imgString = @"";
    }
    
    if (self.selectArray.count) {
        [self.selectArray removeObjectAtIndex:0];
        [self.selectArray removeObjectAtIndex:0];
    }
    //数组转成json传给后台
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self.selectArray options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonArrayString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    NSLog(@"%@",YGSingletonMarco.user.userId);
    
    
    [YGNetService YGPOST:@"addActive" parameters:@{@"userId":YGSingletonMarco.user.userId,@"name":self.activitytheme,@"coverUrl":url,@"beginTime":self.beginTimeString,@"endTime":self.endTimeString,@"address":self.activitysite,@"price":self.applyfee,@"advancePrice":self.allFunds,@"advancePercent":self.fundsPercent,@"manyUrl":imgString,@"detial":self.detailString,@"personCount":self.peoplelimit,@"tag":self.activityTag,@"visibility":self.activityPeople,@"isRecommend":self.allowRecommend,@"allianceId":self.allianceID,@"messages":jsonArrayString,@"cutTime":self.selectEndTimeString} showLoadingView:YES scrollView:_tableView success:^(id responseObject) {
        [YGNetService dissmissLoadingView];
        
        NSLog(@"%@",responseObject);
        
        [YGAlertView showAlertWithTitle:@"您的活动申请已进入平台审核,我们会在第一时间为您处理,并以短信通知您!" buttonTitlesArray:@[@"确定"] buttonColorsArray:@[colorWithMainColor] handler:^(NSInteger buttonIndex) {
            if (buttonIndex == 0) {
                
                [self.navigationController popViewControllerAnimated:YES];
                
            }
        }];
        
    } failure:^(NSError *error) {
        [YGNetService dissmissLoadingView];
        NSLog(@"提交失败");
    }];
}

-(void)agreementButtonClick:(UIButton *)button
{
    PlayTogetherAgreementController *vc = [[PlayTogetherAgreementController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

@end
