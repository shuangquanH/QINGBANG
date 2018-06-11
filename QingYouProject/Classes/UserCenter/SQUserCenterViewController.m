//
//  SQUserCenterViewController.m
//  QingYouProject
//
//  Created by qwuser on 2018/5/16.
//  Copyright © 2018年 ccyouge. All rights reserved.
//

#import "SQUserCenterViewController.h"
#import "PersonalInformationViewController.h"
#import "SQOrderViewController.h"
#import "WKUserCenterMessageViewController.h"

#import "SQUserCenterTableViewHeader.h"

@interface SQUserCenterViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) NSArray                     *userCenterArr;
@property (nonatomic, strong) SQBaseTableView             *tableview;
@property (nonatomic, strong) SQUserCenterTableViewHeader *tableHeader;
@property (nonatomic, strong) UIImageView                 *headerImageView;
@end

@implementation SQUserCenterViewController

#pragma mark - life circle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self layoutNavigation];
    [self readViewControllerByPlistFile];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.tableHeader configUserInfo:YGSingletonMarco.user];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    [self.tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
        if (@available(iOS 11.0, *)) {
            make.bottom.mas_equalTo(-self.view.safeAreaInsets.bottom);
        }
        else {
            make.bottom.mas_equalTo(-self.view.layoutMargins.bottom);
        }
    }];
}

- (void)layoutNavigation {
    self.naviTitle = @"我的";
    UIBarButtonItem *messageItem = [self createBarbuttonWithNormalImageName:@"Details page_tab__icon2" selectedImageName:nil selector:@selector(click_toMessage)];
    self.navigationItem.rightBarButtonItem = messageItem;
}

- (void)setupSubviews {
    self.tableview.hidden = NO;
    
    self.headerImageView = [UIImageView new];
}

- (void)click_toMessage {
    WKUserCenterMessageViewController *next = [WKUserCenterMessageViewController new];
    [self.navigationController pushViewController:next animated:YES];
}

#pragma mark - load data
- (void)readViewControllerByPlistFile {
    NSString *path = [[NSBundle mainBundle]
                      pathForResource:@"SQUserCenterMenuPlist" ofType:@"plist"];
    self.userCenterArr = [NSArray arrayWithContentsOfFile:path];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.userCenterArr.count;
}
- (UITableViewCell  *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SQBaseTableViewCell *cell = [SQBaseTableViewCell cellWithTableView:tableView];
    cell.imageView.image = [UIImage imageNamed:@"mine_instashot"];
    cell.textLabel.text = self.userCenterArr[indexPath.row][@"title"];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Class theclass = NSClassFromString(self.userCenterArr[indexPath.row][@"vc"]);
    RootViewController  *vc = [[theclass alloc] init];
    bool needlogin = [self.userCenterArr[indexPath.row][@"needLogin"] boolValue];
    if (needlogin) {
        if ([self loginOrNot]) {
            [self.navigationController pushViewController:vc animated:YES];
        }
    } else {
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark LazyLoad
- (SQBaseTableView  *)tableview {
    if (!_tableview) {
        _tableview = [[SQBaseTableView alloc] initWithFrame:CGRectZero];
        _tableview.rowHeight = KSCAL(120);
        _tableview.delegate = self;
        _tableview.dataSource = self;
        _tableview.tableHeaderView = self.tableHeader;
        [self.view addSubview:self.tableview];
    }
    return _tableview;
}

- (SQUserCenterTableViewHeader *)tableHeader {
    if (!_tableHeader) {
        _tableHeader = [[SQUserCenterTableViewHeader alloc] initWithFrame:CGRectMake(0, 0, YGScreenWidth, 220)];
        [_tableHeader configUserInfo:YGSingletonMarco.user];
        
        @weakify(self)
        _tableHeader.tapToPersonalInfo = ^{
            @strongify(self)
            if ([self loginOrNot]) {
                PersonalInformationViewController *next = [PersonalInformationViewController new];
                [self.navigationController pushViewController:next animated:YES];
            }
        };
    }
    return _tableHeader;
}

@end
