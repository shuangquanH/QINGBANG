//
//  SQDecorationServeCell.m
//  QingYouProject
//
//  Created by qwuser on 2018/5/18.
//  Copyright © 2018年 ccyouge. All rights reserved.
//

#import "SQDecorationServeCell.h"
#import "SQBaseImageView.h"

#define KSPACE 10

@implementation SQDecorationServeCell {
    SQBaseImageView *productImage;
    UILabel *productTitle;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        productImage    = [[SQBaseImageView alloc] init];
        productImage.backgroundColor = colorWithMainColor;
        [self.contentView addSubview:productImage];
        
        productTitle = [[UILabel alloc] init];
        productTitle.numberOfLines = 0;
        productTitle.backgroundColor = [UIColor lightGrayColor];
        [self.contentView addSubview:productTitle];
        
        [self sqlayoutSubviews];
        
    }
    return self;
}

- (void)sqlayoutSubviews {
    [productImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self.contentView).offset(KSPACE);
        make.right.equalTo(self.contentView).offset(-KSPACE);
        make.height.mas_equalTo(240);
    }];
    
    [productTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(KSPACE);
        make.right.equalTo(self.contentView).offset(-KSPACE);
        make.top.equalTo(productImage.mas_bottom).offset(KSPACE);
        make.bottom.equalTo(self.contentView).offset(-KSPACE);
    }];
    
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
}

- (void)setModel:(NSString *)model {
    productTitle.text = model;
    [productImage setImageWithURL:[NSURL URLWithString:model]];
    [self layoutIfNeeded];
}

- (void)layoutSubviews {
    [super layoutSubviews];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
