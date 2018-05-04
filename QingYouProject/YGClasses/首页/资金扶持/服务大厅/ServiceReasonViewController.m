//
//  ServiceReasonViewController.m
//  QingYouProject
//
//  Created by 王丹 on 2017/10/18.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "ServiceReasonViewController.h"
#import "ServiceResonModel.h"

@interface ServiceReasonViewController ()

@end

@implementation ServiceReasonViewController
{
    NSMutableArray *_listArray;
    NSArray *_array;
    UIView *_headerView;
    UIScrollView *_scrollView;
    int   _index;
    UILabel *_leaderLabel;
    UILabel *_contentLabel;

}

- (void)configAttribute
{
    self.naviTitle = @"为什么选择我们";
    _listArray = [[NSMutableArray alloc]init];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = colorWithYGWhite;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadData];
    // Do any additional setup after loading the view.
}

- (void)loadData
{
    [YGNetService YGPOST:REQUEST_ServiceHall parameters:@{@"serviceType":@"1"} showLoadingView:NO scrollView:nil success:^(id responseObject) {
        
        [_listArray addObjectsFromArray:[ServiceResonModel mj_objectArrayWithKeyValuesArray:responseObject[@"list1"]]];
        if (_listArray.count >0) {
            [self configUI];

        }

    } failure:^(NSError *error) {
        
    }];
    
}

- (void)configUI
{
    _index = 0;
    

    _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 20, YGScreenWidth, 100)];
    [self.view addSubview:_headerView];
    
    int k = 0;
    CGFloat widthCount = 0.0f;
    int j = 0;
    for (int i = 0;i<_listArray.count;i++) {
        ServiceResonModel *model = _listArray[i];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:model.title forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:YGFontSizeNormal];
        [button.titleLabel sizeToFit];
        [button setTitleColor:colorWithDeepGray forState:UIControlStateNormal];
        button.backgroundColor = [UIColor clearColor];
        button.tag = 100+i;
        [button addTarget:self action:@selector(titleChooseChangeContentAction:) forControlEvents:UIControlEventTouchUpInside];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 30)];
        label.font = [UIFont systemFontOfSize:YGFontSizeSmallOne];
        label.text = model.title;
        [label sizeToFit];
        
        CGFloat labeWidth = label.width+30;
        button.frame = CGRectMake(10+widthCount+k*10, 10+40*j, labeWidth, 30) ;
        
        widthCount = widthCount +labeWidth;
        
        if (widthCount>(YGScreenWidth-20-k*10)) {
            j=j+1;
            k=0;
            widthCount = 0.0f;
            button.frame = CGRectMake(10+widthCount+k*10, 10+40*j, labeWidth, 30);
            widthCount = widthCount +labeWidth;
        }
        
        button.layer.cornerRadius = 15;
        button.layer.borderColor = colorWithLine.CGColor;
        button.layer.borderWidth = 1;
        k++;
        
        [_headerView addSubview:button];
        
    }
    _headerView.frame = CGRectMake(0, 0, YGScreenHeight, (j+1)*40);
    
    UIView *sectionHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, _headerView.height+10, YGScreenWidth, 40)];
    //左线
    UIImageView *leftLineImageView = [[UIImageView alloc]init];
    leftLineImageView.frame = CGRectMake(10, 10, 2, 20);
    leftLineImageView.backgroundColor = colorWithMainColor;
    [sectionHeaderView addSubview:leftLineImageView];
    
    _leaderLabel = [[UILabel alloc] init];
    _leaderLabel.textColor = colorWithBlack;
    _leaderLabel.font = [UIFont systemFontOfSize:YGFontSizeBigOne];
    _leaderLabel.text = @"商业计划书服务流程";
    _leaderLabel.frame = CGRectMake(15, leftLineImageView.y, YGScreenWidth-20, 20);
    [sectionHeaderView addSubview:_leaderLabel];
    [self.view addSubview:sectionHeaderView];
    
    
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, sectionHeaderView.y+sectionHeaderView.height+10, YGScreenWidth, YGScreenHeight-YGNaviBarHeight-sectionHeaderView.y+sectionHeaderView.height)];
    _scrollView.backgroundColor = colorWithYGWhite;
    [self.view addSubview:_scrollView];
    
    _contentLabel = [[UILabel alloc] init];
    _contentLabel.textColor = colorWithDeepGray;
    _contentLabel.font = [UIFont systemFontOfSize:YGFontSizeBigOne];
    _contentLabel.text = @"商业计划书服务流程";
    _contentLabel.frame = CGRectMake(15, 0, YGScreenWidth-20, 20);
    [_scrollView addSubview:_contentLabel];

    UIButton *button  = [_headerView viewWithTag:100+0];
    [self titleChooseChangeContentAction:button];
}


- (CGFloat)getLabelHeightWithText:(NSString *)content withLabel:(UILabel *)label
{
    // 调整行间距
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:content];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:5];
    paragraphStyle.paragraphSpacingBefore = 0.0;//段首行空白空间
    paragraphStyle.paragraphSpacing = 0.0; //段与段之间间距
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [content length])];
    //attributedText设置后之前设置的都失效
    
    label.attributedText = attributedString;
    
    [label sizeToFitVerticalWithMaxWidth:YGScreenWidth -20];

    NSDictionary *attribute =@{NSFontAttributeName:label.font,NSParagraphStyleAttributeName:paragraphStyle,NSForegroundColorAttributeName:colorWithDeepGray};
    
    CGSize size = [content boundingRectWithSize:CGSizeMake(YGScreenWidth -20, MAXFLOAT) options:NSStringDrawingTruncatesLastVisibleLine |NSStringDrawingUsesLineFragmentOrigin |NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
    
    return size.height;
}

- (void)titleChooseChangeContentAction:(UIButton *)btn
{
    for (int i = 0; i<_listArray.count; i++) {
        UIButton *button  = [_headerView viewWithTag:100+i];
        button.layer.borderColor = colorWithLine.CGColor;
        [button setTitleColor:colorWithBlack forState:UIControlStateNormal];
    }
    btn.layer.borderColor = colorWithMainColor.CGColor;
    [btn setTitleColor:colorWithMainColor forState:UIControlStateNormal];
    ServiceResonModel *model = _listArray[btn.tag-100];
    _leaderLabel.text =model.titles;
   CGFloat height = [self getLabelHeightWithText:model.introduce withLabel:_contentLabel];
    _scrollView.contentSize = CGSizeMake(YGScreenWidth, height+20);
}
@end
