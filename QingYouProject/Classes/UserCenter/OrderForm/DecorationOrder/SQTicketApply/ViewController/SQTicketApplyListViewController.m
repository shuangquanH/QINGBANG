//
//  SQTicketApplyListViewController.m
//  QingYouProject
//
//  Created by mac on 2018/6/1.
//  Copyright © 2018年 ccyouge. All rights reserved.
//

#import "SQTicketApplyListViewController.h"
#import "SQAddTicketApplyViewController.h"

#import "SQTicketApplyCell.h"
#import "WKInvoiceModel.h"

@interface SQTicketApplyListViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, assign) BOOL isTicketApplyManager;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIButton *addButton;
@property (nonatomic, strong) NSMutableArray<WKInvoiceModel *> *invoiceList;

@end

@implementation SQTicketApplyListViewController

- (instancetype)initWithIsTicketApplyManager:(BOOL)isTicketApplyManager {
    if (self == [super init]) {
        _isTicketApplyManager = isTicketApplyManager;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self layoutNavigation];
    
    [self setupSubviews];
    
    self.invoiceList = [NSMutableArray array];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self.tableView.mj_header beginRefreshing];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    [_addButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.mas_equalTo(0);
        make.height.mas_equalTo(KSCAL(100));
    }];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.mas_equalTo(0);
        make.bottom.equalTo(self.addButton.mas_top);
    }];
}

- (void)layoutNavigation {
    if (self.isTicketApplyManager) {
        self.naviTitle = @"发票抬头管理";
    }
    else {
        self.naviTitle = @"发票抬头";
        UIBarButtonItem *managerItem = [self createBarbuttonWithNormalTitleString:@"管理" selectedTitleString:@"管理" selector:@selector(click_managerBtn)];
        [((UIButton *)managerItem.customView) setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.navigationItem.rightBarButtonItem = managerItem;
    }
}

- (void)setupSubviews {
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.rowHeight = KSCAL(140);
    _tableView.tableFooterView = [UIView new];
    _tableView.separatorInset = UIEdgeInsetsMake(0, KSCAL(30), 0, KSCAL(30));
    [self.view addSubview:_tableView];
    
    _addButton = [UIButton buttonWithTitle:@"添加新抬头" titleFont:KSCAL(38) titleColor:[UIColor whiteColor] bgColor:KCOLOR_MAIN];
    [_addButton addTarget:self action:@selector(click_confirm) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_addButton];
    
    [self createRefreshWithScrollView:self.tableView containFooter:YES];
}

- (void)refreshActionWithIsRefreshHeaderAction:(BOOL)headerAction {
    if (headerAction) {
        [SQRequest post:KAPI_INVOICELIST param:nil success:^(id response) {
            NSArray *tmp = [NSArray yy_modelArrayWithClass:[WKInvoiceModel class] json:response[@"data"][@"invoice_list"]];
            [self.invoiceList removeAllObjects];
            [self.invoiceList addObjectsFromArray:tmp];
            [self.tableView.mj_header endRefreshing];
            [self.tableView reloadData];
        } failure:^(NSError *error) {
            [YGAppTool showToastWithText:@"网络错误"];
            [self.tableView.mj_header endRefreshing];
        }];
        
    }
    else {
        [self.tableView.mj_footer endRefreshing];
    }
}

#pragma mark - action
- (void)click_confirm {
    SQAddTicketApplyViewController *next = [SQAddTicketApplyViewController new];
    [self.navigationController pushViewController:next animated:YES];
}

#pragma mark - action
- (void)click_managerBtn {
    SQTicketApplyListViewController *next = [[SQTicketApplyListViewController alloc] initWithIsTicketApplyManager:YES];
    [self.navigationController pushViewController:next animated:YES];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.invoiceList.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SQTicketApplyCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[SQTicketApplyCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
        cell.accessoryType = (self.isTicketApplyManager ? UITableViewCellAccessoryDisclosureIndicator : UITableViewCellAccessoryNone);
    }
    [cell configInvoiceInfo:[self.invoiceList objectAtIndex:indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!self.isTicketApplyManager) {
        if (self.selectInvoiceBlock) {
            self.selectInvoiceBlock([self.invoiceList objectAtIndex:indexPath.row]);
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
    else {
        SQAddTicketApplyViewController *next = [SQAddTicketApplyViewController new];
        next.invoiceInfo = [self.invoiceList objectAtIndex:indexPath.row];
        [self.navigationController pushViewController:next animated:YES];
    }
}

@end
