//
//  ChooseGoodsWithCategoriesView.m
//  QingYouProject
//
//  Created by apple on 2017/12/11.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "ChooseGoodsWithCategoriesView.h"
#define YEARCOUNT   10
@implementation ChooseGoodsWithCategoriesView

{
    UIView *_thirdLineView;
    UILabel *_thirdPlacehoderLabel;
    UILabel *_fourthPlacehoderLabel;
    
    UILabel  *_describeLabel;
    UILabel  *_yearLabel;
    BOOL    _isSelectYearBtn; //是否选择了年限按钮
    UIImageView *_leftImageView;
    NSArray *_categoryArry;
    UILabel *_titleLabel;
    NSArray *_typeArray;
    UIView *_titleBaseView;
    UIView * _baseView;
    UIScrollView * _backScrollView;
    NSInteger _selectNum;
}
- (instancetype)init
{
    if (self = [super init]) {
        self.frame = CGRectMake(0, 0, YGScreenWidth, YGScreenHeight);
        self.backgroundColor = [colorWithBlack colorWithAlphaComponent:0.5];
    }
    return self;
}

- (void)createFrame:(CGRect)frame withInfoNSArry:(NSArray *)arry
{
    _selectNum =0;
    _categoryArry = arry;
    UIView *selfView = [[UIView alloc] initWithFrame:frame];
    selfView.backgroundColor = colorWithYGWhite;
    [self addSubview:selfView];
    
    _backScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, YGScreenWidth, selfView.height-45-YGBottomMargin)];
    [selfView addSubview:_backScrollView];
    
    _baseView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, YGScreenWidth, selfView.height)];
    _baseView.backgroundColor = colorWithYGWhite;
    [_backScrollView addSubview:_baseView];
    
    UIButton *cancleButton = [[UIButton alloc]initWithFrame:CGRectMake(YGScreenWidth-55,0,40,40)];
    [cancleButton setTitle:@"取消" forState:UIControlStateNormal];
    [cancleButton setTitleColor:colorWithLightGray forState:UIControlStateNormal];
    [cancleButton addTarget:self action:@selector(cancleChooseTypeButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    cancleButton.titleLabel.font = [UIFont systemFontOfSize:YGFontSizeSmallOne];
    [_baseView addSubview:cancleButton];
    
    //左线
    _leftImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"home_tool1.png"]];
    _leftImageView.frame = CGRectMake(10, 20, 60, 60);
    //    _leftImageView.layer.borderColor = colorWithLine.CGColor;
    //    _leftImageView.layer.borderWidth = 0.5;
    _leftImageView.layer.masksToBounds = YES;
    _leftImageView.layer.cornerRadius = 5;
    _leftImageView.backgroundColor = colorWithMainColor;
    //    _leftImageView.contentMode = UIViewContentModeScaleAspectFill;
    [_baseView addSubview:_leftImageView];
    if (_labelList.count>0) {
        [_leftImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",_labelList[0][@"img"]]] placeholderImage:YGDefaultImgSquare];        
    }

    //新鲜事标题label
    _titleLabel= [[UILabel alloc]init];
    _titleLabel.textColor = colorWithRedColor;
    _titleLabel.font = [UIFont systemFontOfSize:YGFontSizeNormal];
    _titleLabel.text = [NSString stringWithFormat:@"¥%@",_labelList[0][@"price"]];
    _titleLabel.frame = CGRectMake(_leftImageView.x+_leftImageView.width+10, _leftImageView.y+15,YGScreenWidth-100-15, 20);
    [_baseView addSubview:_titleLabel];
    
    
    //新鲜事内容label
    _describeLabel = [[UILabel alloc]init];
    _describeLabel.frame = CGRectMake(_titleLabel.x,_titleLabel.y+_titleLabel.height+5 , YGScreenWidth-100, 20);
    _describeLabel.textColor = colorWithLightGray;
    _describeLabel.text = _detailStr;
    if([_pageType isEqualToString:@"RushPurchaseDetailViewController"])
        _describeLabel.text = [NSString stringWithFormat:@"%@",_labelList[0][@"kc"]];;
    _describeLabel.font = [UIFont systemFontOfSize:YGFontSizeSmallOne];
    _describeLabel.numberOfLines = 1;
    _describeLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    [_describeLabel sizeToFitVerticalWithMaxWidth:YGScreenWidth-100];
    _describeLabel.frame = CGRectMake(_titleLabel.x,_titleLabel.y+_titleLabel.height+5 , YGScreenWidth-100, _describeLabel.height);
    [_baseView addSubview:_describeLabel];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(10, _leftImageView.y+_leftImageView.height+20, YGScreenWidth, 1)];
    lineView.backgroundColor = colorWithTable;
    [_baseView addSubview:lineView];
    
    UILabel *typeTitleLabel = [[UILabel alloc]init];
    typeTitleLabel.textColor = colorWithBlack;
    typeTitleLabel.font = [UIFont systemFontOfSize:YGFontSizeNormal];
    typeTitleLabel.text = @"规格   ";
    typeTitleLabel.frame = CGRectMake(_leftImageView.x, lineView.y+lineView.height+20,100, 20);
    [_baseView addSubview:typeTitleLabel];
    
    _titleBaseView = [[UIView alloc] initWithFrame:CGRectMake(10, typeTitleLabel.y+typeTitleLabel.height+10, YGScreenWidth-20, 30)];
    [_baseView addSubview:_titleBaseView];
   
    CGSize size = CGSizeMake(YGScreenWidth, 180);
    if (_dataSource.count>0 && ((NSString *)_dataSource[0]).length>0) {
        
        size = [self createLabelsWithbaseView:_titleBaseView];
        _titleBaseView.frame = CGRectMake(_titleBaseView.x, _titleBaseView.y, _titleBaseView.width, size.height);
    }
    
        _baseView.frame = CGRectMake(0, 0, YGScreenWidth, _titleBaseView.y+_titleBaseView.height + 40 + 2*LDHPadding);
    
    
     UIView *addView = [self createAddView];
     addView.y = _titleBaseView.y+_titleBaseView.height + 2*LDHPadding;
     [_baseView addSubview:addView];
    
    _backScrollView.contentSize = CGSizeMake(0, addView.y + addView.height + 3*LDHPadding);

    
//    _lineView.frame = CGRectMake(10, _baseView.height-1, YGScreenWidth-10, 1);
    
    UIButton *confirmPayButton = [[UIButton alloc]initWithFrame:CGRectMake(0,selfView.height-45-YGBottomMargin,YGScreenWidth,45+YGBottomMargin)];
    [confirmPayButton setTitle:@"确定" forState:UIControlStateNormal];
    [confirmPayButton setTitleColor:colorWithYGWhite forState:UIControlStateNormal];
    confirmPayButton.titleEdgeInsets = UIEdgeInsetsMake(0, -20, 0, 0);
    [confirmPayButton addTarget:self action:@selector(nextStepButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    confirmPayButton.backgroundColor = colorWithMainColor;
    confirmPayButton.titleLabel.font = [UIFont systemFontOfSize:YGFontSizeBigOne];
    [selfView addSubview:confirmPayButton];
    
}

- (CGSize)createLabelsWithbaseView:(UIView *)baseView
{
    int k = 0;
    CGFloat widthCount = 0.0f;
    int j = 0;
    for (int i = 0;i<_dataSource.count;i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:_dataSource[i] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:YGFontSizeSmallOne];
        [button.titleLabel sizeToFit];
        button.backgroundColor = [UIColor clearColor];
        button.tag = 10000+i;
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 25)];
        label.font = [UIFont systemFontOfSize:YGFontSizeSmallOne];
        label.text = _dataSource[i];
        [label sizeToFit];
        
        CGFloat labeWidth = label.width+ 25;
//        widthCount = widthCount +labeWidth;
        
        button.frame = CGRectMake(10+widthCount+k*10, 30*j, labeWidth, 25) ;
        
        widthCount = widthCount +labeWidth;
        
        if (widthCount>(baseView.width-20-k*10)) {
            j=j+1;
            k=0;
            widthCount = 0.0f;
            button.frame = CGRectMake(10+widthCount+k*10,30*j, labeWidth, 25) ;
            widthCount = widthCount +labeWidth;
        }
        button.layer.borderColor = colorWithLine.CGColor;
        [button setTitleColor:colorWithBlack forState:UIControlStateNormal];
        [button setTitleColor:colorWithMainColor forState:UIControlStateSelected];

        button.layer.cornerRadius = 13;
        button.layer.borderWidth = 1;
        k++;
        if(i==0)
        {
            button.selected = YES;
            button.layer.borderColor = colorWithMainColor.CGColor;
        }
        [baseView addSubview:button];
        
    }
    return CGSizeMake(YGScreenWidth, (j+1)*30);
}
- (void)buttonClick:(UIButton *)btn{
    
    //首先把原来按钮的选中效果消除
    
    for (int i=0;i<[_dataSource count];i++) {
        
        UIButton *btn = (UIButton*)[_titleBaseView viewWithTag:i +10000];
        
        btn.selected = NO;
        btn.layer.borderColor = colorWithLine.CGColor;

    }
    
    btn.selected = YES;//sender.selected = !sender.selected;
    btn.layer.borderColor = colorWithMainColor.CGColor;

    _selectNum = btn.tag -10000;
    
    
    [_leftImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",_labelList[_selectNum][@"img"]]] placeholderImage:YGDefaultImgSquare];
    _titleLabel.text = [NSString stringWithFormat:@"¥%@",_labelList[_selectNum][@"price"]];
    if([_pageType isEqualToString:@"RushPurchaseDetailViewController"])
        _describeLabel.text = [NSString stringWithFormat:@"¥%@",_labelList[_selectNum][@"kc"]];
}
- (CGSize)sizeThatFits:(CGSize)size
{
    return CGSizeMake(_baseView.width, _baseView.height);
}
- (UIView *)createAddView
{
    
    UIView *addView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, YGScreenWidth, 40)];
    
    UILabel *typeTitleLabel = [[UILabel alloc]init];
    typeTitleLabel.textColor = colorWithBlack;
    typeTitleLabel.font = [UIFont systemFontOfSize:YGFontSizeNormal];
    typeTitleLabel.text = @"数量  ";
    typeTitleLabel.frame = CGRectMake(_leftImageView.x, 0,100, 40);
    [addView addSubview:typeTitleLabel];
    
    //加
    UIButton *addButton = [[UIButton alloc]initWithFrame:CGRectMake(addView.width-40,0,40,40)];
    [addButton setImage:[UIImage imageNamed:@"popup_plus_btn"] forState:UIControlStateNormal];
    addButton.imageView.contentMode = UIViewContentModeScaleAspectFill;
    addButton.imageView.clipsToBounds = YES;
    [addButton addTarget:self action:@selector(addButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    //    addButton.backgroundColor = colorWithMainColor;
    [addView addSubview:addButton];
    
    //减
    UIButton *subButton = [[UIButton alloc]initWithFrame:CGRectMake(addView.width- 120,0,40,40)];
    [subButton setImage:[UIImage imageNamed:@"popup_subtract_btn"] forState:UIControlStateNormal];
    subButton.imageView.contentMode = UIViewContentModeScaleAspectFill;
    subButton.imageView.clipsToBounds = YES;
    [subButton addTarget:self action:@selector(subButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    //    subButton.backgroundColor = colorWithMainColor;
    [addView addSubview:subButton];
    
    //新鲜事标题label
    _yearLabel = [[UILabel alloc]init];
    _yearLabel.textColor = colorWithBlack;
    _yearLabel.font = [UIFont systemFontOfSize:YGFontSizeSmallTwo];
    _yearLabel.text = @"1";
    _yearLabel.textAlignment = NSTextAlignmentCenter;
    _yearLabel.frame = CGRectMake(addView.width - 80 , 10,40, 20);
    [addView addSubview:_yearLabel];
    
    return addView;
}
//移除自己
- (void)selfDisappear
{
    [self removeFromSuperview];
}
//选择类型取消按钮
- (void)cancleChooseTypeButtonAction:(UIButton *)btn
{
    [self selfDisappear];
}


//加
- (void)addButtonAction:(UIButton *)btn
{
    //判断是否选择了按钮 不用每次都初始一遍按钮
    if (_isSelectYearBtn == YES) {
        for (int i = 0; i<2; i++)
        {
            UIButton *btnFirst = [self viewWithTag:1000+i];
            btnFirst.selected = NO;
            btnFirst.layer.borderColor = colorWithLine.CGColor;
        }
        _isSelectYearBtn = NO;
    }

    _yearLabel.text = [NSString stringWithFormat:@"%d",[_yearLabel.text intValue]+1];
}

//减
- (void)subButtonAction:(UIButton *)btn
{
    if (_isSelectYearBtn == YES) {
        for (int i = 0; i<2; i++)
        {
            UIButton *btnFirst = [self viewWithTag:1000+i];
            btnFirst.selected = NO;
            btnFirst.layer.borderColor = colorWithLine.CGColor;
        }
        _isSelectYearBtn = NO;
    }
    
    if ([_yearLabel.text intValue] == 1) {
        [YGAppTool showToastWithText:@"不能再减了"];
        return ;
    }
    _yearLabel.text = [NSString stringWithFormat:@"%d",[_yearLabel.text intValue]-1];
    
}

//下一步按钮
- (void)nextStepButtonAction:(UIButton *)btn
{
    NSMutableDictionary * dict = [[NSMutableDictionary alloc]init];

    //抢购
    if([_pageType isEqualToString:@"RushPurchaseDetailViewController"])
    {
        dict[@"count"]= _yearLabel.text;
        dict[@"labelID"]= _labelList[_selectNum][@"labelID"];
    }
    else //办公采购
    {
        dict[@"count"]= _yearLabel.text;
        dict[@"labelID"]= _labelList[_selectNum][@"labelID"];
    }
  
    [self.delegate chooseGoodsWithCategoriesViewSurePaywitDict:dict];
    [self selfDisappear];
}

-(void)dealloc
{
    
}

@end

