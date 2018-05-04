//
//  MeetingChildDetailsController.m
//  QingYouProject
//
//  Created by zhaoao on 2017/10/20.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "MeetingChildDetailsController.h"
#import "MeetingDetailCell.h"

@interface MeetingChildDetailsController () <UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_tableView;
    NSMutableArray *_tilteArray;
}
@end

@implementation MeetingChildDetailsController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _tilteArray =[NSMutableArray arrayWithObjects:[NSString stringWithFormat:@"开放时间: %@-%@",[self.dataDic valueForKey:@"beginTime"],[self.dataDic valueForKey:@"endTime"]],[NSString stringWithFormat:@"容纳人数：%@",[self.dataDic valueForKey:@"personCount"]],[NSString stringWithFormat:@"收费标准：%@元/小时",[self.dataDic valueForKey:@"expense"]],nil];
    [self configTable];
    
}

-(void)configTable
{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, YGScreenWidth, YGScreenHeight - YGNaviBarHeight - YGStatusBarHeight - 10) style:UITableViewStyleGrouped];
    _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, YGScreenWidth, 0.001)];
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, YGScreenWidth, 0.001)];
    _tableView.sectionHeaderHeight = 0.001;
    _tableView.sectionFooterHeight = 0.001;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0,0,YGScreenWidth,30)];
    headerView.backgroundColor = [UIColor whiteColor];
//    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
//    imageView.image = [UIImage imageNamed:@"steward_puckup"];
    UILabel *yuanLabel =[[UILabel alloc]initWithFrame:CGRectMake(30, 0, YGScreenWidth-40, 30)];
    yuanLabel.text = [self.dataDic valueForKey:@"areaName"];
    yuanLabel.font = [UIFont systemFontOfSize:14.0];
    yuanLabel.textAlignment = NSTextAlignmentLeft;
//    [headerView addSubview:imageView];
    [headerView addSubview:yuanLabel];
    _tableView.tableHeaderView = headerView;
    
    
    UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, YGScreenWidth, 500)];
//    [equipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(footerView.mas_left).offset(30);
//        make.top.mas_equalTo(footerView.mas_top).offset(0);
//        make.height.mas_equalTo(30);
//    }];
    UIView *equipView = [self text];
    [footerView addSubview:equipView];
    
    UILabel *equipLabel = [[UILabel alloc]initWithFrame:CGRectMake(30, 0, 70, 30)];
    equipLabel.text = @"设备配置:";
    equipLabel.font = [UIFont systemFontOfSize:14.0];
    [footerView addSubview:equipLabel];
    
    _tableView.tableFooterView = footerView;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MeetingDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MeetingDetailCell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"MeetingDetailCell" owner:self options:nil] firstObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    cell.titleLabel.text = _tilteArray[indexPath.row];
//    if (indexPath.row == 3) {
//
//    }else{
////        UIView *footViewNull = [[UIView alloc]initWithFrame:CGRectMake(0,0,0,0)];
////        _tableView.tableFooterView = footViewNull;
//    }
    return cell;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    return 30;
}


-(void)configAttribute
{
    self.view.frame = self.controllerFrame;
}

-(UIView *)text{
     UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, YGScreenWidth, 100)];
    headerView.backgroundColor = [UIColor whiteColor];
    NSInteger toLeft = 100;
//    NSArray *array = @[@"编制内容全面",@"优质服务流程",@"优势",@"全面配套服务",@"价格体系公道"];
    
    NSArray *array = [[self.dataDic valueForKey:@"roomEquip"] componentsSeparatedByString:@","];
    
    
    int k = 0;
    CGFloat widthCount = 0.0f;
    int j = 0;
    for (int i = 0;i<array.count;i++) {
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:array[i] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:YGFontSizeSmallOne];
        [button.titleLabel sizeToFit];
        [button setTitleColor:colorWithMainColor forState:UIControlStateNormal];
        button.backgroundColor = [UIColor clearColor];
        button.tag = 100+i;
//        [button addTarget:self action:@selector(titleChooseChangeContentAction:) forControlEvents:UIControlEventTouchUpInside];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 24)];
        label.font = [UIFont systemFontOfSize:YGFontSizeSmallOne];
        label.text = array[i];
        label.textColor = colorWithMainColor;
        [label sizeToFit];
        
        CGFloat labeWidth = label.width+16;
        button.frame = CGRectMake(toLeft+widthCount+k*5, 10+35*j, labeWidth, 24) ;
        
        
        widthCount = widthCount +labeWidth;
        
        if (widthCount>(YGScreenWidth-toLeft-10-k*5)) {
            j=j+1;
            k=0;
            widthCount = 0.0f;
            button.frame = CGRectMake(toLeft+widthCount+k*5, 10+35*j, labeWidth, 24);
            widthCount = widthCount +labeWidth;
        }
        
        button.layer.cornerRadius = 4;
        button.layer.borderColor = colorWithMainColor.CGColor;
        button.layer.borderWidth = 1;
        k++;
        
        [headerView addSubview:button];
        
    }
    
    headerView.frame = CGRectMake(0, 0, YGScreenWidth, 10+35*(j+1));
    return headerView;
}
//- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    CGPoint offset = _tableView.contentOffset;
//    if (offset.y <= 0) {
//        offset.y = 0;
//    }
//    _tableView.contentOffset = offset;
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
