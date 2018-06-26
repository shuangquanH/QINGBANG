//
//  WKRefundAlertView.m
//  QingYouProject
//
//  Created by mac on 2018/6/25.
//  Copyright © 2018年 ccyouge. All rights reserved.
//

#import "WKRefundAlertView.h"
#import "WKAnimationAlert.h"
#import "WKDecorationOrderListModel.h"

@interface WKRefundAlertView()<UITableViewDataSource, UITableViewDelegate>

@end

@implementation WKRefundAlertView {
    UITableView *_tableView;
    UIButton *_confirmButton;
    NSString *_reason;
    NSAttributedString *_amountStr;
    
    UILabel *_titleLabel;
    UIButton *_dismissBtn;
    
    BOOL _inReason;
    NSInteger _selectReasonIndex;
    NSArray *_reasonArr;
}

+ (WKRefundAlertView *)refundAlert {
    return [[WKRefundAlertView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, KSCAL(376)+1)];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        self.backgroundColor = colorWithLine;
        _reasonArr = @[@"我有疑虑，后悔了", @"没有客服跟进", @"我不满意设计方案", @"其它原因"];
        _selectReasonIndex = -1;
        
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews {
    
    _titleLabel = [UILabel labelWithFont:KSCAL(38) textColor:kCOLOR_333 textAlignment:NSTextAlignmentCenter text: @"申请退款"];
    _titleLabel.backgroundColor = [UIColor whiteColor];
    [self addSubview:_titleLabel];
    
    _dismissBtn = [UIButton buttonWithTitle:nil titleFont:0 titleColor:nil normalImage:@"alert_dismiss_btn" highlightImage:nil];
    _dismissBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [_dismissBtn addTarget:self action:@selector(click_dismiss) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_dismissBtn];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.rowHeight = KSCAL(88);
    _tableView.separatorInset = UIEdgeInsetsMake(0, KSCAL(30), 0, KSCAL(30));
    _tableView.scrollEnabled = NO;
    [self addSubview:_tableView];
    
    _confirmButton = [UIButton buttonWithTitle:@"提交申请" titleFont:KSCAL(38) titleColor:[UIColor whiteColor] bgColor:KCOLOR_MAIN];
    [_confirmButton addTarget:self action:@selector(click_confirm) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_confirmButton];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    _titleLabel.frame = CGRectMake(0, 0, self.bounds.size.width, KSCAL(100));
    _tableView.frame = CGRectMake(0, KSCAL(100)+1, self.bounds.size.width, self.bounds.size.height-KSCAL(200)-1);
    _confirmButton.frame = CGRectMake(0, self.bounds.size.height-KSCAL(100), self.bounds.size.width, KSCAL(100));
    
    _dismissBtn.frame = CGRectMake(self.bounds.size.width - KSCAL(30) - KSCAL(60), 0, KSCAL(60), KSCAL(100));
}

- (void)setStageInfo:(WKDecorationStageModel *)stageInfo {
    _stageInfo = stageInfo;
    if (stageInfo.amount.length) {
       NSMutableAttributedString *tmp = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"退款金额\t¥%@", stageInfo.amount]];
        [tmp setAttributes:@{NSForegroundColorAttributeName: kCOLOR_PRICE_RED} range:NSMakeRange(5, stageInfo.amount.length+1)];
        _amountStr = [tmp copy];
    } else {
        _amountStr = nil;
    }
    [_tableView reloadData];
}

#pragma mark -
- (void)click_dismiss {
    [WKAnimationAlert dismiss];
    _reason = nil;
    _selectReasonIndex = -1;
}

- (void)click_confirm {
    if (_inReason) {//退出原因选择
        [self quiteReasonMode];
    }
    else {
        if (!_reason.length) {
            [YGAppTool showToastWithText:@"请选择原因"];
            return;
        }
        if (self.refundHandler) {
            self.refundHandler(_reason);
        }
        [WKAnimationAlert dismiss];
        _reason = nil;
        _selectReasonIndex = -1;
    }
}

- (void)click_selectBtn:(UIButton *)sender {
    if (sender.isSelected) return;
    
    _selectReasonIndex = sender.tag;
    _reason = _reasonArr[_selectReasonIndex];
    [self quiteReasonMode];
}

- (void)intoReasonMode {
    [_confirmButton setTitle:@"取消" forState:UIControlStateNormal];
    _dismissBtn.hidden = YES;
    _titleLabel.text = @"退款原因";
    CGRect frame = self.frame;
    frame.origin.y -= KSCAL(176);
    frame.size.height += KSCAL(176);
    self.frame = frame;
    _inReason = YES;
    [_tableView reloadData];
}
- (void)quiteReasonMode {
    _titleLabel.text = @"退款申请";
    [_confirmButton setTitle:@"提交申请" forState:UIControlStateNormal];
    _dismissBtn.hidden = NO;
    CGRect frame = self.frame;
    frame.origin.y += KSCAL(176);
    frame.size.height -= KSCAL(176);
    self.frame = frame;
    _inReason = NO;
    [_tableView reloadData];
}

- (UIButton *)accessView {
    UIButton *selectBtn = [UIButton new];
    [selectBtn setImage:[UIImage imageNamed:@"invoicetitle_circle"] forState:UIControlStateNormal];
    [selectBtn setImage:[UIImage imageNamed:@"invoicetitle_circle_selected"] forState:UIControlStateSelected];
    selectBtn.frame = CGRectMake(0, 0, KSCAL(86), KSCAL(88));
    selectBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [selectBtn addTarget:self action:@selector(click_selectBtn:) forControlEvents:UIControlEventTouchUpInside];
    return selectBtn;
}

#pragma mark -
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_inReason) {
        return _reasonArr.count;
    }
    return 2;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (_inReason) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reasonCell"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"reasonCell"];
            cell.textLabel.textColor = kCOLOR_333;
            cell.textLabel.font = KFONT(28);
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            if (!cell.accessoryView) {
                cell.accessoryView = [self accessView];
            }
        }
        UIButton *btn = (UIButton *)cell.accessoryView;
        btn.tag = indexPath.row;
        btn.selected = (_selectReasonIndex == indexPath.row);
        cell.textLabel.text = [_reasonArr objectAtIndex:indexPath.row];
        return cell;
    }
    
    if (indexPath.row == 0) {//选择原因
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"selectCell"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"selectCell"];
            cell.textLabel.textColor = kCOLOR_333;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.textLabel.font = KFONT(28);
            cell.detailTextLabel.font = KFONT(28);
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.textLabel.text = @"退款原因";
        }
        if (_reason.length) {
            cell.detailTextLabel.text = _reason;
            cell.detailTextLabel.textColor = kCOLOR_333;
        } else {
            cell.detailTextLabel.text = @"请选择";
            cell.detailTextLabel.textColor = kCOLOR_999;
        }
        return cell;
    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"priceCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"priceCell"];
        cell.textLabel.textColor = kCOLOR_333;
        cell.textLabel.font = KFONT(28);
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    if (_amountStr.length) {
        cell.textLabel.attributedText = _amountStr;
    } else {
        cell.textLabel.text = @"退款金额";
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0 && !_inReason) {
        [self intoReasonMode];
    }
}

@end
