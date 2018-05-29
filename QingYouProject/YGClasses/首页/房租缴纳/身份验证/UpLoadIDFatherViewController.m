//
//  UpLoadIDFatherViewController.m
//  FrienDo
//
//  Created by apple on 2017/10/19.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "UpLoadIDFatherViewController.h"
#import "UpLoadEnterpriseViewController.h"
#import "UpLoadPersonViewController.h"
#import "YGSegmentView.h"
#import "UpLoadModel.h"
#import "UploadImageTool.h"

#import "HouseRentAuditViewController.h"

#define greenColor [UIColor colorWithHue:0.37 saturation:0.77 brightness:0.75 alpha:1]

@interface UpLoadIDFatherViewController ()<YGSegmentViewDelegate,UIScrollViewDelegate,UpLoadEnterpriseDelegate,UpLoadPersonDelegate,UIImagePickerControllerDelegate>
{
    UIView * _headerView;//headerView背景图
    UITextField * _nameTextField;//姓名/公司名
    UITextField * _phoneTextField;//电话
    YGSegmentView * _segmentView;//选择器
    UIScrollView * _scrollView;//滑动视图
    NSMutableArray * _controllersArray;
    NSMutableArray * _personArry;//身份证数据数组
    NSMutableArray * _enterpriseArry;//企业数据数组
    
    NSMutableArray *_tokenArray;
    UIImagePickerController *_picker;
    NSString    *_takePhotoType; //0 正面 1反面 2企业
    
    UpLoadPersonViewController * _personController;
    UpLoadEnterpriseViewController *_enterpriseController;
}


@end

@implementation UpLoadIDFatherViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = colorWithTable;
    
    [self configUI];
    [self configSegmentView];
}

//配置View
-(void)configUI
{
    //headerView
    _headerView = [[UIView alloc]init];
    _headerView.frame = CGRectMake(0, 0, YGScreenWidth, 200);
    _headerView.backgroundColor = colorWithYGWhite;
    [self.view addSubview:_headerView];
    
    //公司名
    UILabel * nameTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, 100, 60)];
    nameTitleLabel.text = @"公司名/姓名";
    nameTitleLabel.textColor = [UIColor darkGrayColor];
    nameTitleLabel.font = [UIFont systemFontOfSize:YGFontSizeBigTwo];
    [_headerView addSubview:nameTitleLabel];
    
    //手机号text
    _nameTextField = [[UITextField alloc] initWithFrame:CGRectMake(115, 0,_headerView.width - 130 ,60)];
    _nameTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _nameTextField.font = [UIFont systemFontOfSize:YGFontSizeBigOne];
    _nameTextField.textColor = colorWithBlack;
    _nameTextField.placeholder = @"请输入公司名/姓名";
    _nameTextField.keyboardType = UIKeyboardTypeDefault;
    _nameTextField.textAlignment = NSTextAlignmentRight;
    [_headerView addSubview:_nameTextField];
    
    //线
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_nameTextField.frame), YGScreenWidth, 0.5)];
    lineView.backgroundColor = colorWithLine;
    [_headerView addSubview:lineView];
    
    //红星
    UILabel * starLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, CGRectGetMaxY(lineView.frame) + 10, 5, 30)];
    starLabel.text = @"*";
    starLabel.font = [UIFont systemFontOfSize:YGFontSizeSmallOne];
    starLabel.textColor = [UIColor redColor];
    [_headerView addSubview:starLabel];
    
    //介绍
    UILabel * deptLabel = [[UILabel alloc]initWithFrame:CGRectMake(25, CGRectGetMaxY(lineView.frame) + 15, _headerView.width - 30, 60)];
    deptLabel.text = @"若为注册公司，请填写合同预留的公司名；若为个人，请填写合同预留的姓名。";
    deptLabel.font = [UIFont systemFontOfSize:YGFontSizeNormal];
    deptLabel.textColor = colorWithLightGray;
    [deptLabel sizeToFitVerticalWithMaxWidth:_headerView.width - 30];
    [_headerView addSubview:deptLabel];
    
    //线
    UIView * deptLineView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(deptLabel.frame) + 10, _headerView.width, 0.5)];
    deptLineView.backgroundColor = colorWithLine;
    [_headerView addSubview:deptLineView];
    
    //公司名
    UILabel * phoneTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, CGRectGetMaxY(deptLineView.frame), 100, 60)];
    phoneTitleLabel.text = @"合同预留电话";
    phoneTitleLabel.font = [UIFont systemFontOfSize:YGFontSizeBigTwo];
    phoneTitleLabel.textColor = [UIColor darkGrayColor];
    [_headerView addSubview:phoneTitleLabel];
    
    //手机号text
    _phoneTextField = [[UITextField alloc] initWithFrame:CGRectMake(115, CGRectGetMaxY(deptLineView.frame), YGScreenWidth - 130, 60)];
    _phoneTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _phoneTextField.font = [UIFont systemFontOfSize:YGFontSizeBigOne];
    _phoneTextField.textColor = colorWithBlack;
    _phoneTextField.placeholder = @"请输入真实电话";
    _phoneTextField.keyboardType = UIKeyboardTypeDefault;
    _phoneTextField.textAlignment = NSTextAlignmentRight;
    [_headerView addSubview:_phoneTextField];
    
    //更新高度
    _headerView.height = CGRectGetMaxY(_phoneTextField.frame);
}

#pragma mark ---- 选择器 / _scrollView
- (void)configSegmentView
{
    //选择器
    _segmentView = [[YGSegmentView alloc]initWithFrame:CGRectMake(YGScreenWidth / 2 - YGScreenWidth / 2, CGRectGetMaxY(_headerView.frame) + 10,YGScreenWidth, 40) titlesArray:@[@"个人",@"企业"] lineColor:greenColor delegate:self];
    _segmentView.backgroundColor = colorWithYGWhite;
    [self.view addSubview:_segmentView];
    
    //线
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_segmentView.frame), YGScreenWidth, 0.5)];
    lineView.backgroundColor = colorWithLine;
    [self.view addSubview:lineView];
    
    //_scrollView
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(lineView.frame), KAPP_WIDTH, KAPP_HEIGHT - KNAV_HEIGHT - KTAB_HEIGHT - _headerView.height)];
    _scrollView.contentSize = CGSizeMake(YGScreenWidth * 2, _scrollView.height);
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.pagingEnabled = YES;
    _scrollView.delegate = self;
    [self.view addSubview:_scrollView];
    
    _controllersArray = [[NSMutableArray alloc]initWithArray:@[@"个人",@"企业"]];
    
    [self segmentButtonClickWithIndex:0];
}

//nav
-(void)configAttribute
{
    self.naviTitle = @"身份验证";
    [YGAppTool showToastWithText:self.notioceString];
    _tokenArray = [[NSMutableArray alloc] init];
    _personArry = [[NSMutableArray alloc] initWithArray:@[[UIImage imageNamed:@"verify_idcard_front_img"],[UIImage imageNamed:@"verify_idcard_back_img"]]];
    _enterpriseArry = [[NSMutableArray alloc] initWithArray:@[[UIImage imageNamed:@"verify_businesslicense_img"]]];
    //提交
    UIButton *rightButton = [[UIButton alloc]init];
    [rightButton setTitle:@"提交" forState:UIControlStateNormal];
    [rightButton setTitleColor:greenColor forState:UIControlStateNormal];
    [rightButton sizeToFit];
    [rightButton addTarget:self action:@selector(rightButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = rightBarButton;
}



#pragma mark ---- 选择器代理
-(void)segmentButtonClickWithIndex:(int)buttonIndex
{
    [self loadControllerWithIndex:buttonIndex];
    
    [UIView animateWithDuration:0.25 animations:^{
        _scrollView.contentOffset = CGPointMake(buttonIndex * YGScreenWidth, _scrollView.contentOffset.y);
    }];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    int index = scrollView.contentOffset.x / YGScreenWidth;
    
    [self loadControllerWithIndex:index];
    [_segmentView selectButtonWithIndex:index];
}

-(void)loadControllerWithIndex:(int)index
{

        if (index == 0)
        {
            if (_personController == nil) {
                NSMutableArray *imageArry = [[NSMutableArray alloc] init];
                //正面数据
                UpLoadModel * frontModel = [[UpLoadModel alloc]init];
                frontModel.title = @"身份证正面照";
                frontModel.upState = @"0";
                frontModel.image = [UIImage imageNamed:@"verify_idcard_front_img"];
                [imageArry addObject:frontModel];
                
                //反面数据
                UpLoadModel * tailModel = [[UpLoadModel alloc]init];
                tailModel.title = @"身份证反面照";
                tailModel.upState = @"0";
                tailModel.image = [UIImage imageNamed:@"verify_idcard_back_img"];
                [imageArry addObject:tailModel];
                
                _personController = [[UpLoadPersonViewController alloc]init];
                _personController.controllerFrame = CGRectMake(YGScreenWidth * index, 0, _scrollView.width, _scrollView.height);
                _personController.delegate = self;
                _personController.listArray = imageArry;
                [self addChildViewController:_personController];
                [_scrollView addSubview:_personController.view];
            }
          
        }
        else
        {
            if (_enterpriseController == nil) {
                NSMutableArray *imageArry = [[NSMutableArray alloc] init];

                //默认数据
                UpLoadModel * tailModel = [[UpLoadModel alloc]init];
                tailModel.title = @"营业执照";
                tailModel.upState = @"0";
                tailModel.image = [UIImage imageNamed:@"verify_businesslicense_img"];
                [imageArry addObject:tailModel];
                
                _enterpriseController = [[UpLoadEnterpriseViewController alloc]init];
                _enterpriseController.controllerFrame = CGRectMake(YGScreenWidth * index, 0, _scrollView.width, _scrollView.height);
                _enterpriseController.delegate = self;
                _enterpriseController.listArray = imageArry;
                [self addChildViewController:_enterpriseController];
                [_scrollView addSubview:_enterpriseController.view];
            }
           
        }
    
}
#pragma 点击事件
//提交
-(void)rightButtonClick:(UIButton *)button
{
    
    int index = _scrollView.contentOffset.x / YGScreenWidth;

    if (_nameTextField.text.length < 1)
    {
        [YGAppTool showToastWithText:@"请输入公司名/姓名"];
        return;
    }
    
    if (_phoneTextField.text.length < 1)
    {
        [YGAppTool showToastWithText:@"请输入合同预留电话"];
        return;
    }
    if (index == 0)
    {
        if ([_personArry[0] isEqual:[UIImage imageNamed:@"verify_idcard_front_img"]]|| _personArry[0] == nil)
        {
            [YGAppTool showToastWithText:@"身份证正面照错误，请重新上传"];
            return;
        }
        if ([_personArry[1] isEqual:[UIImage imageNamed:@"verify_idcard_back_img"]] || _personArry[1] == nil)
        {
            [YGAppTool showToastWithText:@"身份证反面照错误，请重新上传"];
            return;
        }
        
        button.userInteractionEnabled = NO;
        [YGNetService showLoadingViewWithSuperView:self.view];
        [UploadImageTool uploadImages:_personArry progress:^(CGFloat progress) {
            
        } success:^(NSArray *urlArray) {
            //上传完成 移除加载图
            [YGNetService dissmissLoadingView];
            NSDictionary *dict = @{@"userid":YGSingletonMarco.user.userId,@"status":@"0",@"name":_nameTextField.text,@"phone":_phoneTextField.text,@"img":[NSString stringWithFormat:@"%@,%@",urlArray[0],urlArray[1]]};
            
            [YGNetService YGPOST:REQUEST_SubmitHouserAudit parameters:dict showLoadingView:NO scrollView:nil success:^(id responseObject) {
                if ([responseObject[@"result"] isEqualToString:@"1"])
                {
                    button.userInteractionEnabled = YES;
                    HouseRentAuditViewController *vc = [[HouseRentAuditViewController alloc] init];
                    vc.houseRentHomeOrCertifyPage = @"certifyPage";
                    vc.naviTitle = @"身份认证";
                    [self.navigationController pushViewController:vc animated:YES];
                }
            } failure:^(NSError *error) {
                button.userInteractionEnabled = YES;
                
            }];
        } failure:^{
            button.userInteractionEnabled = YES;
            //上传失败 移除加载图
            [YGNetService dissmissLoadingView];
        }];
        
        
    }else
    {
        if ([_enterpriseArry[0] isEqual:[UIImage imageNamed:@"verify_businesslicense_img"]] || _enterpriseArry[0] == nil)
        {
            
            [YGAppTool showToastWithText:@"企业营业照错误，请重新上传"];
            return;
        }
        button.userInteractionEnabled = NO;
        [YGNetService showLoadingViewWithSuperView:self.view];
        [UploadImageTool uploadImage:_enterpriseArry[0] progress:nil success:^(NSString *url) {
            //上传完成 移除加载图
            [YGNetService dissmissLoadingView];
            NSDictionary *dict = @{@"userid":YGSingletonMarco.user.userId,@"status":@"1",@"name":_nameTextField.text,@"phone":_phoneTextField.text,@"img":url};
            [YGNetService YGPOST:REQUEST_SubmitHouserAudit parameters:dict showLoadingView:NO scrollView:nil success:^(id responseObject) {
                button.userInteractionEnabled = YES;
                if ([responseObject[@"result"] isEqualToString:@"1"])
                {
                    HouseRentAuditViewController *vc = [[HouseRentAuditViewController alloc] init];
                    vc.houseRentHomeOrCertifyPage = @"certifyPage";
                    vc.naviTitle = @"身份认证";
                    [self.navigationController pushViewController:vc animated:YES];
                }
            } failure:^(NSError *error) {
                button.userInteractionEnabled = YES;
            }];
        } failure:^{
            button.userInteractionEnabled = YES;
            //上传失败 移除加载图
            [YGNetService dissmissLoadingView];
        }];
    }
    
    

}


- (void)upLoadPersonBtnAction:(UIButton *)button
{
    //正面

    switch (button.tag) {
        case 0:
        {
            _takePhotoType = @"hourseRentIdentityPhotoFront";
            break;
        }
        case 1:
        {
            _takePhotoType = @"hourseRentIdentityPhotoBack";
            break;
        }
        case 2:
        {
            _takePhotoType = @"hourseRentEnterprisePhoto";
            break;
        }
            
    }
    _picker = [[UIImagePickerController alloc] init];//初始化
    _picker.delegate = (id)self;
    _picker.allowsEditing = NO;//设置可编辑
    _picker.sourceType = UIImagePickerControllerSourceTypeCamera;
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
    
    if ([_takePhotoType isEqualToString:@"hourseRentIdentityPhotoFront"])
    {
        UpLoadModel * frontModel = _personController.listArray[0];
        frontModel.image = image;
        [_personController.tableView reloadData];
        _personArry[0] = image;
    }
    if ([_takePhotoType isEqualToString:@"hourseRentIdentityPhotoBack"])
    {
        UpLoadModel * frontModel = _personController.listArray[1];
        frontModel.image = image;
        [_personController.tableView reloadData];
        _personArry[1] = image;
    }
    if ([_takePhotoType isEqualToString:@"hourseRentEnterprisePhoto"])
    {
        UpLoadModel * frontModel = _enterpriseController.listArray[0];
        frontModel.image = image;
        [_enterpriseController.tableView reloadData];
        _enterpriseArry[0] = image;
    }
}
#pragma 图片处理
//照片获取本地路径转换
- (NSString *)getImagePath:(UIImage *)Image type:(NSString *)type{
    NSString *filePath = nil;
    NSData *data = nil;
    if (UIImagePNGRepresentation(Image) == nil) {
        data = UIImageJPEGRepresentation(Image, 1.0);
    } else {
        data = UIImagePNGRepresentation(Image);
    }
    
    //图片保存的路径
    //这里将图片放在沙盒的documents文件夹中
    NSString *DocumentsPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    
    //文件管理器
    NSFileManager *fileManager = [NSFileManager defaultManager];

    //把刚刚图片转换的data对象拷贝至沙盒中
    [fileManager createDirectoryAtPath:DocumentsPath withIntermediateDirectories:YES attributes:nil error:nil];
    NSString *ImagePath = [[NSString alloc] initWithFormat:@"/uploadImage%@.png",_takePhotoType];
    [fileManager createFileAtPath:[DocumentsPath stringByAppendingString:ImagePath] contents:data attributes:nil];
    
    //得到选择后沙盒中图片的完整路径
    filePath = [[NSString alloc] initWithFormat:@"%@%@", DocumentsPath, ImagePath];
 
    return filePath;
}


@end
