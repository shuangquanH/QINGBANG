//
//  CrowdFundingAddProjectViewController.m
//  QingYouProject
//
//  Created by nefertari on 2017/10/19.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "CrowdFundingAddProjectViewController.h"
#import "CrowdFundingAddProjectModel.h"
#import "CrowdFundingAddProjectTableViewCell.h"
#import "CrowdFundingAddProjectChooseTypeViewController.h"
#import "CrowdFundingAddProjectNameViewController.h"
#import "CrowdFundingAddProjectDescriptionViewController.h"
#import "SubscribeSumOfMoneyViewController.h"
#import "UploadImageTool.h"
#import "YGCityPikerView1.h"

@interface CrowdFundingAddProjectViewController ()<UITableViewDelegate,UITableViewDataSource,CrowdFundingAddProjectChooseTypeViewControllerDelegate,CrowdFundingAddProjectNameViewControllerDelegate,CrowdFundingAddProjectDescriptionViewControllerDelegate,CrowdFundingAddProjectTableViewCellDelegate,SubscribeSumOfMoneyViewControllerViewControllerDelegate,UIActionSheetDelegate>

@end

@implementation CrowdFundingAddProjectViewController
{
    NSMutableArray *_listArray;
    UITableView *_tableView;
    NSMutableArray *_subscribesArray;
    NSMutableArray *_subscribesModelArray;
    
    NSArray   *_typeArray;
    NSString  *_rightsString;
    NSString *_typeIdString;
    
    UIImageView *_headImageView;
    UIImagePickerController *_picker;
    UIButton *_applyButton;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self configUI];
    // Do any additional setup after loading the view.
}

- (void)configAttribute
{
    _listArray = [[NSMutableArray alloc] init];
    _subscribesArray = [[NSMutableArray alloc] init];
    _typeArray = @[@"收益权",@"股权",@"物权"];
    self.naviTitle = @"添加项目";
}

- (void)back
{
    [YGAlertView showAlertWithTitle:@"返回上一页将不保存当前填写的信息，确定返回吗？" buttonTitlesArray:@[@"取消",@"确定"] buttonColorsArray:@[colorWithBlack,colorWithMainColor] handler:^(NSInteger buttonIndex) {
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
                                    @"title":@"选择类型",
                                    @"content":@"请选择"
                                    },
                                @{
                                    @"title":@"项目名称",
                                    @"content":@"请填写"
                                    },
                                @{
                                    @"title":@"项目描述",
                                    @"content":@"请填写"
                                    },
                                @{
                                    @"title":@"认购金额",
                                    @"content":@"请填写"
                                    },
                                @{
                                    @"title":@"项目地址",
                                    @"content":@"请填写项目地址"
                                    }
                                ],
                            @[
                                @{
                                    @"title":@"筹集目标",
                                    @"content":@"",
                                    @"placehoder":@"筹集目标"
                                    
                                    },
                                @{
                                    @"title":@"筹集天数",
                                    @"content":@"",
                                    @"placehoder":@"筹集天数"
                                    }
                                ],
                            @[
                                @{
                                    @"title":@"项目发起人介绍",
                                    @"content":@"请填写"
                                    },
                                @{
                                    @"title":@"项目方案",
                                    @"content":@"请填写"
                                    },
                                @{
                                    @"title":@"项目介绍",
                                    @"content":@"请填写"
                                    }
                                ]
                            ];
    [_listArray addObjectsFromArray:[CrowdFundingAddProjectModel mj_objectArrayWithKeyValuesArray:titlesArr]];
    UIView *tableViewHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, YGScreenWidth, YGScreenWidth*0.5625)];
    tableViewHeaderView.backgroundColor = colorWithTable;
    
    _headImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, YGScreenWidth, YGScreenWidth*0.5625)];
    _headImageView.userInteractionEnabled = YES;
    _headImageView.image = [UIImage imageNamed:@"home_addphotos"];
    _headImageView.contentMode = UIViewContentModeCenter;
    _headImageView.clipsToBounds = YES;
    [tableViewHeaderView addSubview:_headImageView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapToAddImageView:)];
    tap.numberOfTapsRequired = 1;
    tap.numberOfTouchesRequired = 1;
    [_headImageView addGestureRecognizer:tap];
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, YGScreenWidth, YGScreenHeight-64-45) style:UITableViewStyleGrouped];
    _tableView.backgroundColor = colorWithTable;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.tableHeaderView = tableViewHeaderView;
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0.001)];
    _tableView.sectionFooterHeight = 0.001;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    [_tableView registerClass:[CrowdFundingAddProjectTableViewCell class] forCellReuseIdentifier:@"CrowdFundingAddProjectTableViewCelllabel"];
    
    [_tableView registerClass:[CrowdFundingAddProjectTableViewCell class] forCellReuseIdentifier:@"CrowdFundingAddProjectTableViewCelltextfield1"];
    [_tableView registerClass:[CrowdFundingAddProjectTableViewCell class] forCellReuseIdentifier:@"CrowdFundingAddProjectTableViewCelltextfield0"];
    
    [self.view addSubview:_tableView];
    
    _applyButton = [[UIButton alloc]initWithFrame:CGRectMake(0,YGScreenHeight-YGStatusBarHeight-YGNaviBarHeight-45-YGBottomMargin,YGScreenWidth,45+YGBottomMargin)];
    _applyButton.titleEdgeInsets = UIEdgeInsetsMake(-YGBottomMargin, 0, 0, 0);
    [_applyButton addTarget:self action:@selector(applyButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    _applyButton.backgroundColor = colorWithMainColor;
    _applyButton.titleLabel.font = [UIFont systemFontOfSize:YGFontSizeSmallOne];
    [self.view addSubview:_applyButton];
    [_applyButton setTitleColor:colorWithYGWhite forState:UIControlStateNormal];
    [_applyButton setTitle:@"发布" forState:UIControlStateNormal];
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
    if (indexPath.section == 0 || indexPath.section == 2)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:@"CrowdFundingAddProjectTableViewCelllabel" forIndexPath:indexPath];
    }else
    {
        NSString *str =[NSString stringWithFormat:@"CrowdFundingAddProjectTableViewCelltextfield%ld",indexPath.row];
        cell = [tableView dequeueReusableCellWithIdentifier:str forIndexPath:indexPath];
        
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    CrowdFundingAddProjectModel *model = _listArray[indexPath.section][indexPath.row];
    cell.needReturnIndexPath = NO;
    cell.delegate = self;
    [cell setModel:model withIndexPath:indexPath];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section != 0) {
        return 10;
    }
    return 0;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, YGScreenWidth, 10)];
    return view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CrowdFundingAddProjectModel *model = _listArray[indexPath.section][indexPath.row];

    if (indexPath.section != 1)
    {
        if (indexPath.section == 0) {
            switch (indexPath.row) {
                case 0:
                {
                    CrowdFundingAddProjectChooseTypeViewController *crowdFundingAddProjectChooseTypeViewController = [[CrowdFundingAddProjectChooseTypeViewController alloc] init];
                    crowdFundingAddProjectChooseTypeViewController.delegate = self;
                    [self.navigationController pushViewController:crowdFundingAddProjectChooseTypeViewController animated:YES];
                    break;
                    
                }
                case 1:
                {
                    CrowdFundingAddProjectModel *model = _listArray[0][1];
                    CrowdFundingAddProjectNameViewController *crowdFundingAddProjectNameViewController = [[CrowdFundingAddProjectNameViewController alloc] init];
                    crowdFundingAddProjectNameViewController.companyNameOrProjectName = 0;
                    crowdFundingAddProjectNameViewController.content = model.content ;
                    crowdFundingAddProjectNameViewController.delegate = self;
                    [self.navigationController pushViewController:crowdFundingAddProjectNameViewController animated:YES];
                    break;
                    
                }
                case 2:
                {
                    CrowdFundingAddProjectDescriptionViewController *descriptionVc = [[CrowdFundingAddProjectDescriptionViewController alloc] init];
                    descriptionVc.iputTypeOfPage = iputTypeOfDescriptionType;
                    descriptionVc.placehoder = @"项目描述";
                    descriptionVc.content = model.content;
                    descriptionVc.delegate = self;
                    [self.navigationController pushViewController:descriptionVc animated:YES];
                    break;
                    
                }
                case 3:
                {
                    SubscribeSumOfMoneyViewController *vc = [[SubscribeSumOfMoneyViewController alloc] init];
                    vc.delegate = self;
                    if (_subscribesModelArray.count>0) {
                        vc.dataSource = _subscribesModelArray;
                    }
                    [self.navigationController pushViewController:vc animated:YES];
                    break;
                    
                }
                case 4:
                {
                    [YGCityPikerView1 showWithHandler:^(NSString *province, NSString *city) {
                        CrowdFundingAddProjectModel *model = _listArray[0][4];
                        model.content = [NSString stringWithFormat:@"%@ %@",province,city];
                        [_tableView reloadData];
                        
                    }];
                    break;
                    
                }
                    
            }
        }else if (indexPath.section == 2)
        {
            switch (indexPath.row) {
                case 0:
                {
                    CrowdFundingAddProjectDescriptionViewController *descriptionVc = [[CrowdFundingAddProjectDescriptionViewController alloc] init];
                    descriptionVc.delegate = self;
                    descriptionVc.placehoder = @"项目发起人介绍";
                    descriptionVc.content = model.content;
                    descriptionVc.iputTypeOfPage = iputTypeOfInitiaterIntroduceType;
                    [self.navigationController pushViewController:descriptionVc animated:YES];
                    break;
                    
                }
                case 1:
                {
                    CrowdFundingAddProjectDescriptionViewController *descriptionVc = [[CrowdFundingAddProjectDescriptionViewController alloc] init];
                    descriptionVc.iputTypeOfPage = iputTypeOfProjectPlanType;
                    descriptionVc.placehoder = @"项目方案";
                    descriptionVc.content = model.content;
                    descriptionVc.delegate = self;
                    [self.navigationController pushViewController:descriptionVc animated:YES];
                    break;
                    
                }
                case 2:
                {
                    CrowdFundingAddProjectDescriptionViewController *descriptionVc = [[CrowdFundingAddProjectDescriptionViewController alloc] init];
                    descriptionVc.iputTypeOfPage = iputTypeOfProjectIntroduceType;
                    descriptionVc.delegate = self;
                    descriptionVc.placehoder = @"项目介绍";
                    descriptionVc.content = model.content;
                    [self.navigationController pushViewController:descriptionVc animated:YES];
                    break;
                    
                }
                    
            }
            
        }
        
    }
}
- (void)applyButtonAction:(UIButton *)btn
{
    if ([_headImageView.image isEqual:nil]) {
        [YGAppTool showToastWithText:@"请添加项目图片"];
        return ;
    }
    
    //        CrowdFundingAddProjectModel *projectTypeModel = _listArray[0][0];
    CrowdFundingAddProjectModel *projectNameModel = _listArray[0][1];
    CrowdFundingAddProjectModel *projectDescribeModel = _listArray[0][2];
    CrowdFundingAddProjectModel *projectAddressModel = _listArray[0][4];
    
    CrowdFundingAddProjectModel *raiseGoalModel = _listArray[1][0];
    CrowdFundingAddProjectModel *raiseDaysModel = _listArray[1][1];
    
    CrowdFundingAddProjectModel *projectPeopleModel = _listArray[2][0];
    CrowdFundingAddProjectModel *projectPlanModel = _listArray[2][1];
    CrowdFundingAddProjectModel *projectIntroductionModel = _listArray[2][2];
    if (_typeIdString == nil || [_typeIdString isEqualToString:@""])
    {
        [YGAppTool showToastWithText:@"请选择项目类型"];
        return ;
    }
    if (
        [projectNameModel.content isEqualToString:@""] ||
        [raiseGoalModel.content isEqualToString:@""] ||
        [raiseDaysModel.content isEqualToString:@""] ||
        [projectPeopleModel.content isEqualToString:@""] ||
        [projectPlanModel.content isEqualToString:@""] ||
        [projectIntroductionModel.content isEqualToString:@""] ||
        [projectDescribeModel.content isEqualToString:@""])
    {
        [YGAppTool showToastWithText:@"请填写完整的信息"];
        return ;
    }
    btn.userInteractionEnabled = NO;

    [UploadImageTool uploadImage:_headImageView.image progress:^(NSString *key, float percent) {
        
    } success:^(NSString *url) {
        
        
        NSString *rights = [_rightsString isEqualToString:_typeArray[0]]?@"1":([_rightsString isEqualToString:_typeArray[1]]?@"2":@"3");
        NSDictionary *dict = @{
                               @"userId":YGSingletonMarco.user.userId,@"projectType":_typeIdString,@"projectName":projectNameModel.content,@"raiseGoal":raiseGoalModel.content,@"raiseDays":raiseDaysModel.content,@"projectAddress":projectAddressModel.content,@"projectPeople":projectPeopleModel.content,@"projectPlan":projectPlanModel.content,@"projectIntroduction":projectIntroductionModel.content,@"projectDescribe":projectDescribeModel.content,@"power":rights,@"subscribes":_subscribesArray,@"picture":url
                               };
        [self startPostWithURLString:REQUEST_AddProject parameters:dict showLoadingView:NO scrollView:nil];
        
    } failure:^{
        btn.userInteractionEnabled = YES;

    }];
    
    
    
    
}

- (void)didReceiveSuccessResponeseWithURLString:(NSString *)URLString parameters:(id)parameters responeseObject:(id)responseObject
{
    [YGAppTool showToastWithText:@"您提交项目已进入平台审核，审核期间平台有权对发起的项目进行整改"];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)didReceiveFailureResponeseWithURLString:(NSString *)URLString parameters:(id)parameters error:(NSError *)error
{
    _applyButton.userInteractionEnabled = YES;
}
#pragma 点击
- (void)tapToAddImageView:(UITapGestureRecognizer *)tap
{
    UIActionSheet *act = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"拍照" otherButtonTitles:@"从手机选择", nil];

    [act showInView:self.view];

}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    _picker = [[UIImagePickerController alloc] init];//初始化
    _picker.delegate = (id)self;
    if (buttonIndex == 0)
    {
        _picker.allowsEditing = NO;//设置可编辑
        _picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:_picker animated:YES completion:nil];//进入照相界面

        
    }
    if (buttonIndex == 1) {
        _picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:_picker animated:YES completion:nil];//进入照相界面


    }
    return;
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
    
}


#pragma 代理
//选择类型带回来的值
- (void)takeTypeValueBackWithModel:(CrowdFundingAddProjectChooseTypeModel *)model
{
    CrowdFundingAddProjectModel *listModel = _listArray[0][0];
    listModel.content = model.type;
    _typeIdString = model.id;
    [_tableView reloadData];
}


//填写项目名称带回来的值
- (void)takeProjectNameValueBackWithValue:(NSString *)value
{
    CrowdFundingAddProjectModel *model = _listArray[0][1];
    model.content = value;
    [_tableView reloadData];
}

//项目介绍代理带回的值
- (void)takeProjectdesOrIntroduceValueBackWithValue:(NSString *)value withInputType:(iputTypeOfPage)inputType
{
    CrowdFundingAddProjectModel *model;
    switch (inputType) {
        case iputTypeOfDescriptionType: {
            model = _listArray[0][2];
            break;
        }
        case iputTypeOfInitiaterIntroduceType: {
            model = _listArray[2][0];
            break;
        }
        case iputTypeOfProjectPlanType: {
            model = _listArray[2][1];
            break;
        }
        case iputTypeOfProjectIntroduceType: {
            model = _listArray[2][2];
            break;
        }
    }
    model.content = value;
    [_tableView reloadData];
}
//认购金额代理
-(void)takeTypeValueBackWithModels:(NSArray *)modelArray withRights:(NSString *)rights
{
    CrowdFundingAddProjectModel *model = _listArray[0][3];
    model.content = @"已填写";
    _rightsString = rights;
    _subscribesModelArray =(NSMutableArray *) modelArray;
    _subscribesArray = [SubscribeSumOfMoneyModel mj_keyValuesArrayWithObjectArray:modelArray];
    [_tableView reloadData];
    
}
//当前页面cell的代理
- (void)textfieldReturnValue:(NSString *)value withTextfiledTag:(NSInteger)textfieldTag
{
    CrowdFundingAddProjectModel *model;
    
    if (textfieldTag == 1000) {
        model = _listArray[1][0];
    }
    if (textfieldTag == 1001) {
        model = _listArray[1][1];
    }
    model.content = value;
    [_tableView reloadData];
}



@end
