//
//  NetManagerCell.m
//  QingYouProject
//
//  Created by LDSmallCat on 2017/9/22.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "NetManagerCell.h"
#import "LDApplyVC.h"//立即申请
#import "NetVIPmodel.h"
#import "NetDetailViewController.h"


@interface NetManagerCell ()
@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLable;
@property (weak, nonatomic) IBOutlet UIButton *applyButton;
@property (weak, nonatomic) IBOutlet UIView *lineView;

@end

@implementation NetManagerCell

- (void)awakeFromNib {
    
    [super awakeFromNib];
    
    [self.applyButton setTitleColor:LDMainColor forState:UIControlStateNormal];
    self.applyButton.layer.cornerRadius = 13;
    self.applyButton.layer.borderWidth = 1;
    self.applyButton.layer.borderColor = LDMainColor.CGColor;
    [self.applyButton addTarget:self action:@selector(applyButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    self.lineView.backgroundColor = colorWithLine;
//    self.applyButton.userInteractionEnabled = NO;
}
-(void)setModel:(NetVIPmodel *)model
{
    _model = model;
    self.nameLable.text = model.serviceName;
    [self.headerImageView sd_setImageWithURL:[NSURL URLWithString:model.serviceImg] placeholderImage:YGDefaultImgSquare];
}
#pragma mark - 立即申请按钮点击
- (void)applyButtonClick:(UIButton *)btn{
    

    if([self.isVIP isEqualToString:@"1"])
    {
        [YGNetService YGPOST:@"IndoorCall" parameters:@{@"rank":@"15"} showLoadingView:YES scrollView:nil success:^(id responseObject) {
            
            [YGAlertView showAlertWithTitle:@"您已经是VIP用户\n可以直接联系客服或拨打服务人员电话直接办理业务" buttonTitlesArray:@[@"联系客服"] buttonColorsArray:@[colorWithBlack] handler:^(NSInteger buttonIndex) {
                if (buttonIndex == 0) {
                    
                    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",[NSString stringWithFormat:@"%@",responseObject[@"callNum"]]];
                    UIWebView * callWebview = [[UIWebView alloc] init];
                    [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
                    UIViewController * currentVC = [self getCellViewController];
                    [currentVC.view addSubview:callWebview];
                    
                }
            }];

        } failure:^(NSError *error) {
            [YGAppTool showToastWithText:@"电话号码获取失败"];
        }];

        return;
    }
    
    UIViewController * currentVC = [self getCellViewController];
    NetDetailViewController * VC = [[NetDetailViewController alloc] init];
    VC.serviceID = _model.serviceID;
    [currentVC.navigationController pushViewController:VC animated:YES];
    
//    UIViewController * currentVC = [self getCellViewController];
//
//    LDApplyVC * applyVC = [[LDApplyVC alloc] init];
//
//    [currentVC.navigationController pushViewController:applyVC animated:YES];
    
}
@end
