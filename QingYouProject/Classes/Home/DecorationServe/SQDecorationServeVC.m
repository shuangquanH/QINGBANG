//
//  SQDecorationServeVC.m
//  QingYouProject
//
//  Created by qwuser on 2018/5/18.
//  Copyright © 2018年 ccyouge. All rights reserved.
//

#import "SQDecorationServeVC.h"

#import "SQDecorationServeCell.h"
#import "SQDecorationSeveTableHeader.h"

#import "SQDecorationDetailVC.h"


#import "SQDecorationHomeModel.h"

@interface SQDecorationServeVC () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) SQDecorationSeveTableHeader       *header;
@property (nonatomic, strong) SQBaseTableView       *tableview;
@property (nonatomic, strong) SQDecorationHomeModel       *model;

@end

@implementation SQDecorationServeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.naviTitle = @"装修直通车";
    UIBarButtonItem *itme = [self createBarbuttonWithNormalImageName:@"decorate_nav_icon"
                                                   selectedImageName:@"service_black"
                                                            selector:@selector(rightButtonItemAciton)];
    self.navigationItem.rightBarButtonItem = itme;
    
    self.tableview.tableHeaderView = self.header;
    [self.view addSubview:self.tableview];
    [self createRefreshWithScrollView:self.tableview containFooter:YES];
    
    [self requestData];
}

- (void)refreshActionWithIsRefreshHeaderAction:(BOOL)headerAction {
    if (headerAction) {
        [self requestData];
    }
}

- (void)requestData {
    [SQRequest post:KAPI_DECORHOME param:nil success:^(id response) {
        self.model = [SQDecorationHomeModel yy_modelWithDictionary:response];
        self.header.model = self.model;
        [self.tableview reloadData];
        [self endRefreshWithScrollView:self.tableview];
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
    [self contactWithCustomerServerWithType:ContactServerPropertyRepair button:nil];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    SQDecorationDetailVC    *vc = [[SQDecorationDetailVC alloc] init];
    vc.styleModel = self.model.contents[indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
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
