//
//  AllianceMainSignRankViewController.m
//  QingYouProject
//
//  Created by 王丹 on 2017/11/29.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "AllianceMainSignRankViewController.h"
#import "AllianceMemberModel.h"

@interface AllianceMainSignRankViewController ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>
{
    NSMutableArray                 *_dataArray; //数据源
    UITableView             *_tabelView;
    UIImageView *_noDataImageView;
    UIView *_headerView;
}


@end

@implementation AllianceMainSignRankViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self loadData];
}

-(void)configAttribute
{
    self.view.backgroundColor = colorWithTable;
    self.naviTitle = @"签到排行榜";
    _dataArray = [[NSMutableArray alloc] init];
    
}
- (void)loadData
{
    
    [YGNetService YGPOST:REQUEST_AllianceRankingList parameters:@{@"allianceID":_allianceID}  showLoadingView:NO scrollView:_tabelView success:^(id responseObject) {
        [_dataArray addObjectsFromArray:[AllianceMemberModel mj_objectArrayWithKeyValuesArray:responseObject[@"userList"]]];
        [_noDataImageView removeFromSuperview];

        if (_dataArray.count == 0) {
            [self configUI];
            _noDataImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"nodata"]];
            [_noDataImageView sizeToFit];
            _noDataImageView.centerx = YGScreenWidth / 2;
            _noDataImageView.y = 150;
            [_tabelView addSubview:_noDataImageView];
            
        }else
        {
            [self createHeaderView];
            [self configUI];
            _tabelView.tableHeaderView = _headerView;

        }
    } failure:^(NSError *error) {
        
    }];
    
}

#pragma mark --------- tabeleView 相关
- (void)createHeaderView
{
    _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, YGScreenWidth, 240)];
    
    UIView *whiteView = [[UIView alloc] initWithFrame:CGRectMake(15, 20, YGScreenWidth-30, 215)];
    whiteView.backgroundColor = colorWithYGWhite;
    whiteView.layer.cornerRadius = 5;
    whiteView.clipsToBounds = YES;
    [_headerView addSubview:whiteView];
    
    //    UIView *whiteLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, YGScreenWidth-27, 1)];
    ////    UIBezierPath *whiteLineViewshadowPath = [UIBezierPath bezierPathWithRect:whiteLineView.bounds];
    //    [whiteView addSubview:whiteLineView];
    //    whiteLineView.layer.shadowColor = [UIColor blackColor].CGColor;
    //    whiteLineView.layer.shadowOffset = CGSizeMake(2.0f, 2.0f);
    //    whiteLineView.layer.shadowOpacity = 0.4f;
    //    whiteLineView.layer.shadowRadius = 5;
    //    whiteLineView.layer.shadowPath = whiteLineViewshadowPath.CGPath;
    
    
    //    阴影
    UIBezierPath *shadowPath = [UIBezierPath bezierPathWithRect:whiteView.bounds];
    whiteView.layer.masksToBounds = NO;
    whiteView.layer.shadowColor = [UIColor blackColor].CGColor;
    whiteView.layer.shadowOffset = CGSizeMake(1.0f, 3.0f);
    whiteView.layer.shadowOpacity = 0.4f;
    whiteView.layer.shadowRadius = 5;
    whiteView.layer.shadowPath = shadowPath.CGPath;
    
    
    UIView *headerLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 50, 150, 2)];
    headerLineView.backgroundColor = colorWithLine;
    [_headerView addSubview:headerLineView];
    headerLineView.centerx = _headerView.centerx;
    
    //新鲜事标题label
    UILabel *titleLabel = [[UILabel alloc]init];
    titleLabel.backgroundColor = colorWithYGWhite;
    titleLabel.textColor = colorWithDeepGray;
    titleLabel.font = [UIFont systemFontOfSize:YGFontSizeBigOne];
    titleLabel.text = @"签到前3名";
    titleLabel.frame = CGRectMake(headerLineView.x+(headerLineView.width-100)/2, 20,100, 20);
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [_headerView addSubview:titleLabel];
    titleLabel.centery = headerLineView.centery;
    
    UIView *whiteLineView = [[UIView alloc] initWithFrame:CGRectMake(0, _headerView.height-10, YGScreenWidth, 20)];
    whiteLineView.backgroundColor = colorWithYGWhite;
    [_headerView addSubview:whiteLineView];
    
    
    for (int i = 0; i<_dataArray.count; i++) {
        if (i == 3) {
            break;
        }
    
        //左线
        UIImageView *litteHeadImageView = [[UIImageView alloc]initWithImage:YGDefaultImgAvatar];
        litteHeadImageView.frame = CGRectMake((YGScreenWidth-70*2-90)/4*(i+1)+(70*i), titleLabel.y+titleLabel.height+30, 70, 70);
        litteHeadImageView.layer.borderColor = colorWithLine.CGColor;
        litteHeadImageView.layer.borderWidth = 0.5;
        litteHeadImageView.backgroundColor = colorWithMainColor;
        litteHeadImageView.layer.cornerRadius = 35;
        litteHeadImageView.contentMode = UIViewContentModeScaleAspectFill;
        [_headerView addSubview:litteHeadImageView];
        
        if (_dataArray.count == 1)
        {
            litteHeadImageView.frame = CGRectMake((YGScreenWidth-70*2-90)/4*(1+1)+70, titleLabel.y+titleLabel.height+20, 90, 90);
            litteHeadImageView.layer.cornerRadius = 45;
            
            
        }else
        {
            if (i == 1) {
                litteHeadImageView.frame = CGRectMake((YGScreenWidth-70*2-90)/4*(i+1)+70, titleLabel.y+titleLabel.height+20, 90, 90);
                litteHeadImageView.layer.cornerRadius = 45;
                
            }
            if (i == 2) {
                litteHeadImageView.frame = CGRectMake((YGScreenWidth-70*2-90)/4*(i+1)+90+70, titleLabel.y+titleLabel.height+30, 70, 70);
                
            }
        }
        litteHeadImageView.clipsToBounds = YES;
        
        
        UILabel *nameLabel = [[UILabel alloc]init];
        nameLabel.textColor = colorWithBlack;
        nameLabel.font = [UIFont systemFontOfSize:YGFontSizeBigOne];
        nameLabel.textAlignment = NSTextAlignmentCenter;
        nameLabel.frame = CGRectMake(litteHeadImageView.x-10, litteHeadImageView.y+litteHeadImageView.height+15,litteHeadImageView.width+20, 20);
        [_headerView addSubview:nameLabel];
        
        
        UILabel *signCountLabel = [[UILabel alloc]init];
        signCountLabel.textColor = colorWithDeepGray;
        signCountLabel.font = [UIFont systemFontOfSize:YGFontSizeSmallOne];
        signCountLabel.textAlignment = NSTextAlignmentCenter;
        signCountLabel.frame = CGRectMake(nameLabel.x, nameLabel.y+nameLabel.height,nameLabel.width, 20);
        signCountLabel.textAlignment = NSTextAlignmentCenter;
        [_headerView addSubview:signCountLabel];
        
        
        //左线
        UIImage *image = [UIImage imageNamed:@"home_playtogeher_signin_first"];
        UIImageView *rankImageView = [[UIImageView alloc]initWithImage:YGDefaultImgAvatar];
        rankImageView.frame = CGRectMake(litteHeadImageView.x+litteHeadImageView.width-image.size.width+10, litteHeadImageView.y+litteHeadImageView.height-image.size.height+10, image.size.width, image.size.height);
        rankImageView.contentMode = UIViewContentModeScaleAspectFill;
        [_headerView addSubview:rankImageView];
        
        if (i == 1) {
            AllianceMemberModel *model = _dataArray[0];

            [litteHeadImageView sd_setImageWithURL:[NSURL URLWithString:model.userImg] placeholderImage:YGDefaultImgAvatar];
            nameLabel.text = model.userName;
            signCountLabel.text = [NSString stringWithFormat:@"签到%@次",model.signCount];
            rankImageView.image = [UIImage imageNamed:@"home_playtogeher_signin_first"];
            rankImageView.frame = CGRectMake(litteHeadImageView.x+litteHeadImageView.width-image.size.width+5, litteHeadImageView.y+litteHeadImageView.height-image.size.height+5, image.size.width, image.size.height);

        }
        if (i == 0) {
            if (_dataArray.count == 1)
            {
                AllianceMemberModel *model = _dataArray[0];
                
                [litteHeadImageView sd_setImageWithURL:[NSURL URLWithString:model.userImg] placeholderImage:YGDefaultImgAvatar];
                nameLabel.text = model.userName;
                signCountLabel.text = [NSString stringWithFormat:@"签到%@次",model.signCount];
                rankImageView.image = [UIImage imageNamed:@"home_playtogeher_signin_first"];
            }else
            {
                AllianceMemberModel *model = _dataArray[1];
                
                [litteHeadImageView sd_setImageWithURL:[NSURL URLWithString:model.userImg] placeholderImage:YGDefaultImgAvatar];
                nameLabel.text = model.userName;
                signCountLabel.text = [NSString stringWithFormat:@"签到%@次",model.signCount];
                rankImageView.image = [UIImage imageNamed:@"home_playtogeher_signin_second"];
            }
        }
        if (i == 2) {
            AllianceMemberModel *model = _dataArray[2];

            [litteHeadImageView sd_setImageWithURL:[NSURL URLWithString:model.userImg] placeholderImage:YGDefaultImgAvatar];
            nameLabel.text = model.userName;
            signCountLabel.text = [NSString stringWithFormat:@"签到%@次",model.signCount];
            rankImageView.image = [UIImage imageNamed:@"home_playtogeher_signin_third"];

        }
    }

}
-(void)configUI
{
   
    
    _tabelView = [[UITableView alloc] initWithFrame:CGRectMake(0,0, YGScreenWidth, YGScreenHeight-YGNaviBarHeight-YGStatusBarHeight) style:UITableViewStyleGrouped];
    _tabelView.delegate = self;
    _tabelView.dataSource = self;
    [self.view addSubview:_tabelView];
    _tabelView.backgroundColor = [UIColor clearColor];
    _tabelView.sectionHeaderHeight = 0.001;
    _tabelView.tableFooterView =  [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0.001)];

}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count-3;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        
        UIImageView *headImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"home_tool1.png"]];
        headImageView.frame = CGRectMake(10, 10, 50, 50);
        headImageView.layer.borderColor = colorWithLine.CGColor;
        headImageView.layer.borderWidth = 0.5;
        headImageView.layer.cornerRadius = 25;
        headImageView.tag = indexPath.row+1050;
        headImageView.contentMode = UIViewContentModeScaleAspectFill;
        headImageView.clipsToBounds = YES;
        [cell.contentView addSubview:headImageView];
        
        //新鲜事标题label
        UILabel *nameLabel = [[UILabel alloc]init];
        nameLabel.textColor = colorWithBlack;
        nameLabel.font = [UIFont systemFontOfSize:YGFontSizeBigOne];
        nameLabel.tag = indexPath.row+2050;
        nameLabel.text = @"签到20次";
        nameLabel.frame = CGRectMake(headImageView.x+headImageView.width+20, 25,YGScreenWidth/2, 20);
        [cell.contentView addSubview:nameLabel];

        
        UILabel *cellLabel = [[UILabel alloc]init];
        cellLabel.textColor = colorWithDeepGray;
        cellLabel.font = [UIFont systemFontOfSize:YGFontSizeNormal];
        cellLabel.tag = indexPath.row+3050;
        cellLabel.text = @"签到20次";
        cellLabel.frame = CGRectMake(YGScreenWidth/2+20, 25,YGScreenWidth/2-30, 20);
        cellLabel.textAlignment = NSTextAlignmentRight;
        [cell.contentView addSubview:cellLabel];
    }
    UIImageView *headImageView = [cell.contentView viewWithTag:indexPath.row+1050];
    UILabel *nameLabel = [cell.contentView viewWithTag:indexPath.row+2050];
    UILabel *cellLabel = [cell.contentView viewWithTag:indexPath.row+3050];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    AllianceMemberModel *model = _dataArray[indexPath.row+3];
    [headImageView sd_setImageWithURL:[NSURL URLWithString:model.userImg] placeholderImage:YGDefaultImgAvatar];
    nameLabel.text = model.userName;
    cellLabel.text = [NSString stringWithFormat:@"签到%@次",model.signCount];

    return cell;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 70;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //发现详情
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}@end
