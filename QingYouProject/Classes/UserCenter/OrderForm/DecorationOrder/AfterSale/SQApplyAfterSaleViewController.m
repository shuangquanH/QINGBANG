//
//  SQApplyAfterSaleViewController.m
//  QingYouProject
//
//  Created by mac on 2018/6/1.
//  Copyright © 2018年 ccyouge. All rights reserved.
//

#import "SQApplyAfterSaleViewController.h"
#import "SQAfterSaleListViewController.h"
#import "TZImagePickerController.h"

#import "TZTestCell.h"

@interface SQApplyAfterSaleViewController ()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UILabel *tipLabel;

@property (nonatomic, strong) UIButton *confirmButton;

@property (nonatomic, strong) UITextView *problemTV;

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) NSMutableArray<UIImage *> *afterSaleImageArray;

@end

@implementation SQApplyAfterSaleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.afterSaleImageArray = [NSMutableArray array];
    
    [self layoutNavigation];
    
    [self setupSubviews];
}

- (void)layoutNavigation {
    self.naviTitle = @"申请售后";

    UIBarButtonItem *rightBarButton = [self createBarbuttonWithNormalTitleString:@"售后记录" selectedTitleString:@"售后记录" selector:@selector(click_listButton)];
    self.navigationItem.rightBarButtonItem = rightBarButton;
    
}

- (void)setupSubviews {
    _confirmButton = [UIButton new];
    [_confirmButton setBackgroundColor:[UIColor redColor]];
    [_confirmButton setTitle:@"提交申请" forState:UIControlStateNormal];
    [_confirmButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.view addSubview:_confirmButton];
    
    _tipLabel = [UILabel labelWithFont:15.0 textColor:[UIColor blackColor] text:@"问题描述："];
    [_tipLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [self.view addSubview:_tipLabel];
    
    _problemTV = [UITextView new];
    [self.view addSubview:_problemTV];
    
    CGFloat itemW = (kScreenW - 4 * KSCAL(30)) / 3.0;
    UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
    layout.itemSize = CGSizeMake(itemW, itemW);
    layout.sectionInset = UIEdgeInsetsMake(15, KSCAL(30), 0, KSCAL(30));
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.backgroundColor = [UIColor whiteColor];
    _collectionView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    [_collectionView registerClass:[TZTestCell class] forCellWithReuseIdentifier:@"TZTestCell"];
    [self.view addSubview:_collectionView];
    
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    

    [_confirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(55);
        if (@available(iOS 11.0, *)) {
            make.bottom.mas_equalTo(-self.view.safeAreaInsets.bottom);
        }
        else {
            make.bottom.mas_equalTo(-self.view.layoutMargins.bottom);
        }
    }];
    
    [_tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(15);
    }];
    
    [_problemTV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self->_tipLabel.mas_right);
        make.right.mas_equalTo(-15);
        make.top.equalTo(self->_tipLabel);
        make.height.mas_equalTo(100);
    }];

    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.equalTo(self.problemTV.mas_bottom).offset(KSCAL(30));
        make.bottom.equalTo(self.confirmButton.mas_top);
    }];
}

- (void)click_listButton {
    SQAfterSaleListViewController *next = [SQAfterSaleListViewController new];
    [self.navigationController pushViewController:next animated:YES];
}

- (void)pushImagePickerController {
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:(5 - self.afterSaleImageArray.count) columnNumber:4 delegate:nil];
    imagePickerVc.allowTakePicture = YES; // 在内部显示拍照按钮
    imagePickerVc.allowPickingVideo = NO;
    imagePickerVc.allowPickingImage = YES;
    imagePickerVc.allowPickingOriginalPhoto = YES;
    imagePickerVc.sortAscendingByModificationDate = YES;
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        [self.afterSaleImageArray addObjectsFromArray:photos];
        [self.collectionView reloadData];
    }];
    imagePickerVc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:imagePickerVc animated:YES completion:nil];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.afterSaleImageArray.count == 5 ? self.afterSaleImageArray.count : self.afterSaleImageArray.count + 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TZTestCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TZTestCell" forIndexPath:indexPath];
    if (indexPath.item >= self.afterSaleImageArray.count) {
        cell.imageView.image = [UIImage imageNamed:@"steward_snapshot_addphotos"];
        cell.deleteBtn.hidden = YES;
    }
    else {
        cell.deleteBtn.hidden = NO;
        cell.imageView.image = [self.afterSaleImageArray objectAtIndex:indexPath.item];
    }
    return cell;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.item == self.afterSaleImageArray.count) {
        [self pushImagePickerController];
    }
}

@end
