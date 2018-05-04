//
//  MyContractViewController.m
//  QingYouProject
//
//  Created by 王丹 on 2017/10/19.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "MyContractViewController.h"
#import "KSPhotoBrowser.h"

@interface MyContractViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation MyContractViewController
{
    UITableView *_tableView;
    NSMutableArray *_listArray;
    NSMutableArray *_dataSource;
    NSMutableArray *_imgArray;
    UIView *_footerView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self configUI];
    [self loadData];
    // Do any additional setup after loading the view.
}
- (void)loadData
{
    [self startPostWithURLString:REQUEST_FindMyHouserContract parameters:@{@"phone":YGSingletonMarco.user.myContractPhoneNumber} showLoadingView:YES scrollView:nil];
}

-(void)didReceiveSuccessResponeseWithURLString:(NSString *)URLString parameters:(id)parameters responeseObject:(id)responseObject
{
    NSDictionary *rootDict = responseObject[@"housingContract"];
    NSMutableArray *topArray = (NSMutableArray *)@[@"park",@"number",@"payment",@"price",@"propertyfee",@"rentincreases",@"proportion",@"leasetime"];
    NSMutableArray *bottomArray = (NSMutableArray *) @[@"contacts",@"phone",@"company"];
    NSMutableArray *arrayTop = [[NSMutableArray alloc] init];
    for (NSString *str in topArray) {
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        [dict setValue:rootDict[str] forKey:@"title"];
        [arrayTop addObject:dict];
    }
    NSMutableArray *arrayBottom = [[NSMutableArray alloc] init];
    for (NSString *str in bottomArray) {
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        [dict setValue:rootDict[str] forKey:@"title"];
        [arrayBottom addObject:dict];
    }
    [_dataSource addObject:arrayTop];
    [_dataSource addObject:arrayBottom];
    _imgArray = (NSMutableArray *)[rootDict[@"imgs"] componentsSeparatedByString:@","];
    
    int r = 0;
    int k = 0;
    for (int  i = 0; i<_imgArray.count; i++) {
        //合同图
        r = i%3;//个
        k = i/3; //横
        UIImageView * contractImageView = [[UIImageView alloc]init];
        [contractImageView sd_setImageWithURL:[NSURL URLWithString:_imgArray[i]] placeholderImage:YGDefaultImgThree_Four];
        contractImageView.frame = CGRectMake(10+((YGScreenWidth-40)/3+10)*r,15+((YGScreenWidth-40)/3*1.34+10)*k,(YGScreenWidth-40)/3 ,(YGScreenWidth-40)/3*1.34);
        
        contractImageView.contentMode = UIViewContentModeScaleAspectFill;
        contractImageView.clipsToBounds = YES;
        contractImageView.backgroundColor = colorWithMainColor;
        contractImageView.tag = 1000+i;
        contractImageView.userInteractionEnabled = YES;
        [_footerView addSubview:contractImageView];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageButtonClick:)];
        tap.numberOfTapsRequired = 1;
        tap.numberOfTouchesRequired = 1;
        [contractImageView addGestureRecognizer:tap];
        
    }
    _footerView.frame = CGRectMake(0, 0, YGScreenWidth, ((YGScreenWidth-40)/3*1.34+30+10)*(k+1));
    _tableView.tableFooterView = _footerView;
    
    [_tableView reloadData];
}

- (void)didReceiveFailureResponeseWithURLString:(NSString *)URLString parameters:(id)parameters error:(NSError *)error
{
    
}
- (void)configUI
{
    self.naviTitle = @"我的合同";
    self.automaticallyAdjustsScrollViewInsets = NO;
    _imgArray = [[NSMutableArray alloc] init];
    _dataSource = [[NSMutableArray alloc] init];
    _listArray  = (NSMutableArray *)@[@[@"所在园区", @"房屋编号",@"付款方式",@"租金单价",@"物业费",@"租金涨幅",@"租赁面积",@"合同租期"],@[@"联系人",@"联系电话",@"公司名称"]];
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, YGScreenWidth, 40)];
    view.backgroundColor = colorWithYGWhite;
    //最新账单
    UILabel * titleLabel = [[UILabel alloc]init];
    titleLabel.textColor = colorWithBlack;
    titleLabel.font = [UIFont systemFontOfSize:YGFontSizeBigOne];
    titleLabel.text = @"合同信息";
    titleLabel.frame = CGRectMake(10, 10,YGScreenWidth-20, 20);
    [view addSubview:titleLabel];
    
    _footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, YGScreenWidth, (YGScreenWidth-40)/3*1.34+30)];
    _footerView.backgroundColor = colorWithYGWhite;
  
    
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, YGScreenWidth, YGScreenHeight-YGNaviBarHeight-YGStatusBarHeight) style:UITableViewStyleGrouped];
    _tableView.backgroundColor = colorWithTable;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableHeaderView = view;
    _tableView.sectionFooterHeight = 0.001;
    _tableView.sectionHeaderHeight =0.001;
    _tableView.tableFooterView = _footerView;
    _tableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_tableView];
    

}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return [_dataSource[section] count];
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _dataSource.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
        //最新账单
        UILabel * titleLabel = [[UILabel alloc]init];
        titleLabel.textColor = colorWithBlack;
        titleLabel.font = [UIFont systemFontOfSize:YGFontSizeNormal];
        titleLabel.text = @"合同信息";
        titleLabel.tag = 100*indexPath.row+indexPath.section*1000+100;
        titleLabel.frame = CGRectMake(100, 5,YGScreenWidth-130, 20);
        [cell.contentView addSubview:titleLabel];
        
        
    }
    cell.contentView.backgroundColor = colorWithYGWhite;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.textColor = colorWithDeepGray;
    cell.textLabel.font = [UIFont systemFontOfSize:YGFontSizeNormal];
    cell.textLabel.text = _listArray[indexPath.section][indexPath.row];
    
    UILabel *titleLabel = [cell.contentView viewWithTag:100*indexPath.row+indexPath.section*1000+100];
    titleLabel.text = [NSString stringWithFormat:@"%@",_dataSource[indexPath.section][indexPath.row][@"title"]];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 30;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    [self.delegate takeTypeValueBackWithValue:_typeArr[indexPath.row]];
    //    [self back];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
        return 10;

}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, YGScreenWidth, 10)];
    view.backgroundColor = colorWithYGWhite;
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 5, YGScreenWidth, 1)];
    lineView.backgroundColor = colorWithLine;
    [view addSubview:lineView];

    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 0) {
        return 0;
    }
    return 10;

}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section == 0) {
        return nil;
    }
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, YGScreenWidth, 10)];
    view.backgroundColor = colorWithLightTable;
    return view;
}

- (void)imageButtonClick:(UITapGestureRecognizer *)tap
{
    NSMutableArray *items = [[NSMutableArray alloc]init];
    for (int i = 0; i < _imgArray.count; i++)
    {
        UIImageView *imageView = [_footerView viewWithTag:1000+i];
        KSPhotoItem *item = [KSPhotoItem itemWithSourceView:imageView imageUrl:[NSURL URLWithString:_imgArray[i]]];
        [items addObject:item];
    }
    KSPhotoBrowser *browser = [KSPhotoBrowser browserWithPhotoItems:items selectedIndex:tap.view.tag-1000];
    browser.noSingleTap = YES;
    browser.noSingleTap = NO;
    browser.dismissalStyle = KSPhotoBrowserInteractiveDismissalStyleScale;
    browser.pageindicatorStyle = KSPhotoBrowserPageIndicatorStyleText;
    browser.backgroundStyle = KSPhotoBrowserBackgroundStyleBlack;
    [browser showFromViewController:self];
}
@end
