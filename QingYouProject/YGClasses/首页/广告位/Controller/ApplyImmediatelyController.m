//
//  ApplyImmediatelyController.m
//  QingYouProject
//
//  Created by zhaoao on 2017/9/25.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "ApplyImmediatelyController.h"
#import "ApplyPictureCell.h"
#import "ApplyInformationCell.h"
#import "ApplyRemarkCell.h"
#import "CompanyTextViewCell.h"
#import "AdvertisementSuccessController.h"
#import "ResultViewController.h"
#import "AdvertisementAgreementController.h"


@interface ApplyImmediatelyController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_tableView;
}


@end

@implementation ApplyImmediatelyController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.naviTitle = @"立即申请";
    self.view.backgroundColor = colorWithTable;
    [self configUI];
    [self configBottomButton];
    
}

-(void)configUI
{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, YGScreenWidth, YGScreenHeight - 50 - YGBottomMargin) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    _tableView.estimatedRowHeight = 50;
//    _tableView.rowHeight = UITableViewAutomaticDimension;
 
    _tableView.contentInset = UIEdgeInsetsMake(0, 0, 50, 0);
    _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, YGScreenWidth, 0.001)];
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, YGScreenWidth, 0.001)];
    [self.view addSubview:_tableView];
    
    UIView *aggrementView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, YGScreenWidth, 40)];
    UIButton *checkButton = [UIButton buttonWithType:UIButtonTypeCustom];
    checkButton.frame = CGRectMake(15, 2, 15, 15);
    checkButton.tag = 1994;
    [checkButton setBackgroundImage:[UIImage imageNamed:@"nochoice_btn_gray"] forState:UIControlStateNormal];
    [checkButton setBackgroundImage:[UIImage imageNamed:@"choice_btn_green"] forState:UIControlStateSelected];
    [checkButton addTarget:self action:@selector(isAgreeClick:) forControlEvents:UIControlEventTouchUpInside];
    [aggrementView addSubview:checkButton];
    
    UILabel *alreadyLabel = [[UILabel alloc]initWithFrame:CGRectMake(30, 0, 90, 20)];
    alreadyLabel.text = @"已阅读并同意";
    alreadyLabel.textAlignment = NSTextAlignmentRight;
    alreadyLabel.textColor = colorWithBlack;
    alreadyLabel.font = [UIFont systemFontOfSize:13.0];
    [aggrementView addSubview:alreadyLabel];
    
    UIButton *agreementButton = [UIButton buttonWithType:UIButtonTypeCustom];
    agreementButton.frame = CGRectMake(120, 0, 180, 20);
    agreementButton.titleLabel.font = [UIFont systemFontOfSize:13.0];
    agreementButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [agreementButton setTitleColor:colorWithMainColor forState:UIControlStateNormal];
    [agreementButton setTitle:@"《青网广告位服务协议》" forState:UIControlStateNormal];
    [agreementButton addTarget:self action:@selector(agreeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [aggrementView addSubview:agreementButton];
    
    _tableView.tableFooterView = aggrementView;
    
}

-(void)configBottomButton
{
    UIButton *applyImmediatelyButton = [UIButton buttonWithType:UIButtonTypeCustom];
    applyImmediatelyButton.frame = CGRectMake(0, YGScreenHeight - YGNaviBarHeight - YGStatusBarHeight - 50, YGScreenWidth, 50);
    [applyImmediatelyButton setTitle:@"立即申请" forState:UIControlStateNormal];
    applyImmediatelyButton.titleLabel.font = [UIFont systemFontOfSize:15.0];
    applyImmediatelyButton.backgroundColor = colorWithMainColor;
    [applyImmediatelyButton addTarget:self action:@selector(applyImmediatelyClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:applyImmediatelyButton];
}

#pragma mark - UITableViewDelegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0)
    {
        ApplyPictureCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ApplyPictureCell"];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"ApplyPictureCell" owner:self options:nil] firstObject];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        NSURL *picUrl = [NSURL URLWithString:self.picString];
        [cell.advertisementImageView sd_setImageWithURL:picUrl placeholderImage:YGDefaultImgFour_Three];
        return cell;
    }
    if(indexPath.section == 1)
    {
        if (indexPath.row == 2)
        {
            CompanyTextViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CompanyTextViewCell"];
            if (!cell) {
                cell = [[[NSBundle mainBundle] loadNibNamed:@"CompanyTextViewCell" owner:self options:nil] firstObject];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            return cell;
        }
        else
        {
            ApplyInformationCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ApplyInformationCell"];
            if (!cell) {
                cell = [[[NSBundle mainBundle] loadNibNamed:@"ApplyInformationCell" owner:self options:nil] firstObject];
            }
            if (indexPath.row == 0) {
                cell.applyTitleLabel.text = @"联系人";
                cell.applyTextField.placeholder = @"请输入姓名";
                cell.applyTextField.hidden = NO;
            }
            if (indexPath.row == 1) {
                cell.applyTitleLabel.text = @"联系电话";
                cell.applyTextField.placeholder = @"请填写真实联系电话";
                cell.applyTextField.keyboardType = UIKeyboardTypePhonePad;
                cell.applyTextField.hidden = NO;
            }
            //        if (indexPath.row == 2) {
            //            cell.applyTitleLabel.text = @"企业/个人名称";
            //            cell.applyTextField.hidden = YES;
            
            //            [cell.contentView addSubview:self.companyNameTextView];
            //            self.companyNameTextView.placeholder = @"请填写企业/个人全称";
            //            self.companyNameTextView.placeholderFont = [UIFont systemFontOfSize:14.0];
            //            self.companyNameTextView.maxNumberOfLines = 8; //最大行数
            //            self.companyNameTextView.textAlignment = NSTextAlignmentRight;
            //            [self.companyNameTextView mas_makeConstraints:^(MASConstraintMaker *make)
            //             {
            //                 make.top.equalTo(cell.contentView).offset(0);
            //                 make.bottom.equalTo(cell.contentView).offset(0);
            //                 make.left.equalTo(cell.applyTitleLabel).offset(cell.applyTitleLabel.width + 50);
            //                 make.right.equalTo(cell.contentView).offset(-15);
            //             }];
            //
            //            __weak typeof(self) weakSelf = self;
            //            [self.companyNameTextView textValueDidChanged:^(NSString *text, CGFloat textHeight) {
            //
            //                CGRect frame = weakSelf.companyNameTextView.frame;
            //                frame.size.height = textHeight;
            //
            //                [weakSelf.companyNameTextView mas_updateConstraints:^(MASConstraintMaker *make) {
            //                    make.height.offset(textHeight);
            //                }];
            //
            //                [weakSelf.view layoutIfNeeded];
            
            //                [_tableView reloadData];
            //            }];
            
            //      }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
        }
        
    }
    else
    {
        ApplyRemarkCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ApplyRemarkCell"];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"ApplyRemarkCell" owner:self options:nil] firstObject];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 1)
    {
        return 3;
    }
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0)
    {
        return YGScreenWidth * 0.5;
    }
    if(indexPath.section == 1)
    {
        if (indexPath.row == 2)
        {
            return UITableViewAutomaticDimension;
        }
        return 50;
    }
//    return YGScreenWidth * 0.29 - 40;
    return UITableViewAutomaticDimension;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(section == 1 || section == 2)
    {
        return 40;
    }
    return 0.1;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if(section == 1 || section == 2)
    {
        UIView *sectionHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, YGScreenWidth, 40)];
        sectionHeaderView.backgroundColor = [UIColor whiteColor];
        UILabel *headLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, YGScreenWidth - 20, 40)];
        headLabel.textColor = colorWithBlack;
        headLabel.font = [UIFont systemFontOfSize:15.0];
        if(section == 1)
        {
            headLabel.text = @"申请信息";
        }
        else
        {
            headLabel.text = @"其他备注";
        }
        [sectionHeaderView addSubview:headLabel];
        return sectionHeaderView;
    }
    return nil;
}

//勾选已阅读协议文件
-(void)isAgreeClick:(UIButton *)button
{
    button.selected = !button.selected;
}
//立即申请点击
-(void)applyImmediatelyClick:(UIButton *)button
{
    ApplyInformationCell *peopleCell = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
    ApplyInformationCell *phoneCell = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:1]];
    CompanyTextViewCell *companyCell = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:1]];
    ApplyRemarkCell *remarkCell = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:2]];
    
    UIButton *checkButton = [self.view viewWithTag:1994];
    if (checkButton.selected == NO) {
        [YGAppTool showToastWithText:@"请勾选服务协议"];
        return;
    }
    if(!peopleCell.applyTextField.text.length)
    {
        [YGAppTool showToastWithText:@"请填写联系人姓名"];
        return;
    }
    if(!phoneCell.applyTextField.text.length)
    {
        [YGAppTool showToastWithText:@"请填写联系电话"];
        return;
    }
    if(!companyCell.companyTextView.text.length)
    {
        [YGAppTool showToastWithText:@"请填写企业名称"];
        return;
    }
    if ([YGAppTool isNotPhoneNumber:phoneCell.applyTextField.text])
    {
        return;
    }
    
    [YGNetService YGPOST:REQUEST_AdsOrderCreate parameters:@{@"userID":YGSingletonMarco.user.userId,@"addressName":peopleCell.applyTextField.text,@"addressPhone":phoneCell.applyTextField.text,@"companyName":companyCell.companyTextView.text,@"remark":remarkCell.remarkTextView.text,@"adsName":self.adNameString} showLoadingView:NO scrollView:nil success:^(id responseObject) {
        
        NSLog(@"%@",responseObject);
        
        [YGAppTool showToastWithText:@"提交成功!"];
        [self.navigationController popViewControllerAnimated:YES];
        
//        ResultViewController *controller = [[ResultViewController alloc]init];
//        controller.pageType = ResultPageTypeSubmitResult;
//        [self.navigationController pushViewController:controller animated:YES];
        
    } failure:^(NSError *error) {
        
    }];
}

-(void)agreeButtonClick:(UIButton *)button
{
    AdvertisementAgreementController *vc = [[AdvertisementAgreementController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
