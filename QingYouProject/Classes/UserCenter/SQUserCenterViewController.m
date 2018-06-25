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
#import "MyPushInformationController.h"

#import "SQUserCenterTableViewHeader.h"
#import "WKUserCenterCell.h"

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
    [self setupSubviews];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.tableHeader configUserInfo:YGSingletonMarco.user];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    [self.tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
}

- (void)layoutNavigation {
    self.naviTitle = @"我的";
    UIBarButtonItem *messageItem = [self createBarbuttonWithNormalImageName:@"usercenter_nav_news" selectedImageName:nil selector:@selector(click_toMessage)];
    self.navigationItem.rightBarButtonItem = messageItem;
}

- (void)setupSubviews {
    self.tableview.hidden = NO;
    
    self.headerImageView = [UIImageView new];
    self.headerImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.headerImageView.image = [UIImage imageNamed:@"usercenter_bg"];
    self.headerImageView.frame = CGRectMake(0, 0, kScreenW, self.tableHeader.height);
    [self.tableview insertSubview:self.headerImageView belowSubview:self.tableHeader];
}

- (void)click_toMessage {
    MyPushInformationController *next = [MyPushInformationController new];
    [self.navigationController pushViewController:next animated:YES];
}

#pragma mark - load data
- (void)readViewControllerByPlistFile {
    NSString *path = [[NSBundle mainBundle]
                      pathForResource:@"SQUserCenterMenuPlist" ofType:@"plist"];
    self.userCenterArr = [NSArray arrayWithContentsOfFile:path];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.userCenterArr.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
- (UITableViewCell  *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WKUserCenterCell *cell = [WKUserCenterCell cellWithTableView:tableView];
    NSDictionary *dict = self.userCenterArr[indexPath.section];
    cell.userImageView.image = [UIImage imageNamed:dict[@"image"]];
    cell.titleLabel.text = dict[@"title"];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Class theclass = NSClassFromString(self.userCenterArr[indexPath.section][@"vc"]);
    RootViewController  *vc = [[theclass alloc] init];
    bool needlogin = [self.userCenterArr[indexPath.section][@"needLogin"] boolValue];
    if (needlogin) {
        if ([self loginOrNot]) {
            [self.navigationController pushViewController:vc animated:YES];
        }
    } else {
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return KSCAL(20);
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView.contentOffset.y <= 0) {
        self.headerImageView.frame = CGRectMake(0, scrollView.contentOffset.y, kScreenW, KSCAL(340)-scrollView.contentOffset.y);
    }
}

#pragma mark LazyLoad
- (SQBaseTableView  *)tableview {
    if (!_tableview) {
        _tableview = [[SQBaseTableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableview.rowHeight = KSCAL(88);
        _tableview.delegate = self;
        _tableview.dataSource = self;
        _tableview.tableHeaderView = self.tableHeader;
        _tableview.backgroundColor = kCOLOR_RGB(239, 239, 239);
        _tableview.estimatedRowHeight = 0.0;
        _tableview.estimatedSectionFooterHeight = 0.0;
        _tableview.estimatedSectionHeaderHeight = 0.0;
        [self.view addSubview:self.tableview];
    }
    return _tableview;
}

- (SQUserCenterTableViewHeader *)tableHeader {
    if (!_tableHeader) {
        _tableHeader = [[SQUserCenterTableViewHeader alloc] initWithFrame:CGRectMake(0, 0, YGScreenWidth, KSCAL(340))];
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
