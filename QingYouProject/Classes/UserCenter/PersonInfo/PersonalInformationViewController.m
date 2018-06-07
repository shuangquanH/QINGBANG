//
//  PersonalInformationViewController.m
//  QingYouProject
//
//  Created by zhaoao on 2017/11/9.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "PersonalInformationViewController.h"
#import "YGActionSheetView.h"
#import "EditNameViewController.h"
#import <UIImageView+WebCache.h>
#import "QiniuSDK.h"
#import "UploadImageTool.h"

@interface PersonalInformationViewController () <UITableViewDelegate,UITableViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate> {
    NSArray *_titleArray;
}

@property(nonatomic,strong) UIView *blackView; //点击头像时黑色半透明背景
@property(nonatomic,strong) UIImage *headImage;
@property(nonatomic,strong) UITableView *tableView;
@end

@implementation PersonalInformationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.naviTitle = @"个人信息";
    
    _titleArray = [NSArray arrayWithObjects:@"头像",@"账号",@"昵称",@"公司名称",@"所在园区",@"简介",@"邀请码", nil];
    [self.view addSubview:self.tableView];
}

-(UITableView *)tableView
{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, YGScreenWidth, YGScreenHeight - YGNaviBarHeight - YGStatusBarHeight) style:UITableViewStyleGrouped];
        _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, YGScreenWidth, 0.001)];
        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, YGScreenWidth, 0.001)];
        _tableView.sectionHeaderHeight = 0.001;
        _tableView.sectionFooterHeight = 10;
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    [self.tableView reloadData];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.font = [UIFont systemFontOfSize:15.0];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }

    if(indexPath.section == 0)
    {
        cell.textLabel.text = _titleArray[indexPath.row];
        if (indexPath.row == 0) {
            UIImageView *headImageView1 = [cell.contentView viewWithTag:1994];
            if (!headImageView1) {
                [headImageView1 removeFromSuperview];
            }
            UIImageView *headImageView = [[UIImageView alloc]initWithFrame:CGRectMake(YGScreenWidth - 80, 10, 40, 40)];
            headImageView.layer.cornerRadius = 20;
            headImageView.clipsToBounds = YES;
            headImageView.tag = 1994;
            [headImageView sd_setImageWithURL:[NSURL URLWithString:YGSingletonMarco.user.userImg] placeholderImage:[UIImage imageNamed:@"defaultavatar"]];
            [cell.contentView addSubview:headImageView];
        }
        if(indexPath.row == 1)
        {
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.detailTextLabel.text = YGSingletonMarco.user.phone;
        }
        if(indexPath.row == 2)
        {
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.detailTextLabel.text = YGSingletonMarco.user.userName;
        }
    }
    if(indexPath.section == 1)
    {
        cell.textLabel.text = _titleArray[indexPath.row + 3];
        if (indexPath.row == 0) {
            cell.detailTextLabel.text = YGSingletonMarco.user.company;
        }
        if (indexPath.row == 1) {
            cell.detailTextLabel.text = YGSingletonMarco.user.gion;
        }
        if (indexPath.row == 2) {
            cell.detailTextLabel.text = YGSingletonMarco.user.description;
        }
    }
    if (indexPath.section == 2) {
        cell.textLabel.text = _titleArray[indexPath.row + 6];
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.detailTextLabel.text = YGSingletonMarco.user.code;
    }
    cell.detailTextLabel.font = [UIFont systemFontOfSize:15.0];
    return cell;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 2) {
        return 1;
    }
    return 3;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [_tableView cellForRowAtIndexPath:indexPath];
    if ([cell.textLabel.text isEqualToString:@"账号"] || [cell.textLabel.text isEqualToString:@"邀请码"]) {
        return ;
    }
    
    if ([cell.textLabel.text isEqualToString:@"头像"]) {
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
            imagePickerController.cameraDevice = UIImagePickerControllerCameraDeviceFront;
            // 展示选取照片控制器
            [self presentViewController:imagePickerController animated:YES completion:^{}];
        }];
        
        UIAlertAction *photosAction = [UIAlertAction actionWithTitle:@"从相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            [self presentViewController:imagePickerController animated:YES completion:^{}];
        }];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        }];
        
        // 判断是否支持相机
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
        {
            // 添加警告按钮
            [alert addAction:cameraAction];
        }
        [alert addAction:photosAction];
        [alert addAction:cancelAction];
        // 展示警告控制器
        [self presentViewController:alert animated:YES completion:nil];
    }

    if ([cell.textLabel.text isEqualToString:@"所在园区"]) {
        [YGNetService YGPOST:@"ChooseGarden" parameters:@{} showLoadingView:NO scrollView:nil success:^(id responseObject) {
            
            NSLog(@"%@",responseObject);
            
            NSArray *listArray = [NSArray array];
            listArray = [responseObject valueForKey:@"list"];
            NSMutableArray *showMutableArray = [NSMutableArray array];
            for (int i = 0; i < listArray.count; i++) {
                [showMutableArray addObject:[listArray[i] valueForKey:@"label"]];
            }
            
            [YGActionSheetView showAlertWithTitlesArray:showMutableArray handler:^(NSInteger selectedIndex, NSString *selectedString) {
                cell.detailTextLabel.text = selectedString;
                NSString *areaNumber = [NSString stringWithFormat:@"%ld",selectedIndex];
                [self modificateAreaData:selectedString andAreaNumber:areaNumber];
            }];
            
        } failure:^(NSError *error) {
            
        }];
    }
    else
    {
        EditNameViewController *vc = [[EditNameViewController alloc]init];
        vc.titleString = cell.textLabel.text;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

//修改所在园区
-(void)modificateAreaData:(NSString *)areaString andAreaNumber:(NSString *)numberString
{
    [YGNetService YGPOST:@"UpdateMyBase" parameters:@{@"userId":YGSingletonMarco.user.userId,@"type":@"4",@"value":numberString} showLoadingView:YES scrollView:nil success:^(id responseObject) {
        
        NSLog(@"%@",responseObject);
        [YGAppTool showToastWithText:@"修改成功"];
        YGSingletonMarco.user.gion = areaString;
        [YGSingletonMarco archiveUser];
        
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark - UIImagePickerControllerDelegate
// 完成图片的选取后调用的方法
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    // 选取完图片后跳转回原控制器
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    // 从info中将图片取出，并加载到imageView当中
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    self.headImage = image;
//    UIImageView *headImageView = [self.view viewWithTag:1994];
//    headImageView.image = image;
    [self handlePicturedata];
}

// 保存图片后到相册后，回调的相关方法，查看是否保存成功
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    if (error == nil){
        NSLog(@"Image was saved successfully.");
    } else {
        NSLog(@"An error happened while saving the image.");
        NSLog(@"Error = %@", error);
    }
}
// 取消选取调用的方法
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:nil];
}
//处理图片数据
-(void)handlePicturedata
{
    [YGNetService showLoadingViewWithSuperView:YGAppDelegate.window];
    [UploadImageTool uploadImage:_headImage progress:^(NSString *key, float percent) {
        
    } success:^(NSString *url) {
        
        [YGNetService YGPOST:@"UpdateMyBase" parameters:@{@"userId":YGSingletonMarco.user.userId,@"type":@"1",@"value":url} showLoadingView:NO scrollView:_tableView success:^(id responseObject) {
            [YGNetService dissmissLoadingView];
            
            NSLog(@"%@",responseObject);
            
            YGSingletonMarco.user.userImg = url;
            [YGSingletonMarco archiveUser];
            
            [YGAppTool showToastWithText:@"保存成功!"];
            [_tableView reloadData];
            
        } failure:^(NSError *error) {
            [YGNetService dissmissLoadingView];
            NSLog(@"提交失败");
        }];
    } failure:^{
        NSLog(@"传图失败");
        [YGNetService dissmissLoadingView];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
