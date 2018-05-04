//
//  SetupViewController.m
//  QingYouProject
//
//  Created by zhaoao on 2017/11/8.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "SetupViewController.h"
#import "LoginViewController.h"
#import "PasswordSetValidateController.h"
#import "AboutusViewController.h"
#import "ManageMailPostViewController.h"
#import "EvaluateViewController.h"
#import "YGPushSDK.h"

@interface SetupViewController () <UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_tableView;
    NSArray *_titleArray;
}

@end

@implementation SetupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.naviTitle = @"设置";
    self.view.backgroundColor = colorWithTable;
    [self configUI];
}
-(void)configUI
{
    if(YGSingletonMarco.user.userId.length)
    {
         _titleArray = [NSArray arrayWithObjects:@"手机号",@"密码设置",@"收货地址",@"清除缓存",@"反馈",@"关于我们", nil];
    }
    else
    {
        _titleArray = [NSArray arrayWithObjects:@"清除缓存",@"关于我们", nil];
    }
   
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, YGScreenWidth, 300) style:UITableViewStyleGrouped];
    _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, YGScreenWidth, 0.001)];
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, YGScreenWidth, 0.001)];
    _tableView.sectionHeaderHeight = 0.001;
    _tableView.sectionFooterHeight = 0.001;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.scrollEnabled = NO;
    [self.view addSubview:_tableView];
    _tableView.backgroundColor = colorWithTable;
    
    if(YGSingletonMarco.user.userId.length)
    {
        UIButton *exitButton = [UIButton buttonWithType:UIButtonTypeCustom];
        exitButton.backgroundColor = [UIColor whiteColor];
        exitButton.frame = CGRectMake(0, 350, YGScreenWidth, 50);
        [exitButton setTitle:@"退出登录" forState:UIControlStateNormal];
        [exitButton setTitleColor:colorWithOrangeColor forState:UIControlStateNormal];
        [exitButton addTarget:self action:@selector(exitClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:exitButton];
        exitButton.layer.borderWidth = 1;
        exitButton.layer.borderColor = colorWithLine.CGColor;
        
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.font = [UIFont systemFontOfSize:15.0];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    cell.textLabel.text = _titleArray[indexPath.row];
    if ([cell.textLabel.text isEqualToString:@"清除缓存"]) {
        cell.accessoryType = UITableViewCellAccessoryNone;
        NSInteger memory = (int)[self filePath];
        NSString * memoryString = [NSString stringWithFormat:@"%ldM",memory];;
        cell.detailTextLabel.text = memoryString;
    }
    if ([cell.textLabel.text isEqualToString:@"手机号"]) {
        cell.accessoryType = UITableViewCellAccessoryNone;
        UILabel *phoneLabel = [[UILabel alloc]initWithFrame:CGRectMake(YGScreenWidth - 300, 0, 285, 50)];
        phoneLabel.textAlignment = NSTextAlignmentRight;
        phoneLabel.text = YGSingletonMarco.user.phone;
        [cell.contentView addSubview:phoneLabel];
    }
    return cell;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _titleArray.count;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(!YGSingletonMarco.user.userId.length)
    {
        if (indexPath.row == 0) {
            [self clearFile];
        }
        if (indexPath.row == 1) {
            AboutusViewController *vc = [[AboutusViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }
        return;
        
    }
    else
    {
        if (indexPath.row == 1) {
            PasswordSetValidateController *vc = [[PasswordSetValidateController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }
        if(indexPath.row == 2)
        {
            ManageMailPostViewController *vc = [[ManageMailPostViewController alloc] init];
            vc.pageType = @"personCenter";
            [self.navigationController pushViewController:vc animated:YES];
        }
        if(indexPath.row == 3)
        {
            [self clearFile];
        }
        if (indexPath.row == 4) {
            EvaluateViewController *vc = [[EvaluateViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }
        if (indexPath.row == 5) {
            AboutusViewController *vc = [[AboutusViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}

// 显示缓存大小
-(float)filePath
{
    NSString * cachPath = [NSSearchPathForDirectoriesInDomains ( NSCachesDirectory,NSUserDomainMask,YES) firstObject];
    return [ self folderSizeAtPath :cachPath];
}
//1:首先我们计算一下 单个文件的大小
- ( float ) folderSizeAtPath:( NSString *) folderPath{
    NSFileManager * manager = [ NSFileManager defaultManager ];
    if (![manager fileExistsAtPath :folderPath]) return 0 ;
    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath:folderPath] objectEnumerator];
    NSString * fileName;
    long long folderSize = 0 ;
    while ((fileName = [childFilesEnumerator nextObject ]) != nil ){
        NSString * fileAbsolutePath = [folderPath stringByAppendingPathComponent :fileName];
        folderSize += [self fileSizeAtPath:fileAbsolutePath];
    }
    return folderSize/( 1024.0 * 1024.0 );
}
//2:遍历文件夹获得文件夹大小，返回多少 M（提示：你可以在工程界设置（)m）
- ( long long) fileSizeAtPath:(NSString *) filePath{
    NSFileManager * manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePath]){
        return [[manager attributesOfItemAtPath:filePath error:nil] fileSize ];
    }
    return 0 ;
}

//清除缓存
- (void)clearFile
{
    NSString * cachPath = [NSSearchPathForDirectoriesInDomains ( NSCachesDirectory,NSUserDomainMask,YES) firstObject];
    NSArray * files = [[NSFileManager defaultManager] subpathsAtPath:cachPath];
    NSLog (@"cachpath = %@",cachPath);
    for ( NSString * p in files) {
        NSError * error = nil;
        NSString * path = [cachPath stringByAppendingPathComponent:p];
        if ([[NSFileManager defaultManager]fileExistsAtPath:path]) {
            [[NSFileManager defaultManager]removeItemAtPath:path error:&error];
        }
    }
    [self performSelectorOnMainThread:@selector(clearCachSuccess)withObject : nil waitUntilDone:YES ];
}
-(void)clearCachSuccess
{
    NSIndexPath *index;
    if(!YGSingletonMarco.user.userId.length)
    {
        index = [NSIndexPath indexPathForRow:0 inSection:0];//刷新
    }else
    {
        index = [NSIndexPath indexPathForRow:3 inSection:0];//刷新
    }
    
    [_tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:index,nil] withRowAnimation:UITableViewRowAnimationNone];
    [YGAppTool showToastWithText:@"清除成功!"];
}




-(void)exitClick:(UIButton *)button
{
    if (YGSingletonMarco.deviceToken)
    {
        [YGPushSDK unbindSDKWithUserId:YGSingletonMarco.user.userId];
    }
    [YGSingletonMarco deleteUser];
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
