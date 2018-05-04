//
//  AllianceMainSettingViewController.m
//  QingYouProject
//
//  Created by nefertari on 2017/11/29.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "AllianceMainSettingViewController.h"
#import "CrowdFundingAddProjectModel.h"
#import "CrowdFundingAddProjectTableViewCell.h"
#import "AllianceCircleViewController.h"
#import "YGAlertView.h"
#import "UploadImageTool.h"

@interface AllianceMainSettingViewController ()<UITableViewDelegate,UITableViewDataSource,CrowdFundingAddProjectTableViewCellDelegate,UIPickerViewDelegate,UIActionSheetDelegate>

@end

@implementation AllianceMainSettingViewController
{
    NSMutableArray *_listArray;
    UITableView *_tableView;
    
    UIImageView *_headImageView;
    UIImagePickerController *_picker;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadData];
    // Do any additional setup after loading the view.
}
- (void)configAttribute
{
    self.naviTitle = @"联盟设置";
   UIBarButtonItem *barButtonItem =  [self createBarbuttonWithNormalTitleString:@"解散盟圈" selectedTitleString:@"解散盟圈" selector:@selector(dismissAllianceAction)];
    self.navigationItem.rightBarButtonItem = barButtonItem;
    _listArray = [[NSMutableArray alloc] init];
}
- (void)loadData
{
    // 收藏与取消收藏
    [YGNetService YGPOST:REQUEST_viewAlliance parameters:@{@"allianceID":_allianceID} showLoadingView:NO scrollView:nil success:^(id responseObject) {
        NSArray * titlesArr = @[
                                @{
                                    @"title":@"联盟头像",
                                    @"content":@"",
                                    @"placehoder":@"请选择"

                                    },
                                @{
                                    @"title":@"联盟名称",
                                    @"content":@""
                                    },
                                @{
                                    @"title":@"联盟简介",
                                    @"content":@""
                                    },
                                ];
        
        [_listArray addObjectsFromArray:[CrowdFundingAddProjectModel mj_objectArrayWithKeyValuesArray:titlesArr]];
        CrowdFundingAddProjectModel *allianceImgModel = _listArray[0];
        allianceImgModel.content = responseObject[@"allianceImg"];
        
        CrowdFundingAddProjectModel *allianceNameModel = _listArray[1];
        allianceNameModel.content = responseObject[@"allianceName"];
        
        CrowdFundingAddProjectModel *allianceInfoModel = _listArray[2];
        allianceInfoModel.content = responseObject[@"allianceInfo"];

        [self configUI];

    } failure:^(NSError *error) {
        
    }];
}
- (void)configUI
{

    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, YGScreenWidth, YGScreenHeight-YGNaviBarHeight-YGStatusBarHeight-45) style:UITableViewStyleGrouped];
    _tableView.backgroundColor = colorWithTable;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0.001)];
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0.001)];
    _tableView.sectionFooterHeight = 0.001;
    _tableView.separatorColor = colorWithLine;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView registerClass:[CrowdFundingAddProjectTableViewCell class] forCellReuseIdentifier:@"CrowdFundingAddProjectTableViewCelllabel"];
    
    [_tableView registerClass:[CrowdFundingAddProjectTableViewCell class] forCellReuseIdentifier:@"CrowdFundingAddProjectTableViewCelltextfield4"];
    [_tableView registerClass:[CrowdFundingAddProjectTableViewCell class] forCellReuseIdentifier:@"CrowdFundingAddProjectTableViewCelltextfield5"];

    [self.view addSubview:_tableView];

    UIButton *coverButton = [[UIButton alloc]initWithFrame:CGRectMake(0,YGScreenHeight-YGNaviBarHeight-YGStatusBarHeight-45-YGBottomMargin,YGScreenWidth,45+YGBottomMargin)];
    coverButton.backgroundColor = colorWithMainColor;
    [coverButton addTarget:self action:@selector(confirmAction) forControlEvents:UIControlEventTouchUpInside];
    [coverButton setTitleColor:colorWithYGWhite forState:UIControlStateNormal];
    [coverButton setTitle:@"确定" forState:UIControlStateNormal];
    coverButton.titleLabel.font = [UIFont systemFontOfSize:YGFontSizeBigOne];
    [self.view addSubview:coverButton];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _listArray.count;

    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;

}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CrowdFundingAddProjectTableViewCell *cell;
    if (indexPath.row == 0)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:@"CrowdFundingAddProjectTableViewCelllabel" forIndexPath:indexPath];
    }else if(indexPath.row == 1)
    {
        NSString *str =[NSString stringWithFormat:@"CrowdFundingAddProjectTableViewCelltextfield4"];
        cell = [tableView dequeueReusableCellWithIdentifier:str forIndexPath:indexPath];
        
    }else{
        NSString *str =[NSString stringWithFormat:@"CrowdFundingAddProjectTableViewCelltextfield5"];
        cell = [tableView dequeueReusableCellWithIdentifier:str forIndexPath:indexPath];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    CrowdFundingAddProjectModel *model = _listArray[indexPath.row];
    if (indexPath.section == 0 && indexPath.row == 0 && model.image == nil) {
        model.image = YGDefaultImgAvatar;
    }
    cell.needReturnIndexPath = YES;
    cell.delegate = self;
    [cell setModel:model withIndexPath:indexPath];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 60;
    }
    return 50;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        UIActionSheet *act = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"拍照" otherButtonTitles:@"从手机选择", nil];
        [act showInView:self.view];
    }
}

- (void)confirmAction
{
    CrowdFundingAddProjectModel *allianceImgModel = _listArray[0];
    
    CrowdFundingAddProjectModel *allianceNameModel = _listArray[1];
    
    CrowdFundingAddProjectModel *allianceInfoModel = _listArray[2];
    

    if ([allianceNameModel.content isEqualToString:@"限12字"]) {
        [YGAppTool showToastWithText:@"请填写联盟名称"];
        return;
    }
    
    if ([YGAppTool isTooLong:allianceNameModel.content maxLength:12 name:@"联盟名字"]) {
        return;
    }
    if ([allianceInfoModel.content isEqualToString:@"请填写联盟简介（限20字）"]) {
        [YGAppTool showToastWithText:@"请填写联盟简介"];
        return;
    }

    if ([YGAppTool isTooLong:allianceInfoModel.content maxLength:20 name:@"联盟简介"]) {
        return;
    }
    if ( allianceImgModel.image == nil)
    {
        [YGNetService YGPOST:REQUEST_updateAlliance parameters:@{@"allianceID":_allianceID,@"allianceName":allianceNameModel.content,@"allianceImg":allianceImgModel.content,@"allianceInfo":allianceInfoModel.content} showLoadingView:NO scrollView:nil success:^(id responseObject) {
            [YGNetService dissmissLoadingView];
            [YGAppTool showToastWithText:@"设置成功！"];
            [self.navigationController popViewControllerAnimated:YES];
        } failure:^(NSError *error) {
            [YGNetService dissmissLoadingView];
            
        }];
        return;
    }else
    {
        [YGNetService showLoadingViewWithSuperView:self.view];
        
        
        [UploadImageTool uploadImage:allianceImgModel.image progress:^(NSString *key, float percent) {
            
        } success:^(NSString *url) {
            [YGNetService YGPOST:REQUEST_updateAlliance parameters:@{@"allianceID":_allianceID,@"allianceName":allianceNameModel.content,@"allianceImg":url,@"allianceInfo":allianceInfoModel.content} showLoadingView:NO scrollView:nil success:^(id responseObject) {
                [YGNetService dissmissLoadingView];
                [YGAppTool showToastWithText:@"设置成功！"];
                [self.navigationController popViewControllerAnimated:YES];
            } failure:^(NSError *error) {
                [YGNetService dissmissLoadingView];
                
            }];
        } failure:^{
            [YGNetService dissmissLoadingView];
            
        }];
    }
    
}

- (void)dismissAllianceAction
{
    [YGAlertView showAlertWithTitle:@"是否确定要解散联盟？" buttonTitlesArray:@[@"取消",@"确定"] buttonColorsArray:@[colorWithBlack,colorWithMainColor] handler:^(NSInteger buttonIndex) {
        if (buttonIndex == 0) {
            return ;
        }
        [YGNetService YGPOST:REQUEST_dissolveAlliance parameters:@{@"allianceID":_allianceID} showLoadingView:NO scrollView:nil success:^(id responseObject) {
            [YGAppTool showToastWithText:@"联盟解散成功"];
            UINavigationController *navc = self.navigationController;
            NSMutableArray *viewControllers = [[NSMutableArray alloc] init];
            for (UIViewController *vc in [navc viewControllers]) {
                [viewControllers addObject:vc];
                if ([vc isKindOfClass:[AllianceCircleViewController class]]) {
                    break;
                }
            }
            [navc setViewControllers:viewControllers];
        } failure:^(NSError *error) {
            
        }];
        
    }];

//    [YGAppTool showToastWithText:@"您的联盟圈还有成员哦~\n成员人数为0方可解散该联盟圈~"];
}


#pragma 拍照相关

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    _picker = [[UIImagePickerController alloc] init];//初始化
    _picker.delegate = (id)self;
    _picker.allowsEditing = YES;
    if (buttonIndex == 0)
    {
//        _picker.allowsEditing = YES;//设置可编辑
        _picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        
    }
    if (buttonIndex == 1) {
        _picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        
    }
    [self presentViewController:_picker animated:YES completion:nil];//进入照相界面
    
}

#pragma 拍照代理
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
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
    _headImageView.image = image;
    CrowdFundingAddProjectModel *model = _listArray[0];
    model.image = image;
    [_tableView reloadData];
}
//当前页面cell的代理
- (void)textfieldReturnValue:(NSString *)value withTextIndexPath:(NSIndexPath *)indexPath
{
    CrowdFundingAddProjectModel *model;
    
    if (indexPath.row  == 1) {
        model = _listArray[1];
    }
    if (indexPath.row  == 2) {
        model = _listArray[2];
    }
    model.content = value;
    [_tableView reloadData];
}

@end
