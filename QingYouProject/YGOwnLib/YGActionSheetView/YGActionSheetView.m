//
// Created by zhangkaifeng on 2017/10/19.
// Copyright (c) 2017 ccyouge. All rights reserved.
//

#import "YGActionSheetView.h"

#define ROW_HEIGHT 40

@implementation YGActionSheetView
{
    UITableView *_tableView;

    void(^_handler)(NSInteger selectedIndex, NSString *selectedString);
}

- (instancetype)initWithTitlesArray:(NSArray *)titlesArray handler:(void (^)(NSInteger selectedIndex, NSString *selectedString))handler
{
    self = [super init];
    if (self)
    {
        _titlesArray = titlesArray;
        _handler = handler;
        [self configUI];

    }
    return self;
}

+ (void)showAlertWithTitlesArray:(NSArray *)titlesArray handler:(void (^)(NSInteger selectedIndex, NSString *selectedString))handler
{
    YGActionSheetView *view = [[self alloc] initWithTitlesArray:titlesArray handler:handler];
    [view show];
}

- (void)setSelectedIndex:(int)selectedIndex
{
    _selectedIndex = selectedIndex;
    [_tableView reloadData];
}


- (void)handleTapBehind:(UITapGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateEnded){
        CGPoint location = [sender locationInView:nil];
        
        if (![_tableView pointInside:[_tableView convertPoint:location fromView:_tableView.window] withEvent:nil])
        {
            [_tableView.window removeGestureRecognizer:sender];
            [self dismiss];   
        }
    }
}

- (void)configUI
{
    self.frame = [UIScreen mainScreen].bounds;
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    UITapGestureRecognizer *  recognizerTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapBehind:)];
    [recognizerTap setNumberOfTapsRequired:1];
    recognizerTap.cancelsTouchesInView = NO;
    [[UIApplication sharedApplication].keyWindow addGestureRecognizer:recognizerTap];
    
    
    double height = _titlesArray.count * ROW_HEIGHT > YGScreenHeight / 3.0 ? YGScreenHeight / 3.0 : _titlesArray.count * ROW_HEIGHT;
    //tableview
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, (CGFloat) (YGScreenHeight - height), self.width, (CGFloat) height) style:UITableViewStylePlain];
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.tableFooterView = [UIView new];
    _tableView.rowHeight = ROW_HEIGHT;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = colorWithYGWhite;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self addSubview:_tableView];

    [self show];

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _titlesArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"xx"];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"xx"];
        cell.textLabel.textColor = colorWithBlack;
        cell.textLabel.font = [UIFont systemFontOfSize:YGFontSizeNormal];
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    if (indexPath.row == _selectedIndex)
    {
        cell.textLabel.textColor = colorWithMainColor;
    }
    else
    {
        cell.textLabel.textColor = colorWithBlack;
    }

    cell.textLabel.text = _titlesArray[(NSUInteger) indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_handler)
    {
        _handler(indexPath.row, _titlesArray[(NSUInteger) indexPath.row]);
        _handler = nil;
    }
    [self dismiss];
}

- (void)show
{
    [YGAppDelegate.window addSubview:self];

    self.alpha = 0;
    _tableView.y = YGScreenHeight;

    [UIView animateWithDuration:0.3 animations:^
    {
        self.alpha = 1;
        _tableView.y = YGScreenHeight - _tableView.height;
    }];
}

- (void)dismiss
{
    [UIView animateWithDuration:0.3 animations:^
    {
        self.alpha = 0;
        _tableView.y = YGScreenHeight;
    }                completion:^(BOOL finished)
    {
        [self removeFromSuperview];
    }];

}

@end
