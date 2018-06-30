//
//  SQDecorationServeVC.m
//  QingYouProject
//
//  Created by qwuser on 2018/5/18.
//  Copyright © 2018年 ccyouge. All rights reserved.
//

#import "SQDecorationServeVC.h"
#import "SQWebAdViewController.h"

#import "SQDecorationServeCell.h"
#import "SQDecorationSeveTableHeader.h"

#import "SQDecorationDetailVC.h"


#import "SQDecorationHomeModel.h"
#import "SQLocationManager.h"

@interface SQDecorationServeVC () <UITableViewDelegate, UITableViewDataSource, decorationSeveHeaderDelegate>

@property (nonatomic, strong) SQDecorationSeveTableHeader       *header;
@property (nonatomic, strong) SQBaseTableView       *tableview;
@property (nonatomic, strong) SQDecorationHomeModel       *model;

@end

@implementation SQDecorationServeVC

- (void)configAttribute {
    self.naviTitle = @"装修直通车";
    UIBarButtonItem *itme = [self createBarbuttonWithNormalImageName:@"decorate_nav_icon"
                                                   selectedImageName:@"service_black"
                                                            selector:@selector(rightButtonItemAciton)];
    self.navigationItem.rightBarButtonItem = itme;
    
    self.tableview.tableHeaderView = self.header;
    [self.view addSubview:self.tableview];
    [self createRefreshWithScrollView:self.tableview containFooter:NO];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self requestData];
}

- (void)refreshActionWithIsRefreshHeaderAction:(BOOL)headerAction {
    if (headerAction) {
        [self requestData];
    }
}

- (void)requestData {
    NSDictionary *param = @{@"cityid":[SQLocationManager getLocationCityId]};
    [SQRequest post:KAPI_DECORHOME param:param success:^(id response) {
        self.model = [SQDecorationHomeModel yy_modelWithDictionary:response[@"data"]];
        self.header.model = self.model;
        [self endRefreshWithScrollView:self.tableview];
        [self.tableview reloadData];
    } failure:^(NSError *error) {
        [self endRefreshWithScrollView:self.tableview];
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.model.contents.count;
}
- (UITableViewCell  *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SQDecorationServeCell *cell = [SQDecorationServeCell cellWithTableView:tableView];
    cell.model = self.model.contents[indexPath.row];
    return cell;
}

- (void)rightButtonItemAciton {
    [self contactWithCustomerServerWithType:SQContactServerCallAction button:nil];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self setPushtTypeWithModel:self.model.contents[indexPath.row]];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    [cell showExcursionAnimation];
}


- (void)didSelectedBannerWithIndex:(NSInteger)index {
    [self setPushtTypeWithModel:self.model.banners[index]];
}
- (void)setPushtTypeWithModel:(SQDecorationStyleModel *)model {
    if ([model.type isEqualToString:@"1"]) {
        SQDecorationDetailVC    *vc = [[SQDecorationDetailVC alloc] init];
        vc.styleModel = model;
        [self.navigationController pushViewController:vc animated:YES];
    } else if ([model.type isEqualToString:@"2"]) {
        //广告
        SQWebAdViewController *web = [[SQWebAdViewController alloc] init];
        web.funcs_target_params = model.linkurl;
        [self.navigationController pushViewController:web animated:YES];
    }
}

#pragma mark LazyLoad
- (SQBaseTableView  *)tableview {
    if (!_tableview) {
        CGRect  frame = CGRectMake(0, 0, KAPP_WIDTH, KAPP_HEIGHT-KNAV_HEIGHT);
        _tableview = [[SQBaseTableView   alloc] initWithFrame: frame];
        _tableview.backgroundColor = self.view.backgroundColor;
        _tableview.estimatedRowHeight = 600;
        _tableview.rowHeight = UITableViewAutomaticDimension;
        _tableview.delegate = self;
        _tableview.dataSource = self;
    }
    return _tableview;
}
- (SQDecorationSeveTableHeader *)header {
    if (!_header) {
        _header = [[SQDecorationSeveTableHeader alloc] initWithFrame:CGRectMake(0, 0, YGScreenWidth, KSCAL(320))];
        _header.delegate = self;
    }
    return _header;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
