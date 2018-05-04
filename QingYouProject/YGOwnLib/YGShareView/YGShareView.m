//
//  YGShareView.m
//  YogeeLiveShop
//
//  Created by zhangkaifeng on 2016/10/21.
//  Copyright © 2016年 ccyouge. All rights reserved.
//

#import "YGShareView.h"

@implementation YGShareView
{
    UIView *_baseView;
    void(^_handler)(NSInteger buttonIndex);
}

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        self.frame = [UIScreen mainScreen].bounds;
        
        [self configUI];
    }
    return self;
}


-(void)configUI
{
    _baseView = [[UIView alloc]initWithFrame:CGRectMake(0, self.height, self.width, 0)];
    _baseView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_baseView];
    
    //更多人知道
    UILabel *describeLabel = [[UILabel alloc]init];
    describeLabel.text = @"分享到";
    describeLabel.font = [UIFont systemFontOfSize:YGFontSizeNormal];
    describeLabel.textColor = colorWithBlack;
    [describeLabel sizeToFitHorizontal];
    describeLabel.centerx = self.width/2;
    describeLabel.y = 20;
    [_baseView addSubview:describeLabel];
    
    //线
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, describeLabel.y + describeLabel.height + 20, _baseView.width, 0.5)];
    lineView.backgroundColor = colorWithLine;
    [_baseView addSubview:lineView];
    
    NSArray *imageNameArray = @[@"share_wechat",@"share_friend",@"share_qq",@"share_qqzone",@"share_sinablog",@"share_copylink"];
    CGRect shareButtonFrame;
    //四个按钮
    for (int i = 0; i<imageNameArray.count ; i++)
    {
        int x = i%4;
        int y = i/4;
        UIButton *shareButton = [[UIButton alloc]initWithFrame:CGRectMake(_baseView.width/4 * x, lineView.y + lineView.height + 20+86*y, YGScreenWidth/4, 71)];
        [shareButton setImage:[UIImage imageNamed:imageNameArray[i]] forState:UIControlStateNormal];
        shareButton.contentMode = UIViewContentModeScaleAspectFit;
        shareButton.tag = 800 + i;
        [shareButton addTarget:self action:@selector(shareButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_baseView addSubview:shareButton];
        shareButtonFrame = shareButton.frame;
        
    }
    
    //线
    UIView *lineView1 = [[UIView alloc]initWithFrame:CGRectMake(0, shareButtonFrame.origin.y + shareButtonFrame.size.height + 20, _baseView.width, 0.5)];
    lineView1.backgroundColor = colorWithLine;
    [_baseView addSubview:lineView1];
    
    //取消
    UIButton *cancelButton = [[UIButton alloc]initWithFrame:CGRectMake(0, lineView1.y + lineView1.height, _baseView.width, 49)];
    cancelButton.titleLabel.font = [UIFont systemFontOfSize:YGFontSizeNormal];
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [cancelButton setTitleColor:colorWithBlack forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    [_baseView addSubview:cancelButton];
    
    _baseView.height = cancelButton.y + cancelButton.height;
    
}

-(void)shareButtonClick:(UIButton *)button
{
    _handler(button.tag - 800);
    [self dismiss];
}

-(void)buttonClickBlock:(void (^)(NSInteger buttonIndex))handler
{
    _handler = handler;
}

-(void)show
{
    _baseView.y = self.height;
    self.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0];
    [YGAppDelegate.window addSubview:self];
    
    [UIView animateWithDuration:0.25 animations:^
     {
         _baseView.y = self.height - _baseView.height;
         self.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.5];
     }];
}

-(void)dismiss
{
    [UIView animateWithDuration:0.25 animations:^
     {
         _baseView.y = self.height;
         self.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0];
     } completion:^(BOOL finished) {
         [self removeFromSuperview];
     }];
}

@end
