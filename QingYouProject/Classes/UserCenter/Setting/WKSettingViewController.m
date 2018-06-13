//
//  SetupViewController.m
//  QingYouProject
//
//  Created by zhaoao on 2017/11/8.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "WKSettingViewController.h"
#import "SQTicketApplyListViewController.h"
#import "LoginViewController.h"
#import "PasswordSetValidateController.h"
#import "AboutusViewController.h"
#import "ManageMailPostViewController.h"
#import "EvaluateViewController.h"
#import "YGPushSDK.h"

@interface WKSettingViewController () <UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_tableView;
    NSArray  *_titleArray;
    UIButton *_loginoutBtn;
}

@end

@implementation WKSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.naviTitle = @"设置";
    [self configUI];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    [_loginoutBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.height.mas_equalTo(KSCAL(100));
    }];
    
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(0);
        if (_loginoutBtn) {
            make.bottom.equalTo(_loginoutBtn.mas_top);
        }
        else {
            make.bottom.mas_equalTo(0);
        }
    }];
}

- (void)configUI {
    if (YGSingletonMarco.user.userId.length) {
         _titleArray = [NSArray arrayWithObjects:@"手机号", @"密码设置", @"收货地址", @"发票抬头", @"清除缓存", @"反馈", @"关于我们", nil];
    } else {
        _titleArray = [NSArray arrayWithObjects:@"清除缓存",@"关于我们", nil];
    }
   
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = kCOLOR_RGB(239, 239, 239);
    _tableView.tableFooterView = [UIView new];
    _tableView.rowHeight = KSCAL(88);
    _tableView.estimatedSectionFooterHeight = 0.0;
    _tableView.estimatedSectionHeaderHeight = 0.0;
    [self.view addSubview:_tableView];

    if (YGSingletonMarco.user.userId.length) {
        _loginoutBtn = [UIButton buttonWithTitle:@"退出登录" titleFont:KSCAL(38) titleColor:[UIColor whiteColor] bgColor:KCOLOR_MAIN];
        [_loginoutBtn addTarget:self action:@selector(exitClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_loginoutBtn];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.textColor = kCOLOR_333;
        cell.textLabel.font = KFONT(36);
        cell.detailTextLabel.textColor = kCOLOR_666;
        cell.detailTextLabel.font = KFONT(36);
    }
    cell.textLabel.text = _titleArray[indexPath.section];
    if ([cell.textLabel.text isEqualToString:@"清除缓存"]) {
        cell.accessoryType = UITableViewCellAccessoryNone;
        NSInteger memory = (int)[self filePath];
        NSString *memoryString = [NSString stringWithFormat:@"%ldM",memory];;
        cell.detailTextLabel.text = memoryString;
        return cell;
    }
    if ([cell.textLabel.text isEqualToString:@"手机号"]) {
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.detailTextLabel.text = YGSingletonMarco.user.phone;
        return cell;
    }
    
    cell.detailTextLabel.text = @"";
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _titleArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == _titleArray.count - 1) {
        return CGFLOAT_MIN;
    }
    return KSCAL(20);
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if(!YGSingletonMarco.user.userId.length) {//未登录
        if (indexPath.section == 0) {
            [self clearFile];
        }
        if (indexPath.section == 1) {
            AboutusViewController *vc = [[AboutusViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }
        return;
    }
    else
    {
        if (indexPath.section == 1) {
            PasswordSetValidateController *vc = [[PasswordSetValidateController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
            return;
        }
        if(indexPath.section == 2) {
            ManageMailPostViewController *vc = [[ManageMailPostViewController alloc] init];
            vc.pageType = @"personCenter";
            [self.navigationController pushViewController:vc animated:YES];
            return;
        }
        if (indexPath.section == 3) {
            SQTicketApplyListViewController *next = [[SQTicketApplyListViewController alloc] initWithIsTicketApplyManager:YES];
            [self.navigationController pushViewController:next animated:YES];
            return;
        }
        if(indexPath.section == 4) {
            [self clearFile];
            return;
        }
        if (indexPath.section == 5) {
            EvaluateViewController *vc = [[EvaluateViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
            return;
        }
        if (indexPath.section == 6) {
            AboutusViewController *vc = [[AboutusViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
            return;
        }
    }
}

// 显示缓存大小
- (float)filePath {
    NSString * cachPath = [NSSearchPathForDirectoriesInDomains ( NSCachesDirectory,NSUserDomainMask,YES) firstObject];
    return [ self folderSizeAtPath :cachPath];
}
//1:首先我们计算一下 单个文件的大小
- (float)folderSizeAtPath:( NSString *) folderPath{
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
- (long long)fileSizeAtPath:(NSString *)filePath{
    NSFileManager * manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePath]){
        return [[manager attributesOfItemAtPath:filePath error:nil] fileSize ];
    }
    return 0 ;
}

//清除缓存
- (void)clearFile {
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
- (void)clearCachSuccess {
    NSIndexPath *index;
    if(!YGSingletonMarco.user.userId.length)
    {
        index = [NSIndexPath indexPathForRow:0 inSection:0];//刷新
    }else
    {
        index = [NSIndexPath indexPathForRow:0 inSection:3];//刷新
    }
    
    [_tableView reloadData];
    [YGAppTool showToastWithText:@"清除成功!"];
}

- (void)exitClick:(UIButton *)button {
    if (YGSingletonMarco.deviceToken) {
        [YGPushSDK unbindSDKWithUserId:YGSingletonMarco.user.userId];
    }
    [YGSingletonMarco deleteUser];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
