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
//    UILabel *productTitle;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = colorWithTable;
        productImage    = [[SQBaseImageView alloc] init];
        [self.contentView addSubview:productImage];
        
        [self sqlayoutSubviews];
    }
    return self;
}

- (void)sqlayoutSubviews {
    
    
    [productImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(KSPACE);
        make.left.right.equalTo(self.contentView);
        make.height.mas_equalTo(KSCAL(320));
        make.bottom.equalTo(self.contentView);
    }];
    
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}

- (void)setModel:(SQDecorationStyleModel *)model {
    [productImage setImageWithUrl:model.imageUrl];
//    [self layoutIfNeeded];
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
