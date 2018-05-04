//
//  MoreCommentViewController.m
//  QingYouProject
//
//  Created by zhaoao on 2017/11/29.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "MoreCommentViewController.h"
#import <WebKit/WebKit.h>
#import "NewThingsCommentCell.h"
#import <IQKeyboardManager.h>
#import "CommentModel.h"

@class SonCommentModel;

@interface MoreCommentViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
{
    NSMutableArray *_dataArray;
    UITableView *_tableView;
    NSMutableArray *_commentArray;
    UIView *_bottomCommentView; //最下面的写评论栏
}
@property(nonatomic,strong)NSDictionary *detailDictionary;//详情结果字典
@property(nonatomic,strong)UIView *detailHeaderView;//头视图
@property(nonatomic,strong)UILabel *titleLabel;//标题
@property(nonatomic,strong)UILabel *intructionLabel;//来源日期
@property(nonatomic,strong)UIButton *praiseButton;//赞
@property(nonatomic,strong)UITextField *commenttextField; //评论框
@property(nonatomic,strong)NSString *secondIdString; //评论二级id

@end

@implementation MoreCommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"评论详情";
    
    _dataArray = [NSMutableArray array];
    
    //tableview
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, YGScreenWidth, YGScreenHeight - YGNaviBarHeight - YGStatusBarHeight - 50 - YGBottomMargin) style:UITableViewStyleGrouped];
    _tableView.tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, 0.0001)];
    _tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, 0.0001)];
    _tableView.showsVerticalScrollIndicator = NO;
    [_tableView registerClass:[NewThingsCommentCell class] forCellReuseIdentifier:@"NewThingsCommentCell"];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.estimatedRowHeight = 30;
    _tableView.backgroundColor = colorWithYGWhite;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    if (@available(iOS 11.0, *))
    {
        _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    else
    {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    [self.view addSubview:_tableView];
    
    [self createRefreshWithScrollView:_tableView containFooter:YES];
//    self.countString = @"20";
    [self refreshActionWithIsRefreshHeaderAction:YES];
    
    _bottomCommentView = [[UIView alloc]initWithFrame:CGRectMake(0, YGScreenHeight - 50 - YGNaviBarHeight - YGStatusBarHeight - YGBottomMargin, YGScreenWidth, 50 + YGBottomMargin)];
    _bottomCommentView.backgroundColor = [UIColor whiteColor];
    self.commenttextField = [[UITextField alloc]initWithFrame:CGRectMake(15, 10, YGScreenWidth - 65, 30)];
//    self.commenttextField.placeholder = @"回复:";
    self.commenttextField .backgroundColor = YGUIColorFromRGB(0xf5f5f5, 1);
    [self.commenttextField setValue:[UIFont boldSystemFontOfSize:14] forKeyPath:@"_placeholderLabel.font"];
    self.commenttextField .layer.cornerRadius = 5;
    self.commenttextField .clipsToBounds = YES;
    self.commenttextField .delegate = self;
//    //关闭完成那栏
//    self.commenttextField.inputAccessoryView = [[UIView alloc]init];
//    self.commenttextField.returnKeyType = UIReturnKeyDone;
    [_bottomCommentView addSubview:self.commenttextField];
    UIButton *commentButton = [UIButton buttonWithType:UIButtonTypeCustom];
    commentButton.frame = CGRectMake(YGScreenWidth - 50, 0, 50, 50);
    [commentButton setTitle:@"发送" forState:UIControlStateNormal];
    [commentButton.titleLabel setFont:[UIFont systemFontOfSize:15.0]];
    [commentButton setTitleColor:colorWithMainColor forState:UIControlStateNormal];
    //    [commentButton setImage:[UIImage imageNamed:@"home_fresh news_comment_black"] forState:UIControlStateNormal];
    [commentButton addTarget:self action:@selector(sendMessage:) forControlEvents:UIControlEventTouchUpInside];
    [_bottomCommentView addSubview:commentButton];
    
    [self.view addSubview:_bottomCommentView];
}

- (void)refreshActionWithIsRefreshHeaderAction:(BOOL)headerAction
{
    if (headerAction == YES) {
        self.countString = @"20";
        self.totalString = @"0";

    }
    //    [self endRefreshWithScrollView:_tableView];
    [YGNetService YGPOST:@"QueryMoreFreshNewsComment" parameters:@{@"freshNewsCommentId":self.commentIdString,@"userid":YGSingletonMarco.user.userId,@"total":self.totalString,@"count":self.countString} showLoadingView:NO scrollView:_tableView success:^(id responseObject) {
        
        NSLog(@"%@",responseObject);
        self.detailDictionary = responseObject[@"freshNewsComment"];
        
        self.commenttextField.placeholder = [NSString stringWithFormat:@" 回复 %@:",[self.detailDictionary valueForKey:@"userName"]];
        
        if (((NSArray *)self.detailDictionary[@"list"]).count < [YGPageSize integerValue]) {
            [self noMoreDataFormatWithScrollView:_tableView];
        }
        if (headerAction == YES) {
            [_dataArray removeAllObjects];
        }
        [_dataArray addObjectsFromArray:[SonCommentModel mj_objectArrayWithKeyValuesArray:self.detailDictionary[@"list"]]];
//        [self addNoDataImageViewWithArray:_dataArray shouldAddToView:_tableView headerAction:YES];

        [_tableView reloadData];
        
    } failure:^(NSError *error) {
        
    }];
    
}



//发送评论
-(void)sendMessage:(UIButton *)button
{
    if (!self.commenttextField.text.length) {
        [YGAppTool showToastWithText:@"评论信息不能为空哦!"];
        return;
    }
    NSString *placeholderString = [NSString stringWithFormat:@" 回复 %@:",[self.detailDictionary valueForKey:@"userName"]];
    if ([self.commenttextField.placeholder isEqualToString:placeholderString]) {
        self.secondIdString = @"";
    }
    NSLog(@"%@",YGSingletonMarco.user.userId);
    [YGNetService YGPOST:@"AddFreshNewsComment" parameters:@{@"freshNewsId":self.idString,@"firstId":self.commentIdString,@"secondId":self.secondIdString,@"userid":YGSingletonMarco.user.userId,@"content":self.commenttextField.text} showLoadingView:YES scrollView:_tableView success:^(id responseObject) {
        
        NSLog(@"%@",responseObject);
        
        [self.commenttextField resignFirstResponder];
        self.commenttextField.text = @"";
        
        [YGAppTool showToastWithText:@"评论成功!"];
        [self refreshActionWithIsRefreshHeaderAction:YES];
        
    } failure:^(NSError *error) {
        
    }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return [tableView fd_heightForCellWithIdentifier:@"NewThingsCommentCell" cacheByIndexPath:indexPath configuration:^(NewThingsCommentCell *cell) {
        cell.fd_enforceFrameLayout = YES;
        [cell setModel:_dataArray[indexPath.row]];
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NewThingsCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NewThingsCommentCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.fd_enforceFrameLayout = YES;
    [cell setModel:_dataArray[indexPath.row]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    UIView *headerView;
    if (_dataArray.count) {
        headerView = [self headerViewWithData:self.detailDictionary];
    }
    return headerView.height;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [self headerViewWithData:self.detailDictionary];
}

- (UIView *)headerViewWithData:(NSDictionary *)dic
{
    UIView *headerView =[[UIView alloc] initWithFrame:CGRectMake(0, 0, YGScreenWidth, 40)];
    //左线
    UIImageView *leftImageView = [[UIImageView alloc]init];
    if (_dataArray.count) {
        [leftImageView sd_setImageWithURL:[NSURL URLWithString:[self.detailDictionary valueForKey:@"userImg"]] placeholderImage:YGDefaultImgAvatar];
    }
    leftImageView.frame = CGRectMake(10, 20, 50, 50);
    leftImageView.layer.cornerRadius = 25;
    leftImageView.clipsToBounds = YES;
    leftImageView.layer.borderColor = colorWithLine.CGColor;
    leftImageView.layer.borderWidth = 0.5;
    leftImageView.backgroundColor = colorWithMainColor;
    leftImageView.contentMode = UIViewContentModeScaleAspectFill;
    [headerView addSubview:leftImageView];
    
    //热门推荐label
    UILabel *titleLabel = [[UILabel alloc]init];
    titleLabel.textColor = colorWithBlack;
    titleLabel.font = [UIFont systemFontOfSize:YGFontSizeNormal];
    titleLabel.text = [self.detailDictionary valueForKey:@"userName"];
    titleLabel.frame = CGRectMake(leftImageView.x+leftImageView.width+10, leftImageView.y,YGScreenWidth-100-15, 20);
    [headerView addSubview:titleLabel];
    
    //点赞
    UIButton *zanButton = [UIButton buttonWithType:UIButtonTypeCustom];
    zanButton.frame = CGRectMake(YGScreenWidth - 80, leftImageView.y - 5, 80, 25);
    [zanButton setTitle:[self.detailDictionary valueForKey:@"count"] forState:UIControlStateNormal];
    [zanButton setImage:[UIImage imageNamed:@"zan_black"] forState:UIControlStateNormal];
    [zanButton setImage:[UIImage imageNamed:@"zan_green"] forState:UIControlStateSelected];
    [zanButton setTitleColor:colorWithDeepGray forState:UIControlStateNormal];
    [zanButton setTitleColor:colorWithDeepGray forState:UIControlStateSelected];
    if([[self.detailDictionary valueForKey:@"state"] isEqualToString:@"0"])
    {
        zanButton.selected = NO;
    }
    if([[self.detailDictionary valueForKey:@"state"] isEqualToString:@"1"])
    {
        zanButton.selected = YES;
    }
    [zanButton addTarget:self action:@selector(zanClick:) forControlEvents:UIControlEventTouchUpInside];
    zanButton.titleLabel.font = [UIFont systemFontOfSize:14.0];
    [headerView addSubview:zanButton];
    
    
    //内容
    UILabel *describeLabel = [[UILabel alloc]init];
    describeLabel.frame = CGRectMake(titleLabel.x,titleLabel.y+titleLabel.height+5 , YGScreenWidth-100, 0);
    describeLabel.textColor = colorWithBlack;
    describeLabel.text = [self.detailDictionary valueForKey:@"content"];
    describeLabel.font = [UIFont systemFontOfSize:YGFontSizeSmallOne];
    describeLabel.numberOfLines = 0;
    [describeLabel sizeToFitVerticalWithMaxWidth:YGScreenWidth-100];
    
    // 调整行间距
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString: describeLabel.text];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:4];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [describeLabel.text length])];
    //attributedText设置后之前设置的都失效
    describeLabel.attributedText = attributedString;
    
    [headerView addSubview:describeLabel];
    
    //时间label
    UILabel *dateLabel = [[UILabel alloc]init];
    dateLabel.frame = CGRectMake(titleLabel.x,describeLabel.y+describeLabel.height+5 , 100, 20);
    dateLabel.textColor = colorWithDeepGray;
    dateLabel.text = [self.detailDictionary valueForKey:@"time"];
    dateLabel.font = [UIFont systemFontOfSize:YGFontSizeSmallOne];
    dateLabel.numberOfLines = 0;
    [dateLabel sizeToFit];
    dateLabel.frame = CGRectMake(titleLabel.x,describeLabel.y+describeLabel.height+5 , dateLabel.width, 20);
    [headerView addSubview:dateLabel];
    
    //大button
    UIButton *replyButton = [[UIButton alloc]initWithFrame:CGRectMake(dateLabel.x+dateLabel.width+10, dateLabel.y, 60, 20)];
    [replyButton addTarget:self action:@selector(replyButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [replyButton setTitle:@"回复" forState:UIControlStateNormal];
    [replyButton setTitleColor:colorWithMainColor forState:UIControlStateNormal];
    replyButton.titleLabel.font = [UIFont systemFontOfSize:YGFontSizeSmallOne];
    replyButton.contentMode = UIViewContentModeLeft;
    [headerView addSubview:replyButton];
    replyButton.centery = dateLabel.centery;
    
    headerView.frame = CGRectMake(0, 0, YGScreenWidth, (20+describeLabel.height+20+10)>60?(20+describeLabel.height+10+20+20 + 10):60);
    return headerView;
    
}
//-(void)textFieldDidEndEditing:(UITextField *)textField reason:(UITextFieldDidEndEditingReason)reason
//{
//    self.commenttextField.placeholder = [NSString stringWithFormat:@" 回复 %@:",[self.detailDictionary valueForKey:@"userName"]];
//    self.secondIdString = @"";
//    [self.commenttextField resignFirstResponder];
//}

//-(BOOL)textFieldShouldReturn:(UITextField *)textField
//{
////    self.commenttextField.placeholder = [NSString stringWithFormat:@" 回复 %@:",[self.detailDictionary valueForKey:@"userName"]];
//    self.commenttextField.placeholder = @" 回复:";
//    self.secondIdString = @"";
//    [self.commenttextField resignFirstResponder];
//    return YES;
//}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.commenttextField.placeholder = [NSString stringWithFormat:@" 回复 %@:",[_dataArray[indexPath.row] valueForKey:@"userName"]];
//    self.commenttextField.placeholder = @" 回复:";
    self.secondIdString = [_dataArray[indexPath.row] valueForKey:@"ID"];
    [self.commenttextField becomeFirstResponder];
}

//回复评论
-(void)replyButtonClick:(UIButton *)button
{
    self.commenttextField.placeholder = [NSString stringWithFormat:@" 回复 %@:",[self.detailDictionary valueForKey:@"userName"]];
//    self.commenttextField.placeholder = @" 回复:";
    [self.commenttextField becomeFirstResponder];
    self.secondIdString = @"";
}

//点赞
-(void)zanClick:(UIButton *)button
{
    if([[self.detailDictionary valueForKey:@"state"] isEqualToString:@"1"])
    {
        return;
    }
    [YGNetService YGPOST:@"ADDFreshNewsCommentLike" parameters:@{@"freshNewsCommentId":self.commentIdString,@"userid":YGSingletonMarco.user.userId} showLoadingView:YES scrollView:_tableView success:^(id responseObject) {
        
        NSLog(@"%@",responseObject);
        
        [self refreshActionWithIsRefreshHeaderAction:YES];
        
    } failure:^(NSError *error) {
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
