//
//  OfficePurchaseTableViewCell.m
//  QingYouProject
//
//  Created by LDSmallCat on 2017/10/18.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "OfficePurchaseTableViewCell.h"
#import "OfficePurchaseDetailModel.h"
#import "KSPhotoBrowser.h"

@interface OfficePurchaseTableViewCell()
/** 头像  */
@property (nonatomic,strong) UIImageView * headerImageView;
/** 昵称  */
@property (nonatomic,strong) UILabel * nickNameLabel;
/** 评论内容  */
@property (nonatomic,strong) UILabel * commentLabel;
/** 评论时间  */
@property (nonatomic,strong) UILabel * commentTimeLabel;
/** 评论图片  */
@property (nonatomic,strong) NSArray * imagesArray;
@end



@implementation OfficePurchaseTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = kWhiteColor;
        [self setupUI];
    }
    return self;
}
- (void)setupUI{
    //头像
    _headerImageView = [[UIImageView alloc]init];
    [self.contentView addSubview:_headerImageView];
    //昵称
    _nickNameLabel = [UILabel new];
    _nickNameLabel.font = [UIFont systemFontOfSize:YGFontSizeBigOne];
    _nickNameLabel.textColor = colorWithBlack;
    [self.contentView addSubview:_nickNameLabel];
    //时间
    _commentTimeLabel = [UILabel new];
    _commentTimeLabel.font = [UIFont systemFontOfSize:YGFontSizeSmallOne];
    _commentTimeLabel.textColor = colorWithDeepGray;
    _commentTimeLabel.textAlignment =NSTextAlignmentRight;
    [self.contentView addSubview:_commentTimeLabel];
    //评论
    _commentLabel = [UILabel new];
    _commentLabel.font = [UIFont systemFontOfSize:YGFontSizeNormal];
    _commentLabel.textColor = colorWithBlack;
    _commentLabel.numberOfLines = 0;
    [self.contentView addSubview:_commentLabel];
    
    [self.headerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.offset(LDHPadding);
        make.width.height.offset(4 * LDHPadding);
    }];
    
    [self.nickNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headerImageView.mas_right).offset(LDHPadding);
        make.width.offset((YGScreenWidth - 7*LDHPadding)/2);
        make.top.equalTo(self.headerImageView.mas_top).offset(0.5 * LDHPadding);
        
    }];
    [self.commentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nickNameLabel);
        make.right.offset(-LDHPadding);
    make.top.equalTo(self.nickNameLabel.mas_bottom).offset(LDVPadding);
        
    }];
    
    
    [self.commentTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nickNameLabel.mas_right).offset(LDHPadding);
        make.width.offset((YGScreenWidth - 7*LDHPadding)/2 - LDHPadding);
        make.top.equalTo(self.headerImageView.mas_top).offset(0.5 * LDHPadding);
        
    }];

    UIView * bottomView = [UIView new];
    [self.contentView addSubview:bottomView];
    
    CGFloat X = 0;
    CGFloat Y = LDHPadding;
    CGFloat W = (kScreenW - 9 * LDHPadding) / 3;
    CGFloat H = W;
    
    for (int i = 0; i < self.reuseIdentifier.intValue; i++) {
        //行
        int row =   i / 3;
        //列
        int col = i % 3;
        CGRect rect = CGRectMake(X + col * (W + LDHPadding) , Y + row * (H + LDHPadding), W, H);
        UIImageView * imageView = [[UIImageView alloc] initWithFrame:rect];
        [bottomView addSubview:imageView];
        imageView.tag = 100 + i;
        imageView.userInteractionEnabled = YES;
        [imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewDidClick:)]];
        
        
    }

    NSInteger num = self.reuseIdentifier.intValue;
    if (num ==0) {
        bottomView.backgroundColor = kWhiteColor;
        [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.offset(LDVPadding);
            make.left.right.offset(0);
            make.top.equalTo(self.commentLabel.mas_bottom);
            make.bottom.offset(0);
        }];
        
    }else{
        
        [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo([self.contentView viewWithTag:100]);
            
            make.top.equalTo([self.contentView viewWithTag:100]).offset(-LDVPadding);
            make.bottom.equalTo([self.contentView viewWithTag:100 + num - 1 ].mas_bottom).offset(LDVPadding);
            if (num > 2) {
                
                make.right.equalTo([self.contentView viewWithTag:100 + 2]);
                
            }else{
                
                make.right.equalTo([self.contentView viewWithTag:100 + num - 1 ].mas_right);
                
            }
            
            make.left.equalTo(self.nickNameLabel);
            make.top.equalTo(self.commentLabel.mas_bottom);
            make.bottom.offset(0);
        }];
        
    }
    
    //属性设置
    self.headerImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.headerImageView.layer.cornerRadius = 20;
    self.headerImageView.layer.masksToBounds = YES;
    self.commentLabel.preferredMaxLayoutWidth = kScreenW - 7 * LDHPadding;
    
}
- (void)setModel:(OfficePurchaseDetailModel *)model{
    _model = model;
    
    [self.headerImageView sd_setImageWithURL:[NSURL URLWithString:model.userImg] placeholderImage:YGDefaultImgAvatar];
    self.nickNameLabel.text = model.userName;
    self.commentLabel.text = model.context;
    NSArray * timeArry = [model.createDate componentsSeparatedByString:@" "];
    if(timeArry.count)
       _commentTimeLabel.text = timeArry[0];
    
    if(model.imgs.length >0)
      self.imagesArray = [model.imgs componentsSeparatedByString:@","];
    
    for (int i = 0; i < self.imagesArray.count; i++) {
        UIImageView * imageView = [self viewWithTag:100 + i];
        [imageView sd_setImageWithURL:[NSURL URLWithString:self.imagesArray[i]] placeholderImage:YGDefaultImgSquare];
    }
 
}
- (void)signUpSetModel:(OfficePurchaseDetailModel *)model{
    _model = model;
    
    [self.headerImageView sd_setImageWithURL:[NSURL URLWithString:model.userImg] placeholderImage:YGDefaultImgAvatar];
    self.nickNameLabel.text = model.userName;
    self.commentLabel.text = model.userAutograph;
    NSArray * timeArry = [model.createDate componentsSeparatedByString:@" "];
    if(timeArry.count)
        _commentTimeLabel.text = timeArry[0];
    
    if(model.imgs.length >0)
        self.imagesArray = [model.imgs componentsSeparatedByString:@","];
    
    for (int i = 0; i < self.imagesArray.count; i++) {
        UIImageView * imageView = [self viewWithTag:100 + i];
        [imageView sd_setImageWithURL:[NSURL URLWithString:self.imagesArray[i]] placeholderImage:YGDefaultImgAvatar];
    }
    
}

- (void)imageViewDidClick:(UIGestureRecognizer *)gestureRecognizer {
    
    UIImageView * imageView = (UIImageView *)gestureRecognizer.view;
    
    
    NSMutableArray *items = @[].mutableCopy;
    
    for (int i = 0; i < self.imagesArray.count; i++) {
        
        UIImageView *imageView = [self viewWithTag:100 + i];
        
//        KSPhotoItem *item = [KSPhotoItem itemWithSourceView:imageView image:self.imagesArray[i]];
        
        KSPhotoItem *item = [KSPhotoItem  itemWithSourceView:imageView imageUrl:[NSURL URLWithString:self.imagesArray[i]]];
    
        [items addObject:item];
    }
    
    KSPhotoBrowser *browser = [KSPhotoBrowser browserWithPhotoItems:items selectedIndex:imageView.tag - 100];
    [browser showFromViewController:[self getCellViewController]];

}

//
//    NSMutableArray *items = [[NSMutableArray alloc]init];
//
//    for (int i = 0; i < self.imagesArray.count; i++)
//    {
//        KSPhotoItem *item = [KSPhotoItem itemWithSourceView:(UIImageView *)imageButton imageUrl:[NSURL URLWithString:imageArray[i]]];
//        [items addObject:item];
//    }
//    KSPhotoBrowser *browser = [KSPhotoBrowser browserWithPhotoItems:items selectedIndex:imageView.tag - 100];
//    browser.dismissalStyle = KSPhotoBrowserInteractiveDismissalStyleScale;
//    browser.pageindicatorStyle = KSPhotoBrowserPageIndicatorStyleText;
//    browser.backgroundStyle = KSPhotoBrowserBackgroundStyleBlack;
//    [browser showFromViewController:self];
@end
