//
//  RoadShowHallAddVideoImageViewController.m
//  QingYouProject
//
//  Created by nefertari on 2017/11/13.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "RoadShowHallAddVideoImageViewController.h"
#import "TZImagePickerController.h"
#import "TZTestCell.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>
#import "LxGridViewFlowLayout.h"
#import "TZImageManager.h"
#import "TZVideoPlayerController.h"
#import "QiniuSDK.h"
#import "UploadImageTool.h"
#import "YGActionSheetView.h"
#import "GCMAssetModel.h"

@interface RoadShowHallAddVideoImageViewController ()<TZImagePickerControllerDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UITextViewDelegate,UIImagePickerControllerDelegate,UIActionSheetDelegate>
@property (nonatomic, strong) UICollectionView *collectionView;

@end

@implementation RoadShowHallAddVideoImageViewController
{
    NSMutableArray *_selectedPhotos;
    NSMutableArray *_selectedAssets;
    BOOL _isSelectOriginalPhoto;
    
    CGFloat _itemWH;
    CGFloat _margin;
    CGFloat _whiteViewHeight;
    NSString *_videoUrl;
    int    _profileCount;
    NSData *_videoData;
    UIImagePickerController *_picker;
    AVPlayer *_player;
    NSString *_videoPath;
    
    BOOL   _createVideo;
    GCMAssetModel *_model;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self configUI];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didFinishConvert:) name:@"uploadVideoSucces" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didFinishFialureConvert:) name:@"uploadVideoFialure" object:nil];
}

- (void)configAttribute
{
    self.navigationItem.rightBarButtonItem = [self createBarbuttonWithNormalTitleString:@"完成" selectedTitleString:@"完成" selector:@selector(finishChooseAction)];

    if ([self.pageType isEqualToString:@"plan"]) {
        self.naviTitle = @"上传商业计划书";
        _profileCount = 80 ;
    }else
    {
        self.naviTitle = @"上传视频资料";
        _profileCount = 1;
    }
    _selectedPhotos = [[NSMutableArray alloc] init];
_selectedAssets  = [[NSMutableArray alloc] init];
    
    _picker = [[UIImagePickerController alloc] init];//初始化
    _picker.delegate = (id)self;
    _createVideo = NO;


    
}
- (void)didFinishFialureConvert:(NSNotification *)notif
{
    if ([notif.userInfo[@"fialure"] isEqualToString:@"1"]) {
//        [YGAppTool showToastWithText:@"视频存储有问题"];
        return;
    }
}

- (void)didFinishConvert:(NSNotification *)notif
{
    [_selectedAssets removeAllObjects];
    [_selectedPhotos removeAllObjects];
    _videoData = notif.userInfo[@"data"];
    [_selectedAssets addObject:_videoUrl];
    UIImage *image = notif.userInfo[@"thumb"];
    [_selectedPhotos addObject:image];
    dispatch_sync(dispatch_get_main_queue(), ^{
        [_collectionView reloadData];
    });
}
- (void)configUI
{
    
    UIView *collectionHeaderView = [[UIView alloc]init];
    
    UILabel  *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10,10 , YGScreenWidth-20, 20)];
    titleLabel.text = @"诚聘业务员、业务经理";
    titleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.font = [UIFont systemFontOfSize:YGFontSizeBigOne];
    titleLabel.textColor = colorWithBlack;
    [collectionHeaderView addSubview:titleLabel];
    if ([self.pageType isEqualToString:@"plan"])
    {
        titleLabel.text = @"拍摄上传商业计划书资料";

    }else
    {
        titleLabel.text = @"请上传视频资料";

    }
    collectionHeaderView.frame = CGRectMake(0, 0, YGScreenHeight, titleLabel.y + titleLabel.height + 20);

    // 如不需要长按排序效果，将LxGridViewFlowLayout类改成UICollectionViewFlowLayout即可
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    _margin = 4;
    _itemWH = (YGScreenWidth - 2 * _margin - 4) / 3 - _margin;
    layout.itemSize = CGSizeMake(_itemWH, _itemWH);
    layout.minimumInteritemSpacing = _margin;
    layout.minimumLineSpacing = _margin;
    layout.headerReferenceSize = CGSizeMake(collectionHeaderView.width, collectionHeaderView.height);
    
    //collectionView
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, YGScreenWidth, YGScreenHeight - 64) collectionViewLayout:layout];
    _collectionView.scrollEnabled = YES;
    _collectionView.backgroundColor = colorWithYGWhite;
    _collectionView.contentInset = UIEdgeInsetsMake(0, 5, 0, 5);
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.showsVerticalScrollIndicator = NO;
    _collectionView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    [_collectionView registerClass:[TZTestCell class] forCellWithReuseIdentifier:@"TZTestCell"];
    [self.view addSubview:_collectionView];
    [_collectionView addSubview:collectionHeaderView];
    

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
    if ([self.pageType isEqualToString:@"plan"]) {
    
        return _selectedPhotos.count + 1;

    }else
    {
        return  1;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    TZTestCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TZTestCell" forIndexPath:indexPath];
    cell.videoImageView.hidden = YES;
    cell.hidden = NO;

    if (indexPath.row == _selectedPhotos.count || [_selectedPhotos[0] isKindOfClass:[NSString class]])
    {
      
//        if (_createVideo == YES) {
//            cell.imageView.image = _selectedPhotos[indexPath.row];
//            cell.deleteBtn.hidden = YES;
//        }else
//        {
            if (_selectedPhotos.count == _profileCount && _createVideo != YES && ![_selectedPhotos[0] isKindOfClass:[NSString class]])
            {
                cell.hidden = YES;
            }
            cell.imageView.image = [UIImage imageNamed:@"steward_snapshot_addphotos"];
            cell.deleteBtn.hidden = YES;
//        }

       
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
    if (indexPath.row == _selectedPhotos.count || [_selectedPhotos[0] isKindOfClass:[NSString class]])
    {
        if ([self.pageType isEqualToString:@"plan"])
        {
            [self pushImagePickerController];

        }else
        {
            if (_videoUrl == nil)
            {
                UIActionSheet *act = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"录制" otherButtonTitles:@"从手机选择", nil];
                [act showInView:self.view];
                
            }

        }
        
        
    }
    //预览
    else
    {
        if ([self.pageType isEqualToString:@"plan"])
        {
            _createVideo = NO;
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
        }else
        {
            if (_createVideo)
            {
                
            }else
            {
                if (_selectedAssets.count>0)
                {
                    TZAssetModel *model = [[TZAssetModel alloc] init];
                    model.type = TZAssetModelMediaTypeVideo;
                    model.asset = _selectedAssets[0];
                    TZVideoPlayerController *player = [[TZVideoPlayerController alloc] init];
                    player.model = model;
                    [self presentViewController:player animated:YES completion:nil];
                }

            }
        }
        
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
        if (buttonIndex == 1) {
            _createVideo = NO;
            TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:_profileCount columnNumber:4 delegate:self];
#pragma mark - 四类个性化设置，这些参数都可以不传，此时会走默认设置
            imagePickerVc.isSelectOriginalPhoto = _isSelectOriginalPhoto;
            if (![self.pageType isEqualToString:@"plan"]) {
                [_selectedAssets removeAllObjects];
            }
            imagePickerVc.selectedAssets = _selectedAssets; // 目前已经选中的图片数组
            imagePickerVc.allowTakePicture = YES; // 在内部显示拍照按钮
            
            // 2. Set the appearance
            // 2. 在这里设置imagePickerVc的外观
            //     imagePickerVc.navigationBar.barTintColor = [UIColor whiteColor];
            //     imagePickerVc.oKButtonTitleColorDisabled = [UIColor lightGrayColor];
            //     imagePickerVc.oKButtonTitleColorNormal = colorWithBlack;
            
            // 3. Set allow picking video & photo & originalPhoto or not
            // 3. 设置是否可以选择视频/图片/原图
            
            imagePickerVc.allowPickingVideo = YES;
            imagePickerVc.allowPickingImage = NO;
            
//            imagePickerVc.allowPickingOriginalPhoto = YES;
            
            // 4. 照片排列按修改时间升序
            imagePickerVc.sortAscendingByModificationDate = YES;
#pragma mark - 到这里为止
            
        
            // You can get the photos by block, the same as by delegate.
            // 你可以通过block或者代理，来得到用户选择的照片.
            [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
                
            }];
            [imagePickerVc setDidFinishPickingVideoHandle:^(UIImage *coverImage, id asset) {
                
            }];
            
            imagePickerVc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
            
            [self presentViewController:imagePickerVc animated:YES completion:nil];
            
        }
        if (buttonIndex == 0) {
            _createVideo = YES;
            _picker.sourceType = UIImagePickerControllerSourceTypeCamera;    //设置来源为摄像头
            _picker.cameraDevice = UIImagePickerControllerCameraDeviceRear; //设置使用的摄像头为：后置摄像头
            _picker.mediaTypes = @[(NSString *)kUTTypeMovie];    //设置为视频模式-<span style="color: rgb(51, 51, 51); font-family: Georgia, 'Times New Roman', Times, sans-serif; font-size: 14px; line-height: 25px;">注意媒体类型定义在MobileCoreServices.framework中</span>
            _picker.videoQuality = UIImagePickerControllerQualityTypeIFrame1280x720;   //设置视频质量
            _picker.cameraCaptureMode = UIImagePickerControllerCameraCaptureModeVideo;  //设置摄像头模式为录制视频
            [self presentViewController:_picker animated:YES completion:nil];
        }
}
#pragma mark-
#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];

    if([type isEqualToString:(NSString *)kUTTypeMovie]){
        //视频保存后 播放视频
        NSURL *url = [info objectForKey:UIImagePickerControllerMediaURL];
        _videoUrl = [url path];
        if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(_videoUrl))
        {
#define RandomNum (arc4random() % 9999999999999999)
            NSURL *videoURL=[info objectForKey:@"UIImagePickerControllerMediaURL"];
            //                [_picker dismissViewControllerAnimated:YES completion:^{
            _model = [[GCMAssetModel alloc] init];
            _model.fileName = [NSString stringWithFormat:@"%ld.mp4",RandomNum];
            _model.imageURL = videoURL;
            [_model convertVideoWithModel:_model];
            //        }];
            [picker dismissViewControllerAnimated:YES completion:nil];
            
        }
        //        [YGNetService showLoadingViewWithSuperView:YGAppDelegate.window];
        
    }
    
}

#pragma mark-
#pragma mark - share method
//视频保存后的回调
- (void)video:(NSString *)videoPath didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
    if (error) {
        NSLog(@"保存视频过程中发生错误，错误信息:%@",error.localizedDescription);
    }else{
        NSLog(@"视频保存成功.");
//        //录制完之后自动播放
//        NSURL *url=[NSURL fileURLWithPath:videoPath];
//        _videoPath = url;
//        _player=[AVPlayer playerWithURL:url];
//        AVPlayerLayer *playerLayer=[AVPlayerLayer playerLayerWithPlayer:_player];
//        playerLayer.frame = _collectionView.frame;
//        [_collectionView.layer addSublayer:playerLayer];
//        [_player play];
//
//
//        TZAssetModel *model = [[TZAssetModel alloc] init];
//        model.type = TZAssetModelMediaTypeVideo;
//        model.asset = _selectedAssets[0];
//        TZVideoPlayerController *player = [[TZVideoPlayerController alloc] init];
//        player.model = model;
//        [self presentViewController:player animated:YES completion:nil];
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
    
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:_profileCount columnNumber:4 delegate:self];
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
    if ([self.pageType isEqualToString:@"plan"])
    {
        imagePickerVc.allowPickingVideo = NO;
        imagePickerVc.allowPickingImage = YES;
    }else
    {
        imagePickerVc.allowPickingVideo = YES;
        imagePickerVc.allowPickingImage = NO;
    }
    imagePickerVc.allowPickingOriginalPhoto = YES;

    // 4. 照片排列按修改时间升序
    imagePickerVc.sortAscendingByModificationDate = YES;
#pragma mark - 到这里为止
    
    // You can get the photos by block, the same as by delegate.
    // 你可以通过block或者代理，来得到用户选择的照片.
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        
    }];
    [imagePickerVc setDidFinishPickingVideoHandle:^(UIImage *coverImage, id asset) {
        
    }];
    
    imagePickerVc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    
    [self presentViewController:imagePickerVc animated:YES completion:nil];
}


#pragma mark - TZImagePickerControllerDelegate

/// 用户点击了取消
 - (void)imagePickerControllerDidCancel:(TZImagePickerController *)picker {
 NSLog(@"cancel");
 }

// 这个照片选择器会自己dismiss，当选择器dismiss的时候，会执行下面的代理方法
// 如果isSelectOriginalPhoto为YES，表明用户选择了原图
// 你可以通过一个asset获得原图，通过这个方法：[[TZImageManager manager] getOriginalPhotoWithAsset:completion:]
// photos数组里的UIImage对象，默认是828像素宽，你可以通过设置photoWidth属性的值来改变它
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto
{
    [UIView animateWithDuration:0.3 animations:^{
        _collectionView.contentSize = CGSizeMake(0, ((_selectedPhotos.count + 2) / 3 ) * (_margin + _itemWH)+40);

    }];
    
    //    for(int i = 0; i < photos.count; i++)
    //    {
    //        NSData *data = nil;
    //        if(!UIImagePNGRepresentation(photos[i])) {
    //            data =UIImageJPEGRepresentation(photos[i],0.1);
    //        }else{
    //            data =UIImagePNGRepresentation(photos[i]);
    //        }
    //    }
    _selectedPhotos = [NSMutableArray arrayWithArray:photos];
    _selectedAssets = [NSMutableArray arrayWithArray:assets];
    _isSelectOriginalPhoto = isSelectOriginalPhoto;
    _collectionView.contentSize = CGSizeMake(0, ((_selectedPhotos.count + 2) / 3 ) * (_margin + _itemWH)+100);
    [_collectionView reloadData];

}


// If user picking a video, this callback will be called.
// If system version > iOS8,asset is kind of PHAsset class, else is ALAsset class.
// 如果用户选择了一个视频，下面的handle会被执行
// 如果系统版本大于iOS8，asset是PHAsset类的对象，否则是ALAsset类的对象
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingVideo:(UIImage *)coverImage sourceAssets:(id)asset {
    _selectedPhotos = [NSMutableArray arrayWithArray:@[coverImage]];
    _selectedAssets = [NSMutableArray arrayWithArray:@[asset]];
   
    [_collectionView reloadData];
     _collectionView.contentSize = CGSizeMake(0, ((_selectedPhotos.count + 2) / 3 ) * (_margin + _itemWH));
}
#pragma mark Click Event

- (void)deleteBtnClik:(UIButton *)sender {
    [_selectedPhotos removeObjectAtIndex:sender.tag];
    [_selectedAssets removeObjectAtIndex:sender.tag];
    if ([self.pageType isEqualToString:@"plan"]) {
        [_collectionView performBatchUpdates:^{
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:sender.tag inSection:0];
            [_collectionView deleteItemsAtIndexPaths:@[indexPath]];
        } completion:^(BOOL finished) {
            [_collectionView reloadData];
        }];
    }else
    {
        [_selectedPhotos addObject:@""];
        [_selectedAssets addObject:@""];
        _videoData = nil;
        _videoUrl = nil;

//        if ([_collectionView numberOfItemsInSection:0] == _selectedPhotos.count) {
            [_collectionView reloadData];
//        }else{
//            [self.collectionView deleteItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:0 inSection:0]]];
//        }
    }



}

// 设置了navLeftBarButtonSettingBlock后，需打开这个方法，让系统的侧滑返回生效
- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
    navigationController.interactivePopGestureRecognizer.enabled = YES;
    if (viewController != navigationController.viewControllers[0]) {
        navigationController.interactivePopGestureRecognizer.delegate = nil; // 支持侧滑
    }
}

- (void)finishChooseAction
{
    if ([self.pageType isEqualToString:@"plan"])
    {
        [self.delegate selectVideoImagesWithArray:_selectedPhotos];
        YGSingletonMarco.roadShowHallAddImageViewController = self;
        [self.navigationController popViewControllerAnimated:YES];
        
    }else
    {
        
  
        if (_createVideo == YES)
        {
            if (_videoUrl == nil) {
                [YGAppTool showToastWithText:@"请先选择或者录制视频"];
                return;
            }
            
            if (_videoData == nil) {
                [YGNetService showLoadingViewWithSuperView:self.view];
                GCMAssetModel *model = [[GCMAssetModel alloc] init];
                model.imageURL = [NSURL URLWithString:_videoUrl];
                model.fileName = @"roadshowvideo";
                [model convertVideoWithModel:model];
            }else
            {
                [self.delegate takeBackWithCoverImage:_selectedPhotos[0] andVideoData:_videoData];
                YGSingletonMarco.roadShowHallAddVideoViewController = self;
                [self.navigationController popViewControllerAnimated:YES];
            }

            
        }else
        {
            if (_selectedAssets == nil || _selectedAssets.count == 0) {
                [YGAppTool showToastWithText:@"请先选择或者录制视频"];
                return;
            }
            // open this code to send video / 打开这段代码发送视频
            [[TZImageManager manager] getVideoOutputPathWithAsset:_selectedAssets[0] completion:^(NSString *outputPath) {
                // NSLog(@"视频导出到本地完成,沙盒路径为:%@",outputPath);
                // Export completed, send video here, send by outputPath or NSData
                // 导出完成，在这里写上传代码，通过路径或者通过NSData上传
                NSData *data = [NSData dataWithContentsOfFile:outputPath];

                _videoData = data;
                
                [self.delegate takeBackWithCoverImage:_selectedPhotos[0] andVideoData:_videoData];
                YGSingletonMarco.roadShowHallAddVideoViewController = self;
                [self.navigationController popViewControllerAnimated:YES];
            }];
        }
    }


}
@end
