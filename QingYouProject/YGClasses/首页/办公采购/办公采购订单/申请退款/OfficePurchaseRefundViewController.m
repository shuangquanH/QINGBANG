//
//  OfficePurchaseRefundViewController.m
//  QingYouProject
//
//  Created by apple on 2017/11/16.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "OfficePurchaseRefundViewController.h"
#import "GoodsDetailView.h"
#import "TZImagePickerController.h"
#import "TZTestCell.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>
#import "LxGridViewFlowLayout.h"
#import "TZImageManager.h"
#import "TZVideoPlayerController.h"
#import "FileMD5Hash.h"
#import "AESCrypt.h"
//#import "TakePicturesSubmitSuccessController.h"
//#import "TakePicturesStatusController.h"
//#import "TakePicturesOrderListController.h"
#import "QiniuSDK.h"
#import "UploadImageTool.h"
#import "YGActionSheetView.h"
#import "AllOfficePurchaseDetailModel.h"

#import "NSString+SQAttributeString.h"





@interface OfficePurchaseRefundViewController ()<TZImagePickerControllerDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UITextViewDelegate>
{
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

@property (nonatomic,strong) GoodsDetailView * goodsDetailView;
//@property (nonatomic,strong) UIView * bgView;
@property (nonatomic, strong) UICollectionView *collectionView;
@property(nonatomic,strong)UITextView *detailTextView;//描述
@property(nonatomic,strong)UILabel * refundMoney;//退款金额
@property(nonatomic,strong)UILabel * describe;//描述

@end

@implementation OfficePurchaseRefundViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.naviTitle = @"申请退款";
    self.navigationItem.rightBarButtonItem = [self createBarbuttonWithNormalTitleString:@"提交" selectedTitleString:@"提交" selector:@selector(rightBarButtonClick:)];
    [self setupUI];
    // Do any additional setup after loading the view.
}

- (void)setupUI
{

    _scrollView = [[UIScrollView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    _scrollView.alwaysBounceVertical = YES;
    _scrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_scrollView];
    
    _whiteView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, YGScreenWidth, 0)];
    _whiteView.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:_whiteView];
    
//    self.bgView = [UIView new];
//    [_scrollView addSubview:self.bgView];
//    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.left.top. offset(0);
//        make.bottom.offset(-8);
//    }];
    
    UIView *collectionHeaderView = [[UIView alloc]init];

    //商品View
    self.goodsDetailView = [[GoodsDetailView alloc] initWithFrame:CGRectMake(-LDVPadding, 0, kScreenW, 10 * LDVPadding)];
    [collectionHeaderView addSubview:self.goodsDetailView];
    

    UILabel * reasonLabel = [[UILabel alloc]initWithFrame:CGRectMake(LDVPadding,self.goodsDetailView.y + self.goodsDetailView.height + 2 * LDVPadding, YGScreenWidth, 30)];
    reasonLabel.text =@"退款原因";
    reasonLabel.font = [UIFont systemFontOfSize:15];
    reasonLabel.textColor = colorWithBlack;
    [collectionHeaderView addSubview:reasonLabel];
    
    self.detailTextView = [[UITextView alloc]initWithFrame:CGRectMake(LDVPadding, reasonLabel.y + reasonLabel.height + LDVPadding, YGScreenWidth - 2*LDVPadding, 100)];
    self.detailTextView.font = [UIFont systemFontOfSize:YGFontSizeBigOne];
    self.detailTextView.delegate = self;
    self.detailTextView.tag = 997;
    [collectionHeaderView addSubview:self.detailTextView];
    
    UILabel *placeHolderLabel = [[UILabel alloc]initWithFrame:CGRectMake(3, 8, self.detailTextView.width, 14)];
    placeHolderLabel.text = @"请输入退款原因";
    placeHolderLabel.textColor = colorWithLightGray;
    placeHolderLabel.font = self.detailTextView.font;
    placeHolderLabel.tag = 998;
    [self.detailTextView addSubview:placeHolderLabel];
    
    UILabel * lineLabel =[[UILabel alloc]initWithFrame:CGRectMake(-LDVPadding, self.detailTextView.y + self.detailTextView.height , YGScreenWidth, LDVPadding)];
    lineLabel.backgroundColor =colorWithTable;
    [collectionHeaderView addSubview:lineLabel];
    
    UILabel * refund = [[UILabel alloc]initWithFrame:CGRectMake(LDVPadding, lineLabel.y +lineLabel.height , 100, 45)];
    refund.text =@"退款金额";
    refund.font = [UIFont systemFontOfSize:15];
    refund.textColor = colorWithBlack;
    [collectionHeaderView addSubview:refund];

    self.refundMoney = [[UILabel alloc]initWithFrame:CGRectMake(refund.x + refund.width, lineLabel.y +lineLabel.height , YGScreenWidth -  refund.width - 3* LDVPadding, 45)];
//    self.refundMoney.backgroundColor =[UIColor cyanColor];
    [collectionHeaderView addSubview:self.refundMoney];

    
    UILabel * describeBG =[[UILabel alloc]initWithFrame:CGRectMake(-LDVPadding, self.refundMoney.y +self.refundMoney.height, YGScreenWidth + LDVPadding, 40)];
    [collectionHeaderView addSubview:describeBG];
    describeBG.backgroundColor = colorWithTable;

    self.describe =[[UILabel alloc]initWithFrame:CGRectMake( LDVPadding, self.refundMoney.y +self.refundMoney.height, YGScreenWidth + LDVPadding, 40)];
    [collectionHeaderView addSubview:self.describe];
    self.describe.textColor = colorWithDeepGray;
    self.describe.font = [UIFont systemFontOfSize:12];
    
    UILabel * upload =[[UILabel alloc]initWithFrame:CGRectMake(0, describeBG.y + describeBG.height , YGScreenWidth, 40)];
    [collectionHeaderView addSubview:upload];
    upload.text =@"上传凭证";
    upload.textColor = colorWithBlack;
    upload.font = [UIFont systemFontOfSize:15];
    
    collectionHeaderView.frame = CGRectMake(0, 0, YGScreenWidth, upload.y + upload.height );
    
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
    
    _tipLabel = [[UILabel alloc]initWithFrame:CGRectMake((YGScreenWidth - 40) / 3 + 20, _whiteView.height - 54, 200, 14)];
    _tipLabel.text = @"上传凭证，最多3张哦";
    _tipLabel.hidden = NO;
    _tipLabel.font = [UIFont systemFontOfSize:14.0];
    _tipLabel.textAlignment = NSTextAlignmentLeft;
    _tipLabel.textColor = colorWithLightGray;
    _tipLabel.font = self.detailTextView.font;
    [_whiteView addSubview:_tipLabel];
    
    //商品信息View
    self.goodsDetailView.backgroundColor = colorWithTable;
    [self.goodsDetailView reloadDataWithImage:self.model.commodityImg name:self.model.commodityName rule:[NSString stringWithFormat:@"%@",self.model.commodityValue] price:self.model.commodityPrice count:[NSString stringWithFormat:@"x%@",self.model.commodityCount]];
    
    self.describe.text = [NSString stringWithFormat:@"最多能退回¥%@元，含发货邮费#%@",self.model.totalPrice,self.model.freight];

    self.refundMoney.attributedText = [[NSString stringWithFormat:@"¥%@",self.model.totalPrice] attributedStringFromNSString:[NSString stringWithFormat:@"¥%@",self.model.totalPrice] startLocation:1 forwardFont:[UIFont systemFontOfSize:12] backFont:[UIFont systemFontOfSize:17] forwardColor:kRedColor backColor:kRedColor];
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
        NSDictionary * parameters = @{@"orderID":self.model.orderID,
                                      @"refundReason":self.detailTextView.text,
                                      @"refundImg":urlStr,
                                      };
        
        [YGNetService YGPOST:@"ProcurementRefundOrder" parameters:parameters showLoadingView:YES scrollView:nil success:^(id responseObject) {

            [YGAppTool showToastWithText:@"提交成功"];
            if([self.isPush isEqualToString:@"list"])
            {
                [self.delegate officePurchaseRefundViewControllerWithCommintRow:self.row];
                [self.navigationController popViewControllerAnimated:YES];
            }
            else
            {
                [[NSNotificationCenter defaultCenter]  postNotificationName:@"ReloadView" object:[NSString stringWithFormat:@"%d",self.row]];
                [self.navigationController popToViewController:self.navigationController.viewControllers[self.navigationController.viewControllers.count- 3] animated:YES];

            }

        } failure:^(NSError *error) {
            [YGAppTool showToastWithText:@"提交失败"];
        }];
        
        
    } failure:^{
        NSLog(@"传图失败");
    }];
    
}

@end

