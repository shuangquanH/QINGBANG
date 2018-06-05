//
//  GoodsCommentViewController.m
//  QingYouProject
//
//  Created by LDSmallCat on 2017/10/24.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "GoodsCommentViewController.h"
#import "TZImagePickerController.h"
#import "TZTestCell.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>
#import "LxGridViewFlowLayout.h"
#import "TZImageManager.h"
#import "TZVideoPlayerController.h"
#import "FileMD5Hash.h"
#import "AESCrypt.h"
#import "QiniuSDK.h"
#import "UploadImageTool.h"
#import "YGActionSheetView.h"

@interface GoodsCommentViewController ()<TZImagePickerControllerDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UITextViewDelegate> {
    NSMutableArray *_selectedPhotos;
    NSMutableArray *_selectedAssets;
    BOOL _isSelectOriginalPhoto;
    UIScrollView *_scrollView;
    UIView *_whiteView;
    UILabel *_tipLabel; //图片最多9张哦
    
    CGFloat _itemWH;
    CGFloat _margin;
    CGFloat _whiteViewHeight;
    
    NSMutableArray *_tokenArray;
    
}
@property (nonatomic, strong) UICollectionView *collectionView;
@property(nonatomic,strong)UITextView *detailTextView;//描述

@end

@implementation GoodsCommentViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    //导航栏设置
    [self setupNav];

    //UI设置
    [self setupUI];
}

#pragma mark - 绘制UI

//绘制UI
-(void)setupUI
{
    self.view.backgroundColor = colorWithTable;
    
    _scrollView = [[UIScrollView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    _scrollView.alwaysBounceVertical = YES;
    _scrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_scrollView];
    
    _whiteView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, YGScreenWidth, 0)];
    _whiteView.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:_whiteView];
    
    UIView *collectionHeaderView = [[UIView alloc]init];
    
    self.detailTextView = [[UITextView alloc]initWithFrame:CGRectMake(0, 10, YGScreenWidth - 10, 130)];
    self.detailTextView.font = [UIFont systemFontOfSize:YGFontSizeBigOne];
    self.detailTextView.delegate = self;
    self.detailTextView.tag = 997;
    [collectionHeaderView addSubview:self.detailTextView];
    
    UILabel *placeHolderLabel = [[UILabel alloc]initWithFrame:CGRectMake(3, 8, self.detailTextView.width, 14)];
    placeHolderLabel.text = @"说点什么吧...";
    placeHolderLabel.textColor = colorWithLightGray;
    //    placeHolderLabel.textColor = countLabel.textColor;
    placeHolderLabel.font = self.detailTextView.font;
    placeHolderLabel.tag = 998;
    [self.detailTextView addSubview:placeHolderLabel];
    collectionHeaderView.frame = CGRectMake(0, 0, YGScreenHeight, self.detailTextView.y + self.detailTextView.height + 20);
    
    // 如不需要长按排序效果，将LxGridViewFlowLayout类改成UICollectionViewFlowLayout即可
    LxGridViewFlowLayout *layout = [[LxGridViewFlowLayout alloc] init];
    _margin = 4;
    _itemWH = (YGScreenWidth - 2 * _margin - 4) / 3 - _margin;
    layout.itemSize = CGSizeMake(_itemWH, _itemWH);
    layout.minimumInteritemSpacing = _margin;
    layout.minimumLineSpacing = _margin;
    layout.headerReferenceSize = CGSizeMake(collectionHeaderView.width, collectionHeaderView.height);
    
    //collectionView
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, YGScreenWidth, YGScreenHeight - 64) collectionViewLayout:layout];
    _collectionView.scrollEnabled = NO;
    _collectionView.backgroundColor = [UIColor clearColor];
    _collectionView.contentInset = UIEdgeInsetsMake(0, 5, 0, 5);
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.showsVerticalScrollIndicator = NO;
    _collectionView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    [_collectionView registerClass:[TZTestCell class] forCellWithReuseIdentifier:@"TZTestCell"];
    [_scrollView addSubview:_collectionView];
    [_collectionView addSubview:collectionHeaderView];
    
    _whiteViewHeight = layout.headerReferenceSize.height + layout.itemSize.height + 30;
    _whiteView.height = _whiteViewHeight;
    
    _tipLabel = [[UILabel alloc]initWithFrame:CGRectMake((YGScreenWidth - 40) / 3 + 20, _whiteView.height - 54, 120, 14)];
//    _tipLabel.text = @"图片最多3张哦";
    _tipLabel.hidden = NO;
    _tipLabel.font = [UIFont systemFontOfSize:14.0];
    _tipLabel.textAlignment = NSTextAlignmentLeft;
    _tipLabel.textColor = colorWithLightGray;
    _tipLabel.font = self.detailTextView.font;
    [_whiteView addSubview:_tipLabel];

}
//转换image数组存到本地然后返回路径数组
- (NSString *)conventImageToLocalImage:(UIImage *)image name:(NSString *)name
{
    NSData *data = UIImageJPEGRepresentation(image, 1);
    //这里将图片放在沙盒的documents文件夹中
    NSString * DocumentsPath = [NSTemporaryDirectory() stringByAppendingPathComponent:@"tempimg"];
    //文件管理器
    NSFileManager *fileManager = [NSFileManager defaultManager];
    //把刚刚图片转换的data对象拷贝至沙盒中 并保存为image.png
    [fileManager createDirectoryAtPath:DocumentsPath withIntermediateDirectories:YES attributes:nil error:nil];
    [fileManager createFileAtPath:[DocumentsPath stringByAppendingPathComponent:name] contents:data attributes:nil];
    //得到选择后沙盒中图片的完整路径
    return [NSString stringWithFormat:@"%@/%@",DocumentsPath,name];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _selectedPhotos.count + 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    TZTestCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TZTestCell" forIndexPath:indexPath];
    cell.videoImageView.hidden = YES;
    cell.hidden = NO;
    if (_selectedPhotos.count == 0) {
        _tipLabel.hidden = NO;
    }else
    {
        _tipLabel.hidden = YES;
    }
    if (indexPath.row == _selectedPhotos.count)
    {
        if (_selectedPhotos.count == 3)
        {
            cell.hidden = YES;
        }
        cell.imageView.image = [UIImage imageNamed:@"steward_snapshot_addphotos"];
        cell.deleteBtn.hidden = YES;
    }
    else
    {
        cell.imageView.image = _selectedPhotos[indexPath.row];
        cell.asset = _selectedAssets[indexPath.row];
        cell.deleteBtn.hidden = NO;
    }
    cell.deleteBtn.tag = indexPath.row;
    [cell.deleteBtn addTarget:self action:@selector(deleteBtnClik:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    //如果是最后一个 添加
    if (indexPath.row == _selectedPhotos.count)
    {
        [self pushImagePickerController];
        
    }
    //预览
    else
    {
        TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithSelectedAssets:_selectedAssets selectedPhotos:_selectedPhotos index:indexPath.row];
        imagePickerVc.allowPickingOriginalPhoto = YES;
        imagePickerVc.isSelectOriginalPhoto = _isSelectOriginalPhoto;
        [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
            _selectedPhotos = [NSMutableArray arrayWithArray:photos];
            _selectedAssets = [NSMutableArray arrayWithArray:assets];
            _isSelectOriginalPhoto = isSelectOriginalPhoto;
            [_collectionView reloadData];
            _collectionView.contentSize = CGSizeMake(0, ((_selectedPhotos.count + 2) / 3 ) * (_margin + _itemWH));
        }];
        imagePickerVc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [self presentViewController:imagePickerVc animated:YES completion:nil];
    }
}

#pragma mark - LxGridViewDataSource

/// 以下三个方法为长按排序相关代码
- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath
{
    return indexPath.item < _selectedPhotos.count;
}

- (BOOL)collectionView:(UICollectionView *)collectionView itemAtIndexPath:(NSIndexPath *)sourceIndexPath canMoveToIndexPath:(NSIndexPath *)destinationIndexPath
{
    return (sourceIndexPath.item < _selectedPhotos.count && destinationIndexPath.item < _selectedPhotos.count);
}

- (void)collectionView:(UICollectionView *)collectionView itemAtIndexPath:(NSIndexPath *)sourceIndexPath didMoveToIndexPath:(NSIndexPath *)destinationIndexPath
{
    UIImage *image = _selectedPhotos[sourceIndexPath.item];
    [_selectedPhotos removeObjectAtIndex:sourceIndexPath.item];
    [_selectedPhotos insertObject:image atIndex:destinationIndexPath.item];
    
    id asset = _selectedAssets[sourceIndexPath.item];
    [_selectedAssets removeObjectAtIndex:sourceIndexPath.item];
    [_selectedAssets insertObject:asset atIndex:destinationIndexPath.item];
    
    [_collectionView reloadData];
}

#pragma mark - TZImagePickerController

- (void)pushImagePickerController
{
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:3 columnNumber:4 delegate:self];
#pragma mark - 四类个性化设置，这些参数都可以不传，此时会走默认设置
    imagePickerVc.isSelectOriginalPhoto = _isSelectOriginalPhoto;
    imagePickerVc.selectedAssets = _selectedAssets; // 目前已经选中的图片数组
    imagePickerVc.allowTakePicture = YES; // 在内部显示拍照按钮
    
    // 2. Set the appearance
    // 2. 在这里设置imagePickerVc的外观
    //     imagePickerVc.navigationBar.barTintColor = [UIColor whiteColor];
    //     imagePickerVc.oKButtonTitleColorDisabled = [UIColor lightGrayColor];
    //     imagePickerVc.oKButtonTitleColorNormal = colorWithBlack;
    
    // 3. Set allow picking video & photo & originalPhoto or not
    // 3. 设置是否可以选择视频/图片/原图
    imagePickerVc.allowPickingVideo = NO;
    imagePickerVc.allowPickingImage = YES;
    imagePickerVc.allowPickingOriginalPhoto = YES;
    
    // 4. 照片排列按修改时间升序
    imagePickerVc.sortAscendingByModificationDate = YES;
#pragma mark - 到这里为止
    
    // You can get the photos by block, the same as by delegate.
    // 你可以通过block或者代理，来得到用户选择的照片.
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        
    }];
    imagePickerVc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:imagePickerVc animated:YES completion:nil];
}


#pragma mark - TZImagePickerControllerDelegate

/// 用户点击了取消
// - (void)imagePickerControllerDidCancel:(TZImagePickerController *)picker {
// NSLog(@"cancel");
// }

// 这个照片选择器会自己dismiss，当选择器dismiss的时候，会执行下面的代理方法
// 如果isSelectOriginalPhoto为YES，表明用户选择了原图
// 你可以通过一个asset获得原图，通过这个方法：[[TZImageManager manager] getOriginalPhotoWithAsset:completion:]
// photos数组里的UIImage对象，默认是828像素宽，你可以通过设置photoWidth属性的值来改变它
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto
{
    [UIView animateWithDuration:0.3 animations:^{
        if (photos.count >2)
        {
//            int count = (photos.count < 3)?0:((photos.count <6)?1:2);
            
            _whiteView.height = _whiteViewHeight  + _margin;
        }
        else
        {
            _whiteView.height = _whiteViewHeight;
        }
    }];
    
    _selectedPhotos = [NSMutableArray arrayWithArray:photos];
    _selectedAssets = [NSMutableArray arrayWithArray:assets];
    _isSelectOriginalPhoto = isSelectOriginalPhoto;
    [_collectionView reloadData];
    _scrollView.contentSize = CGSizeMake(YGScreenWidth, _whiteView.height);
    _collectionView.frame = CGRectMake(0, 0, YGScreenWidth, _whiteView.height);
    _collectionView.contentSize = CGSizeMake(YGScreenWidth, _whiteView.height);
}


#pragma mark Click Event

- (void)deleteBtnClik:(UIButton *)sender {
    [_selectedPhotos removeObjectAtIndex:sender.tag];
    [_selectedAssets removeObjectAtIndex:sender.tag];
    
    [UIView animateWithDuration:0.3 animations:^{
        if (_selectedPhotos.count >2)
        {
            _whiteView.height = _whiteViewHeight + _itemWH + _margin;
        }
        else
        {
            _whiteView.height = _whiteViewHeight;
        }
    }];
    _scrollView.contentSize = CGSizeMake(YGScreenWidth, _whiteView.height+160);
    
    [_collectionView performBatchUpdates:^{
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:sender.tag inSection:0];
        [_collectionView deleteItemsAtIndexPaths:@[indexPath]];
    } completion:^(BOOL finished) {
        [_collectionView reloadData];
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (void)textViewDidChange:(UITextView *)textView
{
    //    UILabel *countLabel = [self.view viewWithTag:999];
    UILabel *placeHolderLabel = [self.view viewWithTag:998];
    //    countLabel.text = [NSString stringWithFormat:@"%lu/200", (unsigned long)textView.text.length];
    if (textView.text.length == 0)
    {
        placeHolderLabel.hidden = NO;
    }
    else
    {
        placeHolderLabel.hidden = YES;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 导航条设置
- (void)setupNav{
    self.view.backgroundColor = LDRandomColor;
    self.naviTitle = @"发布评价";
    
    // 右边按钮
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem backItemWithimage:nil highImage:nil target:self action:@selector(rightBarButtonClick:) title:@"发布" normalColor:LDMainColor highColor:LDMainColor titleFont:LDFont(14)];
}
#pragma mark - rightBarButtonClick
- (void)rightBarButtonClick:(UIButton *)rightBarButton{
    
    if(!self.detailTextView.text.length)
    {
        [YGAppTool showToastWithText:@"请填写评价哦"];
        return;
    }
    if(self.detailTextView.text.length >150)
    {
        [YGAppTool showToastWithText:@"评价不能超过150字哦"];
        return;
    }
    
    if (_selectedPhotos.count == 0)
    {
        [YGAppTool showToastWithText:@"请至少选择一张图片上传哦"];
        return;
    }
    
    [UploadImageTool uploadImages:_selectedPhotos progress:^(CGFloat progress) {
        
    } success:^(NSArray *urlArray) {
        
        NSString * urlStr = @"";
        for(int i=0;i<urlArray.count;i++)
        {
            if(i==0)
                urlStr = urlArray[i];
            else
                urlStr = [urlStr stringByAppendingString:[NSString stringWithFormat:@",%@",urlArray[i]]];
        }
        
        [YGNetService YGPOST:@"ProcurementOrderComment" parameters:@{@"userID":YGSingletonMarco.user.userId,@"commodityID":self.commodityID,@"context":self.detailTextView.text,@"img":urlStr} showLoadingView:YES scrollView:nil success:^(id responseObject) {
            
            [YGAppTool showToastWithText:@"您的评价提交成功"];

            [[NSNotificationCenter defaultCenter]postNotificationName:@"OfficePurchaseOrderSurePay" object:nil userInfo:nil];

            if([self.isPush isEqualToString:@"list"])
            {
                [self.navigationController popViewControllerAnimated:YES];
            }
            else
            {
                [self.navigationController popToViewController:self.navigationController.viewControllers[self.navigationController.viewControllers.count- 3] animated:YES];
            }
            
        } failure:^(NSError *error) {
            NSLog(@"提交失败");
        }];
        
        
    } failure:^{
        NSLog(@"传图失败");
    }];

}
-(void)back
{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"OfficePurchaseOrderSurePay" object:nil userInfo:nil];
    
    if([self.isPush isEqualToString:@"list"])
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        [self.navigationController popToViewController:self.navigationController.viewControllers[self.navigationController.viewControllers.count- 3] animated:YES];
    }
}
@end
