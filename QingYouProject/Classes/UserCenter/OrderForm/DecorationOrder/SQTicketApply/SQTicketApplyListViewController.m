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
    
    [self.tableView.mj_header beginRefreshing];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    [_addButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(55);
        if (@available(iOS 11.0, *)) {
            make.bottom.mas_equalTo(-self.view.safeAreaInsets.bottom);
        }
        else {
            make.bottom.mas_equalTo(-self.view.layoutMargins.bottom);
        }
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
        self.navigationItem.rightBarButtonItem = managerItem;
    }
}

- (void)setupSubviews {
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.rowHeight = 50;
    _tableView.tableFooterView = [UIView new];
    _tableView.separatorInset = UIEdgeInsetsZero;
    [self.view addSubview:_tableView];
    
    _addButton = [UIButton new];
    [_addButton setBackgroundColor:[UIColor redColor]];
    [_addButton setTitle:@"添加新抬头" forState:UIControlStateNormal];
    [_addButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_addButton addTarget:self action:@selector(click_confirm) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_addButton];
    
    [self createRefreshWithScrollView:self.tableView containFooter:YES];
}

- (void)refreshActionWithIsRefreshHeaderAction:(BOOL)headerAction {
    if (headerAction) {
        [SQRequest post:KAPI_INVOICELIST param:nil success:^(id response) {
            NSArray *tmp = [NSArray yy_modelArrayWithClass:[WKInvoiceModel class] json:response[@"invoice_list"]];
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
    if (self.isTicketApplyManager) {
        SQAddTicketApplyViewController *next = [SQAddTicketApplyViewController new];
        next.invoiceInfo = [self.invoiceList objectAtIndex:indexPath.row];
        [self.navigationController pushViewController:next animated:YES];
    }
    else {
        if (self.selectInvoiceBlock) {
            self.selectInvoiceBlock([self.invoiceList objectAtIndex:indexPath.row]);
        }
    }
}

@end
