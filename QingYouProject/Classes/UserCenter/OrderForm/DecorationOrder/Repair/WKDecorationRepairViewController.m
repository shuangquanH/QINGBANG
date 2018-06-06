//
//  WKDecorationRepairViewController.m
//  QingYouProject
//
//  Created by mac on 2018/6/4.
//  Copyright © 2018年 ccyouge. All rights reserved.
//

#import "WKDecorationRepairViewController.h"
#import "TZImagePickerController.h"

#import "TZTestCell.h"

const CGFloat kItemHorizontalMargin = 30;

@interface WKDecorationRepairViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, TZImagePickerControllerDelegate>

@property (nonatomic, strong) UIButton *confirmButton;

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) NSMutableArray<UIImage *> *repairImageArray;

@end

@implementation WKDecorationRepairViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.naviTitle = @"我要补登";
    self.repairImageArray = [NSMutableArray array];
    [self setupSubviews];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    [_confirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        
        if (@available(iOS 11.0, *)) {
            make.bottom.mas_equalTo(-self.view.safeAreaInsets.bottom);
        }
        else {
            make.bottom.mas_equalTo(-self.view.layoutMargins.bottom);
        }
    }];
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.bottom.equalTo(self.confirmButton.mas_top);
        make.top.mas_equalTo(KSCAL(120));
    }];
}

- (void)setupSubviews {
    _confirmButton = [UIButton new];
    [_confirmButton setBackgroundColor:[UIColor redColor]];
    [_confirmButton setTitle:@"提交" forState:UIControlStateNormal];
    [_confirmButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.view addSubview:_confirmButton];
    
    CGFloat itemW = (kScreenW - 4 * KSCAL(kItemHorizontalMargin)) / 3.0;
    
    UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
    layout.itemSize = CGSizeMake(itemW, itemW);
    layout.sectionInset = UIEdgeInsetsMake(15, KSCAL(kItemHorizontalMargin), 0, KSCAL(kItemHorizontalMargin));
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.backgroundColor = [UIColor whiteColor];
    _collectionView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    [_collectionView registerClass:[TZTestCell class] forCellWithReuseIdentifier:@"TZTestCell"];
    [self.view addSubview:_collectionView];
}

- (void)pushImagePickerController {
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
    return self.repairImageArray.count == 5 ? self.repairImageArray.count : self.repairImageArray.count + 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TZTestCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TZTestCell" forIndexPath:indexPath];
    if (indexPath.item >= self.repairImageArray.count) {
        cell.imageView.image = [UIImage imageNamed:@"steward_snapshot_addphotos"];
        cell.deleteBtn.hidden = YES;
    }
    else {
        cell.deleteBtn.hidden = NO;
        cell.imageView.image = [self.repairImageArray objectAtIndex:indexPath.item];
    }
    return cell;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.item == self.repairImageArray.count) {
        [self pushImagePickerController];
    }
}

#pragma mark - TZImagePickerControllerDelegate
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto {
    [self.repairImageArray addObjectsFromArray:photos];
    [_collectionView reloadData];
}

@end
