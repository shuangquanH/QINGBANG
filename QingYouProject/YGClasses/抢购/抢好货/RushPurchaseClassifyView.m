//
//  RushPurchaseClassifyView.m
//  QingYouProject
//
//  Created by nefertari on 2017/12/22.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "RushPurchaseClassifyView.h"
#import "AdvertisesForInfoModel.h"

@implementation RushPurchaseClassifyView
{
    UIScrollView *_scrollView;
    NSMutableArray *_dataSource;
    UIView *_tableBaseView;
    NSIndexPath *_indexPath;
}

- (instancetype)init
{
    if (self = [super init]) {
        self.frame = CGRectMake(0,0, YGScreenWidth, YGScreenHeight-YGNaviBarHeight);
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

    UIView *topBaseView = [[UIView alloc] initWithFrame:CGRectMake(0, 10, YGScreenWidth, 20)];
    [topView addSubview:topBaseView];
    CGSize sizeTop = [self createLabelsWithbaseView:topBaseView withIndex:1];
    topBaseView.frame  = CGRectMake(topBaseView.x, topBaseView.y, sizeTop.width, sizeTop.height+20);
    
    topView.frame = CGRectMake(0, 0, YGScreenWidth, topBaseView.y+topBaseView.height);
    
    _scrollView.frame = CGRectMake(0,0, YGScreenWidth, topBaseView.y+topBaseView.height+10);
    _scrollView.contentSize = CGSizeMake(YGScreenWidth, topBaseView.y+topBaseView.height+10);
    [self show];
    
//    /****************************** 按钮 **************************/
//
//    UIButton *coverButton = [[UIButton alloc]initWithFrame:CGRectMake(0,_scrollView.height-40,YGScreenWidth,40)];
//    coverButton.titleEdgeInsets = UIEdgeInsetsMake(-YGBottomMargin, 0, 0, 0);
//    coverButton.tag = 556;
//    [coverButton addTarget:self action:@selector(resetAndConfirmAction:) forControlEvents:UIControlEventTouchUpInside];
//    coverButton.backgroundColor = colorWithMainColor;
//    coverButton.titleLabel.font = [UIFont systemFontOfSize:YGFontSizeSmallOne];
//    [_scrollView addSubview:coverButton];
//
//
//    coverButton.backgroundColor = colorWithMainColor;
//    [coverButton setTitleColor:colorWithYGWhite forState:UIControlStateNormal];
//    [coverButton setTitle:@"确定" forState:UIControlStateNormal];
    
    
    
    
    
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
         
     }                completion:^(BOOL finished)
     {
         [self removeFromSuperview];
     }];
    
    
}


- (CGSize)createLabelsWithbaseView:(UIView *)baseView withIndex:(int)index
{
    NSArray *dataArr = _dataSource[index-1];
   
    CGFloat seprate = 0.0f;
    CGFloat width = 0.0f;
    int r = 0;
    int k = 0;
    int j = 0;
    if ((75*4+50)<=YGScreenWidth) {
        j = 3;
        seprate = (YGScreenWidth-80*3)/4;
        width = 80;
    }else
    {
        j = 4;
        seprate = (YGScreenWidth-75*4)/5;
        width = 75;
    }
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
        button.frame = CGRectMake(seprate+width*k+k*seprate, 35*r, width, 25) ;

        if (k == j) {
            k=0;
            r ++;
            button.frame = CGRectMake(seprate+width*k+k*seprate, 35*r, width, 25) ;
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
    return CGSizeMake(YGScreenWidth, (r+1)*35);
}

- (void)titleChooseChangeContentAction:(UIButton *)btn
{

    int  indexpathrow= btn.tag%10000;
    int indexpathsection = (int)btn.tag/10000;
    AdvertisesForInfoModel *model = _dataSource[indexpathsection-1][indexpathrow];
    if (model.isSelect == YES) {
        btn.layer.borderColor = colorWithLine.CGColor;
        [btn setTitleColor:colorWithDeepGray forState:UIControlStateNormal];
        model.isSelect = NO;
        [self.delegate rushPurchaseClassifyViewSiftDataWithKeyModelArray:@[model]];
        [self dismiss];
        return ;
    }
    for (int i = 0; i< [(NSArray *)_dataSource[indexpathsection-1] count]; i++) {
        UIButton *button = [_scrollView viewWithTag:indexpathsection*10000+i];
        button.layer.borderColor = colorWithLine.CGColor;
        [button setTitleColor:colorWithDeepGray forState:UIControlStateNormal];
        AdvertisesForInfoModel *model = _dataSource[indexpathsection-1][i];
        model.isSelect = NO;
        
    }
    model.isSelect = YES;
    btn.layer.borderColor = colorWithMainColor.CGColor;
    [btn setTitleColor:colorWithMainColor forState:UIControlStateNormal];
    [self.delegate rushPurchaseClassifyViewSiftDataWithKeyModelArray:@[model]];
    [self dismiss];
}



@end
