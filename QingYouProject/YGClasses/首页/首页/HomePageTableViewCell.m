//
//  HomePageTableViewCell.m
//  FrienDo
//
//  Created by zhangkaifeng on 2017/2/6.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "HomePageTableViewCell.h"

@implementation HomePageTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setModelArray:(NSArray *)modelArray
{
    _modelArray = modelArray;
    for (int i = 0; i<_modelArray.count; i++)
    {
        HomePageModel *model = _modelArray[i];
        UIImageView *imag = [self.contentView viewWithTag:1000+i];
        [imag sd_setImageWithURL:[NSURL URLWithString:model.img] placeholderImage:YGDefaultImgThree_Four];
    }
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        self.contentView.backgroundColor = colorWithYGWhite;
        for (int i = 0; i<3; i++)
        {
            //背景
            UIImageView  *baseImg = [[UIImageView alloc]initWithFrame:CGRectMake(10+((YGScreenWidth-40)/3+10)*i, 10, (YGScreenWidth-40)/3, (YGScreenWidth-40)/3*1.3)];
            baseImg.contentMode = UIViewContentModeScaleAspectFill;
            baseImg.tag = 1000+i;
            baseImg.clipsToBounds = YES;
            baseImg.userInteractionEnabled = YES;
            [self.contentView addSubview:baseImg];
            
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageTapAction:)];
            tap.numberOfTapsRequired = 1;
            tap.numberOfTouchesRequired = 1;
            [baseImg addGestureRecognizer:tap];
        }
    }
    return self;
}
- (void)imageTapAction:(UITapGestureRecognizer *)tap
{
    [self.delegate HomePageTableViewCellTapImageViewWithIndex:tap.view.tag-1000];
}
@end
