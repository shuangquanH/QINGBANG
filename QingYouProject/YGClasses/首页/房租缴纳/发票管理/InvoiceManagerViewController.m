//
//  InvoiceManagerViewController.m
//  QingYouProject
//
//  Created by 王丹 on 2017/10/26.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "InvoiceManagerViewController.h"
#import "InvoiceHistoryViewController.h"
#import "InvoiceInfoManagerViewController.h"
#import "AskForInvoiceViewController.h"

@interface InvoiceManagerViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_tableView;
    NSMutableArray *_listArray;
}

@end

@implementation InvoiceManagerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configUI];
    // Do any additional setup after loading the view.
}
- (void)configAttribute
{
}
- (void)configUI
{
    self.naviTitle = @"发票管理";
    
    _listArray  = (NSMutableArray *)@[
                                      @{
                                          @"img":@"steward_rent_invoice_history",
                                          @"title":@"历史发票"
                                          },
                                      @{
                                          @"img":@"steward_rent_invoice_manage",
                                          @"title":@"发票信息管理"
                                          },
                                      @{
                                          @"img":@"steward_rent_invoice_address",
                                          @"title":@"索要发票"
                                          }
                                      ];
    
    
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, YGScreenWidth, YGScreenHeight-64) style:UITableViewStyleGrouped];
    _tableView.backgroundColor = colorWithTable;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0.001)];
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0.001)];
    _tableView.sectionFooterHeight = 0.001;
    _tableView.sectionHeaderHeight = 0.001;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return 1;
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell  *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
        cell.backgroundColor = [UIColor clearColor];
        UIView *baseView = [[UIView alloc] initWithFrame:CGRectMake(10, 5, YGScreenWidth-20, 120)];
        baseView.backgroundColor = colorWithYGWhite;
        baseView.layer.cornerRadius = 5;
        baseView.clipsToBounds = YES;
        [cell.contentView addSubview:baseView];
        
        UIButton *coverButton = [[UIButton alloc]init];
        coverButton.tag = 1000+indexPath.section;
        coverButton.backgroundColor = colorWithMainColor;
        coverButton.titleLabel.font = [UIFont systemFontOfSize:YGFontSizeBigOne];
        [baseView addSubview:coverButton];
        coverButton.frame = CGRectMake(baseView.width/2-60, 10, 120, baseView.height-30);
        coverButton.center = baseView.center;
    }
    UIButton *coverButton = [cell.contentView viewWithTag:1000+indexPath.section];
    NSDictionary *dict = _listArray[indexPath.section];
    UIImage *titleImage = [UIImage imageNamed:dict[@"img"]];
    
    coverButton.backgroundColor = colorWithYGWhite;
    [coverButton setTitleColor:colorWithBlack forState:UIControlStateNormal];
    [coverButton setTitle:dict[@"title"] forState:UIControlStateNormal];
    [coverButton setImage:titleImage forState:UIControlStateNormal];
    coverButton.userInteractionEnabled = NO;
    coverButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;//使图片和文字水平居中显示
    [coverButton setTitleEdgeInsets:UIEdgeInsetsMake(coverButton.imageView.frame.size.height ,-coverButton.imageView.frame.size.width, 0.0,0.0)];//文字距离上边框的距离增加imageView的高度，距离左边框减少imageView的宽度，距离下边框和右边框距离不变
    [coverButton setImageEdgeInsets:UIEdgeInsetsMake(-coverButton.imageView.frame.size.height, 0.0,0.0, -coverButton.titleLabel.bounds.size.width)];//图片距离右边框距离减少图片的宽度，其它不边
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 130;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        InvoiceHistoryViewController *vc = [[InvoiceHistoryViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    if (indexPath.section == 1) {
        InvoiceInfoManagerViewController *vc = [[InvoiceInfoManagerViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    if (indexPath.section == 2) {

        AskForInvoiceViewController *vc = [[AskForInvoiceViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}


- (void)searchAdvertieseInfoAction
{
//    SerchAdvertisesViewController *vc = [[SerchAdvertisesViewController alloc] init];
//    [self.navigationController pushViewController:vc animated:YES];
}
@end
