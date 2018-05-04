//
//  PlayTogetherSignupDetailViewController.m
//  QingYouProject
//
//  Created by apple on 2017/12/7.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "PlayTogetherSignupDetailViewController.h"
#import "ServiceEvalutionModel.h"
//#import "OfficePurchaseTableViewCell.h"
#import "PlayTogetherDetailSignUpTableViewCell.h"

#define imageCount 13 //控制评论cell最多有几张图片
#define commentCellCount 3 //该页面展示几条评论cell


@interface PlayTogetherSignupDetailViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView * _tableView;
    NSMutableArray * _dataArray;
    ServiceEvalutionModel * _model;
}
@end

@implementation PlayTogetherSignupDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.naviTitle =@"报名详情";
    self.view.backgroundColor = colorWithTable;
    _dataArray = [[NSMutableArray alloc]init];
    _model = [[ServiceEvalutionModel alloc]init];

      [self.view addSubview:self.tableView];
    
    [self loadDataFromServer];
}

- (void)loadDataFromServer
{
    NSDictionary * parameters =@{
                                 @"activityID":self.activityID,
                                 @"userID":self.userID,
                                 };
    
    [YGNetService YGPOST:@"ActivityMemberInfo" parameters:parameters showLoadingView:NO scrollView:nil success:^(id responseObject) {
        
        _model.userName = [responseObject valueForKey:@"userName"];
        _model.userAutograph = [responseObject valueForKey:@"userAutograph"];
        _model.createDate = [responseObject valueForKey:@"createDate"];
        _model.userImg = [responseObject valueForKey:@"userImg"];

        NSArray * array = [self stringToJSON:[responseObject valueForKey:@"detail"]];

        NSArray * contentArry = @[@{
                                      @"name":@"姓名",
                                      @"content":[responseObject valueForKey:@"name"],
                                      },
                                  @{
                                      @"name":@"手机",
                                      @"content":[responseObject valueForKey:@"phone"],
                                      }];
        [_dataArray addObjectsFromArray:contentArry];
        [_dataArray addObjectsFromArray:array];

      
        [_tableView reloadData];
        
    } failure:^(NSError *error) {
        
    }];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count +1;
}

static NSString * const PlayTogetherDetailSignUpTableViewCellID = @"PlayTogetherDetailSignUpTableViewCellID";

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(indexPath.row ==0)
    {
        PlayTogetherDetailSignUpTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:PlayTogetherDetailSignUpTableViewCellID forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = colorWithYGWhite;
        cell.fd_enforceFrameLayout = YES;
        [cell setModel:_model];
        return cell;
    }
    else
    {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
            CGFloat LabelW = [UILabel calculateWidthWithString:_dataArray[indexPath.row -1][@"name"] textFont:[UIFont systemFontOfSize:15] numerOfLines:1].width;
           CGFloat LabelH = [UILabel calculateWidthWithString:_dataArray[indexPath.row -1][@"name"] textFont:[UIFont systemFontOfSize:15] numerOfLines:1].height;


        UILabel * titleLable = [[UILabel alloc]initWithFrame:CGRectMake(LDHPadding, LDHPadding, LabelW, LabelH)];
        titleLable.font = [UIFont systemFontOfSize:15.0];
        titleLable.textColor = colorWithDeepGray;
        titleLable.text =  [NSString stringWithFormat:@"%@",_dataArray[indexPath.row -1][@"name"]];
        [cell.contentView addSubview:titleLable];

        UILabel * detailLable = [[UILabel alloc]initWithFrame:CGRectMake(titleLable.x + titleLable.width + LDHPadding, LDHPadding, YGScreenWidth - 3*LDHPadding - LabelW, LabelH)];
        detailLable.numberOfLines =0;
        detailLable.font = [UIFont systemFontOfSize:15.0];
        detailLable.text = [NSString stringWithFormat:@"%@",_dataArray[indexPath.row -1][@"content"]] ;
        detailLable.textColor =colorWithBlack;

        [cell.contentView addSubview:detailLable];

        CGSize detailLableSize = [detailLable sizeThatFits:CGSizeMake(YGScreenWidth - 3*LDHPadding - LabelW, 1000)];
        float height = (detailLableSize.height >LabelH)?detailLableSize.height:LabelH;
        detailLable.frame = CGRectMake(titleLable.x + titleLable.width + LDHPadding, LDHPadding, YGScreenWidth - 3*LDHPadding - LabelW,height);

        return cell;
    }

}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row ==0)
    {
        return [tableView fd_heightForCellWithIdentifier:PlayTogetherDetailSignUpTableViewCellID cacheByIndexPath:indexPath configuration:^(PlayTogetherDetailSignUpTableViewCell *cell) {
            cell.fd_enforceFrameLayout = YES;
            [cell setModel:_model];

        }];
    }
    else
    {
        CGFloat LabelW = [UILabel calculateWidthWithString:_dataArray[indexPath.row -1][@"name"] textFont:leftFont numerOfLines:1].width;
        CGFloat LabelH = [UILabel calculateWidthWithString:_dataArray[indexPath.row -1][@"name"] textFont:[UIFont systemFontOfSize:15] numerOfLines:1].height;

        UILabel * detailLable = [[UILabel alloc]init];
        detailLable.font = [UIFont systemFontOfSize:15.0];
        detailLable.text = [NSString stringWithFormat:@"%@",_dataArray[indexPath.row -1][@"content"]] ;
        detailLable.numberOfLines =0;
        CGSize detailLableSize = [detailLable sizeThatFits:CGSizeMake(YGScreenWidth - 3*LDHPadding - LabelW, 1000)];

        float height = (detailLableSize.height >LabelH)?detailLableSize.height:LabelH;

        return height + 2 * LDHPadding;
    }

}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    return;
}

- (UITableView *)tableView{
    if (!_tableView) {
        
        CGFloat Y = kScreenH - YGNaviBarHeight ;
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, Y) style:UITableViewStyleGrouped];
        //        _tableView.estimatedRowHeight = 120;
//        _tableView.rowHeight = 220;
        _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0.001)];
        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0.001)];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        _tableView.estimatedRowHeight =0 ;
        _tableView.estimatedSectionHeaderHeight =0;
        _tableView.estimatedSectionFooterHeight =0;

        [self.tableView registerClass:[PlayTogetherDetailSignUpTableViewCell class] forCellReuseIdentifier:PlayTogetherDetailSignUpTableViewCellID];
        
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        if (@available(iOS 11.0, *)) {
            
            self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentAutomatic;
            
        } else {
            
            self.automaticallyAdjustsScrollViewInsets = YES;
        }
        
    }
    return _tableView;
}
- (NSMutableArray *)dataArray{
    
    if (!_dataArray) {
        
        _dataArray = [NSMutableArray array];
        
    }
    return _dataArray;
}
- (NSArray *)stringToJSON:(NSString *)jsonStr {
    if (jsonStr) {
        id tmp = [NSJSONSerialization JSONObjectWithData:[jsonStr dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments | NSJSONReadingMutableLeaves | NSJSONReadingMutableContainers error:nil];
        
        if (tmp) {
            if ([tmp isKindOfClass:[NSArray class]]) {
                
                return tmp;
                
            } else if([tmp isKindOfClass:[NSString class]]
                      || [tmp isKindOfClass:[NSDictionary class]]) {
                
                return [NSArray arrayWithObject:tmp];
                
            } else {
                return nil;
            }
        } else {
            return nil;
        }
        
    } else {
        return nil;
    }
}
@end








