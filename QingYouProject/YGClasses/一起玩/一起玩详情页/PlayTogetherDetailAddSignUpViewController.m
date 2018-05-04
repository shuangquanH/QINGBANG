 //
//  PlayTogetherDetailAddSignUpViewController.m
//  QingYouProject
//
//  Created by apple on 2017/11/17.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "PlayTogetherDetailAddSignUpViewController.h"
#import "PlayTogetherSignupTableViewCell.h"
#import "PlayTogetherSignUpPayViewController.h"

@interface PlayTogetherDetailAddSignUpViewController ()<UITableViewDelegate,UITableViewDataSource,PlayTogetherSignupTableViewCellDelegate>
{
    UITableView * _tableView;
    NSMutableArray * _dataArray;
    UILabel * _allPriceLabel;
    UIButton * _nextButton;//下一步
    NSString * _name;
    NSString *_phone;
}

@end

@implementation PlayTogetherDetailAddSignUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.naviTitle = @"填写报名信息";
    _dataArray = [[NSMutableArray alloc]init];

            NSMutableDictionary *infoDic = @{}.mutableCopy;
            NSMutableArray * listArray = [[NSMutableArray alloc]init];
            for(int j = 0 ;j<_messageList.count ;j ++)
            {
                //字典set
                NSMutableDictionary * detailDict = [[NSMutableDictionary alloc]init];
                NSString * isCheck = _messageList[j][@"isCheck"];
                if([isCheck isEqualToString:@"0"])
                {
                    detailDict[@"customName"] = [NSString stringWithFormat:@"%@(选填)",_messageList[j][@"customName"]];
                }
                else
                {
                    detailDict[@"customName"] = _messageList[j][@"customName"];
                }
                detailDict[@"placeholder"] = [NSString stringWithFormat:@"请输入%@",_messageList[j][@"customName"]];
                detailDict[@"isCheck"] = _messageList[j][@"isCheck"];
                detailDict[@"value"] = @"";
                [listArray addObject:detailDict];
                
            }
            infoDic[@"list"] = listArray;
            [_dataArray addObject:infoDic];
    
    [self.view addSubview:self.tableView];
    
    CGFloat H = YGNaviBarHeight + YGBottomMargin ;
    
    //悬浮视图
    CGFloat Y = kScreenH - YGNaviBarHeight - YGStatusBarHeight - YGNaviBarHeight - YGBottomMargin;
    
    UIView * footView = [[UIView alloc]initWithFrame:CGRectMake(0, Y, kScreenW, YGNaviBarHeight + YGBottomMargin)];
    footView.backgroundColor =[UIColor whiteColor];
    [self.view addSubview:footView];
    
    _allPriceLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, YGScreenWidth/2 -15, H)];
    _allPriceLabel.font = LDFont(13);
    _allPriceLabel.textAlignment = NSTextAlignmentLeft;
    _allPriceLabel.textColor = colorWithDeepGray;
    _allPriceLabel.attributedText = [[NSString stringWithFormat:@"合计 ¥%@",_price] ld_attributedStringFromNSString:[NSString stringWithFormat:@"合计 ¥%@",_price] startLocation:3 forwardFont:LDFont(13) backFont:LDFont(15) forwardColor:colorWithBlack backColor:[UIColor redColor]];

    [footView addSubview:_allPriceLabel];
    
    _nextButton = [[UIButton alloc]initWithFrame:CGRectMake(YGScreenWidth/2, 0, YGScreenWidth/2, H)];
    _nextButton.backgroundColor = colorWithMainColor;
    [_nextButton setTitle:@"确认支付" forState:UIControlStateNormal];
    [footView addSubview:_nextButton];
    [_nextButton addTarget:self action:@selector(nextButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    

}
-(void)nextButtonClick:(UIButton *)btn
{
    NSMutableArray * arry = [[NSMutableArray alloc]init];
    int section = 0;
    for (NSDictionary *infoDic in _dataArray)
    {
        int row = 0;
        for (NSDictionary *subDic in infoDic[@"list"])
        {
            NSString * isCheck = subDic[@"isCheck"];
            NSString * value = subDic[@"value"];
           
            if((row == 0 && ![YGAppTool isVerifiedWithText:subDic[@"value"] name:subDic[@"customName"] maxLength:10 minLength:2 shouldEmpty:NO]) || (row == 1 && [YGAppTool isNotPhoneNumber:subDic[@"value"]]))
            {
                PlayTogetherSignupTableViewCell *cell = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:section]];
                [cell.detailTextField becomeFirstResponder];
                return;
            }
            else  if([isCheck isEqualToString:@"1"] && !value.length)
            {
                PlayTogetherSignupTableViewCell *cell = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:section]];
                [cell.detailTextField becomeFirstResponder];
                [YGAppTool showToastWithText:[NSString stringWithFormat:@"%@为必填项",subDic[@"customName"]]];
                return;
            }
            switch (row) {
                case 0:
                    _name = value;
                    break;
                case 1:
                    _phone = value;
                    break;
                default:
                    break;
            }
                if(row>2)
                {
                    NSMutableDictionary * dict = [[NSMutableDictionary alloc]init];
                    [dict setObject:value forKey:@"content"];
                    [dict setObject:subDic[@"customName"] forKey:@"name"];
                    [arry addObject:dict];
                }
            row++;
        }
        section++;
    }
    
    NSString * jsonStr =  [self arrayToJsonString:arry];
    
    NSDictionary * dict = @{
                            @"activityID":self.activityID,
                            @"count":[NSString stringWithFormat:@"%ld",(long)self.personNum],
                            @"userID":YGSingletonMarco.user.userId,
                            @"userName":_name,
                            @"userPhone":_phone,
                            @"userDetail":jsonStr,
                            };
    
    [YGNetService YGPOST:@"ActivityCreateOrder" parameters:dict showLoadingView:YES scrollView:nil success:^(id responseObject) {
        
        if(_price.floatValue >0)
        {
            PlayTogetherSignUpPayViewController * singUpPay =[[PlayTogetherSignUpPayViewController alloc]init];
            singUpPay.orderID = responseObject[@"orderID"];
            [self.navigationController pushViewController:singUpPay animated:YES];
        }
        else
        {
            NSDictionary * parameters =@{
                                         @"orderID":responseObject[@"orderID"],
                                         @"channel":@"",
                                         };
            
            [YGNetService YGPOST:@"ActivityPayOrder" parameters:parameters showLoadingView:NO scrollView:nil success:^(id responseObject) {
                
                    [YGAppTool showToastWithText:@"您已报名成功"];
                    NSInteger index = [[self.navigationController viewControllers] indexOfObject:self];
                    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:index - 1]animated:YES];
                
            } failure:^(NSError *error) {
                
            }];
        }
        
    } failure:^(NSError *error) {
        [YGAppTool showToastWithText:@"操作失败"];
    }];
    
}
- (NSString *)arrayToJsonString:(NSArray *)arr{
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:arr options:NSJSONWritingPrettyPrinted error:&parseError];
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return _dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_dataArray[section][@"list"] count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    PlayTogetherSignupTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:PlayTogetherSignupTableViewCellID forIndexPath:indexPath];
    cell.infoDic = _dataArray[indexPath.section][@"list"][indexPath.row];
    cell.delegate = self;
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    return;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 5;
}

- (void)PlayTogetherSignupTableViewCell:(PlayTogetherSignupTableViewCell *)cell textFieldDidEndEditingWithString:(NSString *)string
{
    NSIndexPath * indexPath = [_tableView indexPathForCell:cell];
    _dataArray[indexPath.section][@"list"][indexPath.row][@"value"] = string;
    
}
static NSString * const PlayTogetherSignupTableViewCellID = @"PlayTogetherSignupTableViewCellID";

- (UITableView *)tableView{
    if (!_tableView) {
        
        CGFloat Y = kScreenH - YGNaviBarHeight - YGStatusBarHeight - YGNaviBarHeight - YGBottomMargin;
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, Y) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        //        _tableView.estimatedRowHeight = 120;
        _tableView.rowHeight = 220;
        _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0.001)];
        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0.001)];        
        _tableView.estimatedRowHeight =0 ;
        _tableView.estimatedSectionHeaderHeight =0;
        _tableView.estimatedSectionFooterHeight =0;
        
        [_tableView registerClass:[PlayTogetherSignupTableViewCell class] forCellReuseIdentifier:PlayTogetherSignupTableViewCellID];
        
    }
    return _tableView;
}
- (NSMutableArray *)dataArray{
    
    if (!_dataArray) {
        
        _dataArray = [NSMutableArray array];
        
    }
    return _dataArray;
}

@end







