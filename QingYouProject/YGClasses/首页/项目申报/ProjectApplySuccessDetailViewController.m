//
//  ProjectApplySuccessDetailViewController.m
//  QingYouProject
//
//  Created by nefertari on 2017/11/28.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "ProjectApplySuccessDetailViewController.h"
#import "ProjectApplySuccessModel.h"

@interface ProjectApplySuccessDetailViewController ()<UIScrollViewDelegate>

@end

@implementation ProjectApplySuccessDetailViewController
{
    UIScrollView * _scrollView;
    UIView *_baseView;
    UILabel *_describeLabel; //内容
    UILabel *_titleLabel; //标题
    UILabel *_dateLabel; //标题
    
    UIView *_orderBaseView;
    UIView *_orderFinishBaseView;
    UIView *_orderResonBaseView;
    
    UILabel *_resonLabel; //标题
    ProjectApplySuccessModel *_model;

}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self loadData];
}
- (void)configAttribute
{
    _model = [[ProjectApplySuccessModel alloc] init];
    self.naviTitle = @"项目详情";
}
- (void)loadData
{
    if (self.pageType == 1) {//提交成功
        [YGNetService YGPOST:REQUEST_SeachGradeProject parameters:@{@"id":_itemID}  showLoadingView:NO scrollView:nil success:^(id responseObject) {
            
            [_model setValuesForKeysWithDictionary:responseObject];
            
            [self configUI];
            [self createOrderView];
            
        } failure:^(NSError *error) {
            
        }];
    }else
    {
        [YGNetService YGPOST:REQUEST_SearchApplicationDetail parameters:@{@"id":_itemID}  showLoadingView:NO scrollView:nil success:^(id responseObject) {
            
            [_model setValuesForKeysWithDictionary:responseObject];
            [self configUI];

            if (self.stateType == 1) {
                [self createOrderView];
            }
            if (self.stateType == 2 || [_model.auditStatus isEqualToString:@"3"]) {
                [self createOrderView];
                [self createOrderFinishView];
            }
            if (self.stateType == 3 && [_model.auditStatus isEqualToString:@"4"]) {
                [self createOrderView];
                [self createOrderFinishView];
                [self createOrderResonView];
            }
    
            
        } failure:^(NSError *error) {
            
        }];
    }

}
- (void)configUI
{
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, YGScreenWidth, YGScreenHeight-YGNaviBarHeight-YGStatusBarHeight)];
    _scrollView.contentSize = CGSizeMake(YGScreenWidth, _scrollView.height);
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.backgroundColor = colorWithYGWhite;
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
    _titleLabel.frame = CGRectMake(10, 10,YGScreenWidth-20, 25);
    _titleLabel.numberOfLines = 0;
    [_titleLabel sizeToFit];
    [_baseView addSubview:_titleLabel];
    _titleLabel.frame = CGRectMake(10, 15,YGScreenWidth-35, _titleLabel.height+10);

    
    //新鲜事内容label
    _describeLabel = [[UILabel alloc]init];
    _describeLabel.frame = CGRectMake(_titleLabel.x,_titleLabel.y+_titleLabel.height , 100, 17);
    _describeLabel.textColor = colorWithLightGray;
    _describeLabel.text =[NSString stringWithFormat:@"作者：%@  来源：%@",_model.author,_model.source];;
    _describeLabel.font = [UIFont systemFontOfSize:YGFontSizeSmallOne];
    [_describeLabel sizeToFit];
    [_baseView addSubview:_describeLabel];
    _describeLabel.frame = CGRectMake(_describeLabel.x,_describeLabel.y, _describeLabel.width, 17);
    
    //新鲜事内容label
    _dateLabel = [[UILabel alloc]init];
    _dateLabel.frame = CGRectMake(_describeLabel.x, _describeLabel.y+_describeLabel.height, 130, 17);
    _dateLabel.textColor = colorWithLightGray;
    _dateLabel.text = [NSString stringWithFormat:@"发布时间：%@",_model.releaseTime];
    _dateLabel.font = [UIFont systemFontOfSize:YGFontSizeSmallOne];
    [_dateLabel sizeToFit];
    [_baseView addSubview:_dateLabel];
    _dateLabel.frame = CGRectMake(_dateLabel.x,_dateLabel.y, _dateLabel.width, 17);
    
    
    NSArray *baseArray  = (NSMutableArray *)@[@"申请企业名称", @"企业性质",@"联系人",@"联系电话"];
    NSArray *baseContentArray  = @[_model.enterpriseName, _model.enterpriseNature,_model.contactPerson,_model.contactPhone];
    
    CGFloat countHeight = 0.0;
    for (int i = 0; i<4; i++) {
        UIView *baseView = [[UIView alloc] initWithFrame:CGRectMake(0,_dateLabel.y+_dateLabel.height+10+countHeight, YGScreenWidth, 30)];
        baseView.backgroundColor = colorWithYGWhite;
        [_baseView addSubview:baseView];
        
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10,0 , 100, 30)];
        nameLabel.text = baseArray[i];
        nameLabel.textAlignment = NSTextAlignmentLeft;
        nameLabel.font = [UIFont systemFontOfSize:YGFontSizeBigOne];
        nameLabel.textColor = colorWithDeepGray;
        [nameLabel sizeToFit];
        [baseView addSubview:nameLabel];
        nameLabel.frame = CGRectMake(nameLabel.x,nameLabel.y, 100, 30);

        UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(nameLabel.x+nameLabel.width+10, nameLabel.y, YGScreenWidth-(nameLabel.x+nameLabel.width+10)-20, nameLabel.height)];
        contentLabel.text = baseContentArray[i];
        contentLabel.tag = 100+i;
        contentLabel.textAlignment = NSTextAlignmentLeft;
        contentLabel.font = [UIFont systemFontOfSize:YGFontSizeBigOne];
        contentLabel.textColor = colorWithBlack;
        [contentLabel sizeToFit];
        [baseView addSubview:contentLabel];
        contentLabel.frame = CGRectMake(contentLabel.x,contentLabel.y, YGScreenWidth-nameLabel.width-20, contentLabel.height+10);
        
        countHeight += contentLabel.height;
    }
    _baseView.frame = CGRectMake(0, 0, YGScreenWidth, _dateLabel.y+_dateLabel.height+30*4+15);
    if (self.pageType == 1 || self.stateType == 1) {//提交成功
        UIButton *coverButton = [[UIButton alloc]initWithFrame:CGRectMake(0,YGScreenHeight-YGStatusBarHeight-YGNaviBarHeight-45-YGBottomMargin,YGScreenWidth,45+YGBottomMargin)];
        coverButton.titleEdgeInsets = UIEdgeInsetsMake(-YGBottomMargin, 0, 0, 0);
        [coverButton addTarget:self action:@selector(cancleApplyAction) forControlEvents:UIControlEventTouchUpInside];
        coverButton.backgroundColor = colorWithMainColor;
        coverButton.titleLabel.font = [UIFont systemFontOfSize:YGFontSizeSmallOne];
        [self.view addSubview:coverButton];
        [coverButton setTitleColor:colorWithYGWhite forState:UIControlStateNormal];
        [coverButton setTitle:@"取消申请" forState:UIControlStateNormal];
    }

}

- (void)createOrderView
{
    
    //热门推荐view
    _orderBaseView = [[UIView alloc]initWithFrame:CGRectMake(0,_baseView.height, YGScreenWidth, 80)];
    _orderBaseView.backgroundColor = colorWithYGWhite;
    [_scrollView addSubview:_orderBaseView];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0,0, YGScreenWidth, 10)];
    lineView.backgroundColor = colorWithPlateSpacedColor;
    [_orderBaseView addSubview:lineView];
    
    NSArray *orderArray  = (NSMutableArray *)@[@"订单编号：", @"创建时间："];
        NSArray *orderContentArray  = @[_model.orderNumber, _model.createDate];
    
    for (int i = 0; i<2; i++) {
        UIView *baseView = [[UIView alloc] initWithFrame:CGRectMake(0,lineView.height+10+25*i, YGScreenWidth, 25)];
        baseView.backgroundColor = colorWithYGWhite;
        [_orderBaseView addSubview:baseView];
        
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10,0 , 75, 25)];
        nameLabel.text = orderArray[i];
        nameLabel.textAlignment = NSTextAlignmentLeft;
        nameLabel.font = [UIFont systemFontOfSize:YGFontSizeNormal];
        nameLabel.textColor = colorWithDeepGray;
        [baseView addSubview:nameLabel];
        
        UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(nameLabel.x+nameLabel.width+10, 0, YGScreenWidth-(nameLabel.x+nameLabel.width+10)-20, nameLabel.height)];
        textField.tag = 100+i;
        textField.font = [UIFont systemFontOfSize:YGFontSizeNormal];
        textField.textColor = colorWithBlack;
        [baseView addSubview:textField];
        textField.text = orderContentArray[i];
        [textField setEnabled:NO];
    }
    _orderBaseView.frame = CGRectMake(0, _orderBaseView.y, YGScreenWidth, 25*2+10+10);

    
}

- (void)createOrderFinishView
{
    
    //热门推荐view
    _orderFinishBaseView = [[UIView alloc]initWithFrame:CGRectMake(0,_baseView.height+25*2+20, YGScreenWidth, 40)];
    _orderFinishBaseView.backgroundColor = colorWithYGWhite;
    [_scrollView addSubview:_orderFinishBaseView];
    NSArray *arry;
    NSArray *orderFinishArray;
    NSArray *orderFinishContentArray;
    NSArray *orderFinishColorArray;
    if (self.stateType == 2 && ![_model.auditStatus isEqualToString:@"4"])
    {
       orderFinishArray  = (NSMutableArray *)@[@"审核时间"];
        orderFinishContentArray  = @[_model.processTime];
    }else
    {
        arry = @[@"",@"",@"",@"审核通过",@"审核未通过"];
        orderFinishArray  = (NSMutableArray *)@[@"审核时间", @"审核完成"];
        orderFinishContentArray  = @[_model.processTime, arry[[_model.auditStatus intValue]]];
        orderFinishColorArray = @[colorWithMainColor,colorWithMainColor,colorWithMainColor,colorWithMainColor,colorWithOrangeColor];

    }
    
    for (int i = 0; i<orderFinishArray.count; i++) {
        UIView *baseView = [[UIView alloc] initWithFrame:CGRectMake(0,25*i, YGScreenWidth, 25)];
        baseView.backgroundColor = colorWithYGWhite;
        [_orderFinishBaseView addSubview:baseView];
        
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10,0 , 75, 25)];
        nameLabel.text = orderFinishArray[i];
        nameLabel.textAlignment = NSTextAlignmentLeft;
        nameLabel.font = [UIFont systemFontOfSize:YGFontSizeNormal];
        nameLabel.textColor = colorWithDeepGray;
        [baseView addSubview:nameLabel];
        
        UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(nameLabel.x+nameLabel.width+10, 0, YGScreenWidth-(nameLabel.x+nameLabel.width+10)-20, nameLabel.height)];
        textField.tag = 100+i;
        textField.font = [UIFont systemFontOfSize:YGFontSizeNormal];
        textField.textColor = colorWithBlack;
        [baseView addSubview:textField];
        textField.text = orderFinishContentArray[i];
        [textField setEnabled:NO];
        if ( i == 1) {
            textField.textColor = orderFinishColorArray[[_model.auditStatus intValue]];

        }
    }
    _orderFinishBaseView.frame = CGRectMake(0, _orderFinishBaseView.y, YGScreenWidth, 25*orderFinishArray.count+10);

}
- (void)createOrderResonView
{
    //热门推荐view
    _orderResonBaseView = [[UIView alloc]initWithFrame:CGRectMake(0,_orderFinishBaseView.y+_orderFinishBaseView.height, YGScreenWidth, 40)];
    _orderResonBaseView.backgroundColor = colorWithYGWhite;
    [_scrollView addSubview:_orderResonBaseView];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0,0, YGScreenWidth, 1)];
    lineView.backgroundColor = colorWithPlateSpacedColor;
    [_orderResonBaseView addSubview:lineView];
    
    //新鲜事内容label
    _resonLabel = [[UILabel alloc]init];
    _resonLabel.frame = CGRectMake(10, lineView.y+10, YGScreenWidth-20, 20);
    _resonLabel.textColor = colorWithLightGray;
    _resonLabel.text = [NSString stringWithFormat:@"未通过原因：%@", _model.cause];
    _resonLabel.font = [UIFont systemFontOfSize:YGFontSizeSmallOne];
    _resonLabel.numberOfLines = 0;
    [_resonLabel sizeToFitVerticalWithMaxWidth:YGScreenWidth-20];
    [_orderResonBaseView addSubview:_resonLabel];
    _resonLabel.frame = CGRectMake(_resonLabel.x,_resonLabel.y, YGScreenWidth-20, _resonLabel.height+20);
    
    _orderResonBaseView.frame = CGRectMake(0, _orderFinishBaseView.y+_orderFinishBaseView.height, YGScreenWidth, _resonLabel.height+10);

}

- (void)cancleApplyAction
{
    [YGAlertView showAlertWithTitle:@"您确定要取消这条申请吗？" buttonTitlesArray:@[@"取消",@"确定"] buttonColorsArray:@[colorWithBlack,colorWithMainColor] handler:^(NSInteger buttonIndex) {
        if (buttonIndex == 1)
        {
            [YGNetService YGPOST:REQUEST_DeletApplication parameters:@{@"id":_itemID} showLoadingView:NO scrollView:nil success:^(id responseObject) {
                [YGAppTool showToastWithText:@"取消申请成功！"];
                [self.navigationController popViewControllerAnimated:YES];
            } failure:^(NSError *error) {
                
            }];
        }
    }];
}
@end
