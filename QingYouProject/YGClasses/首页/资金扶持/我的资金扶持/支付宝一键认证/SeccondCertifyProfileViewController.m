//
//  SeccondCertifyProfileViewController.m
//  QingYouProject
//
//  Created by nefertari on 2017/12/14.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "SeccondCertifyProfileViewController.h"
#import "CrowdFundingAddProjectModel.h"
#import "CrowdFundingAddProjectTableViewCell.h"
#import "YGPickerView.h"
//#import "SeccondHandExchangeChooseTypeViewController.h"

//#import "SeccondHandExchangeViewController.h"
//#import "BabyDetailsController.h"

@interface SeccondCertifyProfileViewController ()<UITableViewDelegate,UITableViewDataSource,UIActionSheetDelegate,CrowdFundingAddProjectTableViewCellDelegate>

@end

@implementation SeccondCertifyProfileViewController
{
    NSMutableArray *_listArray;
    UITableView *_tableView;
    UIButton *_applyButton;
    UIButton *_confirmRealButton;
    NSString *_sexString;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self configUI];
}

- (void)configAttribute
{
    self.fd_interactivePopDisabled = YES;
    self.naviTitle = @"基本资料";
    UIButton *submitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    submitButton.frame = CGRectMake(0, 0, 35, 35);
    [submitButton setTitleColor:colorWithMainColor forState:UIControlStateNormal];
    [submitButton setTitle:@"提交" forState:normal];
    submitButton.titleLabel.font = [UIFont systemFontOfSize:15.0];
    [submitButton addTarget:self action:@selector(submitInfo) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightButtonItem = [[UIBarButtonItem alloc] initWithCustomView:submitButton];
    self.navigationItem.rightBarButtonItem = rightButtonItem;
    _listArray = [[NSMutableArray alloc] init];
}
- (void)back
{
    
    [YGAlertView showAlertWithTitle:@"返回上一页将不保存当前填写的信息，确定返回吗？" buttonTitlesArray:@[@"取消",@"确定"] buttonColorsArray:@[colorWithLightGray,colorWithMainColor] handler:^(NSInteger buttonIndex) {
        if (buttonIndex == 1) {
        
            if ([self.pageType isEqualToString:@"SeccondHandExchangeMain"] || [self.pageType isEqualToString:@"SeccondHandExchangeCertify"]) {
                //返回首页
                UINavigationController *navc = self.navigationController;
                NSMutableArray *viewControllers = [[NSMutableArray alloc] init];
                for (UIViewController *vc in [navc viewControllers]) {
                    [viewControllers addObject:vc];
//                    if ([vc isKindOfClass:[SeccondHandExchangeViewController class]]) {
//                        break;
//                    }
                }
                [navc setViewControllers:viewControllers];
            }
           
            if ([self.pageType isEqualToString:@"addSeccondHandExchange"]) {
                //返回首页
                UINavigationController *navc = self.navigationController;
                NSMutableArray *viewControllers = [[NSMutableArray alloc] init];
                for (UIViewController *vc in [navc viewControllers]) {
                    [viewControllers addObject:vc];
//                    if ([vc isKindOfClass:[BabyDetailsController class]]) {
//                        break;
//                    }
                }
                [navc setViewControllers:viewControllers];
            }
            
        }
    }];
}
- (void)configUI
{
    NSArray * titlesArr = @[
                            
                            @[
                                @{
                                    @"title":@"姓名",
                                    @"content":@"请填写姓名"
                                    },
                                @{
                                    @"title":@"性别",
                                    @"content":@"请选择性别"
                                    },
                                @{
                                    @"title":@"手机号",
                                    @"content":@"请填写手机号"
                                    },
                                @{
                                    @"title":@"电子邮箱",
                                    @"content":@"请填写电子邮箱"
                                    },
                                ]
                            
                            ];
    [_listArray addObjectsFromArray:[CrowdFundingAddProjectModel mj_objectArrayWithKeyValuesArray:titlesArr]];
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, YGScreenWidth, YGScreenHeight-64-45) style:UITableViewStyleGrouped];
    _tableView.backgroundColor = colorWithTable;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0.001)];
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0.001)];
    _tableView.sectionFooterHeight = 0.001;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    [_tableView registerClass:[CrowdFundingAddProjectTableViewCell class] forCellReuseIdentifier:@"CrowdFundingAddProjectTableViewCelllabel"];
    
    [_tableView registerClass:[CrowdFundingAddProjectTableViewCell class] forCellReuseIdentifier:@"CrowdFundingAddProjectTableViewCelltextfield"];
    
    
    
    [self.view addSubview:_tableView];
    
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, YGScreenHeight-YGStatusBarHeight-YGNaviBarHeight-45, YGScreenWidth, 45)];
    bottomView.backgroundColor = colorWithYGWhite;
    [self.view addSubview:bottomView];
    
    _confirmRealButton = [[UIButton alloc]initWithFrame:CGRectMake(10,10,100,25)];
    [_confirmRealButton setImage:[UIImage imageNamed:@"nochoice_btn_gray"] forState:UIControlStateNormal];
    [_confirmRealButton setImage:[UIImage imageNamed:@"order_choice_btn_green"] forState:UIControlStateSelected];
    [_confirmRealButton setTitle:@"本人保证所填写的内容属实" forState:UIControlStateNormal];
    [_confirmRealButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    [_confirmRealButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 5, 0, -20)];
    [_confirmRealButton setTitleColor:colorWithDeepGray forState:UIControlStateNormal];
    [_confirmRealButton addTarget:self action:@selector(defultButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    _confirmRealButton.titleLabel.font = [UIFont systemFontOfSize:YGFontSizeNormal];
    [_confirmRealButton sizeToFit];
    [bottomView addSubview:_confirmRealButton];
    _confirmRealButton.frame = CGRectMake(10,_confirmRealButton.y,_confirmRealButton.width+20,30);
    _confirmRealButton.selected = NO;
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return [(NSArray *)_listArray[section] count];
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _listArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CrowdFundingAddProjectTableViewCell *cell;
    if ((indexPath.section == 0 && indexPath.row == 1)||(indexPath.section == 1 && indexPath.row == 1))
    {
        cell = [tableView dequeueReusableCellWithIdentifier:@"CrowdFundingAddProjectTableViewCelllabel" forIndexPath:indexPath];
    }else
    {
        cell = [tableView dequeueReusableCellWithIdentifier:@"CrowdFundingAddProjectTableViewCelltextfield" forIndexPath:indexPath];
        
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    CrowdFundingAddProjectModel *model = _listArray[indexPath.section][indexPath.row];
    if (indexPath.section == 1 && indexPath.row == 1 && model.image == nil) {
        model.image = YGDefaultImgSquare;
    }
    cell.needReturnIndexPath = YES;
    cell.delegate = self;
    [cell setModel:model withIndexPath:indexPath];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1 && indexPath.row == 1) {
        return 80;
    }
    return 50;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0;
    }
    return 10;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _applyButton.userInteractionEnabled = YES;
    CrowdFundingAddProjectModel *model = _listArray[indexPath.section][indexPath.row];
    if (indexPath.section == 0 && indexPath.row == 1)
    {
        YGPickerView *pickerView = [YGPickerView showWithPickerViewDataSource:@[ @"男",@"女"] titleString:@"请选择" handler:^(NSInteger selectedRow, NSString *selectedString){
            //            _sexString = [NSString stringWithFormat:@"%ld",selectedRow+1];
            _sexString = selectedString;
            model.content = selectedString;
            [_tableView reloadData];
        }];
        if (![model.content containsString:@"请选择"]) {
            [pickerView selectWithTitleString:model.content];
        }
    }
}

- (void)textfieldReturnValue:(NSString *)value withTextIndexPath:(NSIndexPath *)indexPath
{
    CrowdFundingAddProjectModel *model;
    model = _listArray[indexPath.section][indexPath.row];
    model.content = value;
    [_tableView reloadData];
}
- (void)submitInfo
{
    if (![self loginOrNot])
    {
        return;
    }
    //公司名称可选  头像可选  视频已上传
    CrowdFundingAddProjectModel *nameModel = _listArray[0][0];
    CrowdFundingAddProjectModel *identifyNumberModel = _listArray[0][2];
    CrowdFundingAddProjectModel *emailModel = _listArray[0][3]; //选填
    
    
    if ([nameModel.content isEqualToString:@"请填写"])
    {
        [YGAppTool showToastWithText:@"请填写姓名"];
        _applyButton.userInteractionEnabled = YES;
        [YGNetService dissmissLoadingView];
        
        return ;
    }
    
    if (_sexString == nil || [_sexString isEqualToString:@""])
    {
        [YGAppTool showToastWithText:@"请选择性别"];
        _applyButton.userInteractionEnabled = YES;
        [YGNetService dissmissLoadingView];
        
        return ;
    }
    
    if ([YGAppTool isNotPhoneNumber:identifyNumberModel.content])
    {
        return ;
    }
    
    
    if ([emailModel.content isEqualToString:@"请填写"] || [YGAppTool isNotEmail:emailModel.content])
    {
        _applyButton.userInteractionEnabled = YES;
        [YGNetService dissmissLoadingView];
        
        return ;
    }
    if (_confirmRealButton.selected != YES) {
        [YGAppTool showToastWithText:@"请确认并勾选“本人保证所填写的内容属实”按钮"];
        return;
    }
    
    [self startPostWithURLString:REQUEST_ReplacementInformation parameters:@{@"name":nameModel.content,@"phone":identifyNumberModel.content,@"email":emailModel.content,@"userId":YGSingletonMarco.user.userId,@"gender":_sexString} showLoadingView:NO scrollView:nil];
    
}
- (void)didReceiveSuccessResponeseWithURLString:(NSString *)URLString parameters:(id)parameters responeseObject:(id)responseObject
{
  //从哪个页面进来的 @“SeccondHandExchangeMain” 首页  @“SeccondHandExchangeCertify” 认证页面 @"SeccondHandExchangePublish" 发布页面  @“SeccondHandExchangeMainSearch” 首页进来搜索
    [YGAppTool showToastWithText:@"恭喜您认证成功"];
    if ([self.pageType isEqualToString:@"SeccondHandExchangeMain"]) {
        //返回首页
        UINavigationController *navc = self.navigationController;
        NSMutableArray *viewControllers = [[NSMutableArray alloc] init];
        for (UIViewController *vc in [navc viewControllers]) {
            [viewControllers addObject:vc];
//            if ([vc isKindOfClass:[SeccondHandExchangeViewController class]]) {
//                break;
//            }
        }
        [navc setViewControllers:viewControllers];
    }
    if ([self.pageType isEqualToString:@"SeccondHandExchangeCertify"]) {
        NSInteger index = [[self.navigationController viewControllers] indexOfObject:self];
        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:index - 3]animated:YES];
    }
//    if ([self.pageType isEqualToString:@"addSeccondHandExchange"]) {
//        //返回首页
//        UINavigationController *navc = self.navigationController;
//        NSMutableArray *viewControllers = [[NSMutableArray alloc] init];
//        for (UIViewController *vc in [navc viewControllers]) {
//            [viewControllers addObject:vc];
//            if ([vc isKindOfClass:[BabyDetailsController class]]) {
//                break;
//            }
//        }
//        [navc setViewControllers:viewControllers];
//    }
//    SeccondHandExchangeChooseTypeViewController *vc = [[SeccondHandExchangeChooseTypeViewController alloc] init];
//    vc.pageType  = self.pageType;
//    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didReceiveFailureResponeseWithURLString:(NSString *)URLString parameters:(id)parameters error:(NSError *)error
{

}

- (void)defultButtonAction:(UIButton *)btn
{
    btn.selected = !btn.selected;
}

@end
