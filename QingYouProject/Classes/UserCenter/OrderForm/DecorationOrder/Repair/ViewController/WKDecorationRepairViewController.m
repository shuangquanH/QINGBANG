//
//  WKDecorationRepairViewController.m
//  QingYouProject
//
//  Created by mac on 2018/6/4.
//  Copyright © 2018年 ccyouge. All rights reserved.
//

#import "WKDecorationRepairViewController.h"
#import "TZImagePickerController.h"
#import "WKDecorationRepairPhotoCell.h"

const CGFloat kItemHorizontalMargin = 10;

@interface WKDecorationRepairViewController ()<TZImagePickerControllerDelegate, UICollectionViewDelegate, UICollectionViewDataSource, WKDecorationRepairPhotoCellDelegate>

@property (nonatomic, strong) UILabel *topTipLabel;

@property (nonatomic, strong) UILabel *tipLabl;

@property (nonatomic, strong) UIButton *addPhotoBtn;

@property (nonatomic, strong) UIButton *confirmButton;

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) NSMutableArray<UIImage *> *repairImageArray;

@property (nonatomic, assign) NSInteger selectIndex;

@end

@implementation WKDecorationRepairViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.naviTitle = @"我要补登";
    self.repairImageArray = [NSMutableArray array];
    _selectIndex = -1;
    
    [self setupSubviews];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    [self makeContraints];
}

- (void)setupSubviews {
    
    self.view.backgroundColor = colorWithTable;
    
    _topTipLabel = [UILabel labelWithFont:KSCAL(30.0) textColor:kCOLOR_333 textAlignment:NSTextAlignmentCenter text:@"我已在线下完成付款，申请补登更新订单状态："];
    _topTipLabel.backgroundColor = kCOLOR_RGB(210, 211, 212);
    [self.view addSubview:_topTipLabel];
    
    _confirmButton = [UIButton buttonWithTitle:@"提交" titleFont:KSCAL(38) titleColor:[UIColor whiteColor] bgColor:KCOLOR_MAIN];
    [_confirmButton addTarget:self action:@selector(click_confirmButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_confirmButton];
    
    _tipLabl = [UILabel labelWithFont:KSCAL(38) textColor:kCOLOR_666 text:@"上传回执单"];
    [self.view addSubview:_tipLabl];
    
    _addPhotoBtn = [UIButton new];
    [_addPhotoBtn setBackgroundImage:[UIImage imageNamed:@"repair_bg_btn"] forState:UIControlStateNormal];
    [_addPhotoBtn setBackgroundImage:[UIImage imageNamed:@"repair_bg_btn"] forState:UIControlStateHighlighted];
    [_addPhotoBtn addTarget:self action:@selector(pushImagePickerController) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_addPhotoBtn];
    
    CGFloat itemW = (kScreenW - 4 * KSCAL(kItemHorizontalMargin) - 2 * KSCAL(30)) / 5.0;
    CGFloat itemH = KSCAL(240);
    UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
    layout.itemSize = CGSizeMake(itemW, itemH);
    layout.minimumInteritemSpacing = KSCAL(kItemHorizontalMargin);
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.backgroundColor = self.view.backgroundColor;
    [_collectionView registerClass:[WKDecorationRepairPhotoCell class] forCellWithReuseIdentifier:@"photoCell"];
    [self.view addSubview:_collectionView];
}

- (void)makeContraints {
    [_topTipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.right.mas_equalTo(0);
        make.height.mas_equalTo(KSCAL(110));
    }];
    
    [_tipLabl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_topTipLabel.mas_bottom).offset(KSCAL(130));
        make.centerX.mas_equalTo(0);
    }];
    
    [_addPhotoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.width.height.mas_equalTo(KSCAL(200));
        make.top.equalTo(_tipLabl.mas_bottom).offset(KSCAL(30));
    }];
    
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(KSCAL(30));
        make.top.equalTo(_addPhotoBtn.mas_bottom).offset(KSCAL(90));
        make.centerX.mas_equalTo(0);
        make.height.mas_equalTo(KSCAL(240));
    }];
    
    [_confirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.mas_equalTo(0);
        make.height.mas_equalTo(KSCAL(100));
    }];
}

- (void)click_confirmButton {
    
}

- (void)pushImagePickerController {

    if (self.repairImageArray.count == 5) {
        return;
    }
    
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:(5 - self.repairImageArray.count) columnNumber:4 delegate:self];
    imagePickerVc.allowTakePicture = YES; // 在内部显示拍照按钮
    imagePickerVc.allowPickingVideo = NO;
    imagePickerVc.allowPickingImage = YES;
    imagePickerVc.allowPickingOriginalPhoto = YES;
    imagePickerVc.sortAscendingByModificationDate = YES;
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        
    }];
    imagePickerVc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:imagePickerVc animated:YES completion:nil];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 5;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    WKDecorationRepairPhotoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"photoCell" forIndexPath:indexPath];
    cell.delegate = self;
    if (self.repairImageArray.count > indexPath.item) {
        cell.imageView.image = self.repairImageArray[indexPath.item];
    }
    else {
        cell.imageView.image = nil;
    }
    cell.photoSelect = (_selectIndex == indexPath.item);
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.item >= self.repairImageArray.count) return;
    if (indexPath.item == _selectIndex) return;
    
    _selectIndex = indexPath.item;
    WKDecorationRepairPhotoCell *cell = (WKDecorationRepairPhotoCell *)[collectionView cellForItemAtIndexPath:indexPath];
    cell.photoSelect = YES;
}

#pragma mark - WKDecorationRepairPhotoCellDelegate
- (void)photoCellDidClickDelete:(WKDecorationRepairPhotoCell *)photoCell {
    NSIndexPath *deleteIndexPath = [self.collectionView indexPathForCell:photoCell];
    if (deleteIndexPath) {
        [self.repairImageArray removeObjectAtIndex:deleteIndexPath.item];
        if (deleteIndexPath.item == _selectIndex) {
            if (!self.repairImageArray.count) {
                _selectIndex = -1;
            }
            else {
                _selectIndex = 0;
            }
        }
        [self.collectionView reloadData];
    }
}

#pragma mark - TZImagePickerControllerDelegate
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto {
    [self.repairImageArray insertObjects:photos atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, photos.count)]];
    if (_selectIndex == -1) {
        _selectIndex = 0;
    }
    [self.collectionView reloadData];
}

@end
