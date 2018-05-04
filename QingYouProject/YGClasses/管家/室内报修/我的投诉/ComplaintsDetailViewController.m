//
//  ComplaintsDetailViewController.m
//  QingYouProject
//
//  Created by LDSmallCat on 2017/10/25.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "ComplaintsDetailViewController.h"
#import "ComplaintsDetailModel.h"

@interface ComplaintsDetailViewController ()
/** 背景ScrollowView  */
@property (nonatomic,strong) UIScrollView * backScrollowView;
/** 内容ScrollowView  */
@property (nonatomic,strong) UIView * containerView;
/** 投诉内容  */
@property (nonatomic,strong) UILabel * complaintsLabel;
/** 投诉时间  */
@property (nonatomic,strong) UILabel * complaintsTimeLabel;
/** 回复内容  */
@property (nonatomic,strong) UILabel * replyLabel;
/** 回复时间  */
@property (nonatomic,strong) UILabel * replyTimeLabel;
/** 删除  */
@property (nonatomic,strong) UIButton * deleteButton;

@property (nonatomic,strong) ComplaintsDetailModel * model;


@end

@implementation ComplaintsDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.naviTitle = @"投诉详情";
    
    //设置UI
    [self setupUI];
    
    //刷新数据
    [self sendRequest];
    
    
}
#pragma mark - 网络
- (void)sendRequest{
    
    NSMutableDictionary * dict = [NSMutableDictionary dictionary];
    dict[@"id"] = self.complainId;

    [YGNetService YGPOST:@"SearchToReplyDetail" parameters:dict showLoadingView:NO scrollView:nil success:^(id responseObject) {
        
        LDLog(@"%@",responseObject);
        //字典转模型
        self.model = [ComplaintsDetailModel mj_objectWithKeyValues:responseObject[@"complain"]];
        
        self.complaintsLabel.text = self.model.message;
        self.complaintsTimeLabel.text = [NSString stringWithFormat:@"投诉时间:%@",self.model.createDate];
        
        if([self.model.replyType isEqualToString:@"1"])
        {
            self.replyLabel.hidden =YES;
            self.replyTimeLabel.hidden =YES;

            [self.deleteButton mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.complaintsTimeLabel.mas_bottom).offset(LDVPadding);
            }];
            
            [super updateViewConstraints]; 

            [self.deleteButton setTitle:@"撤销投诉" forState:UIControlStateNormal];
        }else
        {
            
            self.replyLabel.text = self.model.replyContent;
            self.replyTimeLabel.text = [NSString stringWithFormat:@"回复时间:%@",self.model.updateDate];
        }
        
    } failure:^(NSError *error) {
        
        LDLog(@"%@",error);
    }];
}


#pragma mark - 刷新数据
- (void)reloadData{
    
    
   
}
#pragma mark - UI设置
- (void)setupUI{
    [self.view addSubview:self.backScrollowView];

    //投诉内容
    self.complaintsLabel = [UILabel ld_labelWithTextColor:LD16TextColor textAlignment:NSTextAlignmentLeft font:LDFont(15) numberOfLines:0];
    [self.containerView addSubview:self.complaintsLabel];
    //回复内容
    self.replyLabel = [UILabel ld_labelWithTextColor:LD16TextColor textAlignment:NSTextAlignmentLeft font:LDFont(15) numberOfLines:0];
    [self.containerView addSubview:self.replyLabel];
    //投诉时间
    self.complaintsTimeLabel = [UILabel ld_labelWithTextColor:LD9ATextColor textAlignment:NSTextAlignmentLeft font:LDFont(12) numberOfLines:1];
    [self.containerView addSubview:self.complaintsTimeLabel];
    //回复时间
    self.replyTimeLabel = [UILabel ld_labelWithTextColor:LD9ATextColor textAlignment:NSTextAlignmentLeft font:LDFont(12) numberOfLines:1];
    [self.containerView addSubview:self.replyTimeLabel];
    
    //删除按钮
    self.deleteButton = [UIButton buttonWithType:UIButtonTypeCustom normalImage:nil selectedImage:nil normalTitle:@"删除投诉" selectedTitle:@"删除投诉" normalTitleColor:LD16TextColor selectedTitleColor:LD16TextColor backGroundColor:kWhiteColor normalBackGroundImageStr:nil selectedBackGroundImageStr:nil titleFont:14];
    self.deleteButton.layer.cornerRadius = 15;
    self.deleteButton.layer.masksToBounds = YES;
    self.deleteButton.layer.borderColor = colorWithLine.CGColor;
    self.deleteButton.layer.borderWidth = 1;
    [self.containerView addSubview:self.deleteButton];
    self.containerView.userInteractionEnabled = YES;
    [self.deleteButton addTarget:self action:@selector(deleteButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.complaintsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.offset(LDVPadding);
        make.right.offset(-LDHPadding);
        
    }];
    
    [self.complaintsTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(LDVPadding);
        make.right.offset(-LDHPadding);
        make.top.equalTo(self.complaintsLabel.mas_bottom).offset(LDVPadding);
    }];
    
    [self.replyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(LDVPadding);
        make.right.offset(-LDHPadding);
        make.top.equalTo(self.complaintsTimeLabel.mas_bottom).offset(LDVPadding);
    }];
    
    [self.replyTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(LDVPadding);
        make.right.offset(-LDHPadding);
        make.top.equalTo(self.replyLabel.mas_bottom).offset(LDVPadding);
    }];
    
    [self.deleteButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-LDHPadding);
        make.top.equalTo(self.replyTimeLabel.mas_bottom).offset(LDVPadding);
        make.width.offset(80);
        make.height.offset(30);
    }];
    
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.deleteButton.mas_bottom).offset(2 * LDVPadding);
    }];
 
    MASAttachKeys(self.complaintsLabel,self.replyLabel,self.complaintsTimeLabel,self.replyTimeLabel,self.deleteButton,self.containerView,self.backScrollowView,self.view)
}
- (UIScrollView *)backScrollowView{
    
    if (!_backScrollowView) {
        
        _backScrollowView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, self.view.height)];
        
        self.containerView = [[UIView alloc] init];
        self.containerView.backgroundColor = [UIColor whiteColor];
        [_backScrollowView addSubview:self.containerView];
        
        [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        
            make.top.left.right.offset(0);
            make.width.offset(kScreenW);
        }];
        
    }
    return _backScrollowView;
}
-(void)deleteButtonClick:(UIButton *)btn
{
   
    NSString * titleStr =@"确定要撤销投诉吗？";
    if(![self.isPush isEqualToString:@"waiteReply"])
        titleStr = @"确定要删除投诉吗？";
    
    [YGAlertView showAlertWithTitle:titleStr buttonTitlesArray:@[@"取消",@"确定"] buttonColorsArray:@[colorWithBlack,colorWithMainColor] handler:^(NSInteger buttonIndex) {
        if (buttonIndex == 0) {
            return ;
        }else
        {
            NSMutableDictionary * dict = [NSMutableDictionary dictionary];
            dict[@"id"] = self.complainId;
 
            [YGNetService YGPOST:@"DeletComplain" parameters:dict showLoadingView:NO scrollView:nil success:^(id responseObject) {
                
                if([self.isPush isEqualToString:@"waiteReply"])
                    [YGAppTool showToastWithText:@"撤销成功"];
                else
                    [YGAppTool showToastWithText:@"删除成功"];
                
                [self.delegate ComplaintsDetailViewControllerDelegateDeletewithrow: self.row];
                
                [self.navigationController popViewControllerAnimated:YES];
            } failure:^(NSError *error) {
                if([self.isPush isEqualToString:@"waiteReply"])
                    [YGAppTool showToastWithText:@"撤销失败"];
                else
                    [YGAppTool showToastWithText:@"删除失败"];

                LDLog(@"%@",error);
            }];
            
        }
    }];
}
@end
