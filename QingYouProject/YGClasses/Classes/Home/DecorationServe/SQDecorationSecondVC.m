//
//  SQDecorationSecondVC.m
//  QingYouProject
//
//  Created by qwuser on 2018/5/24.
//  Copyright © 2018年 ccyouge. All rights reserved.
//

#import "SQDecorationSecondVC.h"
#import "SQDecorationServeCell.h"
#import "SQDecorationDetailVC.h"

@interface SQDecorationSecondVC () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) SQBaseTableView       *tableview;
@property (nonatomic, strong) NSMutableArray       *dataArr;

@end

@implementation SQDecorationSecondVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.naviTitle = @"装修风格";
    UIBarButtonItem *itme = [self createBarbuttonWithNormalImageName:@"mine_instashot"
                                                   selectedImageName:@"mine_instashot"
                                                            selector:@selector(rightButtonItemAciton)];
    self.navigationItem.rightBarButtonItem = itme;
    
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
    NSArray *userarr = @[@"http://img4.duitang.com/uploads/item/201310/16/20131016230233_5BuyL.thumb.700_0.gif",
                         @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1526636729682&di=17cb24dba05e69286d92f16606b23ad8&imgtype=0&src=http%3A%2F%2Fup.enterdesk.com%2Fedpic_source%2Ff7%2Ffb%2F1b%2Ff7fb1bd224c27f43d2ec3eaebedcf064.jpg",
                         @"https://ss0.bdstatic.com/70cFvHSh_Q1YnxGkpoWK1HF6hhy/it/u=1765474568,392718820&fm=27&gp=0.jpg",
                         @"https://ss0.bdstatic.com/70cFvHSh_Q1YnxGkpoWK1HF6hhy/it/u=3900680988,3018369610&fm=27&gp=0.jpg",
                         @"http://img5.imgtn.bdimg.com/it/u=2547359387,735038154&fm=200&gp=0.jpg",
                         @"http://img5.duitang.com/uploads/item/201411/25/20141125120243_mn8dR.gif",
                         @"https://ss2.bdstatic.com/70cFvnSh_Q1YnxGkpoWK1HF6hhy/it/u=3413067445,3734096099&fm=27&gp=0.jpg"];
    self.dataArr = [NSMutableArray arrayWithArray:userarr];
    [self.tableview reloadData];
    [self endRefreshWithScrollView:self.tableview];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}
- (UITableViewCell  *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SQDecorationServeCell *cell = [SQDecorationServeCell cellWithTableView:tableView];
    cell.model = self.dataArr[indexPath.row];
    return cell;
}

- (void)rightButtonItemAciton {
    [self contactWithCustomerServerWithType:ContactServerPropertyRepair button:nil];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.navigationController pushViewController:[SQDecorationDetailVC new] animated:YES];
}


#pragma mark LazyLoad
- (SQBaseTableView  *)tableview {
    if (!_tableview) {
        _tableview = [[SQBaseTableView   alloc] initWithFrame:CGRectMake(0, 0, KAPP_WIDTH, KAPP_HEIGHT-KNAV_HEIGHT)];
        _tableview.estimatedRowHeight = 600;
        _tableview.rowHeight = UITableViewAutomaticDimension;
        _tableview.delegate = self;
        _tableview.dataSource = self;
    }
    return _tableview;
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
