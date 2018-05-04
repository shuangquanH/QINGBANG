//
//  CommetTableViewCell.m
//  YogeeLiveShop
//
//  Created by zhangkaifeng on 16/8/19.
//  Copyright © 2016年 ccyouge. All rights reserved.
//

#import "CommetTableViewCell.h"
#import "SocketEnterRoomModel.h"
#import "SocketNormalMessageModel.h"
#import "SocketSendGiftModel.h"
#import "SocketConcernModel.h"
#import "SocketNoTalkModel.h"
#import "SocketAddGoodModel.h"
#import "YGLevelView.h"
#define LABEL_BLANK @"        "

@implementation CommetTableViewCell
{
    UIView *_backgroundView;
    YGLevelView *_levelView;
    UILabel *_commentLabel;
    UIButton *_nameButton;
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        self.contentView.backgroundColor = [UIColor clearColor];
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        //黑色背景
        _backgroundView = [UIView new];
        _backgroundView.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.2];
        _backgroundView.layer.cornerRadius = 3;
        _backgroundView.transform = CGAffineTransformMakeScale (1,-1);

        [self.contentView addSubview:_backgroundView];
        
        //等级imageview
        _levelView = [[YGLevelView alloc]initWithFrame:CGRectMake(0, 0, 0, 0) levelString:@"1"];
        [_backgroundView addSubview:_levelView];
        
        //评论label
        _commentLabel = [UILabel new];
        [_commentLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:YGFontSizeBigOne]];
        _commentLabel.textColor = [UIColor whiteColor];
        _commentLabel.lineBreakMode = NSLineBreakByCharWrapping;
        [_backgroundView addSubview:_commentLabel];
        [_backgroundView sendSubviewToBack:_commentLabel];
        
        //名字button
        _nameButton = [UIButton new];
        _nameButton.titleLabel.font = _commentLabel.font;
        [_nameButton setTitle:@"" forState:UIControlStateNormal];
        [_nameButton addTarget:self action:@selector(nameButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_backgroundView addSubview:_nameButton];
    }
    return self;
}

-(void)setModel:(SocketBaseModel *)model
{
    _model = model;
    //如果是进入房间
    if ([model isKindOfClass:[SocketEnterRoomModel class]])
    {
        _showString = [NSString stringWithFormat:@"%@%@ 进入了直播间",LABEL_BLANK,model.username];
    }
    //如果是普通的消息
    else if([model isKindOfClass:[SocketNormalMessageModel class]])
    {
        SocketNormalMessageModel *localModel = (SocketNormalMessageModel*)model;
        _showString = [NSString stringWithFormat:@"%@%@ %@",LABEL_BLANK,model.username,localModel.msg];
    }
    //如果是送礼物
    else if([model isKindOfClass:[SocketSendGiftModel class]])
    {
        SocketSendGiftModel *localModel = (SocketSendGiftModel*)model;
        _showString = [NSString stringWithFormat:@"%@%@ 送了个%@",LABEL_BLANK,model.username,localModel.giftname];;
    }
    //如果是关注
    else if([model isKindOfClass:[SocketConcernModel class]])
    {
        _showString = [NSString stringWithFormat:@"%@%@ 关注了主播",LABEL_BLANK,model.username];
    }
    //如果是禁言
    else if([model isKindOfClass:[SocketNoTalkModel class]])
    {
        SocketNoTalkModel *localModel = (SocketNoTalkModel*)model;
        if ([localModel.isGag isEqualToString:@"1"])
        {
            _showString = [NSString stringWithFormat:@"%@%@ 已被主播禁言",LABEL_BLANK,model.username];
        }
        else
        {
            _showString = [NSString stringWithFormat:@"%@%@ 已被主播解除禁言",LABEL_BLANK,model.username];
        }
        
    }
    //如果是卖东西
    else if([model isKindOfClass:[SocketAddGoodModel class]])
    {
        SocketAddGoodModel *localModel = (SocketAddGoodModel*)model;
        _showString = [NSString stringWithFormat:@"%@%@ 添加了商品 %@",LABEL_BLANK,model.username,localModel.goodname];
    }
    
    [_commentLabel addAttributedWithString:_showString range:NSMakeRange(0, [NSString stringWithFormat:@"%@%@",LABEL_BLANK,model.username].length + 1) color:colorWithMainColor];
    _levelView.levelString = model.grade;
    _levelView.frame = CGRectMake(5, 0, 0, 0);
    _levelView.centery = YGFontSizeSmallOne/2;
    [_commentLabel sizeToFitVerticalWithMaxWidth:_realWidth - 6];
    _commentLabel.frame =CGRectMake(3, 3, _commentLabel.width, _commentLabel.height);
    _backgroundView.frame = CGRectMake(0, 0,_commentLabel.x + _commentLabel.width + 3, _commentLabel.y + _commentLabel.height + 3);
    _nameButton.frame = CGRectMake(_levelView.x+_levelView.width, 0,model.username.length *YGFontSizeBigOne + 10, YGFontSizeBigOne);
}

-(void)nameButtonClick:(UIButton *)button
{
    [_delegate commetTableViewCellDidClickNameButtonWithModel:_model nameButton:button];
}

-(CGSize)sizeThatFits:(CGSize)size
{
    return CGSizeMake(self.contentView.width, _backgroundView.height);
}

@end
