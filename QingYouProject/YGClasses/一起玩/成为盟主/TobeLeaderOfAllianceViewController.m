//
//  TobeLeaderOfAllianceViewController.m
//  QingYouProject
//
//  Created by nefertari on 2017/12/4.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "TobeLeaderOfAllianceViewController.h"
#import "CrowdFundingAddProjectModel.h"
#import "TobeLeaderOfAllianceTableViewCell.h"
#import "UploadImageTool.h"
#import "YGPickerView.h"
#import "PlayTogetherViewController.h"

@interface TobeLeaderOfAllianceViewController ()<UITableViewDelegate,UITableViewDataSource,UIActionSheetDelegate,CrowdFundingAddProjectTableViewCellDelegate,UIImagePickerControllerDelegate>

@end

@implementation TobeLeaderOfAllianceViewController
{
    NSMutableArray *_listArray;
    UITableView *_tableView;
    UIImagePickerController *_picker;
    UIImage *_headImage;
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
            [self.navigationController popViewControllerAnimated:YES];
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
                                    @"title":@"支付宝账号",
                                    @"content":@"请填写支付宝账号"
                                    },
                                @{
                                    @"title":@"电子邮箱",
                                    @"content":@"请填写电子邮箱"
                                    },
                                ],
                            @[
                                @{
                                    @"title":@"联盟名称",
                                    @"content":@"请填写联盟名称"
                                    },
                                @{
                                    @"title":@"联盟头像",
                                    @"content":@""
                                    }
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
    
    for (int i = 0; i<4; i++) {
            [_tableView registerClass:[TobeLeaderOfAllianceTableViewCell class] forCellReuseIdentifier:[NSString stringWithFormat:@"CrowdFundingAddProjectTableViewCelltextfield%d",i]];
    }
    [_tableView registerClass:[TobeLeaderOfAllianceTableViewCell class] forCellReuseIdentifier:@"CrowdFundingAddProjectTableViewCelllabel"];
    
    [_tableView registerClass:[TobeLeaderOfAllianceTableViewCell class] forCellReuseIdentifier:@"CrowdFundingAddProjectTableViewCelltextfield5"];

    
    
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
    TobeLeaderOfAllianceTableViewCell *cell;
    if (indexPath.section == 0 && indexPath.row != 1)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:[NSString stringWithFormat:@"CrowdFundingAddProjectTableViewCelltextfield%ld",indexPath.row] forIndexPath:indexPath];

    }else if((indexPath.section == 1 && indexPath.row == 0))
    {
        cell = [tableView dequeueReusableCellWithIdentifier:@"CrowdFundingAddProjectTableViewCelltextfield5" forIndexPath:indexPath];
        
    }else
    {
        cell = [tableView dequeueReusableCellWithIdentifier:@"CrowdFundingAddProjectTableViewCelllabel" forIndexPath:indexPath];

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
        return 60;
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
    if (indexPath.section == 1 && indexPath.row == 1) {
        UIActionSheet *act = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"拍照" otherButtonTitles:@"从手机选择", nil];
        [act showInView:self.view];
    }
}
#pragma actionSheet代理

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    _picker = [[UIImagePickerController alloc] init];
    _picker.delegate = (id)self;
    if (buttonIndex == 0)
    {
        
        _picker.allowsEditing = YES;//设置可编辑
        _picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        
        
    }else if (buttonIndex == 1)
    {
        
        _picker.allowsEditing = YES;//设置可编辑
        _picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        
    }else
    {
        return;
    }
    [self presentViewController:_picker animated:YES completion:nil];//进入照相界面
}
#pragma 拍照代理
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    
    NSString * mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    if ([mediaType isEqualToString:(NSString *)kUTTypeImage]) { //如果是拍照
        //先把自己干掉要不看不见
        [picker dismissViewControllerAnimated:YES completion:nil];
        
        if (picker.sourceType == UIImagePickerControllerSourceTypeCamera)
        {
            UIImageWriteToSavedPhotosAlbum(info[UIImagePickerControllerOriginalImage], nil, nil, nil);
        }
        
        //取出图片
        UIImage *image= info[UIImagePickerControllerOriginalImage];
        
        NSData * imageData = UIImageJPEGRepresentation(image,1);
        
        long imageKB = [imageData length]/1000;
        
        NSLog(@"before zip size:%luKB",imageKB);
        if (imageKB >1000 && imageKB <2000)
        {
            //压缩
            image = [UIImage imageWithData:UIImageJPEGRepresentation(image,0.3)];
        }
        else if (imageKB>=2000)
        {
            //压缩
            image = [UIImage imageWithData:UIImageJPEGRepresentation(image,0.1)];
        }
        
        NSLog(@"after zip size:%luKB",[UIImageJPEGRepresentation(image,1) length]/1000);
        
        
            CrowdFundingAddProjectModel *logoModel = _listArray[1][1];
            _headImage = image;
            logoModel.image = image;
            logoModel.content = @"";
            [_tableView reloadData];
        
        
    }
    
}




- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    
    NSLog(@"放弃");
    [self dismissViewControllerAnimated:YES completion:nil];
    
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
    [self.view endEditing:YES];
    
    if (![self loginOrNot])
    {
        return;
    }
    //公司名称可选  头像可选  视频已上传
    CrowdFundingAddProjectModel *nameModel = _listArray[0][0];
    CrowdFundingAddProjectModel *identifyNumberModel = _listArray[0][2];
    CrowdFundingAddProjectModel *emailModel = _listArray[0][3]; //选填
    
    CrowdFundingAddProjectModel *allianceNameModel = _listArray[1][0];
    CrowdFundingAddProjectModel *headImageModel = _listArray[1][1];

    
    if ([nameModel.content containsString:@"请填写"])
    {
        [YGAppTool showToastWithText:@"请填写姓名"];
        
        return ;
    }

    if (_sexString == nil || [_sexString isEqualToString:@""])
    {
        [YGAppTool showToastWithText:@"请选择性别"];
        
        return ;
    }
    
    if ([identifyNumberModel.content containsString:@"请填写"])
    {
        [YGAppTool showToastWithText:@"请填写支付宝账号"];
        return ;
    }
    
    if ([emailModel.content containsString:@"请填写"])
    {
        [YGAppTool showToastWithText:@"请填写邮箱"];

        return ;
    }
    if ([YGAppTool isNotEmail:emailModel.content])
    {
        return ;
    }
  
    if ([allianceNameModel.content isEqualToString:@"请填写联盟名称"]) {
        [YGAppTool showToastWithText:@"请填写联盟名称"];
        return;
    }
    
    
 
    if (_confirmRealButton.selected != YES) {
        [YGAppTool showToastWithText:@"请确认并勾选“本人保证所填写的内容属实”按钮"];
        return;
    }
    
    _applyButton.userInteractionEnabled = NO;
    if (headImageModel.image != nil && ![headImageModel.image isEqual:YGDefaultImgSquare]) {//如果没有上传logo
        
        [UploadImageTool uploadImage:_headImage progress:^(NSString *key, float percent) {
            
        } success:^(NSString *url) {
            [self startPostWithURLString:REQUEST_createAlliance parameters:@{@"userName":nameModel.content,@"alipayNumber":identifyNumberModel.content,@"email":emailModel.content,@"allianceName":allianceNameModel.content,@"userID":YGSingletonMarco.user.userId,@"allianceImg":url,@"userSex":_sexString} showLoadingView:NO scrollView:nil];
            
        } failure:^{
            _applyButton.userInteractionEnabled = YES;
            [YGNetService dissmissLoadingView];
        }];
    }else
    {
        _applyButton.userInteractionEnabled = YES;
        [YGAppTool showToastWithText:@"请上传联盟圈头像"];
        return;
    }
    
    
}
- (void)didReceiveSuccessResponeseWithURLString:(NSString *)URLString parameters:(id)parameters responeseObject:(id)responseObject
{
    [YGAppTool showToastWithText:@"您的联盟创建已提交审核，请耐心等待~"];
    YGSingletonMarco.user.allianceID = responseObject[@"allianceID"];
    UINavigationController *navc = self.navigationController;
    NSMutableArray *viewControllers = [[NSMutableArray alloc] init];
    for (UIViewController *vc in [navc viewControllers]) {
        [viewControllers addObject:vc];
        if ([vc isKindOfClass:[PlayTogetherViewController class]]) {
            break;
        }
    }
    [navc setViewControllers:viewControllers];
    
}

- (void)didReceiveFailureResponeseWithURLString:(NSString *)URLString parameters:(id)parameters error:(NSError *)error
{
    _applyButton.userInteractionEnabled = YES;

}

- (void)defultButtonAction:(UIButton *)btn
{
    btn.selected = !btn.selected;
}



@end
