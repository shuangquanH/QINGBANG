//
//  WaitToDealViewController.m
//  QingYouProject
//
//  Created by LDSmallCat on 2017/10/26.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "WaitToDealViewController.h"
#import "WaitToDealCell.h"//待处理cell
#import "OrderDetailListViewController.h"//工单详情
#import "WaitToDealModel.h"

@interface WaitToDealViewController ()<UITableViewDelegate,UITableViewDataSource,WaitToDealCellDelegate,UITextViewDelegate,OrderDetailListViewControllerDelegate>
@property (nonatomic,strong) UITableView * tableView;
/** 数据源  */
@property (nonatomic,strong) NSMutableArray * dataArray;

@property (nonatomic, strong) UIView * bgView;//背景
@property (nonatomic, strong) UIView * baseView;//白色背景
@property (nonatomic, strong) UITextView * reasonTextView;//白色背景

@property (nonatomic, assign) int row;//选择行数

@end

@implementation WaitToDealViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.view.frame = CGRectFromString(_controllFrame);

    [self.view addSubview:self.tableView];
    
    [self createRefreshWithScrollView:_tableView containFooter:YES];
    [_tableView.mj_header beginRefreshing];

    //网络请求
//    [self sendRequest];
}
#pragma mark - 网络请求
//刷新
-(void)refreshActionWithIsRefreshHeaderAction:(BOOL)headerAction
{
    NSDictionary *parameters = @{
                                 @"commenId":YGSingletonMarco.user.userId,
                                 @"workState":@"2",
                                 @"count":self.countString,
                                 @"total":self.totalString
                                 };
    NSString *url = @"SearchIndoor";
    
    //如果不是加载过缓存
//    if (!self.isAlreadyLoadCache)
//    {
//        //加载缓存数据
//        NSDictionary *cacheDic = [YGNetService loadCacheWithURLString:url parameter:parameters];
//        [self.dataArray addObjectsFromArray:[WaitToDealModel mj_objectArrayWithKeyValuesArray:cacheDic[@"list1"]]];
//        [_tableView reloadData];
//        self.isAlreadyLoadCache = YES;
//    }
    
    [YGNetService YGPOST:url
              parameters:parameters
         showLoadingView:NO
              scrollView:_tableView
                 success:^( id responseObject) {
                     
                     //如果是刷新
                     if (headerAction)
                     {
                         //先移除数据源所有数据
                         [self.dataArray removeAllObjects];
                     }
                     //如果是加载
                     else
                     {
                         //判断服务器返回的数组是不是没数据了，如果没数据
                         if ([responseObject[@"list1"] count] == 0)
                         {
                             //调用一下没数据的方法，告诉用户没有更多
                             [self noMoreDataFormatWithScrollView:_tableView];
                             return;
                         }
                     }
                     //将字典数组转化为模型数组，再加入到数据源
                     [self.dataArray addObjectsFromArray:[WaitToDealModel mj_objectArrayWithKeyValuesArray:responseObject[@"list1"]]];
                     //调用加载无数据图的方法
                     [self addNoDataImageViewWithArray:self.dataArray shouldAddToView:_tableView headerAction:headerAction];
                     [_tableView reloadData];
                 } failure:^(NSError *error)
     {
         [self addNoNetRetryButtonWithFrame:_tableView.frame listArray:self.dataArray];
     }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    WaitToDealCell * cell = [tableView dequeueReusableCellWithIdentifier:WaitToDealCellID forIndexPath:indexPath];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];

    cell.model = self.dataArray[indexPath.row];
    cell.row = (int)indexPath.row;
    cell.delegate =self;
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    OrderDetailListViewController * VC = [[OrderDetailListViewController alloc] init];
    VC.IndoorId = ((WaitToDealModel *)self.dataArray[indexPath.row]).ID;
    VC.state = 3;
    VC.row = (int)indexPath.row;
    VC.delegate =self;
    VC.workNumber = ((WaitToDealModel *)self.dataArray[indexPath.row]).workNumber;
    [self.navigationController pushViewController:VC animated:YES];
    
}
- (void)orderDetailListViewControllerDealedWithRow:(int)row
{
    [self.dataArray removeObjectAtIndex:row];
    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:row inSection:0];
    [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:(UITableViewRowAnimationNone)];
}

static NSString * const WaitToDealCellID = @"WaitToDealCellID";


- (UITableView *)tableView{
    if (!_tableView) {
        CGFloat H = kScreenH - YGNaviBarHeight - YGStatusBarHeight - YGNaviBarHeight;
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, self.view.height) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.estimatedRowHeight = 120;
        _tableView.rowHeight = 200;
        _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0.001)];
        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0.001)];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([WaitToDealCell class]) bundle:[NSBundle mainBundle]] forCellReuseIdentifier:WaitToDealCellID];
    }
    return _tableView;
}
- (NSMutableArray *)dataArray{
    
    if (!_dataArray) {
        
        _dataArray = [NSMutableArray array];
        
    }
    return _dataArray;
}
//已处理协议方法
- (void)WaitToDealCellDelegateAlreadyDealBtnClick:(UIButton *)btn withrow:(int)row
{
    NSMutableDictionary * dict = [NSMutableDictionary dictionary];
    dict[@"id"] = ((WaitToDealModel *)self.dataArray[row]).ID;
    
    [YGNetService YGPOST:@"CompleteOrder" parameters:dict showLoadingView:YES scrollView:nil success:^(id responseObject) {
        
        LDLog(@"%@",responseObject);
        [YGAppTool showToastWithText:@"已处理提交成功"];
        [self.dataArray removeObjectAtIndex:row];
        NSIndexPath *indexPath=[NSIndexPath indexPathForRow:row inSection:0];
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:(UITableViewRowAnimationNone)];
        
    } failure:^(NSError *error) {
        LDLog(@"%@",error);
        [YGAppTool showToastWithText:@"已处理提交失败"];
    }];
}
//处理中协议方法
- (void)WaitToDealCellDelegateDealIngBtnClick:(UIButton *)btn withrow:(int)row
{
    self.row = row;
    
    _bgView= [UIView new];
    _bgView.frame = [UIScreen mainScreen].bounds;
    
    _bgView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    [YGAppDelegate.window addSubview:_bgView];
    
    //白色
    _baseView= [[UIView alloc] initWithFrame:CGRectMake(30, (YGScreenHeight- 150)/2, YGScreenWidth - 60, 150)];
    _baseView.backgroundColor = [UIColor whiteColor];
    _baseView.layer.masksToBounds = YES;
    _baseView.layer.cornerRadius = 5;
    _baseView.clipsToBounds = YES;
    [_bgView addSubview:_baseView];
    
    _reasonTextView =[[UITextView alloc]initWithFrame:CGRectMake(0, 0, _baseView.width, _baseView.height - 40)];
    [_baseView addSubview:_reasonTextView];
    _reasonTextView.scrollEnabled=YES;
    _reasonTextView.delegate=self;
    _reasonTextView.textColor=[UIColor lightGrayColor];//设置提示内容颜色
    _reasonTextView.text=NSLocalizedString(@"请填写未处理原因", nil);//提示语
    _reasonTextView.selectedRange=NSMakeRange(0,0) ;//光标起始位置
    _reasonTextView.keyboardType=UIKeyboardTypeDefault;
    
    
    UILabel * lineOne =[[UILabel alloc]initWithFrame:CGRectMake(0, _reasonTextView.y + _reasonTextView.height , _reasonTextView.width, 0.5)];
    lineOne.backgroundColor = colorWithLine;
    [_baseView addSubview:lineOne];
    
    NSArray * buttonTitlesArray = @[@"取消",@"确定"];
    NSArray * buttonColorsArray= @[colorWithBlack,colorWithMainColor];
    //按钮
    for (int i = 0; i < buttonTitlesArray.count; i++)
    {
        //按钮
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(_baseView.width / buttonTitlesArray.count * i, _reasonTextView.y + _reasonTextView.height, _baseView.width / buttonTitlesArray.count, 40)];
        [button setTitle:buttonTitlesArray[i] forState:UIControlStateNormal];
        [button setTitleColor:buttonColorsArray[i] forState:UIControlStateNormal];
        
        button.titleLabel.font = [UIFont systemFontOfSize:15];
        button.tag = 100 + i;
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_baseView addSubview:button];
    }
    
    UILabel * lineTwo =[[UILabel alloc]initWithFrame:CGRectMake(_baseView.width /2  , _baseView.height - 40 , 0.5, 40)];
    lineTwo.backgroundColor = colorWithLine;
    [_baseView addSubview:lineTwo];
    
}

- (void)textViewDidChangeSelection:(UITextView *)textView
{
    if (textView.textColor==[UIColor lightGrayColor])//如果是提示内容，光标放置开始位置
    {
        NSRange range;
        range.location = 0;
        range.length = 0;
        textView.selectedRange = range;
    }
}
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString*)text
{
    if (![text isEqualToString:@""]&&textView.textColor==[UIColor lightGrayColor])//如果不是delete响应,当前是提示信息，修改其属性
    {
        textView.text=@"";//置空
        textView.textColor=[UIColor blackColor];
    }
    
    if ([text isEqualToString:@"n"])//回车事件
    {
        if ([textView.text isEqualToString:@""])//如果直接回车，显示提示内容
        {
            textView.textColor=[UIColor lightGrayColor];
            textView.text=NSLocalizedString(@"请填写未处理原因", nil);
        }
        [textView resignFirstResponder];//隐藏键盘
        return NO;
    }
    return YES;
}
- (void)textViewDidChange:(UITextView *)textView
{
    if ([textView.text isEqualToString:@""])
    {
        textView.textColor=[UIColor lightGrayColor];
        textView.text=NSLocalizedString(@"请填写未处理原因", nil);
    }
}

-(BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    
    [self keyboardWasShown];
    return YES;
}
- (BOOL)textViewShouldEndEditing:(UITextView *)textView;
{
    [self keyboardWillBeHidden];
    [textView resignFirstResponder];
    return YES;
}
-(void)keyboardWasShown
{
    [UIView animateWithDuration:0.2 animations:^{
        _baseView.frame = CGRectMake(30,(YGScreenHeight- 150)/2 - 100, YGScreenWidth - 60, 150);
    } completion:^(BOOL finished) {
        
    }];
}

-(void)keyboardWillBeHidden
{
    [UIView animateWithDuration:0.2 animations:^{
        _baseView.frame = CGRectMake(30,(YGScreenHeight- 150)/2, YGScreenWidth - 60, 150);
    } completion:^(BOOL finished) {
        
    }];
}
-(void)buttonClick:(UIButton *)btn
{
    if(btn.tag == 101)
    {
        if (!_reasonTextView.text.length || [_reasonTextView.text isEqualToString:@"请填写未处理原因"]) {
            [YGAppTool showToastWithText:@"请填写未处理原因"];
            return;
        }
        
        NSMutableDictionary * dict = [NSMutableDictionary dictionary];
        dict[@"workNumber"] = ((WaitToDealModel *)self.dataArray[self.row]).workNumber;
        dict[@"cause"] = _reasonTextView.text;
        dict[@"workId"] = YGSingletonMarco.user.userId;
        
        
        [YGNetService YGPOST:@"Acknowledgment" parameters:dict showLoadingView:YES scrollView:nil success:^(id responseObject) {
            
            LDLog(@"%@",responseObject);
            [YGAppTool showToastWithText:@"提交成功"];
            [self.dataArray removeObjectAtIndex:self.row];
            NSIndexPath *indexPath=[NSIndexPath indexPathForRow:self.row inSection:0];
            [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:(UITableViewRowAnimationNone)];
            
        } failure:^(NSError *error) {
            LDLog(@"%@",error);
            [YGAppTool showToastWithText:@"提交失败"];
        }];
        
    }
    [_bgView removeFromSuperview];
    
}

@end
