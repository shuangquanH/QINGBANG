//
//  SearchAdvertiesePopSiftView.m
//  QingYouProject
//
//  Created by nefertari on 2017/10/25.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "SearchAdvertiesePopSiftView.h"

@implementation SearchAdvertiesePopSiftView

{
    UIScrollView *_scrollView;
    NSMutableArray *_dataSource;
    UIView *_tableBaseView;
    NSIndexPath *_indexPath;
}

- (instancetype)init
{
    if (self = [super init]) {
        self.frame = CGRectMake(0,40, YGScreenWidth, YGScreenHeight-YGNaviBarHeight-40);
        self.backgroundColor = [colorWithBlack colorWithAlphaComponent:0];
        UITapGestureRecognizer *  recognizerTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapBehind:)];
        [recognizerTap setNumberOfTapsRequired:1];
        recognizerTap.cancelsTouchesInView = NO;
        [[UIApplication sharedApplication].keyWindow addGestureRecognizer:recognizerTap];
        
    }
    return self;
}

- (void)handleTapBehind:(UITapGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateEnded){
        CGPoint location = [sender locationInView:nil];
        
        if (![_scrollView pointInside:[_scrollView convertPoint:location fromView:_scrollView.window] withEvent:nil])
        {
            [_scrollView.window removeGestureRecognizer:sender];

                [self dismiss];
                
        }
    }
}

- (void)createPopChooseViewWithDataSorce:(NSArray *)dataSource
{
    _dataSource = [[NSMutableArray alloc] init];
    [_dataSource addObjectsFromArray:[AdvertisesForInfoModel mj_objectArrayWithKeyValuesArray:dataSource]];

    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, YGScreenWidth, 100)];
    _scrollView.contentSize = CGSizeMake(YGScreenWidth, _scrollView.height);
    _scrollView.backgroundColor  = colorWithYGWhite;
    [self addSubview:_scrollView];
    
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, YGScreenWidth, 20)];
    [_scrollView addSubview:topView];

    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, YGScreenWidth, 1)];
    lineView.backgroundColor = colorWithLine;
    [topView addSubview:lineView];
    
    UILabel *sexTitleLabel  = [[UILabel alloc] initWithFrame:CGRectMake(10,10 , YGScreenWidth-20, 20)];
    sexTitleLabel.text = @"性别";
    sexTitleLabel.textAlignment = NSTextAlignmentLeft;
    sexTitleLabel.font = [UIFont systemFontOfSize:YGFontSizeNormal];
    sexTitleLabel.textColor = colorWithBlack;
    [topView addSubview:sexTitleLabel];

    UIView *topBaseView = [[UIView alloc] initWithFrame:CGRectMake(0, 40, YGScreenWidth, 20)];
    [topView addSubview:topBaseView];
    CGSize sizeTop = [self createLabelsWithbaseView:topBaseView withIndex:1];
    topBaseView.frame  = CGRectMake(topBaseView.x, topBaseView.y, sizeTop.width, sizeTop.height);

    topView.frame = CGRectMake(0, 0, YGScreenWidth, topBaseView.y+topBaseView.height);
    
    //学历
    UIView *educationView = [[UIView alloc] initWithFrame:CGRectMake(0, topView.y+topView.height, YGScreenWidth, 20)];
    [_scrollView addSubview:educationView];
    
    UILabel *educationTitleLabel  = [[UILabel alloc] initWithFrame:CGRectMake(10,10 , YGScreenWidth-20, 20)];
    educationTitleLabel.text = @"学历";
    educationTitleLabel.textAlignment = NSTextAlignmentLeft;
    educationTitleLabel.font = [UIFont systemFontOfSize:YGFontSizeNormal];
    educationTitleLabel.textColor = colorWithBlack;
    [educationView addSubview:educationTitleLabel];
    
    UIView *educationBaseView = [[UIView alloc] initWithFrame:CGRectMake(0, 40, YGScreenWidth, 20)];
    [educationView addSubview:educationBaseView];
    CGSize sizeEducation = [self createLabelsWithbaseView:educationBaseView withIndex:2];
    educationBaseView.frame  = CGRectMake(educationBaseView.x, educationBaseView.y, sizeEducation.width, sizeEducation.height);
    educationView.frame = CGRectMake(0, educationView.y, YGScreenWidth, educationBaseView.y+educationBaseView.height);

    //工作年限
    UIView *experienceView = [[UIView alloc] initWithFrame:CGRectMake(0, educationView.y+educationView.height, YGScreenWidth, 20)];
    [_scrollView addSubview:experienceView];
    
    UILabel *experienceTitleLabel  = [[UILabel alloc] initWithFrame:CGRectMake(10,10 , YGScreenWidth-20, 20)];
    experienceTitleLabel.text = @"工作年限";
    experienceTitleLabel.textAlignment = NSTextAlignmentLeft;
    experienceTitleLabel.font = [UIFont systemFontOfSize:YGFontSizeNormal];
    experienceTitleLabel.textColor = colorWithBlack;
    [experienceView addSubview:experienceTitleLabel];
    
    UIView *experienceBaseView = [[UIView alloc] initWithFrame:CGRectMake(0, 40, YGScreenWidth, 20)];
    [experienceView addSubview:experienceBaseView];
    CGSize sizeExperience = [self createLabelsWithbaseView:experienceBaseView withIndex:3];
    experienceBaseView.frame  = CGRectMake(experienceBaseView.x, experienceBaseView.y, sizeExperience.width, sizeExperience.height);
    experienceView.frame = CGRectMake(0, experienceView.y, YGScreenWidth, experienceBaseView.y+experienceBaseView.height);
    
    _scrollView.frame = CGRectMake(0, 0, YGScreenWidth, experienceView.y+experienceView.height+40);
    _scrollView.contentSize = CGSizeMake(YGScreenWidth, experienceView.y+educationView.height+40);
    [self show];
    
    /****************************** 按钮 **************************/
    for (int i = 0; i<2; i++)
    {
        UIButton *coverButton = [[UIButton alloc]initWithFrame:CGRectMake(YGScreenWidth/2*i,_scrollView.height-40,YGScreenWidth/2,40)];
        coverButton.titleEdgeInsets = UIEdgeInsetsMake(-YGBottomMargin, 0, 0, 0);
        coverButton.tag = 555+i;
        [coverButton addTarget:self action:@selector(resetAndConfirmAction:) forControlEvents:UIControlEventTouchUpInside];
        coverButton.backgroundColor = colorWithMainColor;
        coverButton.titleLabel.font = [UIFont systemFontOfSize:YGFontSizeSmallOne];
        [_scrollView addSubview:coverButton];
        
        if (i == 0)
        {
            coverButton.backgroundColor = colorWithYGWhite;
            [coverButton setTitleColor:colorWithBlack forState:UIControlStateNormal];
            [coverButton setTitle:@"重置" forState:UIControlStateNormal];
            [self resetAndConfirmAction:coverButton];
        }else
        {
            coverButton.backgroundColor = colorWithMainColor;
            [coverButton setTitleColor:colorWithYGWhite forState:UIControlStateNormal];
            [coverButton setTitle:@"确定" forState:UIControlStateNormal];
        }
    }
    
    
    
}
- (void)createOrderHouseCheckPopChooseViewWithDataSorce:(NSArray *)dataSource withTitle:(NSString *)title
{
    _dataSource = [[NSMutableArray alloc] init];
    [_dataSource addObjectsFromArray:[AdvertisesForInfoModel mj_objectArrayWithKeyValuesArray:dataSource]];
    
    
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, YGScreenWidth, 100)];
    _scrollView.contentSize = CGSizeMake(YGScreenWidth, _scrollView.height);
    _scrollView.backgroundColor  = colorWithYGWhite;
    [self addSubview:_scrollView];
    
    
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, YGScreenWidth, 50)];
    [_scrollView addSubview:topView];
    
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, YGScreenWidth, 1)];
    lineView.backgroundColor = colorWithLine;
    [topView addSubview:lineView];
    
    UILabel *sexTitleLabel  = [[UILabel alloc] initWithFrame:CGRectMake(10,15 , YGScreenWidth-20, 20)];
    sexTitleLabel.text = title;
    sexTitleLabel.textAlignment = NSTextAlignmentLeft;
    sexTitleLabel.font = [UIFont systemFontOfSize:YGFontSizeNormal];
    sexTitleLabel.textColor = colorWithBlack;
    [topView addSubview:sexTitleLabel];
    
    UIView *topBaseView = [[UIView alloc] initWithFrame:CGRectMake(0, 50, YGScreenWidth, 20)];
    [topView addSubview:topBaseView];
    CGSize sizeTop = [self createLabelsWithbaseView:topBaseView withIndex:1];
    topBaseView.frame  = CGRectMake(topBaseView.x, topBaseView.y, sizeTop.width, sizeTop.height+20);
    
    topView.frame = CGRectMake(0, 0, YGScreenWidth, topBaseView.y+topBaseView.height);
    
    _scrollView.frame = CGRectMake(0,0, YGScreenWidth, topBaseView.y+topBaseView.height+50);
    _scrollView.contentSize = CGSizeMake(YGScreenWidth, topBaseView.y+topBaseView.height+50);
    [self show];
    
    /****************************** 按钮 **************************/

        UIButton *coverButton = [[UIButton alloc]initWithFrame:CGRectMake(0,_scrollView.height-40,YGScreenWidth,40)];
        coverButton.titleEdgeInsets = UIEdgeInsetsMake(-YGBottomMargin, 0, 0, 0);
        coverButton.tag = 556;
        [coverButton addTarget:self action:@selector(resetAndConfirmAction:) forControlEvents:UIControlEventTouchUpInside];
        coverButton.backgroundColor = colorWithMainColor;
        coverButton.titleLabel.font = [UIFont systemFontOfSize:YGFontSizeSmallOne];
        [_scrollView addSubview:coverButton];
        
        
        coverButton.backgroundColor = colorWithMainColor;
        [coverButton setTitleColor:colorWithYGWhite forState:UIControlStateNormal];
        [coverButton setTitle:@"确定" forState:UIControlStateNormal];
    
    
    
    
    
}
- (void)show
{
    //    [YGAppDelegate.window addSubview:self];
    

    [UIView animateWithDuration:0.25 animations:^
     {
         self.backgroundColor = [colorWithBlack colorWithAlphaComponent:0.4];

         CGRect rect = _scrollView.frame;
         rect.origin.y = 0;
         _scrollView.frame = rect;
     }];
}

- (void)dismiss
{
    [UIView animateWithDuration:0.25 animations:^
     {
         CGRect rect = _scrollView.frame;
         rect.size.height = 0;
         _scrollView.frame = rect;
         self.backgroundColor = [colorWithBlack colorWithAlphaComponent:0];
         for (UIView *view in _scrollView.subviews)
         {
             view.hidden = YES;
         }
         [self.delegate dismissChangeColor];
         
     }                completion:^(BOOL finished)
     {
         [self removeFromSuperview];
     }];
    
    
}


- (CGSize)createLabelsWithbaseView:(UIView *)baseView withIndex:(int)index
{
    NSArray *dataArr = _dataSource[index-1];
    int k = 0;
    CGFloat widthCount = 0.0f;
    int j = 0;
    for (int i = 0;i<dataArr.count;i++) {
        AdvertisesForInfoModel *model = dataArr[i];

        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:model.name forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:YGFontSizeSmallOne];
        [button.titleLabel sizeToFit];
        [button setTitleColor:colorWithDeepGray forState:UIControlStateNormal];
        button.backgroundColor = [UIColor clearColor];
        button.tag = index*10000+i;
        [button addTarget:self action:@selector(titleChooseChangeContentAction:) forControlEvents:UIControlEventTouchUpInside];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 25)];
        label.font = [UIFont systemFontOfSize:YGFontSizeSmallOne];
        label.text = model.name;
        [label sizeToFit];
        
        CGFloat labeWidth = label.width+35;
        button.frame = CGRectMake(10+widthCount+k*10, 35*j, labeWidth, 25) ;
        
        widthCount = widthCount +labeWidth;
        
        if (widthCount>(YGScreenWidth-20-k*10)) {
            j=j+1;
            k=0;
            widthCount = 0.0f;
            button.frame = CGRectMake(10+widthCount+k*10, 35*j, labeWidth, 25) ;
            widthCount = widthCount +labeWidth;
        }
        button.layer.borderColor = colorWithLine.CGColor;

        if (model.isSelect == YES) {
            button.layer.borderColor = colorWithMainColor.CGColor;
            [button setTitleColor:colorWithMainColor forState:UIControlStateNormal];
        }
        button.layer.cornerRadius = 12;
        button.layer.borderWidth = 1;
        k++;
        
        [baseView addSubview:button];
        
    }
    return CGSizeMake(YGScreenWidth, (j+1)*35);
}

- (void)titleChooseChangeContentAction:(UIButton *)btn
{
    
    int  indexpathrow= btn.tag%10000;
    int indexpathsection = (int)btn.tag/10000;

    for (int i = 0; i< [(NSArray *)_dataSource[indexpathsection-1] count]; i++) {
        UIButton *button = [_scrollView viewWithTag:indexpathsection*10000+i];
        button.layer.borderColor = colorWithLine.CGColor;
        [button setTitleColor:colorWithDeepGray forState:UIControlStateNormal];
        AdvertisesForInfoModel *model = _dataSource[indexpathsection-1][i];
        model.isSelect = NO;

    }
    AdvertisesForInfoModel *model = _dataSource[indexpathsection-1][indexpathrow];
    model.isSelect = YES;
    btn.layer.borderColor = colorWithMainColor.CGColor;
    [btn setTitleColor:colorWithMainColor forState:UIControlStateNormal];
}

- (void)resetAndConfirmAction:(UIButton *)btn
{
    if (btn.tag == 555) {
        for (int i = 0; i< _dataSource.count; i++) {
            for (int j = 0; j<[(NSArray*)_dataSource[i] count]; j++) {
                UIButton *button = [_scrollView viewWithTag:(i+1)*10000+j];
                button.layer.borderColor = colorWithLine.CGColor;
                [button setTitleColor:colorWithDeepGray forState:UIControlStateNormal];
                AdvertisesForInfoModel *model = _dataSource[i][j];
                model.isSelect = NO;
                if (j==0) {
                    button.layer.borderColor = colorWithMainColor.CGColor;
                    [button setTitleColor:colorWithMainColor forState:UIControlStateNormal];
                    model.isSelect = YES;
                 
                }
                
            }
        }
    }else
    {
        NSMutableArray *valueArray = [[NSMutableArray alloc] init];
        for (int i = 0; i< _dataSource.count; i++) {
            for (int j = 0; j<[(NSArray*)_dataSource[i] count]; j++) {
                AdvertisesForInfoModel *model = _dataSource[i][j];
                if (model.isSelect == YES) {
                    [valueArray addObject:model];
                }
            }
        }
 
        [self.delegate siftDataWithKeyModelArray:valueArray];
        [self dismiss];

    }
   

}
@end
