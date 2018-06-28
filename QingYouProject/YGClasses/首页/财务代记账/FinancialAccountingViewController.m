//
//  FinancialAccountingViewController.m
//  QingYouProject
//
//  Created by nefertari on 2017/9/22.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "FinancialAccountingViewController.h"
#import "FinancialAccountingModel.h"
#import "FinancialAccountingCell.h"
#import "FinacialAccountingDetailViewController.h"

#import "YGSegmentView.h"
#import "ServiceEvalutionCell.h"
#import "ServiceEvalutionModel.h"
#import "ServiceProtectTableViewCell.h"
#import "IntegrationIndustryWebViewController.h"

#define heraderHeight  ((YGScreenWidth-20)*0.28+YGScreenWidth*0.29*0.77+40+20)

@interface FinancialAccountingViewController ()<UITableViewDelegate,UITableViewDataSource,YGSegmentViewDelegate>

@end

@implementation FinancialAccountingViewController
{
    NSMutableArray                 *_dataArray; //数据源
//    NSArray                 *_commentArray; //数据源
    UITableView             *_tabelView;
    
    UIImageView * _baseImg;
    UIView *_headerView;
    UIImageView *_leftImageView; //左边的图
    UILabel *_describeLabel; //内容
    UILabel *_titleLabel; //标题
    
    UILabel *_askTitleLabel; //标题
    UIImageView *_introduceImageView; //介绍的图

    YGSegmentView *_segmentView;
    int  _value;
    NSMutableArray *_financeList;
    
    NSString * _topImg;
    NSString * _topText;
    NSArray * _topTextLabel;
    NSString * _guarantee;
    NSString *_info;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupNav];
}
- (void)setupNav{
    
    // 右边按钮
    self.navigationItem.rightBarButtonItem = [self createBarbuttonWithNormalImageName:@"service_green" selectedImageName:@"service_green" selector:@selector(rightBarButtonClick:)];
    
}
#pragma mark - 导航栏右侧按钮点击
- (void)rightBarButtonClick:(UIButton *)rightBarButton{
    [self contactWithCustomerServerWithType:ContactServerFinacialAccount button:rightBarButton];
}
-(void)configAttribute
{
    self.view.backgroundColor = colorWithTable;
    
    self.naviTitle = @"财务代记账" ;
   
    _dataArray = [[NSMutableArray alloc] init];
    _financeList = [[NSMutableArray alloc] init];

//    [self configUI];
    [self sendRequest];
    
}
#pragma mark --------- tabeleView 相关
-(void)configUI
{
    
    _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, YGScreenWidth, heraderHeight)];
    _headerView.backgroundColor = colorWithTable;
    
    UIView *headerTopView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, YGScreenWidth, YGScreenWidth*0.29*0.77+20)];
    headerTopView.backgroundColor = colorWithYGWhite;
    [_headerView addSubview:headerTopView];
    //左线
    _leftImageView = [[UIImageView alloc]init];
    [_leftImageView sd_setImageWithURL:[NSURL URLWithString:_topImg] placeholderImage:YGDefaultImgFour_Three];
    _leftImageView.frame = CGRectMake(10, 10, YGScreenWidth*0.29, YGScreenWidth*0.29*0.77);
    _leftImageView.layer.borderColor = colorWithLine.CGColor;
    _leftImageView.layer.borderWidth = 0.5;
    _leftImageView.backgroundColor = colorWithMainColor;
    _leftImageView.layer.cornerRadius = 5;
    _leftImageView.contentMode = UIViewContentModeScaleAspectFill;
    _leftImageView.clipsToBounds = YES;
    [headerTopView addSubview:_leftImageView];
    
    //新鲜事标题label
    _titleLabel = [[UILabel alloc]init];
    _titleLabel.textColor = colorWithBlack;
    _titleLabel.font = [UIFont systemFontOfSize:YGFontSizeNormal];
    _titleLabel.text = _topText;
     _titleLabel.numberOfLines = 2;
    _titleLabel.frame = CGRectMake(_leftImageView.x+_leftImageView.width+10, _leftImageView.y,YGScreenWidth-_leftImageView.width-25, 40);
    [headerTopView addSubview:_titleLabel];
    
        CGFloat LabelW = [UILabel calculateWidthWithString:@"资深注册" textFont:[UIFont systemFontOfSize:15] numerOfLines:1].width;
    for(int i=0;i<3;i++)
    {
        //新鲜事内容label
        _describeLabel = [[UILabel alloc]init];
        _describeLabel.frame = CGRectMake(_titleLabel.x + (LabelW +15)* i,_titleLabel.y+_titleLabel.height+5 , (YGScreenWidth - _leftImageView.width - 50)/3, 35);
        _describeLabel.textColor = colorWithMainColor;
        _describeLabel.font = [UIFont systemFontOfSize:YGFontSizeSmallOne];
        _describeLabel.textAlignment = NSTextAlignmentLeft;
        [headerTopView addSubview:_describeLabel];
        _describeLabel.tag = 100 +i;
    }
    for(int i=0;i <_topTextLabel.count;i++)
    {
        UILabel * tagLabel = [headerTopView viewWithTag:100+i];
        tagLabel.text = _topTextLabel[i];
    }
    //新鲜事内容label
//    _describeLabel = [[UILabel alloc]init];
//    _describeLabel.frame = CGRectMake(_titleLabel.x,_titleLabel.y+_titleLabel.height+5 , YGScreenWidth-_leftImageView.width-25, 35);
//    _describeLabel.textColor = colorWithMainColor;
//    _describeLabel.text = _topDetailText;
//    _describeLabel.font = [UIFont systemFontOfSize:YGFontSizeSmallOne];
//    _describeLabel.numberOfLines = 2;
//    _describeLabel.lineBreakMode = NSLineBreakByTruncatingTail;
//    [headerTopView addSubview:_describeLabel];
    
    
    UIView *headerMiddleView = [[UIView alloc] initWithFrame:CGRectMake(0,headerTopView.y+headerTopView.height+ 10, YGScreenWidth, (YGScreenWidth-20)*0.28+20)];
    headerMiddleView.backgroundColor = colorWithYGWhite;
    [_headerView addSubview:headerMiddleView];
    
    //左线
    _introduceImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"home_tool1.png"]];
    _introduceImageView.frame = CGRectMake(10, 10, YGScreenWidth-20, (YGScreenWidth-20)*0.28);
    _introduceImageView.layer.borderColor = colorWithLine.CGColor;
    _introduceImageView.layer.borderWidth = 0.5;
    _introduceImageView.backgroundColor = colorWithMainColor;
    _introduceImageView.layer.cornerRadius = 5;
    _introduceImageView.contentMode = UIViewContentModeScaleAspectFill;
    _introduceImageView.clipsToBounds = YES;
    [headerMiddleView addSubview:_introduceImageView];
    [_introduceImageView sd_setImageWithURL:[NSURL URLWithString:_info] placeholderImage:YGDefaultImgFour_Three];

    UIButton * introduceBtn = [[UIButton alloc]initWithFrame:CGRectMake(10, 10, YGScreenWidth-20, (YGScreenWidth-20)*0.28)];
    [introduceBtn addTarget:self action:@selector(introduceBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [headerMiddleView addSubview:introduceBtn];
    
//    UIView *alphaView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _introduceImageView.width, _introduceImageView.height)];
//    alphaView.backgroundColor = [colorWithBlack colorWithAlphaComponent:0.5];
//    [_introduceImageView addSubview:alphaView];
    
    //title
//    _askTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 20, _introduceImageView.width, 25)];
//    _askTitleLabel.text = @"诚挚为您服务，详细了解财务代记账具体";
//    _askTitleLabel.font = [UIFont systemFontOfSize:YGFontSizeBigOne];
//    _askTitleLabel.textColor = colorWithYGWhite;
//    _askTitleLabel.textAlignment = NSTextAlignmentCenter;
//    [_introduceImageView addSubview:_askTitleLabel];
    
    
//    UIView *headerBottomView = [[UIView alloc] initWithFrame:CGRectMake(0, headerMiddleView.y+headerMiddleView.height+ LDHPadding, YGScreenWidth, 40)];
//    headerBottomView.backgroundColor = colorWithYGWhite;
//    [_headerView addSubview:headerBottomView];
    
//    //选择页面按钮
//    YGSegmentView *segmentView = [[YGSegmentView alloc]initWithFrame:CGRectMake(0, 0, YGScreenWidth, 40) titlesArray:@[@"服务直达",@"用户点评",@"服务保障"] lineColor:colorWithMainColor delegate:self];
//    segmentView.backgroundColor = colorWithTable;
//    [headerBottomView addSubview:segmentView];
    
    _headerView.frame = CGRectMake(0, 0, YGScreenWidth, headerMiddleView.y + headerMiddleView.height+10);
    
    _tabelView = [[UITableView alloc] initWithFrame:CGRectMake(0,0, YGScreenWidth, YGScreenHeight-64) style:UITableViewStyleGrouped];
    _tabelView.delegate = self;
    _tabelView.dataSource = self;
    _tabelView.backgroundColor = [UIColor clearColor];
    [_tabelView registerClass:[ServiceEvalutionCell class] forCellReuseIdentifier:@"ServiceEvalutionCell"];
    [_tabelView registerClass:[ServiceProtectTableViewCell class] forCellReuseIdentifier:@"ServiceProtectTableViewCell"];
    
    [_tabelView setSeparatorColor:colorWithLine];
    
    _tabelView.tableHeaderView = _headerView;
    [self.view addSubview:_tabelView];

    //选择页面按钮
    _segmentView = [[YGSegmentView alloc]initWithFrame:CGRectMake(0, 0, YGScreenWidth, 40) titlesArray:@[@"服务直达",@"用户点评",@"服务保障"]  lineColor:colorWithMainColor delegate:self];
    _segmentView.backgroundColor = colorWithTable;
    [self.view addSubview:_segmentView];
    _segmentView.hidden = YES;
    _value = 0;
}

//按钮图标在右边的情况   如 ：详情>
- (UIButton *)createButtonWithTitle:(NSString *)titleString andImagePath:(NSString *)imagePath baseView:(UIView *)topView
{
    UILabel *describeLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 200, 20)];
    describeLabel.textColor = colorWithBlack;
    describeLabel.text = [NSString stringWithFormat:titleString,arc4random()%100];
    describeLabel.font = [UIFont systemFontOfSize:YGFontSizeBigOne];
    [describeLabel sizeToFitHorizontal];
    
    //大button
    UIButton *coverButton = [[UIButton alloc]initWithFrame:CGRectMake(YGScreenWidth-describeLabel.width-15, topView.y, describeLabel.width, 25)];
    [coverButton addTarget:self action:@selector(coverButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [coverButton setTitleColor:colorWithMainColor forState:UIControlStateNormal];
    coverButton.titleLabel.font = [UIFont systemFontOfSize:YGFontSizeSmallOne];
    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:@""];
    NSTextAttachment *attatchment = [[NSTextAttachment alloc] init];
    attatchment.image = [UIImage imageNamed:imagePath];
    attatchment.bounds = CGRectMake(0, -3, attatchment.image.size.width, attatchment.image.size.height);
    [attributedText appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",titleString]]];
    [attributedText appendAttributedString:[NSAttributedString attributedStringWithAttachment:attatchment]];
    [coverButton setAttributedTitle:attributedText forState:UIControlStateNormal];
    return coverButton;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
    {
        return _dataArray.count;
    }else if (section == 1)
    {
        return _financeList.count;
    }else
    {
        return 1;
    }
    return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        static NSString *cellIdentifier = @"methodCell";
        FinancialAccountingCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            cell = [[FinancialAccountingCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = colorWithYGWhite;
        cell.isPush =@"FinancialAccounting";
        FinancialAccountingModel *model = _dataArray[indexPath.row];
        cell.model = model;
        [cell showFadeAnimate];
        return cell;
    }else if (indexPath.section == 1)
    {
        
        ServiceEvalutionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ServiceEvalutionCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = colorWithYGWhite;
        cell.fd_enforceFrameLayout = YES;
        [cell setModel:_financeList[indexPath.row]];
        return cell;
    }else
    {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = colorWithYGWhite;
        //左线
        UIImageView * serviceImageView = [[UIImageView alloc]init];
        serviceImageView.frame = CGRectMake(10, 10, YGScreenWidth-20, (YGScreenWidth-20)*0.28);
        serviceImageView.layer.borderColor = colorWithLine.CGColor;
        serviceImageView.layer.borderWidth = 0.5;
        serviceImageView.backgroundColor = colorWithMainColor;
        serviceImageView.layer.cornerRadius = 5;
        serviceImageView.contentMode = UIViewContentModeScaleAspectFill;
        serviceImageView.clipsToBounds = YES;
        [cell.contentView addSubview:serviceImageView];
        [serviceImageView sd_setImageWithURL:[NSURL URLWithString:_guarantee] placeholderImage:YGDefaultImgTwo_One];
        
//        UIView *alphaView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, serviceImageView.width, serviceImageView.height)];
//        alphaView.backgroundColor = [colorWithBlack colorWithAlphaComponent:0.5];
//        [serviceImageView addSubview:alphaView];
        
        //title
//        UILabel  *serviceTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 20, serviceImageView.width, 25)];
//        serviceTitleLabel.text = @"诚挚为您服务，详细了解财务代记账具体";
//        serviceTitleLabel.font = [UIFont systemFontOfSize:YGFontSizeBigOne];
//        serviceTitleLabel.textColor = colorWithYGWhite;
//        serviceTitleLabel.textAlignment = NSTextAlignmentCenter;
//        [serviceImageView addSubview:serviceTitleLabel];
        return cell;
        
    }
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        return 80;
        
    }else if (indexPath.section == 1)
    {
        return [tableView fd_heightForCellWithIdentifier:@"ServiceEvalutionCell" cacheByIndexPath:indexPath configuration:^(ServiceEvalutionCell *cell) {
            
            cell.fd_enforceFrameLayout = YES;
            [cell setModel:_financeList[indexPath.row]];
            
        }];
    }else
    {
        return (YGScreenWidth-20)*0.28+20;
    }
    return 0;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //发现详情
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0)
    {
          FinacialAccountingDetailViewController *vc = [[FinacialAccountingDetailViewController alloc]init];
          vc.pageType = @"FinancialAccountingViewController";
          vc.cellWithID = ((FinancialAccountingModel *)_dataArray[indexPath.row]).financeID;
          vc.hidesBottomBarWhenPushed = YES;
          [self.navigationController pushViewController:vc animated:YES];
    }
     else if(indexPath.section == 2)
     {
         IntegrationIndustryWebViewController * integration = [[IntegrationIndustryWebViewController alloc]init];
         integration.isPush = @"FinancialAccountingViewController";
         integration.type = @"2";
         [self.navigationController pushViewController:integration animated:YES];
     }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, YGScreenWidth, 10)];
    view.backgroundColor = colorWithTable;
    return view;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{

    UIView *headerView =[[UIView alloc] initWithFrame:CGRectMake(0, 0, YGScreenWidth, 40)];
    headerView.backgroundColor = colorWithYGWhite;

    if (section == 0) {
        //        UIView *headerBottomView = [[UIView alloc] initWithFrame:CGRectMake(0, headerMiddleView.y+headerMiddleView.height+LDHPadding, YGScreenWidth, 40)];
        //        headerBottomView.backgroundColor = [UIColor whiteColor];
        //        [_headerView addSubview:headerBottomView];
        
        //选择页面按钮
        YGSegmentView *segmentView = [[YGSegmentView alloc]initWithFrame:CGRectMake(0, 0, YGScreenWidth, 40) titlesArray:@[@"服务直达",@"用户点评",@"服务保障"] lineColor:colorWithMainColor delegate:self];
        segmentView.backgroundColor = [UIColor whiteColor];
        [headerView addSubview:segmentView];
        return headerView;
        
    }
    //热门推荐label
    UILabel *describeLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 200, 20)];
    describeLabel.textColor = colorWithBlack;
    describeLabel.font = [UIFont systemFontOfSize:YGFontSizeBigOne];
    if (section == 1)
    {
        describeLabel.text = @"用户点评";
    }
    if (section == 2)
    {
        describeLabel.text = @"服务保障";
    }
    [describeLabel sizeToFitHorizontal];
    [headerView addSubview:describeLabel];
    
    return headerView;
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    [_segmentView selectButtonWithIndex:(int)index];
    return index;
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //页面没有加载的时候不进行调整
    if (!self.view.window) {
        
        return;
    }
    
    CGFloat offsetY = scrollView.contentOffset.y;
    
    //上拉加载更多（头部还没有隐藏）
    if (offsetY >= heraderHeight)
    {
        _segmentView.hidden = NO;
        
    }else
    {
        _segmentView.hidden = YES;
        
    }
    
    int value = _value;
    if (offsetY>0 && offsetY<=(heraderHeight+60*3*_dataArray.count)) {
        value = 0;
    }
    if (offsetY>(heraderHeight+60*_dataArray.count) && offsetY<=_tabelView.contentSize.height-250) {
        value =1;
    }
    if (offsetY>=_tabelView.contentSize.height-250) {
        value = 2;
    }
    if (value != _value) {
        [_segmentView selectButtonWithIndex:value];
        _value = value;
    }
    
}
#pragma segment代理

-(void)segmentButtonClickWithIndex:(int)buttonIndex
{
    if(_financeList.count == 0 && buttonIndex ==1)
        return;
    
    [_tabelView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:buttonIndex] atScrollPosition:UITableViewScrollPositionTop animated:YES];
}
#pragma mark -----------点击事件
- (void)contanctWithCustomerServiceAction:(UIButton *)btn
{
    
}

//更多按钮事件
- (void)coverButtonClick:(UIButton *)btn
{
    
}
#pragma mark - 网络请求数据
- (void)sendRequest{
    
    [YGNetService YGPOST:@"FinanceIndex" parameters:@{} showLoadingView:YES scrollView:nil success:^(id responseObject) {
        
        [_financeList addObjectsFromArray:[ServiceEvalutionModel mj_objectArrayWithKeyValuesArray:responseObject[@"financeCommentList"]]];
        [_dataArray addObjectsFromArray:[FinancialAccountingModel mj_objectArrayWithKeyValuesArray:responseObject[@"financeList"]]];
        
        _topImg = responseObject[@"topImg"];
        _topText = responseObject[@"topText1"];
        _topTextLabel = responseObject[@"topTextLabel"];
        _guarantee = responseObject[@"guarantee"];
        _info = responseObject[@"info"];
        [self configUI];
    
    } failure:^(NSError *error) {
    }];
}
-(void)introduceBtnClick
{
    IntegrationIndustryWebViewController * integration = [[IntegrationIndustryWebViewController alloc]init];
    integration.isPush = @"FinancialAccountingViewController";
    integration.type = @"1";
    [self.navigationController pushViewController:integration animated:YES];
}
@end
