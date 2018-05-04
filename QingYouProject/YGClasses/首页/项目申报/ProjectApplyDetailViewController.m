//
//  ProjectApplyDetailViewController.m
//  QingYouProject
//
//  Created by 王丹 on 2017/11/27.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "ProjectApplyDetailViewController.h"
#import "TextViewAjustHeight.h"
#import "ProjectApplyForDetailModel.h"
#import "ProjectApplySuccessDetailViewController.h"
#import "ProjectApplyForWebDetailViewController.h"

@interface ProjectApplyDetailViewController ()<UIScrollViewDelegate>

@end

@implementation ProjectApplyDetailViewController
{
    UIScrollView * _scrollView;
    UIView *_baseView;
    UILabel *_describeLabel; //内容
    UILabel *_titleLabel; //标题
    UILabel *_dateLabel; //标题
    UILabel *_contentLabel; //标题
    UILabel *_prepareContentLabel; //标题

    UIView *_decodeView; //项目解读
    UILabel *_decodeContentLabel; //项目解读内容

    
    UIView *_inputbaseView; //项目解读
    UIView *_companyNamebaseView;
    UILabel *_companyNameLabel;
    TextViewAjustHeight *_companyNameTextView;
    ProjectApplyForDetailModel *_model;
    
    UIButton *_confirmRealButton;
    UIButton *_confirmImageViewButton;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadData];
    // Do any additional setup after loading the view.
}
- (void)configAttribute
{

    self.naviTitle = @"项目详情";
    _model = [[ProjectApplyForDetailModel alloc] init];
    UIBarButtonItem *rightItem = [self createBarbuttonWithNormalTitleString:@"申请" selectedTitleString:@"申请" selector:@selector(finishImputAction)];
    self.navigationItem.rightBarButtonItem = rightItem;
}
- (void)loadData
{
    [YGNetService YGPOST:REQUEST_SearchGrade parameters:@{@"id":_itemID}  showLoadingView:NO scrollView:nil success:^(id responseObject) {
        
        [_model setValuesForKeysWithDictionary:responseObject];
        
        [self configUI];
        
    } failure:^(NSError *error) {
        
    }];
}
#pragma mark ---- 配置UI
-(void)configUI
{
    
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, YGScreenWidth, YGScreenHeight-YGNaviBarHeight-YGStatusBarHeight)];
    _scrollView.contentSize = CGSizeMake(YGScreenWidth, _scrollView.height);
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    //    _scrollView.pagingEnabled = YES;
    //    _scrollView.bounces = NO;
    _scrollView.delegate = self;
    [self.view addSubview:_scrollView];
    
    //热门推荐view
    _baseView = [[UIView alloc]initWithFrame:CGRectMake(0,0, YGScreenWidth, 80)];
    _baseView.backgroundColor = colorWithYGWhite;
    [_scrollView addSubview:_baseView];
    
    //        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0,0, YGScreenWidth, 1)];
    //        lineView.backgroundColor = colorWithLine;
    //        [_baseView addSubview:lineView];
    
    
    //新鲜事标题label
    _titleLabel = [[UILabel alloc]init];
    _titleLabel.textColor = colorWithBlack;
    _titleLabel.font = [UIFont systemFontOfSize:YGFontSizeBigFour];
    _titleLabel.text = _model.fundName;
    _titleLabel.frame = CGRectMake(10, 15,YGScreenWidth-35, 25);
    [_titleLabel sizeToFitVerticalWithMaxWidth:YGScreenWidth-20];
    _titleLabel.frame = CGRectMake(10, 15,YGScreenWidth-35, _titleLabel.height+10);
    [_baseView addSubview:_titleLabel];
    
    
    //新鲜事内容label
    _describeLabel = [[UILabel alloc]init];
    _describeLabel.frame = CGRectMake(_titleLabel.x,_titleLabel.y+_titleLabel.height+5 , 100, 1);
    _describeLabel.textColor = colorWithLightGray;
    _describeLabel.text =[NSString stringWithFormat:@"作者：%@  来源：%@",_model.author,_model.source];
    _describeLabel.font = [UIFont systemFontOfSize:YGFontSizeSmallOne];
    [_describeLabel sizeToFit];
    [_baseView addSubview:_describeLabel];
    _describeLabel.frame = CGRectMake(_describeLabel.x,_describeLabel.y, _describeLabel.width, 17);
    
    //新鲜事内容label
    _dateLabel = [[UILabel alloc]init];
    _dateLabel.frame = CGRectMake(_describeLabel.x, _describeLabel.y+_describeLabel.height, 130, 17);
    _dateLabel.textColor = colorWithLightGray;
    _dateLabel.text = [NSString stringWithFormat:@"发布时间：%@",_model.createDate];
    _dateLabel.font = [UIFont systemFontOfSize:YGFontSizeSmallOne];
    [_dateLabel sizeToFit];
    [_baseView addSubview:_dateLabel];
    _dateLabel.frame = CGRectMake(_dateLabel.x,_dateLabel.y, _dateLabel.width, 20);

    
    //新鲜事内容label
    UILabel  *contentTitleLabel = [[UILabel alloc]init];
    contentTitleLabel.frame = CGRectMake(10, _dateLabel.y+_dateLabel.height+30, YGScreenWidth-20, 20);
    contentTitleLabel.textColor = colorWithBlack;
    contentTitleLabel.text = @"一、政策优惠";
    contentTitleLabel.font = [UIFont systemFontOfSize:YGFontSizeBigTwo];
    contentTitleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    [_baseView addSubview:contentTitleLabel];
    
    //新鲜事内容label
    _contentLabel = [[UILabel alloc]init];
    _contentLabel.frame = CGRectMake(contentTitleLabel.x, contentTitleLabel.y+contentTitleLabel.height+5, YGScreenWidth-20, 20);
    _contentLabel.textColor = colorWithLightGray;
    _contentLabel.text = _model.preferentialPolicy;
    _contentLabel.font = [UIFont systemFontOfSize:YGFontSizeBigOne];
    _contentLabel.numberOfLines = 0;
    [_baseView addSubview:_contentLabel];
    [_contentLabel sizeToFitVerticalWithMaxWidth:YGScreenWidth-20];
    _contentLabel.frame = CGRectMake(_contentLabel.x, _contentLabel.y, YGScreenWidth-20, _contentLabel.height+10);

    //新鲜事内容label
    UILabel  *prepareContentTitleLabel = [[UILabel alloc]init];
    prepareContentTitleLabel.frame = CGRectMake(10, _contentLabel.y+_contentLabel.height+5, YGScreenWidth-20, 20);
    prepareContentTitleLabel.textColor = colorWithBlack;
    prepareContentTitleLabel.text = @"二、企业申报的必需条件";
    prepareContentTitleLabel.font = [UIFont systemFontOfSize:YGFontSizeBigTwo];
    prepareContentTitleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    [_baseView addSubview:prepareContentTitleLabel];
    
    //新鲜事内容label
    _prepareContentLabel = [[UILabel alloc]init];
    _prepareContentLabel.frame = CGRectMake(10, prepareContentTitleLabel.y+prepareContentTitleLabel.height+10, YGScreenWidth-20, 20);
    _prepareContentLabel.textColor = colorWithLightGray;
    _prepareContentLabel.text = _model.declareConditions;
    _prepareContentLabel.font = [UIFont systemFontOfSize:YGFontSizeBigOne];
    _prepareContentLabel.numberOfLines = 0;
    [_baseView addSubview:_prepareContentLabel];
    [_prepareContentLabel sizeToFitVerticalWithMaxWidth:YGScreenWidth-20];
    _prepareContentLabel.frame = CGRectMake(_prepareContentLabel.x, _prepareContentLabel.y, YGScreenWidth-20, _prepareContentLabel.height+10);
    
    
    _baseView.frame = CGRectMake(0, 0, YGScreenWidth, _prepareContentLabel.y+_prepareContentLabel.height+10);
    
    
    //热门推荐view
    _decodeView = [[UIView alloc]initWithFrame:CGRectMake(0,_baseView.height+10, YGScreenWidth, 80)];
    _decodeView.backgroundColor = colorWithYGWhite;
    [_scrollView addSubview:_decodeView];
    
    //新鲜事标题label
    UILabel  *dedcadeTitleLabel = [[UILabel alloc]init];
    dedcadeTitleLabel.textColor = colorWithBlack;
    dedcadeTitleLabel.font = [UIFont systemFontOfSize:YGFontSizeBigTwo];
    dedcadeTitleLabel.text = @"项目解读";
    dedcadeTitleLabel.frame = CGRectMake(10, 10,YGScreenWidth-20, 25);
    [_decodeView addSubview:dedcadeTitleLabel];
    
    UIView *dedcadeLineView = [[UIView alloc]initWithFrame:CGRectMake(0,40, YGScreenWidth, 1)];
    dedcadeLineView.backgroundColor = colorWithLine;
    [_decodeView addSubview:dedcadeLineView];

    //新鲜事内容label
    _decodeContentLabel = [[UILabel alloc]init];
    _decodeContentLabel.frame = CGRectMake(10, dedcadeLineView.y+dedcadeLineView.height+10, YGScreenWidth-20, 20);
    _decodeContentLabel.textColor = colorWithLightGray;
    _decodeContentLabel.text = _model.projectInterpretation;
    _decodeContentLabel.font = [UIFont systemFontOfSize:YGFontSizeBigOne];
    _decodeContentLabel.numberOfLines = 0;
    [_decodeView addSubview:_decodeContentLabel];
    [_decodeContentLabel sizeToFitVerticalWithMaxWidth:YGScreenWidth-20];
    _decodeContentLabel.frame = CGRectMake(_decodeContentLabel.x, _decodeContentLabel.y, YGScreenWidth-20, _decodeContentLabel.height+20);

    _decodeView.frame = CGRectMake(0, _decodeView.y, YGScreenWidth, _decodeContentLabel.y+_decodeContentLabel.height+10);


    
    //热门推荐view
    _inputbaseView = [[UIView alloc]initWithFrame:CGRectMake(0,_decodeView.y +_decodeView.height+10, YGScreenWidth, 45*4+40+80)];
    _inputbaseView.backgroundColor = colorWithYGWhite;
    [_scrollView addSubview:_inputbaseView];
    
   
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, YGScreenWidth-20, 40)];
    label.text = @"我们为您提供高效、专业的项目申报服务";
    label.backgroundColor = colorWithYGWhite;
    label.font = [UIFont systemFontOfSize:YGFontSizeBigTwo];
    label.textColor = colorWithBlack;
    [_inputbaseView addSubview:label];
    
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 39, YGScreenWidth, 1)];
    lineView.backgroundColor = colorWithLine;
    [_inputbaseView addSubview:lineView];
    
    _companyNamebaseView = [[UIView alloc] initWithFrame:CGRectMake(0, lineView.y+1, YGScreenWidth, 45)];
    _companyNamebaseView.backgroundColor = colorWithYGWhite;
    [_inputbaseView addSubview:_companyNamebaseView];
    
    _companyNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10,12 , 100, 20)];
    _companyNameLabel.text = @"企业名称";
    _companyNameLabel.textAlignment = NSTextAlignmentLeft;
    _companyNameLabel.font = [UIFont systemFontOfSize:YGFontSizeBigOne];
    _companyNameLabel.textColor = colorWithBlack;
    [_companyNamebaseView addSubview:_companyNameLabel];
    
    _companyNameTextView = [[TextViewAjustHeight alloc]initWithFrame:CGRectMake(_companyNameLabel.x+_companyNameLabel.width+10, 5, YGScreenWidth-(_companyNameLabel.x+_companyNameLabel.width+10)-10, 30)];
    _companyNameTextView.font = [UIFont systemFontOfSize:YGFontSizeNormal];
    _companyNameTextView.textColor = colorWithBlack;
    _companyNameTextView.textAlignment = NSTextAlignmentRight;
    _companyNameTextView.returnKeyType = UIReturnKeyDone;
    _companyNameTextView.backgroundColor = [UIColor clearColor];
    _companyNameTextView.placeholder = @"请输入企业名称";
    _companyNameTextView.placeholderColor = colorWithLightGray;
    _companyNameTextView.placeholderFont = [UIFont systemFontOfSize:YGFontSizeBigOne];
    _companyNameTextView.maxNumberOfLines = 4;
    [_companyNamebaseView addSubview:_companyNameTextView];
    
    UIView *companyLineView = [[UIView alloc] initWithFrame:CGRectMake(10, 44, YGScreenWidth-10, 1)];
    companyLineView.backgroundColor = colorWithLine;
    [_companyNamebaseView addSubview:companyLineView];

    UIView *leftBaseView = [[UIView alloc] initWithFrame:CGRectMake(0, _companyNamebaseView.y+_companyNamebaseView.height, YGScreenWidth, 45*3+70)];
    [_inputbaseView addSubview:leftBaseView];
    
    NSArray *titleArray = @[@"企业性质",@"联系人",@"联系电话"];
    NSArray *placehoderArray = @[@"请输入企业性质",@"请输入联系人姓名",@"请输入联系电话"];
    for (int i = 0; i<3; i++) {
        UIView *baseView = [[UIView alloc] initWithFrame:CGRectMake(0, (45*i), YGScreenWidth, 45)];
        baseView.backgroundColor = colorWithYGWhite;
        [leftBaseView addSubview:baseView];
        
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10,0 , 100, 45)];
        nameLabel.text = titleArray[i];
        nameLabel.textAlignment = NSTextAlignmentLeft;
        nameLabel.font = [UIFont systemFontOfSize:YGFontSizeBigOne];
        nameLabel.textColor = colorWithDeepGray;
        [baseView addSubview:nameLabel];
        
        UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(nameLabel.x+nameLabel.width+10, 0, YGScreenWidth-(nameLabel.x+nameLabel.width+10)-10, nameLabel.height)];
        textField.tag = 100+i;
        textField.font = [UIFont systemFontOfSize:YGFontSizeBigOne];
        textField.textColor = colorWithBlack;
        textField.placeholder = placehoderArray[i];
        textField.textAlignment = NSTextAlignmentRight;
        [baseView addSubview:textField];
        [textField setValue:colorWithLightGray forKeyPath:@"_placeholderLabel.textColor"];
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(10, baseView.height-1, YGScreenWidth-10, 1)];
        lineView.backgroundColor = colorWithLine;
        [baseView addSubview:lineView];
    }

    
    __weak UIView *weakFourthbaseView = _companyNamebaseView;
    __weak UIView *weakThirdLineView = companyLineView;
    __weak TextViewAjustHeight *weakTextView = _companyNameTextView;
    __weak UIView *weakLeftView = leftBaseView;

    // 设置文本框最大行数
    [_companyNameTextView textValueDidChanged:^(NSString *text, CGFloat textHeight) {
        CGRect frame = weakTextView.frame;
        frame.size.height = textHeight;
        weakTextView.frame = frame;
        if ((textHeight+10)>45)
        {
            weakFourthbaseView.frame = CGRectMake(weakFourthbaseView.x, weakFourthbaseView.y, weakFourthbaseView.width, 5+textHeight+5);
            weakThirdLineView.frame = CGRectMake(10, weakFourthbaseView.height-1, weakThirdLineView.width, 1);
            weakLeftView.frame = CGRectMake(weakFourthbaseView.x, weakFourthbaseView.y+weakFourthbaseView.height, weakFourthbaseView.width, weakFourthbaseView.height);
        }
        
    }];
    
    _confirmImageViewButton = [[UIButton alloc]initWithFrame:CGRectMake(3,45*3+20,40,40)];
    [_confirmImageViewButton setImage:[UIImage imageNamed:@"nochoice_btn_gray"] forState:UIControlStateNormal];
    [_confirmImageViewButton setImage:[UIImage imageNamed:@"order_choice_btn_green"] forState:UIControlStateSelected];
    [_confirmImageViewButton setTitleColor:colorWithDeepGray forState:UIControlStateNormal];
    [_confirmImageViewButton addTarget:self action:@selector(defultButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    _confirmImageViewButton.contentMode = UIViewContentModeCenter;
    [leftBaseView addSubview:_confirmImageViewButton];
    _confirmImageViewButton.selected = NO;

    //新鲜事内容label
    UILabel  *confirmLabel = [[UILabel alloc]init];
    confirmLabel.frame = CGRectMake(_confirmImageViewButton.x+_confirmImageViewButton.width,_confirmImageViewButton.y, 100, 20);
    confirmLabel.textColor = colorWithLightGray;
    confirmLabel.text =@"已阅读并同意";
    confirmLabel.font = [UIFont systemFontOfSize:YGFontSizeNormal];
    [confirmLabel sizeToFit];
    [leftBaseView addSubview:confirmLabel];
    confirmLabel.frame = CGRectMake(confirmLabel.x,confirmLabel.y, confirmLabel.width, 20);
    confirmLabel.centery = _confirmImageViewButton.centery;
    
    _confirmRealButton = [[UIButton alloc]initWithFrame:CGRectMake(confirmLabel.x+confirmLabel.width,confirmLabel.y,100,25)];
    [_confirmRealButton setTitle:@"《青网项目申报服务协议》" forState:UIControlStateNormal];
    [_confirmRealButton setTitleColor:colorWithMainColor forState:UIControlStateNormal];
    [_confirmRealButton addTarget:self action:@selector(protocolButtonAction) forControlEvents:UIControlEventTouchUpInside];
    _confirmRealButton.titleLabel.font = [UIFont systemFontOfSize:YGFontSizeNormal];
    [_confirmRealButton sizeToFit];
    [leftBaseView addSubview:_confirmRealButton];
    _confirmRealButton.frame = CGRectMake(_confirmRealButton.x,_confirmRealButton.y,_confirmRealButton.width+20,30);
    _confirmRealButton.centery = _confirmImageViewButton.centery;
    
    _scrollView.contentSize = CGSizeMake(YGScreenWidth, _inputbaseView.y+_inputbaseView.height+20);
}

- (void)defultButtonAction:(UIButton *)btn
{
    btn.selected = !btn.selected;
}
- (void)protocolButtonAction
{
    ProjectApplyForWebDetailViewController *protocolVC = [[ProjectApplyForWebDetailViewController alloc] init];
    protocolVC.contentUrl = _model.projectAgreement;
    protocolVC.naviTitleString = @"青网项目申报服务协议";
    [self.navigationController pushViewController:protocolVC animated:YES];
}
- (void)finishImputAction
{

    UITextField *typeTextField = [self.view  viewWithTag:100];
    UITextField *nameTextField = [self.view  viewWithTag:101];
    UITextField *phoneTextField = [self.view  viewWithTag:102];

    if (phoneTextField.text.length == 0 || typeTextField.text.length == 0 || phoneTextField.text.length == 0 ||_companyNameTextView.text.length == 0) {
        [YGAppTool showToastWithText:@"请将信息填写完整"];
        return;
    }
    
    if (![YGAppTool isVerifiedWithText:nameTextField.text name:@"联系人姓名" maxLength:20 minLength:2 shouldEmpty:NO]) {
        return;
    }
    
    if ([YGAppTool isNotPhoneNumber:phoneTextField.text]) {
        return;
    }
    if (_confirmImageViewButton.selected != YES) {
        [YGAppTool showToastWithText:@"请确认并勾选“本人保证所填写的内容属实”按钮"];
        return;
    }
    [self startPostWithURLString:REQUEST_AddGradeProject parameters:@{@"contactPerson":nameTextField.text,@"enterpriseName":_companyNameTextView.text,@"enterpriseNature":typeTextField.text,@"contactPhone":phoneTextField.text,@"releasedId":_itemID,@"userId":YGSingletonMarco.user.userId} showLoadingView:NO scrollView:nil];
    
}

- (void)didReceiveSuccessResponeseWithURLString:(NSString *)URLString parameters:(id)parameters responeseObject:(id)responseObject
{
    
    [YGAlertView showAlertWithTitle:@"申请成功，等待审核" buttonTitlesArray:@[@"确定"] buttonColorsArray:@[colorWithMainColor] handler:^(NSInteger buttonIndex) {
        ProjectApplySuccessDetailViewController *vc = [[ProjectApplySuccessDetailViewController alloc] init];
        vc.pageType = 1;
        vc.itemID = responseObject[@"id"];
        [self.navigationController pushViewController:vc animated:YES];
        
    }];
}
@end
