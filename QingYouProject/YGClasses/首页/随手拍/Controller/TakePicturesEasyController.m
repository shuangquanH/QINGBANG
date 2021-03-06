//
//  TakePicturesEasyController.m
//  QingYouProject
//
//  Created by zhaoao on 2017/10/17.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "TakePicturesEasyController.h"
#import "TZImagePickerController.h"
#import "TZTestCell.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>
#import "LxGridViewFlowLayout.h"
#import "TZImageManager.h"
#import "TZVideoPlayerController.h"
#import "FileMD5Hash.h"
#import "AESCrypt.h"
#import "TakePicturesSubmitSuccessController.h"
#import "TakePicturesStatusController.h"
#import "TakePicturesOrderListController.h"
#import "QiniuSDK.h"
#import "UploadImageTool.h"
#import "YGActionSheetView.h"

@interface TakePicturesEasyController ()<TZImagePickerControllerDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UITextViewDelegate> {
    NSMutableArray *_selectedPhotos; //选择的图片
    NSMutableArray *_selectedAssets; //相册里选中的图片数组
    BOOL _isSelectOriginalPhoto;
    UIScrollView *_scrollView;
    UIView *_whiteView;
    UILabel *_tipLabel; //图片最多9张哦
    
    CGFloat _itemWH;
    CGFloat _margin; //边缘
    CGFloat _whiteViewHeight;
    
    NSMutableArray *_tokenArray;
    
}
@property (nonatomic, strong) UICollectionView *collectionView;
@property(nonatomic,strong)UITextView *detailTextView;//描述
@property(nonatomic,strong)UILabel *chooseAreaLabel;//选择的区域
@property(nonatomic,strong)UITextField *phoneTextField;//手机
@property(nonatomic,strong)UITextField *peopleTextField;//联系人
@property(nonatomic,strong)NSString *areaString;//园区string

@end

@implementation TakePicturesEasyController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIButton *submitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    submitButton.frame = CGRectMake(0, 0, 35, 35);
    [submitButton setTitleColor:colorWithMainColor forState:UIControlStateNormal];
    [submitButton setTitle:@"提交" forState:normal];
    submitButton.titleLabel.font = [UIFont systemFontOfSize:15.0];
    [submitButton addTarget:self action:@selector(submitInfo:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightButtonItem = [[UIBarButtonItem alloc] initWithCustomView:submitButton];
    self.navigationItem.rightBarButtonItem = rightButtonItem;    
    
    [self configUI];
}

-(void)configAttribute
{
    self.naviTitle = @"随手拍";
//    [self configNaviWithNaviTitle:@"发布状态" containBackButton:YES];
}

//-(void)back
//{
//    [self dismissViewControllerAnimated:YES completion:nil];
//}

//绘制UI
-(void)configUI
{
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, YGScreenWidth, YGScreenHeight - YGNaviBarHeight - YGStatusBarHeight)];
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
    
//    UILabel *countLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, detailTextView.height-14,detailTextView.width, 14)];
//    countLabel.text = @"0/200";
//    countLabel.textAlignment = NSTextAlignmentRight;
//    countLabel.tag = 999;
//    countLabel.textColor = colorWithLightGray;
//    countLabel.font = detailTextView.font;
//    [detailTextView addSubview:countLabel];
    
    
    UILabel *placeHolderLabel = [[UILabel alloc]initWithFrame:CGRectMake(3, 8, self.detailTextView.width, 14)];
    placeHolderLabel.text = @"您的监督是我们前进的动力";
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
    _tipLabel.text = @"图片最多9张哦";
    _tipLabel.hidden = NO;
    _tipLabel.font = [UIFont systemFontOfSize:14.0];
    _tipLabel.textAlignment = NSTextAlignmentLeft;
    _tipLabel.textColor = colorWithLightGray;
    _tipLabel.font = self.detailTextView.font;
    [_whiteView addSubview:_tipLabel];
    
    UIView *bottomView = [[UIView alloc]init];
    bottomView.backgroundColor = [UIColor whiteColor];
    [_collectionView addSubview:bottomView];
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_whiteView.mas_bottom).offset(10);
        make.left.mas_equalTo(self.view).offset(0);
        make.right.mas_equalTo(self.view).offset(0);
        make.height.mas_equalTo(150);
    }];
    
    
    UIView *areaView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, YGScreenWidth, 50)];
    UILabel *lineLabel1 = [[UILabel alloc]initWithFrame:CGRectMake(0, 49, YGScreenWidth, 1)];
    lineLabel1.backgroundColor = colorWithLine;
    lineLabel1.text = @"";
    [areaView addSubview:lineLabel1];
    UILabel *areaLabel = [[UILabel alloc]initWithFrame:CGRectMake(14, 0, 80, 50)];
    areaLabel.text = @"发现区域";
    areaLabel.font = [UIFont systemFontOfSize:15.0];
    areaLabel.textColor = colorWithDeepGray;
    self.chooseAreaLabel = [[UILabel alloc]initWithFrame:CGRectMake(100, 0, YGScreenWidth - 130, 50)];
    self.chooseAreaLabel.text = @"请选择区域";
    self.chooseAreaLabel.font = [UIFont systemFontOfSize:14.0];
    self.chooseAreaLabel.textAlignment = NSTextAlignmentRight;
    self.chooseAreaLabel.textColor = [UIColor lightGrayColor];
    UIImageView *accessImageView = [[UIImageView alloc]initWithFrame:CGRectMake(YGScreenWidth - 30, 17, 15, 16)];
    accessImageView.image = [UIImage imageNamed:@"unfold_btn_gray"];
    UIButton *areaButton = [UIButton buttonWithType:UIButtonTypeCustom];
    areaButton.frame = CGRectMake(0, 0, YGScreenWidth, 50);
    [areaButton addTarget:self action:@selector(chooseArea:) forControlEvents:UIControlEventTouchUpInside];
    [areaButton setTitle:@"" forState:UIControlStateNormal];
    [areaView addSubview:areaButton];
    [areaView addSubview:accessImageView];
    [areaView addSubview:self.chooseAreaLabel];
    [areaView addSubview:areaLabel];
    [bottomView addSubview:areaView];
    
    UIView *phoneView = [[UIView alloc]initWithFrame:CGRectMake(0, 50, YGScreenWidth, 50)];
    UILabel *lineLabel2 = [[UILabel alloc]initWithFrame:CGRectMake(0, 99, YGScreenWidth, 1)];
    lineLabel2.backgroundColor = colorWithLine;
    lineLabel2.text = @"";
    [areaView addSubview:lineLabel2];
    UILabel *phoneLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, 65, 50)];
    phoneLabel.text = @"您的手机";
    phoneLabel.font = [UIFont systemFontOfSize:15.0];
    phoneLabel.textColor = colorWithDeepGray;
    self.phoneTextField = [[UITextField alloc]initWithFrame:CGRectMake(90, 0, YGScreenWidth - 100, 50)];
    self.phoneTextField.placeholder = @"请如实填写便于第一时间联系处理";
    self.phoneTextField.font = [UIFont systemFontOfSize:14.0];
    self.phoneTextField.keyboardType = UIKeyboardTypePhonePad;
    self.phoneTextField.textAlignment = NSTextAlignmentRight;
    UIButton *phoneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    phoneButton.frame = CGRectMake(0, 0, YGScreenWidth, 50);
    [phoneButton setTitle:@"" forState:UIControlStateNormal];
    [phoneView addSubview:phoneButton];
    [phoneView addSubview:self.phoneTextField];
    [phoneView addSubview:phoneLabel];
    [bottomView addSubview:phoneView];
    
    UIView *peopleView = [[UIView alloc]initWithFrame:CGRectMake(0, 100, YGScreenWidth, 50)];
    UILabel *peopleLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, 65, 50)];
    peopleLabel.text = @"联系人";
    peopleLabel.font = [UIFont systemFontOfSize:15.0];
    peopleLabel.textColor = colorWithDeepGray;
    self.peopleTextField = [[UITextField alloc]initWithFrame:CGRectMake(90, 0, YGScreenWidth - 100, 50)];
    self.peopleTextField.placeholder = @"请输入姓名";
    self.peopleTextField.font = [UIFont systemFontOfSize:14.0];
    self.peopleTextField.textAlignment = NSTextAlignmentRight;
    UIButton *peopleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    peopleButton.frame = CGRectMake(0, 0, YGScreenWidth, 50);
    [peopleButton setTitle:@"" forState:UIControlStateNormal];
    [peopleView addSubview:peopleButton];
    [peopleView addSubview:self.peopleTextField];
    [peopleView addSubview:peopleLabel];
    [bottomView addSubview:peopleView];
    
}
////发送状态
//-(void)finishButtonClick
//{
//    UITextView *detailTextView = [_collectionView viewWithTag:997];
//    if (![YGAppTool isVerifiedWithText:detailTextView.text name:@"状态" maxLength:200 minLength:1 shouldEmpty:NO])
//    {
//        return;
//    }
//
//    if (_selectedPhotos.count == 0)
//    {
//        [YGAppTool showToastWithText:@"请至少选择一张图片上传哦"];
//        return;
//    }
//    NSDictionary *parame = @{@"userid":YGSingletonMarco.user.userid,@"title":detailTextView.text};
//
//    [YGNetService YGPOST:REQUEST_PUSHSTATUS parameters:nil showLoadingView:YES controller:self constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
//        for (int i = 0; i<_selectedPhotos.count; i++)
//        {
//            //写入沙盒拿到路径
//            NSString *path = [self conventImageToLocalImage:_selectedPhotos[i] name:[NSString stringWithFormat:@"mystatus%d.jpg",i]];
//            //通过路径拿到md5
//            NSString *md5 = [FileMD5Hash computeMD5HashOfFileInPath:path];
//            //通过路径拿到data
//            NSData *imgData = [[NSData alloc]initWithContentsOfFile:path];
//            [formData appendPartWithFileData:imgData name:md5 fileName:@"mystatus.jpg" mimeType:@"image/jpg"];
//            //插入完删除掉
//            [[NSFileManager defaultManager]removeItemAtPath:path error:nil];
//        }
//        NSData *jsonData = [[NSData getEncryptValueWithDic:parame] dataUsingEncoding:NSUTF8StringEncoding];
//        [formData appendPartWithFormData:jsonData name:@"data"];
//
//    } success:^(id responseObject) {
//        [YGAppTool showToastWithText:@"发布状态成功"];
//        [self dismissViewControllerAnimated:YES completion:nil];
//    } failure:nil];
//}

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
        if (_selectedPhotos.count == 9)
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
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:9 columnNumber:4 delegate:self];
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
            int count = (photos.count < 3)?0:((photos.count <6)?1:2);
            
            _whiteView.height = _whiteViewHeight + _itemWH * count + _margin;
            
        }
        else
        {
            _whiteView.height = _whiteViewHeight;
        }
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
    [_collectionView reloadData];
    _scrollView.contentSize = CGSizeMake(YGScreenWidth, _whiteView.height+224);
    _collectionView.frame = CGRectMake(0, 0, YGScreenWidth, _whiteView.height+224);
    _collectionView.contentSize = CGSizeMake(YGScreenWidth, _whiteView.height+224);
}


#pragma mark Click Event

- (void)deleteBtnClik:(UIButton *)sender {
    [_selectedPhotos removeObjectAtIndex:sender.tag];
    [_selectedAssets removeObjectAtIndex:sender.tag];
    
    [UIView animateWithDuration:0.3 animations:^{
        if (_selectedPhotos.count >2)
        {
             int count = (_selectedPhotos.count < 3)?0:((_selectedPhotos.count <6)?1:2);
            
            _whiteView.height = _whiteViewHeight + _itemWH * count + _margin;
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

-(void)chooseArea:(UIButton *)button
{
    button.userInteractionEnabled = NO;
    [YGNetService YGPOST:@"ChooseGarden" parameters:@{} showLoadingView:NO scrollView:nil success:^(id responseObject) {
        button.userInteractionEnabled = YES;

        NSLog(@"%@",responseObject);
        
        NSArray *listArray = [NSArray array];
        listArray = [responseObject valueForKey:@"list"];
        NSMutableArray *showMutableArray = [NSMutableArray array];
        for (int i = 0; i < listArray.count; i++) {
            [showMutableArray addObject:[listArray[i] valueForKey:@"label"]];
        }
        
        [YGActionSheetView showAlertWithTitlesArray:showMutableArray handler:^(NSInteger selectedIndex, NSString *selectedString) {
            self.chooseAreaLabel.text = selectedString;
            self.areaString = [NSString stringWithFormat:@"%ld",selectedIndex];
            self.chooseAreaLabel.textColor = colorWithBlack;
        }];

    } failure:^(NSError *error) {
        button.userInteractionEnabled = YES;

    }];

}


//提交
-(void)submitInfo:(UIButton *)button
{
    if(!self.detailTextView.text.length)
    {
        [YGAppTool showToastWithText:@"请填写描述哦"];
        return;
    }

    if (_selectedPhotos.count == 0)
    {
        [YGAppTool showToastWithText:@"请至少选择一张图片上传哦"];
        return;
    }
    if ([self.chooseAreaLabel.text isEqualToString:@"请选择区域"]) {
        [YGAppTool showToastWithText:@"请选择区域"];
        return;
    }
    if (!self.phoneTextField.text.length) {
        [YGAppTool showToastWithText:@"请填写您的手机号"];
        return;
    }
    if (!self.peopleTextField.text.length) {
        [YGAppTool showToastWithText:@"请填写联系人"];
        return;
    }
    if ([YGAppTool isNotPhoneNumber:self.phoneTextField.text])
    {
        return;
    }
    [YGNetService showLoadingViewWithSuperView:YGAppDelegate.window];
    [UploadImageTool uploadImages:_selectedPhotos progress:^(CGFloat progress) {

    } success:^(NSArray *urlArray) {

        NSString *imgString = [urlArray componentsJoinedByString:@","];

        [YGNetService YGPOST:REQUEST_AddSnapshotOrder parameters:@{@"userId":YGSingletonMarco.user.userId,@"findAddress":self.areaString,@"phone":self.phoneTextField.text,@"name":self.peopleTextField.text,@"describe":self.detailTextView.text,@"img":imgString} showLoadingView:NO scrollView:_scrollView success:^(id responseObject) {
            [YGNetService dissmissLoadingView];

            NSLog(@"%@",responseObject);

            if([[responseObject valueForKey:@"result"] integerValue])
            {
                TakePicturesSubmitSuccessController *ssVC = [[TakePicturesSubmitSuccessController alloc]init];
                [self.navigationController pushViewController:ssVC animated:YES];
            }

        } failure:^(NSError *error) {
            [YGNetService dissmissLoadingView];
            NSLog(@"提交失败");
        }];


    } failure:^{
        NSLog(@"传图失败");
        [YGNetService dissmissLoadingView];
    }];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
