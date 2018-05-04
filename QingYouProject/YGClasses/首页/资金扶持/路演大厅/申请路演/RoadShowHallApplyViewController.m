//
//  RoadShowHallApplyViewController.m
//  QingYouProject
//
//  Created by nefertari on 2017/10/18.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "RoadShowHallApplyViewController.h"
#import "CrowdFundingAddProjectModel.h"
#import "CrowdFundingAddProjectTableViewCell.h"
#import "CrowdFundingAddProjectChooseTypeViewController.h"
#import "CrowdFundingAddProjectNameViewController.h"
#import "CrowdFundingAddProjectDescriptionViewController.h"
//选择行业领域
#import "CrowdFundingAddProjectChooseTypeViewController.h"
#import "UploadImageTool.h"
#import <AVFoundation/AVFoundation.h>
#import "GCMAssetModel.h"
#import "RoadShowHallAddVideoImageViewController.h"

@interface RoadShowHallApplyViewController ()<UITableViewDelegate,UITableViewDataSource,CrowdFundingAddProjectChooseTypeViewControllerDelegate,CrowdFundingAddProjectNameViewControllerDelegate,CrowdFundingAddProjectDescriptionViewControllerDelegate,CrowdFundingAddProjectTableViewCellDelegate,CrowdFundingAddProjectChooseTypeViewControllerDelegate,UIActionSheetDelegate,RoadShowHallAddVideoImageViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) AVPlayer * player;
@property (nonatomic,strong) GCMAssetModel *assetModel;

@end

@implementation RoadShowHallApplyViewController

{
    NSMutableArray *_listArray;
    UITableView *_tableView;
    NSArray *_sectionTitleArray;
    NSString *_typeIdString;
    UIImagePickerController *_picker;
    UIImage *_headImage;
    
    NSData *_videoData;
    UIImage *_thumbImage; //视频封面
    NSString *_videoUrl;
    
    NSMutableArray *_bussinessPlanImages;
    BOOL  _isHeadImagePhoto;
    BOOL  _isVideo;
    UIButton *_applyButton;
    
    NSArray *_bussinessPlanImagesUrls;
    NSIndexPath *_selectIndexPath;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self configUI];
    // Do any additional setup after loading the view.
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    YGSingletonMarco.roadShowHallAddVideoViewController = nil;
    YGSingletonMarco.roadShowHallAddImageViewController = nil;

}
- (void)back
{
    
    [YGAlertView showAlertWithTitle:@"返回上一页将不保存当前填写的信息，确定返回吗？" buttonTitlesArray:@[@"取消",@"确定"] buttonColorsArray:@[colorWithLightGray,colorWithMainColor] handler:^(NSInteger buttonIndex) {
        if (buttonIndex == 1) {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
}
- (void)configAttribute
{
    _listArray = [[NSMutableArray alloc] init];
    self.naviTitle = @"申请路演";
    _sectionTitleArray = @[@"基本信息",@"联系人信息",@"项目详细信息",@"上传资料"];
    _picker = [[UIImagePickerController alloc] init];//初始化
    _picker.delegate = (id)self;
}


- (void)applyRoadShowSubmitWithVideoUrl:(NSString *)videoUrl
{
    
    //公司名称可选  头像可选  视频已上传
    CrowdFundingAddProjectModel *logoModel = _listArray[0][0];
    CrowdFundingAddProjectModel *roadshowNameModel = _listArray[0][1];
    CrowdFundingAddProjectModel *companyNameModel = _listArray[0][2]; //选填
    
    CrowdFundingAddProjectModel *contactNameModel = _listArray[1][0];
    CrowdFundingAddProjectModel *contactPhoneModel = _listArray[1][1];
    CrowdFundingAddProjectModel *contactEmailPlanModel = _listArray[1][2];
    
    CrowdFundingAddProjectModel *roadshowGradeModel = _listArray[2][0];
    CrowdFundingAddProjectModel *teamIntroductionModel = _listArray[2][1];
    CrowdFundingAddProjectModel *roadshowIntroductionModel = _listArray[2][2];
    CrowdFundingAddProjectModel *competitiveAdvantageModel = _listArray[2][3];
    
    if ([roadshowNameModel.content isEqualToString:@"请填写"])
    {
        [YGAppTool showToastWithText:@"请填写项目名称"];
        _applyButton.userInteractionEnabled = YES;
        [YGNetService dissmissLoadingView];
        
        return ;
    }
    if ([companyNameModel.content isEqualToString:@"请填写"])
    {
        companyNameModel.content = @"";
    }
    if (_typeIdString == nil || [_typeIdString isEqualToString:@""])
    {
        [YGAppTool showToastWithText:@"请选择行业领域"];
        _applyButton.userInteractionEnabled = YES;
        [YGNetService dissmissLoadingView];

        return ;
    }
    
    if ([contactNameModel.content isEqualToString:@"请填写"])
    {
        [YGAppTool showToastWithText:@"请填写联系人姓名"];
        _applyButton.userInteractionEnabled = YES;
        [YGNetService dissmissLoadingView];
        
        return ;
    }

    if ([contactPhoneModel.content isEqualToString:@"请填写"])
    {
        [YGAppTool showToastWithText:@"请填写联系人手机号"];
        _applyButton.userInteractionEnabled = YES;
        [YGNetService dissmissLoadingView];

        return ;
    }
    
    if ([YGAppTool isNotPhoneNumber:contactPhoneModel.content]) {
        _applyButton.userInteractionEnabled = YES;
        [YGNetService dissmissLoadingView];
        return ;
    }
    if ([contactEmailPlanModel.content isEqualToString:@"请填写"] || [YGAppTool isNotEmail:contactEmailPlanModel.content])
    {
        _applyButton.userInteractionEnabled = YES;
        [YGNetService dissmissLoadingView];

        return ;
    }

    if ([roadshowGradeModel.content isEqualToString:@"请填写"])
    {
        [YGAppTool showToastWithText:@"请填写项目成绩内容"];
        _applyButton.userInteractionEnabled = YES;
        [YGNetService dissmissLoadingView];

        return ;
    }
    if ([teamIntroductionModel.content isEqualToString:@"请填写"])
    {
        [YGAppTool showToastWithText:@"请填写团队介绍内容"];
        _applyButton.userInteractionEnabled = YES;
        [YGNetService dissmissLoadingView];

        return ;
    }
    if ([roadshowIntroductionModel.content isEqualToString:@"请填写"])
    {
        [YGAppTool showToastWithText:@"请填写项目介绍内容"];
        _applyButton.userInteractionEnabled = YES;
        [YGNetService dissmissLoadingView];

        return ;
    }
    if ([competitiveAdvantageModel.content isEqualToString:@"请填写"])
    {
        [YGAppTool showToastWithText:@"请填写竞争优势"];
        _applyButton.userInteractionEnabled = YES;
        [YGNetService dissmissLoadingView];
        
        return ;
    }
    
    if (_bussinessPlanImages.count == 0) {
        [YGAppTool showToastWithText:@"请选择商业计划书图片进行上传"];
        _applyButton.userInteractionEnabled = YES;
        [YGNetService dissmissLoadingView];

        return ;
    }
    
    if (_bussinessPlanImagesUrls == nil) {//判断是否已上传了计划书图片获取了urls 未上传就先上传计划书图片
        
        
        [UploadImageTool uploadImages:_bussinessPlanImages progress:^(CGFloat progress) {
            
        } success:^(NSArray *urlArray) {
            
            //获取到的urls保存记录一下
            _bussinessPlanImagesUrls = urlArray;
            //转换成用逗号隔开的字符串
            NSString * bussinessPlanImagesUrlString = [urlArray componentsJoinedByString:@","];
            
            if (logoModel.image == nil) {//如果没有上传logo就只上传视频封面图片
                
                [UploadImageTool uploadImage:_thumbImage progress:^(NSString *key, float percent) {
                    
                } success:^(NSString *url) {
                    NSDictionary *dict = @{
                                           @"logo":@"",@"roadshowName":roadshowNameModel.content,@"companyName":companyNameModel.content,@"industryField":_typeIdString,@"contactName":contactNameModel.content,@"contactPhone":contactPhoneModel.content,@"contactEmail":contactEmailPlanModel.content,@"roadshowGrade":roadshowNameModel.content,@"teamIntroduction":teamIntroductionModel.content,@"roadshowIntroduction":roadshowIntroductionModel.content,@"competitiveAdvantage":competitiveAdvantageModel.content,@"businessPlan":bussinessPlanImagesUrlString,@"videoData":videoUrl,@"userId":YGSingletonMarco.user.userId,@"videoImg":url
                                           };
                    [self startPostWithURLString:REQUEST_applyRoadShow parameters:dict showLoadingView:NO scrollView:nil];
                } failure:^{
                    _applyButton.userInteractionEnabled = YES;
                    [YGNetService dissmissLoadingView];
                }];
         
            }else
            {//选择了logo就上传
                
                [UploadImageTool uploadImages:@[_thumbImage,_headImage] progress:^(CGFloat progress) {
                    
                } success:^(NSArray *urlArray) {
                    
                    NSDictionary *dict = @{
                                           @"logo":urlArray[1],@"roadshowName":roadshowNameModel.content,@"companyName":companyNameModel.content,@"industryField":_typeIdString,@"contactName":contactNameModel.content,@"contactPhone":contactPhoneModel.content,@"contactEmail":contactEmailPlanModel.content,@"roadshowGrade":roadshowNameModel.content,@"teamIntroduction":teamIntroductionModel.content,@"roadshowIntroduction":roadshowIntroductionModel.content,@"competitiveAdvantage":competitiveAdvantageModel.content,@"businessPlan":bussinessPlanImagesUrlString,@"videoData":videoUrl,@"userId":YGSingletonMarco.user.userId,@"videoImg":urlArray[0]
                                           };
                    [self startPostWithURLString:REQUEST_applyRoadShow parameters:dict showLoadingView:NO scrollView:nil];
                } failure:^{
                    _applyButton.userInteractionEnabled = YES;
                    [YGNetService dissmissLoadingView];

                }];
            }
        } failure:^{
            [YGAppTool showToastWithText:@"上传图片错误"];
            _applyButton.userInteractionEnabled = YES;
            [YGNetService dissmissLoadingView];

        }];
        
    }else //已经上传了计划书图片后出现问题终止了后面的请求 再次调起时不再重复上传计划书图
    {
        NSString * bussinessPlanImagesUrlString = [_bussinessPlanImagesUrls componentsJoinedByString:@","];
        
        if (logoModel.image == nil) {
            
            [UploadImageTool uploadImage:_thumbImage progress:^(NSString *key, float percent) {
                
            } success:^(NSString *url) {
                
                NSDictionary *dict = @{
                                       @"logo":@"",@"roadshowName":roadshowNameModel.content,@"companyName":companyNameModel.content,@"industryField":_typeIdString,@"contactName":contactNameModel.content,@"contactPhone":contactPhoneModel.content,@"contactEmail":contactEmailPlanModel.content,@"roadshowGrade":roadshowNameModel.content,@"teamIntroduction":teamIntroductionModel.content,@"roadshowIntroduction":roadshowIntroductionModel.content,@"competitiveAdvantage":competitiveAdvantageModel.content,@"businessPlan":bussinessPlanImagesUrlString,@"videoData":videoUrl,@"userId":YGSingletonMarco.user.userId,@"videoImg":url
                                       };
                [self startPostWithURLString:REQUEST_applyRoadShow parameters:dict showLoadingView:NO scrollView:nil];
            } failure:^{
                _applyButton.userInteractionEnabled = YES;
                [YGNetService dissmissLoadingView];

            }];
        }else
        {
            [UploadImageTool uploadImages:@[_thumbImage,_headImage] progress:^(CGFloat progress) {
                
            } success:^(NSArray *urlArray) {
                
                NSDictionary *dict = @{
                                       @"logo":urlArray[1],@"roadshowName":roadshowNameModel.content,@"companyName":companyNameModel.content,@"industryField":_typeIdString,@"contactName":contactNameModel.content,@"contactPhone":contactPhoneModel.content,@"contactEmail":contactEmailPlanModel.content,@"roadshowGrade":roadshowNameModel.content,@"teamIntroduction":teamIntroductionModel.content,@"roadshowIntroduction":roadshowIntroductionModel.content,@"competitiveAdvantage":competitiveAdvantageModel.content,@"businessPlan":bussinessPlanImagesUrlString,@"videoData":videoUrl,@"userId":YGSingletonMarco.user.userId,@"videoImg":urlArray[0]
                                       };
                [self startPostWithURLString:REQUEST_applyRoadShow parameters:dict showLoadingView:NO scrollView:nil];
            } failure:^{
                _applyButton.userInteractionEnabled = YES;
                [YGNetService dissmissLoadingView];

            }];
        }
    }
    
    
}
- (void)configUI
{
    NSArray * titlesArr = @[
                            
                            @[
                                @{
                                    @"title":@"LOGO(选填)",
                                    @"content":@""
                                    },
                                @{
                                    @"title":@"项目名称",
                                    @"content":@"请填写"
                                    },
                                @{
                                    @"title":@"公司名称(选填)",
                                    @"content":@"请填写"
                                    },
                                @{
                                    @"title":@"行业领域",
                                    @"content":@"请填写"
                                    },
                                ],
                            @[
                                @{
                                    @"title":@"联系人姓名",
                                    @"content":@"请填写联系人姓名"
                                    },
                                @{
                                    @"title":@"联系人手机",
                                    @"content":@"请填写联系人手机"
                                    },
                                @{
                                    @"title":@"联系人邮箱",
                                    @"content":@"请填写联系人邮箱"
                                    }
                                ],
                            @[
                                @{
                                    @"title":@"项目成绩",
                                    @"content":@"请填写"
                                    },
                                @{
                                    @"title":@"团队介绍(必填)",
                                    @"content":@"请填写"
                                    },
                                @{
                                    @"title":@"项目介绍",
                                    @"content":@"请填写"
                                    },
                                @{
                                    @"title":@"竞争优势",
                                    @"content":@"请填写"
                                    }
                                ],
                            @[
                                @{
                                    @"title":@"上传商业企划书",
                                    @"content":@"请上传"
                                    },
                                @{
                                    @"title":@"上传视频资料",
                                    @"content":@"请上传"
                                    }
                                
                                ]
                            ];
    [_listArray addObjectsFromArray:[CrowdFundingAddProjectModel mj_objectArrayWithKeyValuesArray:titlesArr]];
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, YGScreenWidth, YGScreenHeight-64-45) style:UITableViewStyleGrouped];
    _tableView.backgroundColor = colorWithTable;
    _tableView.showsVerticalScrollIndicator = NO;
//    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0.001)];
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0.001)];
    _tableView.sectionFooterHeight = 0.001;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    [_tableView registerClass:[CrowdFundingAddProjectTableViewCell class] forCellReuseIdentifier:@"CrowdFundingAddProjectTableViewCelllabel"];
    
    [_tableView registerClass:[CrowdFundingAddProjectTableViewCell class] forCellReuseIdentifier:@"CrowdFundingAddProjectTableViewCelltextfield1"];
    [_tableView registerClass:[CrowdFundingAddProjectTableViewCell class] forCellReuseIdentifier:@"CrowdFundingAddProjectTableViewCelltextfield0"];
    [_tableView registerClass:[CrowdFundingAddProjectTableViewCell class] forCellReuseIdentifier:@"CrowdFundingAddProjectTableViewCelltextfield2"];
    
    
    [self.view addSubview:_tableView];
    
    _applyButton = [[UIButton alloc]initWithFrame:CGRectMake(0,YGScreenHeight-YGStatusBarHeight-YGNaviBarHeight-45-YGBottomMargin,YGScreenWidth,45+YGBottomMargin)];
    _applyButton.titleEdgeInsets = UIEdgeInsetsMake(-YGBottomMargin, 0, 0, 0);
    [_applyButton addTarget:self action:@selector(applyButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    _applyButton.backgroundColor = colorWithMainColor;
    _applyButton.titleLabel.font = [UIFont systemFontOfSize:YGFontSizeBigOne];
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
    if (indexPath.section == 0 || indexPath.section == 2 ||  indexPath.section == 3)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:@"CrowdFundingAddProjectTableViewCelllabel" forIndexPath:indexPath];
    }else
    {
        NSString *str =[NSString stringWithFormat:@"CrowdFundingAddProjectTableViewCelltextfield%ld",indexPath.row];
        cell = [tableView dequeueReusableCellWithIdentifier:str forIndexPath:indexPath];
        
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    CrowdFundingAddProjectModel *model = _listArray[indexPath.section][indexPath.row];
    if (indexPath.section == 0 && indexPath.row == 0 && model.image == nil) {
        model.image = YGDefaultImgSquare;
    }
    cell.needReturnIndexPath = NO;
    cell.delegate = self;
    [cell setModel:model withIndexPath:indexPath];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row == 0)
    {
        return 60;
    }
    return 50;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, YGScreenWidth, 40)];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10,0 , YGScreenWidth-20, 40)];
    titleLabel.text = _sectionTitleArray[section];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.font = [UIFont systemFontOfSize:YGFontSizeNormal];
    titleLabel.textColor = colorWithDeepGray;
    [view addSubview:titleLabel];
    return view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _applyButton.userInteractionEnabled = YES;
    _selectIndexPath = indexPath;
    CrowdFundingAddProjectModel *model = _listArray[indexPath.section][indexPath.row];
    if (indexPath.section != 1)
    {
        if (indexPath.section == 0) {
            switch (indexPath.row) {
                case 0:
                {
                    _isVideo = NO;
                    _isHeadImagePhoto = YES;
                    UIActionSheet *act = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"拍照" otherButtonTitles:@"从手机选择", nil];
                    [act showInView:self.view];
                    
                    break;
                    
                }
                case 1:
                {
                    CrowdFundingAddProjectNameViewController *crowdFundingAddProjectNameViewController = [[CrowdFundingAddProjectNameViewController alloc] init];
                    crowdFundingAddProjectNameViewController.content = model.content;
                    crowdFundingAddProjectNameViewController.delegate = self;
                    crowdFundingAddProjectNameViewController.companyNameOrProjectName = 0;
                    [self.navigationController pushViewController:crowdFundingAddProjectNameViewController animated:YES];
                    break;
                    
                }
                case 2:
                {
                    CrowdFundingAddProjectNameViewController *crowdFundingAddProjectNameViewController = [[CrowdFundingAddProjectNameViewController alloc] init];
                    crowdFundingAddProjectNameViewController.content = model.content;
                    crowdFundingAddProjectNameViewController.delegate = self;
                    crowdFundingAddProjectNameViewController.companyNameOrProjectName = 1;
                    [self.navigationController pushViewController:crowdFundingAddProjectNameViewController animated:YES];
                    break;
                    
                }
                case 3:
                {
               
                    CrowdFundingAddProjectChooseTypeViewController *descriptionVc = [[CrowdFundingAddProjectChooseTypeViewController alloc] init];
                    descriptionVc.pageFromController = @"RoadShowHallApplyViewController";
                    descriptionVc.delegate = self;
                    [self.navigationController pushViewController:descriptionVc animated:YES];
                    
                    break;
                    
                }
                    
            }
        }else if (indexPath.section == 2)
        {
            switch (indexPath.row) {
                case 0:
                {
                    CrowdFundingAddProjectDescriptionViewController *descriptionVc = [[CrowdFundingAddProjectDescriptionViewController alloc] init];
                    descriptionVc.content = model.content;
                    descriptionVc.delegate = self;
                    descriptionVc.placehoder = @"项目成绩";
                    descriptionVc.iputTypeOfPage = iputTypeOfInitiaterIntroduceType;
                    [self.navigationController pushViewController:descriptionVc animated:YES];
                    break;
                    
                }
                case 1:
                {
                    CrowdFundingAddProjectDescriptionViewController *descriptionVc = [[CrowdFundingAddProjectDescriptionViewController alloc] init];
                    descriptionVc.content = model.content;
                    descriptionVc.placehoder = @"团队介绍";
                    descriptionVc.iputTypeOfPage = iputTypeOfProjectPlanType;
                    descriptionVc.delegate = self;
                    [self.navigationController pushViewController:descriptionVc animated:YES];
                    break;
                    
                }
                case 2:
                {
                    CrowdFundingAddProjectDescriptionViewController *descriptionVc = [[CrowdFundingAddProjectDescriptionViewController alloc] init];
                    descriptionVc.content = model.content;
                    descriptionVc.placehoder = @"项目介绍";
                    descriptionVc.iputTypeOfPage = iputTypeOfProjectIntroduceType;
                    descriptionVc.delegate = self;
                    [self.navigationController pushViewController:descriptionVc animated:YES];
                    break;
                    
                }
                case 3:
                {
                    CrowdFundingAddProjectDescriptionViewController *descriptionVc = [[CrowdFundingAddProjectDescriptionViewController alloc] init];
                    descriptionVc.content = model.content;
                    descriptionVc.placehoder = @"竞争优势";
                    descriptionVc.iputTypeOfPage = iputTypeOfProjectCompetitiveAdvantageType;
                    descriptionVc.delegate = self;
                    [self.navigationController pushViewController:descriptionVc animated:YES];
                    break;
                    
                }
                    
                    
            }
            
        }else if(indexPath.section == 3)
        {
            
            switch (indexPath.row)
            {
                case 0:
                {
                    if (YGSingletonMarco.roadShowHallAddImageViewController)
                    {
                        [self.navigationController pushViewController:YGSingletonMarco.roadShowHallAddImageViewController animated:YES];
                        
                    }else
                    {
                        RoadShowHallAddVideoImageViewController *vc = [[RoadShowHallAddVideoImageViewController alloc] init];
                        vc.delegate = self;
                        vc.pageType = @"plan";
                        [self.navigationController pushViewController:vc animated:YES];
                        
                    }
                    
                    break;
                }
                case 1:
                {
                    if (YGSingletonMarco.roadShowHallAddVideoViewController)
                    {
                        [self.navigationController pushViewController:YGSingletonMarco.roadShowHallAddVideoViewController animated:YES];
                        
                    }else
                    {
                        RoadShowHallAddVideoImageViewController *vc = [[RoadShowHallAddVideoImageViewController alloc] init];
                        vc.delegate = self;
                        vc.pageType = @"video";
                        [self.navigationController pushViewController:vc animated:YES];
                    }
                    break;
                }
                    
            }
            
            
        }
    }
}
#pragma actionSheet代理

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
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

#pragma 发布按钮
- (void)applyButtonAction:(UIButton *)btn
{
    if (_videoData == nil)
    {
        [YGAppTool showToastWithText:@"请选择路演视频进行上传"];
        return;
    }
    btn.userInteractionEnabled = NO;
    [YGNetService showLoadingViewWithSuperView:self.view];

    if (_videoUrl == nil)
    {

        [UploadImageTool uploadvideoData:_videoData progress:^(NSString *key, float percent) {
            
        } success:^(NSString *url) {
            NSLog(@"上传成功");
            _videoUrl = url;
            [self applyRoadShowSubmitWithVideoUrl:url];
        } failure:^{
            [YGAppTool showToastWithText:@"视频上传失败"];
            btn.userInteractionEnabled = YES;
            [YGNetService dissmissLoadingView];

        }];
    }else
    {
        
        [self applyRoadShowSubmitWithVideoUrl:_videoUrl];
        
    }
    
    
    
}

- (void)didReceiveSuccessResponeseWithURLString:(NSString *)URLString parameters:(id)parameters responeseObject:(id)responseObject
{
    
    [YGAppTool showToastWithText:@"申请已发布，请等待审核！"];
    _applyButton.userInteractionEnabled = YES;
    [self.navigationController popViewControllerAnimated:YES];
    
}

-(void)didReceiveFailureResponeseWithURLString:(NSString *)URLString parameters:(id)parameters error:(NSError *)error
{
    _applyButton.userInteractionEnabled = YES;
    
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
        
        
        if (_isHeadImagePhoto == YES) {
            CrowdFundingAddProjectModel *logoModel = _listArray[0][0];
            _headImage = image;
            logoModel.image = image;
            logoModel.content = @"";
            [_tableView reloadData];
            
        }
        
    }
    
}




- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    
    NSLog(@"放弃");
    [self dismissViewControllerAnimated:YES completion:nil];
    
}


#pragma 代理
//选择类型带回来的值
- (void)takeTypeValueBackWithValue:(NSString *)value
{
    CrowdFundingAddProjectModel *model = _listArray[0][0];
    model.content = value;
    [_tableView reloadData];
}

//填写项目名称带回来的值 公司名称
- (void)takeProjectNameValueBackWithValue:(NSString *)value
{
    if (_selectIndexPath.row == 1) {
        CrowdFundingAddProjectModel *model = _listArray[0][1];
        model.content = value;
    }
    if (_selectIndexPath.row == 2) {
        CrowdFundingAddProjectModel *model = _listArray[0][2];
        model.content = value;
    }

    [_tableView reloadData];
}
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
        case iputTypeOfProjectCompetitiveAdvantageType: {
            model = _listArray[2][3];
            break;
        }
    }
    model.content = value;
    [_tableView reloadData];
}
//选择行业领域
- (void)takeTypeValueBackWithModel:(CrowdFundingAddProjectChooseTypeModel *)model
{
    CrowdFundingAddProjectModel *listModel = _listArray[0][3];
    listModel.content = model.tradeName;
    _typeIdString = model.id;
    [_tableView reloadData];
    
}

- (void)textfieldReturnValue:(NSString *)value withTextfiledTag:(NSInteger)textfieldTag
{
    CrowdFundingAddProjectModel *model;
    
    if (textfieldTag == 1000) {
        model = _listArray[1][0];
    }
    if (textfieldTag == 1001) {
        model = _listArray[1][1];
    }
    if (textfieldTag == 1002) {
        model = _listArray[1][2];
    }
    model.content = value;
    [_tableView reloadData];
}

- (void)takeBackWithCoverImage:(UIImage *)coverImage andVideoData:(NSData *)videoData
{
    _videoData = videoData;
    _thumbImage = coverImage;
    CrowdFundingAddProjectModel *roadShowVideoModel = _listArray[3][1];
    roadShowVideoModel.content = @"已上传";
    [_tableView reloadData];
}

- (void)selectVideoImagesWithArray:(NSArray *)fileArray
{
    _bussinessPlanImagesUrls = nil;
    
    _bussinessPlanImages = (NSMutableArray *)fileArray;
    CrowdFundingAddProjectModel *businessPlanModel = _listArray[3][0];
    businessPlanModel.content = @"已上传";
    [_tableView reloadData];
}
@end
