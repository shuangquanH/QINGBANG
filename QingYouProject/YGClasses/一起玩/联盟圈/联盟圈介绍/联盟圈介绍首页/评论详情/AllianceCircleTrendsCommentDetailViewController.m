//
//  AllianceCircleTrendsCommentDetailViewController.m
//  QingYouProject
//
//  Created by nefertari on 2017/11/30.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "AllianceCircleTrendsCommentDetailViewController.h"
#import "AllianceCircleTrendsCommentDetailTableViewCell.h"
#import "AllianceCircleTrendsCommentDetailModel.h"
#import "KSPhotoBrowser.h"

@interface AllianceCircleTrendsCommentDetailViewController ()<UITableViewDelegate,UITableViewDataSource,UITextViewDelegate>
{
    NSMutableArray *_listArray;
    UITableView *_tableView;
    UIView *_headerView;
    UITextView *myTextView;
    UILabel *textViewPlaceLabel;
    UIView * sendMessageView;
    UIButton *_commentButton;
}

@property (nonatomic,strong) UIButton *avatarButton;
@property (nonatomic,strong) UILabel *nameLabel;
@property (nonatomic,strong) UILabel *timeLabel;
@property (nonatomic,strong) UILabel *detailLabel;
@property (nonatomic,strong) UIView *baseView;
@property (nonatomic,strong) UILabel *playCountLabel;
@property (nonatomic,strong) UIButton *goodButton;
@property (nonatomic,strong) UIButton *commentButton;
@property (nonatomic,strong) UIImageView *videoImageView;

@end

@implementation AllianceCircleTrendsCommentDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self configUI];

}

- (void)configAttribute
{
    _listArray = [[NSMutableArray alloc]init];
    self.naviTitle = @"详情";
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

}
- (void)setHeaderModel:(AllianceCircleTrendsModel *)headerModel
{
    _headerModel = headerModel;
    [self configHeaderView];
}
- (void)configCommentView
{
    CGFloat H = YGNaviBarHeight ;
    CGFloat Y = kScreenH - H  - YGNaviBarHeight - YGStatusBarHeight;
    
    sendMessageView = [[UIView alloc]initWithFrame:CGRectMake(0, Y, YGScreenWidth, 70)];
    [self.view addSubview:sendMessageView];
    sendMessageView.hidden =YES;
    
    sendMessageView.backgroundColor =[UIColor whiteColor];
    //输入框
    myTextView = [[UITextView alloc]initWithFrame:CGRectMake(10, 0, YGScreenWidth-10 -  90, 45)];
    myTextView.delegate = self;
    myTextView.backgroundColor = [UIColor whiteColor];
    myTextView.bounces = NO;
    myTextView.tag = 100;
    myTextView.font = [UIFont systemFontOfSize:YGFontSizeNormal];
    myTextView.textColor = colorWithBlack;
    myTextView.returnKeyType = UIReturnKeyDone;
    myTextView.inputAccessoryView = [UIView new];
    [sendMessageView addSubview:myTextView];
    
    //  placeLabel
    textViewPlaceLabel = [[UILabel alloc]init];
    textViewPlaceLabel.text = @"  说点什么";
    textViewPlaceLabel.numberOfLines = 2;
    textViewPlaceLabel.textColor = colorWithLightGray;
    textViewPlaceLabel.font = [UIFont systemFontOfSize:YGFontSizeSmallOne];
    textViewPlaceLabel.frame = CGRectMake(10, 10, YGScreenWidth - 100, 30);
    [textViewPlaceLabel sizeToFit];
    [sendMessageView addSubview:textViewPlaceLabel];
    
    UIButton * sendBtn =[[UIButton alloc]initWithFrame:CGRectMake(YGScreenWidth - 90, 0, 90, 45)];
    sendBtn.backgroundColor = colorWithMainColor;
    [sendBtn setTitle:@"发送" forState:UIControlStateNormal];
    [sendBtn addTarget:self action:@selector(sendBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [sendMessageView addSubview:sendBtn];
}
- (void)configHeaderView
{
    
    _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, YGScreenWidth, 0)];
    _headerView.backgroundColor = colorWithYGWhite;

    _avatarButton = [[UIButton alloc]initWithFrame:CGRectMake(10, 10, 35, 35)];
    _avatarButton.layer.cornerRadius = 15;
    _avatarButton.imageView.contentMode = UIViewContentModeScaleAspectFill;
    _avatarButton.contentHorizontalAlignment= UIControlContentHorizontalAlignmentFill;
    _avatarButton.contentVerticalAlignment = UIControlContentVerticalAlignmentFill;
    _avatarButton.clipsToBounds = YES;
//    [_avatarButton addTarget:self action:@selector(avatarButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [_headerView addSubview:_avatarButton];
    
    _nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(_avatarButton.x+_avatarButton.width+8, _avatarButton.y+5, YGScreenWidth-(_avatarButton.x+_avatarButton.width+8)-10-100, 20)];
    _nameLabel.textColor = colorWithBlack;
    _nameLabel.font = [UIFont systemFontOfSize:YGFontSizeBigOne];
    [_headerView addSubview:_nameLabel];

    
    _detailLabel = [[UILabel alloc]initWithFrame:CGRectMake(_nameLabel.x, _nameLabel.y+_nameLabel.height+8, YGScreenWidth-(_avatarButton.x+_avatarButton.width+8)-10,20)];
    _detailLabel.textColor = colorWithBlack;
    _detailLabel.font = [UIFont systemFontOfSize:YGFontSizeNormal];
    _detailLabel.numberOfLines = 0;
    [_headerView addSubview:_detailLabel];
    _detailLabel.text = _headerModel.content;
    [_detailLabel sizeToFit];
    _detailLabel.frame = CGRectMake(_detailLabel.x, _detailLabel.y, YGScreenWidth-(_avatarButton.x+_avatarButton.width+8)-10, _detailLabel.height);

    
    _baseView = [[UIView alloc]initWithFrame:CGRectMake(_nameLabel.x, _detailLabel.y+_detailLabel.height+8, (YGScreenWidth -48-10), 0)];
    [_headerView addSubview:_baseView];
    
    UIView *subBaseView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, (YGScreenWidth -48-10), 0)];
    [_baseView addSubview:subBaseView];
    
    _detailLabel.preferredMaxLayoutWidth = subBaseView.width;
    
    int rowCount = 0;
    for (int i = 0; i<_headerModel.imgArr.count; i++)
    {
        int x = i%3;
        int y = i/3;
        UIButton *imageButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, (subBaseView.width - 5*2)/3, (subBaseView.width - 5*2)/3)];
        imageButton.x = x * (imageButton.width+5);
        imageButton.y = y * (imageButton.height+5);
        imageButton.tag = 100 + i;
        imageButton.imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageButton.contentHorizontalAlignment= UIControlContentHorizontalAlignmentFill;
        imageButton.contentVerticalAlignment = UIControlContentVerticalAlignmentFill;
        imageButton.clipsToBounds = YES;
        [imageButton addTarget:self action:@selector(imageButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [subBaseView addSubview:imageButton];
        
        if (_headerModel.imgArr.count == 1)
        {
            imageButton.width = subBaseView.width;
            imageButton.height = imageButton.width * 380 / 690;
        }
        
        if (i == self.headerModel.imgArr.count - 1)
        {
            subBaseView.height = imageButton.y + imageButton.height;
        }
        if (_headerModel.imgArr.count == 1) {
            [imageButton sd_setImageWithURL:[NSURL URLWithString:_headerModel.imgArr[i]] forState:UIControlStateNormal placeholderImage:YGDefaultImgSquare];
        }
        else
        {
            [imageButton sd_setImageWithURL:[NSURL URLWithString:_headerModel.imgArr[i]] forState:UIControlStateNormal placeholderImage:YGDefaultImgSquare];
        }
        rowCount = y;
    }
    
    _baseView.frame = CGRectMake(_baseView.x, _baseView.y, (YGScreenWidth -48-10), subBaseView.height);
    
    _headerView.frame = CGRectMake(0, 0, YGScreenWidth, _baseView.y+_baseView.height+40);

    
    UIView *lineView = [[UIView alloc]init];
    lineView.backgroundColor = colorWithYGWhite;
    [_headerView addSubview:lineView];
    
    

    
    _commentButton = [[UIButton alloc]init];
    [_commentButton setImage:[UIImage imageNamed:@"home_playtogether_comment_black"] forState:UIControlStateNormal];
    [_commentButton setTitleColor:colorWithDeepGray forState:UIControlStateNormal];
    _commentButton.titleLabel.font = [UIFont systemFontOfSize:YGFontSizeSmallTwo];
    _commentButton.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
//    [_commentButton addTarget:self action:@selector(commentButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [_headerView addSubview:_commentButton];
    
    _goodButton = [[UIButton alloc]init];
    [_goodButton setImage:[UIImage imageNamed:@"zan_black"] forState:UIControlStateNormal];
    [_goodButton setImage:[UIImage imageNamed:@"zan_green"] forState:UIControlStateSelected];
    [_goodButton setTitleColor:colorWithDeepGray forState:UIControlStateNormal];
    _goodButton.titleLabel.font = _commentButton.titleLabel.font;
    _goodButton.titleEdgeInsets = _commentButton.titleEdgeInsets;
    [_goodButton addTarget:self action:@selector(goodButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_headerView addSubview:_goodButton];
    
    
    _timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(_nameLabel.x,_commentButton.y , 100, 20)];
    _timeLabel.textColor = colorWithDeepGray;
    _timeLabel.font = [UIFont systemFontOfSize:YGFontSizeSmallOne];
    [_headerView addSubview:_timeLabel];
    
    
    [_avatarButton sd_setImageWithURL:[NSURL URLWithString:_headerModel.userImg] forState:UIControlStateNormal placeholderImage:YGDefaultImgAvatar];
    _nameLabel.text = _headerModel.userName;
    _timeLabel.text = _headerModel.createDate;
    _goodButton.selected = _headerModel.isLike.intValue;
    [_goodButton setTitle:_headerModel.likeCount forState:UIControlStateNormal];
    [_commentButton setTitle:_headerModel.commentCount forState:UIControlStateNormal];
    
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_baseView.y+_baseView.height+10);
        make.left.right.mas_equalTo(_baseView);
        make.height.mas_equalTo(1);
    }];
    
    [_commentButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(_headerView.mas_right).mas_offset(-10);
        make.top.mas_equalTo(lineView.mas_bottom).offset(5);
        make.width.mas_equalTo(70);
        make.bottom.mas_equalTo(_headerView.mas_bottom).mas_offset(-10);
    }];
    
    [_goodButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(_commentButton.mas_left).offset(-5);
        make.centerY.mas_equalTo(_commentButton.mas_centerY);
        make.width.mas_equalTo(_commentButton.mas_width);
    }];
    
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_nameLabel.mas_left);
        make.centerY.mas_equalTo(_goodButton.mas_centerY);
        
    }];
    MASAttachKeys(_avatarButton,_nameLabel,_timeLabel,_detailLabel,_baseView,lineView,_commentButton,_goodButton);


    
    [self configUI];
    
}
- (void)configUI
{
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, YGScreenWidth, YGScreenHeight-YGNaviBarHeight-YGStatusBarHeight-45) style:UITableViewStyleGrouped];
    _tableView.backgroundColor = colorWithTable;
    _tableView.sectionFooterHeight = 0.001;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, YGScreenWidth, 0.001)];
    _tableView.tableHeaderView = _headerView;
        [_tableView registerClass:[AllianceCircleTrendsCommentDetailTableViewCell class] forCellReuseIdentifier:@"AllianceCircleTrendsCommentDetailTableViewCell"];
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    [self createRefreshWithScrollView:_tableView containFooter:YES];
    [self refreshActionWithIsRefreshHeaderAction:YES];
    
    if (@available(iOS 11.0, *)) {
        
        _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        
    } else {
        
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    /****************************** 按钮 **************************/
    _commentButton = [[UIButton alloc]initWithFrame:CGRectMake(0,YGScreenHeight-YGStatusBarHeight-YGNaviBarHeight-45-YGBottomMargin,YGScreenWidth,45+YGBottomMargin)];
    _commentButton.titleEdgeInsets = UIEdgeInsetsMake(-YGBottomMargin, 0, 0, 0);
    [_commentButton addTarget:self action:@selector(commentButtonAction) forControlEvents:UIControlEventTouchUpInside];
    _commentButton.backgroundColor = colorWithMainColor;
    _commentButton.titleLabel.font = [UIFont systemFontOfSize:YGFontSizeBigOne];
    [self.view addSubview:_commentButton];
    [_commentButton setTitleColor:colorWithYGWhite forState:UIControlStateNormal];
    [_commentButton setTitle:@"评论" forState:UIControlStateNormal];
    
    [self configCommentView];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _listArray.count;
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 1;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AllianceCircleTrendsCommentDetailModel *model = _listArray[indexPath.row];
    
    AllianceCircleTrendsCommentDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AllianceCircleTrendsCommentDetailTableViewCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.model = model;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return [tableView fd_heightForCellWithIdentifier:@"AllianceCircleTrendsCommentDetailTableViewCell" cacheByIndexPath:indexPath configuration:^(AllianceCircleTrendsCommentDetailTableViewCell *cell) {
        cell.model = _listArray[indexPath.row];
    }];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    AllianceCircleTrendsCommentDetailModel *model = _listArray[indexPath.row];
    //    CircleDetailViewController *controller = [[CircleDetailViewController alloc]init];
    //    controller.circleId = model.ID;
    
    //    [self.navigationController pushViewController:controller animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 55;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, YGScreenWidth, 55)];
    headerView.backgroundColor = colorWithYGWhite;
    
    UIView *headerLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, YGScreenWidth, 10)];
    headerLineView.backgroundColor = colorWithTable;
    [headerView addSubview:headerLineView];

    UILabel *commentCountLabel = [[UILabel alloc]initWithFrame:CGRectMake(10,10 , YGScreenWidth-20, 45)];
    commentCountLabel.textColor = colorWithBlack;
    commentCountLabel.font = [UIFont systemFontOfSize:YGFontSizeBigTwo];
    commentCountLabel.text = [NSString stringWithFormat:@"评论（%ld）",_listArray.count];
    [headerView addSubview:commentCountLabel];
    
    return headerView;
}
- (void)refreshActionWithIsRefreshHeaderAction:(BOOL)headerAction
{
 
    //    NSString *userId;
    //    if (YGSingletonMarco.user)
    //    {
    //        userId = YGSingletonMarco.user.ID;
    //    }
    //    else
    //    {
    //        userId = @"";
    //    }
    if (headerAction == YES) {
        self.totalString = @"0";
    }
    [YGNetService YGPOST:REQUEST_getDynamicComment parameters:@{@"dynamicID":_headerModel.dynamicID,@"userID":YGSingletonMarco.user.userId,@"count":self.countString,@"total":self.totalString} showLoadingView:NO scrollView:_tableView success:^(id responseObject) {
        if (headerAction)
        {
            [_listArray removeAllObjects];
        }
        if ([responseObject[@"commentList"] count] == 0)
        {
            [YGAppTool showToastWithText:NOTICE_NOMORE];
        }
        [_listArray addObjectsFromArray:[AllianceCircleTrendsCommentDetailModel mj_objectArrayWithKeyValuesArray:responseObject[@"commentList"]]];
        [_tableView reloadData];
    } failure:^(NSError *error) {
        
    }];
    
}

-(void)textViewDidChange:(UITextView *)textView
{
    [textView becomeFirstResponder];
    if (textView.text.length > 0)
    {
        textViewPlaceLabel.hidden = YES;
    }else
    {
        textViewPlaceLabel.hidden = NO;
    }
    //    if (textView.text.length >140)
    //    {
    //        [textView resignFirstResponder];
    //        [YGAppTool showToastWithText:@"输入文字不能多于50字哦！"];
    //    }
}
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString*)text
{
    if ([text isEqualToString:@"\n"])
    {
        [textView resignFirstResponder];
        sendMessageView.hidden = YES;
        _commentButton.hidden = NO;
        return NO;
    }
    return YES;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    [myTextView becomeFirstResponder];
    
    sendMessageView.hidden =YES;

    _commentButton.hidden =NO;

    return YES;
}
- (void)commentButtonAction
{
    sendMessageView.hidden = NO;
    [myTextView becomeFirstResponder];
    
    _commentButton.hidden =YES;
}

-(void)sendBtnClick
{
    sendMessageView.hidden = YES;
    
    if (myTextView.text.length <1)
    {
        [YGAppTool showToastWithText:@"请输入评价文字"];
        return ;
    }
    if (myTextView.text.length >50)
    {
        [myTextView resignFirstResponder];
        [YGAppTool showToastWithText:@"输入文字不能多于50字哦！"];
        return ;
    }
    [myTextView resignFirstResponder];

    
    //发布评论
    [YGNetService YGPOST:REQUEST_postedDynamicComment parameters:@{@"userID":YGSingletonMarco.user.userId,@"content":myTextView.text,@"dynamicID":_headerModel.dynamicID} showLoadingView:NO scrollView:nil success:^(id responseObject) {
        
        [YGAppTool showToastWithText:@"评论发布成功！"];
        myTextView.text = @"";
        [self refreshActionWithIsRefreshHeaderAction:YES];
        
    } failure:^(NSError *error) {
        
        
    }];
}

- (void)imageButtonClick:(UIButton *)imageButton
{
    NSMutableArray *items = [[NSMutableArray alloc]init];
    for (int i = 0; i < _headerModel.imgArr.count; i++)
    {
        UIButton *btn = [_baseView viewWithTag:100+i];
        KSPhotoItem *item = [KSPhotoItem itemWithSourceView:(UIImageView *)btn imageUrl:[NSURL URLWithString:_headerModel.imgArr[i]]];
        [items addObject:item];
    }
    KSPhotoBrowser *browser = [KSPhotoBrowser browserWithPhotoItems:items selectedIndex:imageButton.tag-100];
    browser.noSingleTap = YES;
    browser.noSingleTap = NO;
    browser.dismissalStyle = KSPhotoBrowserInteractiveDismissalStyleScale;
    browser.pageindicatorStyle = KSPhotoBrowserPageIndicatorStyleText;
    browser.backgroundStyle = KSPhotoBrowserBackgroundStyleBlack;
    [browser showFromViewController:self];
}

- (void)goodButtonClick:(UIButton *)button
{
    // 点赞与取消点赞
    [YGNetService YGPOST:REQUEST_likeAllianceDynamic parameters:@{@"dynamicID":_headerModel.dynamicID,@"userID":YGSingletonMarco.user.userId} showLoadingView:NO scrollView:nil success:^(id responseObject) {
        button.selected = !button.isSelected;
        [button showQAnimate];
        _headerModel.isLike = [YGAppTool stringValueWithInt:button.selected];
        
        if (button.isSelected)
        {
            _headerModel.likeCount = [YGAppTool stringValueWithInt:_headerModel.likeCount.intValue + 1];
        }
        else
        {
            _headerModel.likeCount = [YGAppTool stringValueWithInt:_headerModel.likeCount.intValue - 1];
        }
        [button setTitle:_headerModel.likeCount forState:UIControlStateNormal];
    } failure:^(NSError *error) {
        
    }];
}

- (void)collectButtonClick
{
}

@end
