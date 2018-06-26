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

@property (nonatomic, assign) BOOL isFirstLoad;
@property (nonatomic, assign) BOOL isTicketApplyManager;

@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, assign) NSInteger pageSize;

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
    _isFirstLoad = YES;
    _currentPage = 1;
    _pageSize = 10;
    
    //[SQRequest setApiAddress:KAPI_ADDRESS_TEST_MH];
    [self refreshActionWithIsRefreshHeaderAction:YES];
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
    
    if (_isFirstLoad) {
        [YGNetService showLoadingViewWithSuperView:YGAppDelegate.window];
    }
    
    NSInteger tmpPage = 1;
    if (!headerAction) {
        tmpPage = _currentPage + 1;
    }
    [SQRequest post:KAPI_INVOICELIST param:@{@"currentPage": [NSString stringWithFormat:@"%ld", tmpPage], @"pageSize": [NSString stringWithFormat:@"%ld", self.pageSize]} success:^(id response) {
        
        if (_isFirstLoad) {
            [YGNetService dissmissLoadingView];
            _isFirstLoad = NO;
        }
        if ([response[@"code"] longLongValue] == 0) {
            NSArray *tmp = [NSArray yy_modelArrayWithClass:[WKInvoiceModel class] json:response[@"data"][@"invoiceInfoList"]];
            if (headerAction) {
                [self.invoiceList removeAllObjects];
                [self.invoiceList addObjectsFromArray:tmp];
                self.currentPage = tmpPage;
                [self.tableView reloadData];
            } else {
                if (tmp.count) {
                    self.currentPage = tmpPage;
                    [self.invoiceList addObjectsFromArray:tmp];
                    [self.tableView reloadData];
                }
            }
        } else {
            [YGAppTool showToastWithText:response[@"msg"]];
        }
       
        if (headerAction) {
            [self.tableView.mj_header endRefreshing];
        } else {
            [self.tableView.mj_footer endRefreshing];
        }
        self.pageSize = 10;
        [self addNoDataImageViewWithArray:self.invoiceList shouldAddToView:_tableView headerAction:YES];
    } failure:^(NSError *error) {
        
        if (_isFirstLoad) {
            [YGNetService dissmissLoadingView];
            _isFirstLoad = NO;
        }
        [YGAppTool showToastWithText:@"网络错误"];
        if (headerAction) {
            [self.tableView.mj_header endRefreshing];
        } else {
            [self.tableView.mj_footer endRefreshing];
        }
        self.pageSize = 10;
        [self addNoDataImageViewWithArray:self.invoiceList shouldAddToView:_tableView headerAction:YES];
    }];
}

#pragma mark - action
//添加发票
- (void)click_confirm {
    [self pushToManagerInvoice:nil];
}
//发票列表管理
- (void)click_managerBtn {
    SQTicketApplyListViewController *next = [[SQTicketApplyListViewController alloc] initWithIsTicketApplyManager:YES];
    [self.navigationController pushViewController:next animated:YES];
    next.managerRefresh = ^(NSArray<WKInvoiceModel *> *invoiceList) {
        if (!invoiceList) {//添加新的抬头，需要刷新
            [self.tableView.mj_header beginRefreshing];
        } else {
            [self.invoiceList removeAllObjects];
            [self.invoiceList addObjectsFromArray:invoiceList];
            BOOL needClearApplyInvoice = YES;//是否需要清除申请列表默认的抬头
            for (WKInvoiceModel *m in self.invoiceList) {
                if ([m.ID isEqualToString:self.defaultInvoiceId]) {
                    needClearApplyInvoice = NO;
                    break;
                }
            }
            if (needClearApplyInvoice) {
                self.selectInvoiceBlock(nil);
            }
            [self.tableView reloadData];
        }
    };
}
//添加/编辑发票信息
- (void)pushToManagerInvoice:(WKInvoiceModel *)invoice {
    SQAddTicketApplyViewController *next = [SQAddTicketApplyViewController new];
    next.invoiceInfo = invoice;
    [self.navigationController pushViewController:next animated:YES];
    
    NSInteger index = [self.invoiceList indexOfObject:invoice];
    next.invoiceHandler = ^(WKInvoiceModel *invoice) {
        (void)index;
        if (invoice) {//替换、刷新
            [self.invoiceList replaceObjectAtIndex:index withObject:invoice];
            if (invoice.isDefault) {//设置为默认
                for (WKInvoiceModel *m in self.invoiceList) {
                    if (m == invoice) continue;
                    m.isDefault = NO;
                }
            }
            [self.tableView reloadData];
            if (self.managerRefresh) {
                self.managerRefresh(self.invoiceList);
            }
        } else {//重新请求
            self.pageSize = MAX(self.invoiceList.count+1, 10);
            [self.tableView.mj_header beginRefreshing];
            if (self.managerRefresh) {
                self.managerRefresh(nil);
            }
        }
    };
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
    if (!self.isTicketApplyManager) {//不是抬头管理，直接返回选择抬头模型
        if (self.selectInvoiceBlock) {
            self.selectInvoiceBlock([self.invoiceList objectAtIndex:indexPath.row]);
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
    else {//编辑抬头
        [self pushToManagerInvoice:[self.invoiceList objectAtIndex:indexPath.row]];
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return _isTicketApplyManager;
}
- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!_isTicketApplyManager) return nil;
    
    NSMutableArray *actions = [NSMutableArray array];
    
    WKInvoiceModel *invoice = self.invoiceList[indexPath.row];
    if (!invoice.isDefault) {//设置默认
        UITableViewRowAction *setDefaultAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"设为默认" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
            [YGNetService showLoadingViewWithSuperView:YGAppDelegate.window];
            [SQRequest post:KAPI_SETDEFAULTINVOICE
                      param:@{@"invoiceInfoId": invoice.ID}
                    success:^(id response) {
                        [YGNetService dissmissLoadingView];
                        if ([response[@"code"] longLongValue] == 0) {
                            for (WKInvoiceModel *m in self.invoiceList) {
                                m.isDefault = NO;
                            }
                            invoice.isDefault = YES;
                            [self.tableView reloadData];
                            if (self.managerRefresh) {
                                self.managerRefresh(self.invoiceList);
                            }
                        }
                        else {
                            [YGAppTool showToastWithText:response[@"msg"]];
                        }
                    } failure:^(NSError *error) {
                        [YGNetService dissmissLoadingView];
                        [YGAppTool showToastWithText:@"网络错误"];
                    }];
        }];
        setDefaultAction.backgroundColor = KCOLOR_MAIN;
        [actions addObject:setDefaultAction];
    }

    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        [YGNetService showLoadingViewWithSuperView:YGAppDelegate.window];
        [SQRequest post:KAPI_DELETEINVOICE param:@{@"invoiceInfoId": invoice.ID} success:^(id response) {
            [YGNetService dissmissLoadingView];
            if ([response[@"code"] longLongValue] == 0) {
                [self.invoiceList removeObjectAtIndex:indexPath.row];
                [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
                if (self.managerRefresh) {
                    self.managerRefresh(self.invoiceList);
                }
            }
            else {
                [YGAppTool showToastWithText:response[@"msg"]];
            }
            [self addNoDataImageViewWithArray:self.invoiceList shouldAddToView:_tableView headerAction:YES];
        } failure:^(NSError *error) {
            [YGNetService dissmissLoadingView];
            [YGAppTool showToastWithText:@"网络错误"];
        }];
    }];
    [actions insertObject:deleteAction atIndex:0];
    return actions;
}

@end
