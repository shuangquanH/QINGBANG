//
//  WKInvoiceFunctionCell.m
//  QingYouProject
//
//  Created by mac on 2018/6/25.
//  Copyright © 2018年 ccyouge. All rights reserved.
//

#import "WKInvoiceFunctionCell.h"
#import "UIButton+SQImagePosition.h"

@implementation WKInvoiceFunctionCell {
    UIButton *_setDefaultBtn;
    UIButton *_editBtn;
    UIButton *_deleteBtn;
    
    NSIndexPath *_selfIndexPath;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews {
    _setDefaultBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _setDefaultBtn.titleLabel.font = KFONT(28);
    [_setDefaultBtn setTitle:@"设置默认" forState:UIControlStateNormal];
    [_setDefaultBtn setTitleColor:kCOLOR_333 forState:UIControlStateNormal];
    [_setDefaultBtn setImage:[UIImage imageNamed:@"order_nochoice_btn_gray"] forState:UIControlStateNormal];
    [_setDefaultBtn setImage:[UIImage imageNamed:@"order_choice_btn_green"] forState:UIControlStateSelected];
    [_setDefaultBtn addTarget:self action:@selector(click_setDefaultButton) forControlEvents:UIControlEventTouchUpInside];
    [_setDefaultBtn sq_setImagePosition:SQImagePositionLeft spacing:5];
    [self.contentView addSubview:_setDefaultBtn];
    
    _editBtn = [UIButton new];
    [_editBtn setImage:[UIImage imageNamed:@"steward_edit_black"] forState:UIControlStateNormal];
    [_editBtn addTarget:self action:@selector(click_editButton) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_editBtn];
    
    _deleteBtn = [UIButton new];
    [_deleteBtn setImage:[UIImage imageNamed:@"steward_delete_black"] forState:UIControlStateNormal];
    [_deleteBtn addTarget:self action:@selector(click_deleteButton) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_deleteBtn];
    
    [_setDefaultBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.left.mas_equalTo(KSCAL(30));
        make.size.mas_equalTo(CGSizeMake(KSCAL(160), KSCAL(80)));
    }];
    
    [_deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.right.mas_equalTo(-KSCAL(30));
        make.width.height.mas_equalTo(KSCAL(80));
    }];
    
    [_editBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.right.equalTo(_deleteBtn.mas_left).offset(-KSCAL(40));
        make.width.height.mas_equalTo(KSCAL(80));
    }];
}

- (void)configIndexPath:(NSIndexPath *)indexPath isDefault:(BOOL)isDefault {
    _selfIndexPath = indexPath;
    _setDefaultBtn.selected = isDefault;
}

- (void)click_setDefaultButton {
    [self.functionDelegate functionCell:self didClickType:0 withIndexPath:_selfIndexPath];
}

- (void)click_editButton {
    [self.functionDelegate functionCell:self didClickType:1 withIndexPath:_selfIndexPath];
}

- (void)click_deleteButton {
    [self.functionDelegate functionCell:self didClickType:2 withIndexPath:_selfIndexPath];
}

@end
