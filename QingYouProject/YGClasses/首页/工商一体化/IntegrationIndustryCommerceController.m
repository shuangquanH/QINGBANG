//
//  IntegrationIndustryCommerceController.m
//  QingYouProject
//
//  Created by nefertari on 2017/9/25.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "IntegrationIndustryCommerceController.h"
#import "FinancialAccountingModel.h"
#import "FinancialAccountingCell.h"
#import "FinacialAccountingDetailViewController.h"

#import "YGSegmentView.h"
#import "ServiceEvalutionCell.h"
#import "ServiceEvalutionModel.h"
#import "ServiceProtectTableViewCell.h"
#import "IntegrationIndustryWebViewController.h"


#define heraderHeight  (YGScreenWidth*0.29*0.77+20+90+20+40+10)

@interface IntegrationIndustryCommerceController ()<UITableViewDelegate,UITableViewDataSource,YGSegmentViewDelegate>

@end

@implementation IntegrationIndustryCommerceController
{
    NSMutableArray                 *_dataArray; //数据源
    NSMutableArray                 *_commentArray; //数据源
    UITableView             *_tabelView;
    
    UIImageView * _baseImg;
    UIView *_headerView;
    UIImageView *_leftImageView; //左边的图
    UILabel *_describeLabel; //内容
    UILabel *_titleLabel; //标题

    UILabel *_askTitleLabel; //标题

    YGSegmentView *_segmentView;
    int  _value;
    
    NSString * _topImg;
    NSString * _topText;
    NSArray * _topTextLabel;

    NSString * _question;
//    NSString * _bottomImg;
    NSString * _guarantee;
    NSString * _answer;
    NSArray * _bottomList;

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
   
    [self contactWithCustomerServerWithType:ContactServerIntegrationIndustry button:rightBarButton];
}

-(void)configAttribute
{
    self.view.backgroundColor = colorWithTable;

    
    self.naviTitle = @"工商一体化" ;

    _dataArray = [[NSMutableArray alloc] init];
    _commentArray = [[NSMutableArray alloc] init];

 
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
    
    CGFloat LabelW = [UILabel calculateWidthWithString:@"资深注册" textFont:KFONT(30) numerOfLines:1].width;
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
//    //新鲜事内容label
//    _describeLabel = [[UILabel alloc]init];
//    _describeLabel.frame = CGRectMake(_titleLabel.x,_titleLabel.y+_titleLabel.height+5 , YGScreenWidth-_leftImageView.width-25, 35);
//    _describeLabel.textColor = colorWithMainColor;
//    _describeLabel.text = _topDetailText;
//    _describeLabel.font = [UIFont systemFontOfSize:YGFontSizeSmallOne];
//    _describeLabel.numberOfLines = 2;
//    _describeLabel.lineBreakMode = NSLineBreakByTruncatingTail;
//    [headerTopView addSubview:_describeLabel];
    
    UIView *headerMiddleView = [[UIView alloc] initWithFrame:CGRectMake(0,headerTopView.y+headerTopView.height , YGScreenWidth, 90)];
    headerMiddleView.backgroundColor = [UIColor whiteColor];
    [_headerView addSubview:headerMiddleView];

    
    //title
    _askTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 10, YGScreenWidth - 45 -30, 25)];
    _askTitleLabel.text = @"我们为您解答";
    _askTitleLabel.font = [UIFont systemFontOfSize:YGFontSizeBigOne];
    _askTitleLabel.textColor = colorWithBlack;
    [headerMiddleView addSubview:_askTitleLabel];
    
    UIButton *moreBtn = [[UIButton alloc]initWithFrame:CGRectMake(YGScreenWidth-45-15, _askTitleLabel.y, 45, 25)];
    [moreBtn addTarget:self action:@selector(moreBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [moreBtn setImage:[UIImage imageNamed:@"home_more_btn_green"] forState: UIControlStateNormal] ;
    //更多按钮
    [headerMiddleView addSubview:moreBtn];
    
    UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(15, _askTitleLabel.y+_askTitleLabel.height + 10, YGScreenWidth-30, 1)];
    line.backgroundColor = colorWithLine;
    [headerMiddleView addSubview:line];
    
    UILabel *desLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, line.y+line.height , YGScreenWidth-30, 35)];
    desLabel.text = [NSString stringWithFormat:@"%@\n%@",_question,_answer];
    desLabel.font = [UIFont systemFontOfSize:YGFontSizeSmallOne];
    desLabel.textColor = colorWithLightGray;
    desLabel.textAlignment = NSTextAlignmentLeft;
    desLabel.numberOfLines = 3;
    desLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:desLabel.text];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    
    [paragraphStyle setLineSpacing:6];
    
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [desLabel.text length])];
    
    desLabel.attributedText = attributedString;
    //    [_detailLabel sizeToFit];

    CGSize desLabelSize = [desLabel sizeThatFits:CGSizeMake(YGScreenWidth-30, 200)];
    
    desLabel.frame= CGRectMake(15, line.y+line.height+15,YGScreenWidth-30, desLabelSize.height);
    
    [headerMiddleView addSubview:desLabel];
    
    headerMiddleView.frame=CGRectMake(0,headerTopView.y+headerTopView.height+ 10, YGScreenWidth, desLabel.y + desLabel.height +10);
    
    _headerView.frame = CGRectMake(0, 0, YGScreenWidth, headerMiddleView.y + headerMiddleView.height+10);
    
    _tabelView = [[UITableView alloc] initWithFrame:CGRectMake(0,0, YGScreenWidth, YGScreenHeight-64) style:UITableViewStyleGrouped];
    _tabelView.delegate = self;
    _tabelView.dataSource = self;
    _tabelView.backgroundColor = [UIColor clearColor];
    [_tabelView setSeparatorColor:colorWithLine];
    
    [_tabelView registerClass:[FinancialAccountingCell class] forCellReuseIdentifier:@"methodCell"];

    [_tabelView registerClass:[ServiceEvalutionCell class] forCellReuseIdentifier:@"ServiceEvalutionCell"];
    [_tabelView registerClass:[ServiceProtectTableViewCell class] forCellReuseIdentifier:@"ServiceProtectTableViewCell"];

    _tabelView.tableHeaderView = _headerView;
    [self.view addSubview:_tabelView];

    //选择页面按钮
    _segmentView = [[YGSegmentView alloc]initWithFrame:CGRectMake(0, 0, YGScreenWidth, 40) titlesArray:@[@"服务直达",@"用户点评",@"服务保障"]  lineColor:colorWithMainColor delegate:self];
    _segmentView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_segmentView];
    _segmentView.hidden = YES;
    _value = 0;
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
        return _commentArray.count;
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
        FinancialAccountingCell *cell = [tableView dequeueReusableCellWithIdentifier:@"methodCell" forIndexPath:indexPath];

        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = colorWithYGWhite;
    
        cell.model = (FinancialAccountingModel *)_dataArray[indexPath.row];
        [cell showFadeAnimate];
        return cell;
    }else if (indexPath.section == 1)
    {

        ServiceEvalutionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ServiceEvalutionCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = colorWithYGWhite;
        cell.fd_enforceFrameLayout = YES;
        [cell setModel:_commentArray[indexPath.row]];
        return cell;
    }else
    {
        ServiceProtectTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ServiceProtectTableViewCell" forIndexPath:indexPath];
        [cell createRecommendServiceViewsWithBottomList:_bottomList withBaseImageUrl:_guarantee];
        cell.isCreate =YES;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = colorWithYGWhite;
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
            [cell setModel:_commentArray[indexPath.row]];
            
        }];
    }else
    {
        return YGScreenWidth*1.2;
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
         vc.pageType = @"IntegrationIndustryCommerceController";
         vc.hidesBottomBarWhenPushed = YES;
         vc.cellWithID = ((FinancialAccountingModel *)_dataArray[indexPath.row]).commerceID;
         [self.navigationController pushViewController:vc animated:YES];
    }
    else if (indexPath.section == 2)
    {
        IntegrationIndustryWebViewController * integration = [[IntegrationIndustryWebViewController alloc]init];
        integration.isPush = @"Integration";
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
//    if (section == 0) {
//        return nil;
//    }
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
    if (offsetY > _headerView.height)
    {
        _segmentView.hidden = NO;
    }else
    {
        _segmentView.hidden = YES;
    }
    
    int value = _value;
    if (offsetY>0 && offsetY<=(_headerView.height+60*3+20)) {
        value = 0;
    }
    if (offsetY>(_headerView.height+60*3+20) && offsetY<=_tabelView.contentSize.height-250) {
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
    if(_commentArray.count ==0 && buttonIndex == 1)
        return;
    
    [_tabelView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:buttonIndex] atScrollPosition:UITableViewScrollPositionTop animated:YES];
}
#pragma mark -----------点击事件
- (void)contanctWithCustomerServiceAction:(UIButton *)btn
{
    
}

//更多按钮事件
- (void)moreBtnClick:(UIButton *)btn
{
    IntegrationIndustryWebViewController * integration = [[IntegrationIndustryWebViewController alloc]init];
    integration.isPush = @"Integration";
    integration.type = @"1";
    [self.navigationController pushViewController:integration animated:YES];
}
#pragma mark - 网络请求数据
- (void)sendRequest{
    
    [YGNetService YGPOST:@"CommerceIndex" parameters:@{} showLoadingView:YES scrollView:nil success:^(id responseObject) {
        
        [_commentArray addObjectsFromArray:[ServiceEvalutionModel mj_objectArrayWithKeyValuesArray:responseObject[@"commerceCommentList"]]];
        [_dataArray addObjectsFromArray:[FinancialAccountingModel mj_objectArrayWithKeyValuesArray:responseObject[@"commerceList"]]];

        
        _topImg = responseObject[@"topImg"];
        _topText = responseObject[@"topText1"];
        _topTextLabel = responseObject[@"topTextLabel"];

        _guarantee = responseObject[@"guarantee"];
        _question = responseObject[@"question"];
        _answer = responseObject[@"answer"];

//        _bottomImg = responseObject[@"bottomImg"];

        _bottomList = [[NSArray alloc]init];
        _bottomList = responseObject[@"bottomList"];

        //设置UI
         [self configUI];

        
    } failure:^(NSError *error) {
        
    }];
}

@end
