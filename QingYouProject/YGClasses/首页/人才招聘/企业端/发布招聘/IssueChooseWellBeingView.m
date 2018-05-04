//
//  IssueChooseWellBeingView.m
//  QingYouProject
//
//  Created by nefertari on 2017/10/24.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "IssueChooseWellBeingView.h"

@implementation IssueChooseWellBeingView
{
    UIScrollView *_scrollView;
    NSMutableArray *_dataSource;
    UIView *_tableBaseView;
    NSIndexPath *_indexPath;
    UIView *selfView;
}

- (instancetype)init
{
    if (self = [super init]) {
        self.frame = CGRectMake(0,0, YGScreenWidth, YGScreenHeight);
        self.backgroundColor = [colorWithBlack colorWithAlphaComponent:0.5];
        
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
        
        if (![selfView pointInside:[selfView convertPoint:location fromView:selfView.window] withEvent:nil])
        {
            [selfView.window removeGestureRecognizer:sender];
            
            [self dismiss];
            
        }
    }
}

- (void)createPopChooseViewWithDataSorce:(NSArray *)dataSource
{
    _dataSource = [[NSMutableArray alloc] init];
    [_dataSource addObjectsFromArray:[AdvertisesForInfoModel mj_objectArrayWithKeyValuesArray:dataSource]];
    
   selfView = [[UIView alloc] initWithFrame:CGRectMake(0, YGScreenHeight/2-YGBottomMargin, YGScreenWidth, YGScreenHeight/2+YGBottomMargin)];
    selfView.backgroundColor = colorWithTable;
    [self addSubview:selfView];
    
    UIView *titleBaseView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, YGScreenWidth, 40)];
    titleBaseView.backgroundColor = colorWithYGWhite;
    [selfView addSubview:titleBaseView];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 20, YGScreenWidth-100, 10)];
    titleLabel.textColor = colorWithBlack;
    titleLabel.font = [UIFont systemFontOfSize:YGFontSizeNormal];
    titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    titleLabel.text = @"福利待遇";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [titleBaseView addSubview:titleLabel];
    
    UIButton * cancelButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [cancelButton setTitleColor:colorWithLightGray forState:UIControlStateNormal];
    cancelButton.frame = CGRectMake(YGScreenWidth-50,0,40, 40);
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    [titleBaseView addSubview:cancelButton];
    
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, titleBaseView.y+titleBaseView.height+1, YGScreenWidth, selfView.height-80)];
    _scrollView.contentSize = CGSizeMake(YGScreenWidth, _scrollView.height);
    _scrollView.backgroundColor  = colorWithTable;
    [selfView addSubview:_scrollView];
    
    UIView *topBaseView = [[UIView alloc] initWithFrame:CGRectMake(0,0, YGScreenWidth, 20)];
    topBaseView.backgroundColor = colorWithYGWhite;
    [_scrollView addSubview:topBaseView];
    
    CGSize sizeTop = [self createLabelsWithbaseView:topBaseView];
    topBaseView.frame  = CGRectMake(topBaseView.x, topBaseView.y, sizeTop.width, sizeTop.height);
    
    _scrollView.contentSize = CGSizeMake(YGScreenWidth, topBaseView.y+topBaseView.height+40);
    
    /****************************** 按钮 **************************/
    for (int i = 0; i<2; i++)
    {
        UIButton *coverButton = [[UIButton alloc]initWithFrame:CGRectMake(YGScreenWidth/2*i,selfView.height-YGBottomMargin-40,YGScreenWidth/2,40+YGBottomMargin)];
        coverButton.titleEdgeInsets = UIEdgeInsetsMake(-YGBottomMargin, 0, 0, 0);
        coverButton.tag = 555+i;
        [coverButton addTarget:self action:@selector(resetAndConfirmAction:) forControlEvents:UIControlEventTouchUpInside];
        coverButton.backgroundColor = colorWithMainColor;
        coverButton.titleLabel.font = [UIFont systemFontOfSize:YGFontSizeSmallOne];
        [selfView addSubview:coverButton];
        
        if (i == 0)
        {
            coverButton.backgroundColor = colorWithYGWhite;
            [coverButton setTitleColor:colorWithBlack forState:UIControlStateNormal];
            [coverButton setTitle:@"重置" forState:UIControlStateNormal];
        }else
        {
            coverButton.backgroundColor = colorWithMainColor;
            [coverButton setTitleColor:colorWithYGWhite forState:UIControlStateNormal];
            [coverButton setTitle:@"确定" forState:UIControlStateNormal];
        }
    }
    [self show];

}
- (CGSize)createLabelsWithbaseView:(UIView *)baseView
{
    int k = 0;
    CGFloat widthCount = 0.0f;
    int j = 0;
    for (int i = 0;i<_dataSource.count;i++) {
        AdvertisesForInfoModel *model = _dataSource[i];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:model.name forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:YGFontSizeSmallOne];
        [button.titleLabel sizeToFit];
        [button setTitleColor:colorWithBlack forState:UIControlStateNormal];
        button.backgroundColor = [UIColor clearColor];
        button.tag = 10000+i;
        [button addTarget:self action:@selector(titleChooseChangeContentAction:) forControlEvents:UIControlEventTouchUpInside];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 25)];
        label.font = [UIFont systemFontOfSize:YGFontSizeSmallOne];
        label.text = model.name;
        [label sizeToFit];
        
        CGFloat labeWidth = label.width+35;
        button.frame = CGRectMake(10+widthCount+k*10,10+35*j, labeWidth, 25) ;
        
        widthCount = widthCount +labeWidth;
        
        if (widthCount>(YGScreenWidth-20-k*10)) {
            j=j+1;
            k=0;
            widthCount = 0.0f;
            button.frame = CGRectMake(10+widthCount+k*10, 10+35*j, labeWidth, 25) ;
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
    return CGSizeMake(YGScreenWidth, 10+(j+1)*35);
}
- (void)show
{
        [YGAppDelegate.window addSubview:self];
    
    self.alpha = 0;
    
    [UIView animateWithDuration:0.3 animations:^
     {
         self.alpha = 1;
         CGRect rect = self.frame;
         rect.size.height = YGScreenHeight;
         self.frame = rect;
     }];
}


- (void)dismiss
{
    [UIView animateWithDuration:0.3 animations:^
     {
         self.alpha = 0;
         CGRect rect = self.frame;
         rect.size.height = 0;
         self.frame = rect;
         
         
     }                completion:^(BOOL finished)
     {
         [self removeFromSuperview];
     }];
    
    
}

- (void)titleChooseChangeContentAction:(UIButton *)btn
{
    AdvertisesForInfoModel *model = _dataSource[btn.tag-10000];
    model.isSelect = !model.isSelect;
    if (model.isSelect == YES) {
        btn.layer.borderColor = colorWithMainColor.CGColor;
        [btn setTitleColor:colorWithMainColor forState:UIControlStateNormal];
    }else
    {
        btn.layer.borderColor = colorWithLine.CGColor;
        [btn setTitleColor:colorWithBlack forState:UIControlStateNormal];

    }

}

- (void)resetAndConfirmAction:(UIButton *)btn
{
    if (btn.tag == 555) {
        for (int i = 0;i<_dataSource.count;i++)
        {
            AdvertisesForInfoModel *model = _dataSource[i];
            model.isSelect = NO;
            UIButton *button = [self viewWithTag:10000+i];
            button.layer.borderColor =  colorWithLine.CGColor;
            [button setTitleColor:colorWithBlack forState:UIControlStateNormal];
        }
    }else
    {
        NSMutableArray *valueArray = [[NSMutableArray alloc] init];
        
        for (AdvertisesForInfoModel *model in _dataSource) {
                if (model.isSelect == YES) {
                    [valueArray addObject:model];
            }
        }
        [self.delegate siftDataWithKeyModelArray:valueArray];
        [self dismiss];
    }
}
@end
