//
//  SeccondHandExchangePublishViewController.m
//  QingYouProject
//
//  Created by 王丹 on 2017/12/14.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "SeccondHandExchangePublishViewController.h"
#import "TZImagePickerController.h"
#import "TZTestCell.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>
#import "LxGridViewFlowLayout.h"
#import "TZImageManager.h"
#import "TZVideoPlayerController.h"
#import "TakePicturesSubmitSuccessController.h"
#import "QiniuSDK.h"
#import "UploadImageTool.h"
#import "YGActionSheetView.h"
#import "SeccondHandExchangePublishTableViewCell.h"
#import "AreaSelectViewController.h"
#import "SeccondHandExchangeChooseTypeViewController.h"

#import "SeccondHandExchangeTypeModel.h"
#import "SeccondHandExchangeViewController.h"

#import "SeccondHandExchangeViewController.h"
#import "BabyDetailsController.h"
#import "SecondhandReplacementICreateViewController.h"
#import "KSPhotoBrowser.h"

@interface SeccondHandExchangePublishViewController ()<TZImagePickerControllerDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UITextViewDelegate,UITableViewDelegate,UITableViewDataSource,SeccondHandExchangePublishTableViewCellDelegate,SeccondHandExchangeChooseTypeViewControllerDelegate> {
    NSMutableArray *_selectedPhotos; //选择的图片
    NSMutableArray *_selectedAssets; //相册里选中的图片数组
    BOOL _isSelectOriginalPhoto;
    UIScrollView *_scrollView;
    
    CGFloat _itemWH;
    CGFloat _margin; //边缘
    CGFloat _whiteViewHeight;
    
    NSMutableArray *_tokenArray;
    UITableView *_tableView;
    
    NSMutableArray *_dataArray;

    UILabel *_addressLabel;
    
    UIButton *_addressButton;
    
    UITextField *_titleContentTextfield;
    
    CGFloat _headerHeight;
    NSString *_typeIdsString;
    UIView *_addressView;
    NSString *_dozenDis;
    BOOL _isAgreeDozen;
    NSString *_doDiTitle;

    NSString *_titleString;
    NSString *_discriptionString;
    NSString *_addressString;
    NSMutableArray *_serverClassifyArray;
    int  _urlCount;
    UIButton *_checkButton;
}
@property (nonatomic, strong) UICollectionView *collectionView;
@property(nonatomic,strong)UITextView *detailTextView;//描述



@end

@implementation SeccondHandExchangePublishViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIButton *submitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    submitButton.frame = CGRectMake(0, 0, 35, 35);
    [submitButton setTitleColor:colorWithMainColor forState:UIControlStateNormal];
    [submitButton setTitle:@"发布" forState:normal];
    submitButton.titleLabel.font = [UIFont systemFontOfSize:15.0];
    [submitButton addTarget:self action:@selector(submitInfo:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightButtonItem = [[UIBarButtonItem alloc] initWithCustomView:submitButton];
    self.navigationItem.rightBarButtonItem = rightButtonItem;
    _doDiTitle = @"同意平台以青币折扣形式回收";
    if (![self.pageType isEqualToString:@"SecondhandReplacementICreateViewController"]) {
        if (![self.pageType isEqualToString:@"SecondhandReplacementICreateViewController"]) {
            NSArray * titlesArr =
            @[
              @{
                  @"title":@"以物换",
                  @"placehoder":@"请选择商品类别"
                  },
              @{
                  @"title":@"预付交易保证金",
                  @"placehoder":@"请填写"
                  },
              @{
                  @"title":@"以青币换",
                  @"placehoder":@"请输入兑换所需青币"
                  },
              @{
                  @"title":@"以钱换",
                  @"placehoder":@"请输入兑换所需金额"
                  },
              @{
                  @"title":@"支付宝账号",
                  @"placehoder":@"涉及到钱款去向，请您准确填写"
                  },
              @{
                  @"title":@"联系方式",
                  @"placehoder":@"请输入您的常用电话"
                  }
              ];
            [_dataArray addObjectsFromArray:[SeccondHandExchangePublishModel mj_objectArrayWithKeyValuesArray:titlesArr]];
            _titleString = @"";
            _discriptionString = @"";
            _addressString = nil;
        }
        
        [self loadDozenDis];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(SeccondHandExchangePublishAddressSelect:) name:@"SeccondHandExchangePublishAddressSelect" object:nil];
}
- (void)loadDozenDis
{
    
    [YGNetService YGPOST:REQUEST_getDozenDis parameters:@{} showLoadingView:NO scrollView:nil success:^(id responseObject) {
        _dozenDis = responseObject[@"text"];
        _doDiTitle = responseObject[@"rule"];
        [self configUI];

    } failure:^(NSError *error) {
        
    }];
}
-(void)setEditModel:(SecondhandReplacementICreateModel *)editModel
{
    _editModel = editModel;
    [YGNetService YGPOST:REQUEST_editMyMerchandise parameters:@{@"mid":_editModel.ID} showLoadingView:NO scrollView:nil success:^(id responseObject) {
        NSArray * titlesArr =
        @[
          @{
              @"title":@"以物换",
              @"placehoder":@"请选择商品类别"
              },
          @{
              @"title":@"预付交易保证金",
              @"placehoder":@"请填写"
              },
          @{
              @"title":@"以青币换",
              @"placehoder":@"请输入兑换所需青币"
              },
          @{
              @"title":@"以钱换",
              @"placehoder":@"请输入兑换所需金额"
              },
          @{
              @"title":@"支付宝账号",
              @"placehoder":@"涉及到钱款去向，请您准确填写"
              },
          @{
              @"title":@"联系方式",
              @"placehoder":@"请输入您的常用电话"
              }
          ];
        [_dataArray addObjectsFromArray:[SeccondHandExchangePublishModel mj_objectArrayWithKeyValuesArray:titlesArr]];
        
        NSDictionary *merchandise = responseObject[@"merchandise"];
        SeccondHandExchangePublishModel *chooseTypeModel = _dataArray[0];//选择的类别
        chooseTypeModel.isSelect = [merchandise[@"margin"] isEqualToString:@""]?NO:YES;//是否一物换
        
        _serverClassifyArray = [[NSMutableArray alloc] initWithArray:responseObject[@"classify"]];
        NSString *str = @"";
        for (NSDictionary *dict in responseObject[@"classify"]) {
            if ([dict isEqual:[responseObject[@"classify"] lastObject]]) {
                str = [str stringByAppendingString:dict[@"name"]];
                _typeIdsString  = [_typeIdsString stringByAppendingString:dict[@"id"]];;

            }else{
               _typeIdsString = [_typeIdsString stringByAppendingString:[NSString stringWithFormat:@"%@,",dict[@"id"]]];
                str = [str stringByAppendingString:[NSString stringWithFormat:@"%@,",dict[@"name"]]];
            }
        }

        chooseTypeModel.content = str;
        
        SeccondHandExchangePublishModel *ensureMoneyModel = _dataArray[1];//保证金
        ensureMoneyModel.content = merchandise[@"margin"];
        ensureMoneyModel.isSelect = chooseTypeModel.isSelect;
        
        
        SeccondHandExchangePublishModel *pointsModel = _dataArray[2];//以青币换
        pointsModel.isSelect = [merchandise[@"integral"] isEqualToString:@""]?NO:YES;//是否一物换
        pointsModel.content = merchandise[@"integral"] ;
        
        SeccondHandExchangePublishModel *moneyModel = _dataArray[3];//以钱换
        moneyModel.isSelect = [merchandise[@"money"] isEqualToString:@""]?NO:YES;//是否一物换
        moneyModel.content = merchandise[@"money"] ;
        
        
        SeccondHandExchangePublishModel *aliAccountModel = _dataArray[4];//支付宝账号
        aliAccountModel.content = merchandise[@"zhifubaoNum"];
        
        SeccondHandExchangePublishModel *phoneModel = _dataArray[5];//联系方式
        phoneModel.content = merchandise[@"phone"];

        _isAgreeDozen =[merchandise[@"bottomLine"] boolValue];
        
        [_selectedPhotos addObjectsFromArray:responseObject[@"imgs"]];
        _urlCount =(int) _selectedPhotos.count;
        
        _titleString = merchandise[@"title"];
        _discriptionString = merchandise[@"introduce"];
        _addressString = merchandise[@"address"];;
        self.tyepId = merchandise[@"classify"];
        [self loadDozenDis];
        
    } failure:^(NSError *error) {
        
    }];
   
}
- (void)SeccondHandExchangePublishAddressSelect:(NSNotification *)notifit
{
    NSString * addressStr =[notifit object];
    _addressLabel.text = addressStr;
}

-(void)configAttribute
{
    self.naviTitle = @"发布";
    _dataArray = [[NSMutableArray alloc] init];
    _selectedAssets = [[NSMutableArray alloc] init];
    _selectedPhotos = [[NSMutableArray alloc] init];
    _typeIdsString = @"";
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}
/*
- (void)back
{
    
    if ([self.pageType isEqualToString:@"SeccondHandExchangeMain"] || [self.pageType isEqualToString:@"SeccondHandExchangeCertify"]) {
        //返回首页
        UINavigationController *navc = self.navigationController;
        NSMutableArray *viewControllers = [[NSMutableArray alloc] init];
        for (UIViewController *vc in [navc viewControllers]) {
            [viewControllers addObject:vc];
            if ([vc isKindOfClass:[SeccondHandExchangeViewController class]]) {
                break;
            }
        }
        [navc setViewControllers:viewControllers];
    }
    
    if ([self.pageType isEqualToString:@"addSeccondHandExchange"]) {
        //返回首页
        UINavigationController *navc = self.navigationController;
        NSMutableArray *viewControllers = [[NSMutableArray alloc] init];
        for (UIViewController *vc in [navc viewControllers]) {
            [viewControllers addObject:vc];
            if ([vc isKindOfClass:[BabyDetailsController class]]) {
                break;
            }
        }
        [navc setViewControllers:viewControllers];
    }
    
}
 */
//绘制UI
-(void)configUI
{
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, YGScreenWidth, YGScreenHeight - YGNaviBarHeight - YGStatusBarHeight)];
    _scrollView.alwaysBounceVertical = YES;
    _scrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_scrollView];
    
    UIView *collectionHeaderView = [[UIView alloc]init];
    
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 45, 45)];
    titleLabel.text = @"标题";
    titleLabel.textColor = colorWithBlack;
    titleLabel.font = [UIFont systemFontOfSize:YGFontSizeBigOne];
    [collectionHeaderView addSubview:titleLabel];
    
    _titleContentTextfield = [[UITextField alloc]initWithFrame:CGRectMake(50, 0, YGScreenWidth-60, 45)];
    _titleContentTextfield.placeholder = @"限15个字哦~";
    _titleContentTextfield.text = _titleString;
    _titleContentTextfield.textAlignment = NSTextAlignmentRight;
    _titleContentTextfield.textColor = colorWithDeepGray;
    _titleContentTextfield.font = [UIFont systemFontOfSize:YGFontSizeBigOne];
    [collectionHeaderView addSubview:_titleContentTextfield];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 45, YGScreenWidth, 1)];
    lineView.backgroundColor = colorWithLine;
    [collectionHeaderView addSubview:lineView];
    
    self.detailTextView = [[UITextView alloc]initWithFrame:CGRectMake(7, lineView.y+lineView.height+5, YGScreenWidth - 14, 130)];
    self.detailTextView.font = [UIFont systemFontOfSize:YGFontSizeBigOne];
    self.detailTextView.delegate = self;
    self.detailTextView.tag = 997;
    self.detailTextView.text = _discriptionString;
    [collectionHeaderView addSubview:self.detailTextView];
    
    
    UILabel *placeHolderLabel = [[UILabel alloc]initWithFrame:CGRectMake(3, 8, self.detailTextView.width, 14)];
    placeHolderLabel.text = @"描述一下您的宝贝，70字以内...";
    placeHolderLabel.textColor = colorWithPlaceholder;
    //    placeHolderLabel.textColor = countLabel.textColor;
    placeHolderLabel.font = self.detailTextView.font;
    placeHolderLabel.tag = 998;
    [self.detailTextView addSubview:placeHolderLabel];
    collectionHeaderView.frame = CGRectMake(0, 0, YGScreenHeight, self.detailTextView.y + self.detailTextView.height + 20);
    
    if (_discriptionString.length != 0) {
        placeHolderLabel.hidden = YES;
    }
    _headerHeight = self.detailTextView.y+self.detailTextView.height+65;
    
    // 如不需要长按排序效果，将LxGridViewFlowLayout类改成UICollectionViewFlowLayout即可
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    _margin = 4;
    _itemWH = (YGScreenWidth - 2 * _margin - 4) / 3 - _margin;
    layout.itemSize = CGSizeMake(_itemWH, _itemWH);
    layout.minimumInteritemSpacing = _margin;
    layout.minimumLineSpacing = _margin;
    layout.headerReferenceSize = CGSizeMake(collectionHeaderView.width, collectionHeaderView.height);
    
    //collectionView
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, YGScreenWidth, _itemWH+_headerHeight) collectionViewLayout:layout];
    _collectionView.scrollEnabled = NO;
    _collectionView.backgroundColor = [UIColor clearColor];
    _collectionView.contentInset = UIEdgeInsetsMake(0, 5, 0, 5);
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.backgroundColor = colorWithYGWhite;
    _collectionView.showsVerticalScrollIndicator = NO;
    _collectionView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    [_collectionView registerClass:[TZTestCell class] forCellWithReuseIdentifier:@"TZTestCell"];
    [_scrollView addSubview:_collectionView];
    [_collectionView addSubview:collectionHeaderView];
    
    
    [UIView animateWithDuration:0.3 animations:^{
        if (_selectedPhotos.count >2)
        {
            int count = (_selectedPhotos.count < 3)?1:((_selectedPhotos.count <6)?2:3);
            _collectionView.frame = CGRectMake(0, 0, YGScreenWidth, _itemWH * count + _margin+_headerHeight);
            
        }
        else
        {
            _collectionView.frame = CGRectMake(0, 0, YGScreenWidth, _itemWH * 1 + _margin+_headerHeight);
        }
    }];
    
    _addressView = [[UIView alloc] initWithFrame:CGRectMake(0, _collectionView.height-30, YGScreenWidth, 25)];
    [_collectionView addSubview: _addressView];
    
    UIImageView *addressImageView = [[UIImageView alloc] init];
    addressImageView.frame = CGRectMake(10, 5, 20, 20);
    addressImageView.image = [UIImage imageNamed:@"unused_local"];
    [addressImageView sizeToFit];
    [_addressView addSubview:addressImageView];
    
    _addressLabel = [[UILabel alloc]initWithFrame:CGRectMake(35, 0, YGScreenWidth-50, 20)];
    _addressLabel.text = _addressString == nil? @"安徽 合肥":_addressString;
    _addressLabel.textColor = colorWithDeepGray;
    _addressLabel.font = [UIFont systemFontOfSize:YGFontSizeSmallOne];
    [_addressView addSubview:_addressLabel];
    _addressLabel.centery  = addressImageView.centery;
    
    _addressButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _addressButton.frame = CGRectMake(addressImageView.x, 0, _addressLabel.width+addressImageView.width, _addressView.height);
    _addressButton.contentMode = UIViewContentModeCenter;
    [_addressButton addTarget:self action:@selector(addressButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [_addressView addSubview:_addressButton];
    
    [self configTableView];
    
    
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
        if ([_selectedPhotos[indexPath.row]isKindOfClass:[NSString class]]) {
            [cell.imageView sd_setImageWithURL:[NSURL URLWithString:_selectedPhotos[indexPath.row]] placeholderImage:YGDefaultImgSquare];
           

        }else
        {
            cell.imageView.image = _selectedPhotos[indexPath.row];
            cell.asset = _selectedAssets[indexPath.row-_urlCount];

        }
        cell.deleteBtn.hidden = NO;
    }
    cell.deleteBtn.tag = indexPath.row;
    [cell.deleteBtn addTarget:self action:@selector(deleteBtnClik:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
//    if (indexPath.row <= _urlCount-1) {
//        return;
//    }
    //如果是最后一个 添加
    if (indexPath.row == _selectedPhotos.count)
    {
        [self pushImagePickerController];
        
    }
    //预览
    else
    {
        TZTestCell *cell = (TZTestCell *)[collectionView cellForItemAtIndexPath:indexPath];
        NSMutableArray *items = [[NSMutableArray alloc]init];
        for (int i = 0; i < _selectedPhotos.count; i++) {
            // Get the large image url
            KSPhotoItem *item;
            if ([_selectedPhotos[i] isKindOfClass:[NSString class]]) {
                item = [KSPhotoItem itemWithSourceView:cell.imageView imageUrl:[NSURL URLWithString:_selectedPhotos[i]]];
                
            }else
            {
                item = [KSPhotoItem itemWithSourceView:cell.imageView image:_selectedPhotos[i]];
            }
            [items addObject:item];
        }
        KSPhotoBrowser *browser = [KSPhotoBrowser browserWithPhotoItems:items selectedIndex:indexPath.row];
        browser.dismissalStyle = KSPhotoBrowserInteractiveDismissalStyleScale;
        browser.pageindicatorStyle = KSPhotoBrowserPageIndicatorStyleText;
        browser.backgroundStyle = KSPhotoBrowserBackgroundStyleBlur;
        [browser showFromViewController:self];
        
//        TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithSelectedAssets:_selectedAssets selectedPhotos:_selectedPhotos index:indexPath.row];
//        imagePickerVc.maxImagesCount = 9-_urlCount;
//        imagePickerVc.allowPickingOriginalPhoto = YES;
//        imagePickerVc.isSelectOriginalPhoto = _isSelectOriginalPhoto;
//        [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
//            _selectedPhotos = [NSMutableArray arrayWithArray:photos];
//            _selectedAssets = [NSMutableArray arrayWithArray:assets];
//            _isSelectOriginalPhoto = isSelectOriginalPhoto;
//            [_collectionView reloadData];
//            _collectionView.contentSize = CGSizeMake(0, ((_selectedPhotos.count + 2) / 3 ) * (_margin + _itemWH));
//        }];
//        imagePickerVc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
//        [self presentViewController:imagePickerVc animated:YES completion:nil];
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

#pragma mark --------- tabeleView 相关
-(void)configTableView
{
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, YGScreenWidth, 30)];
    footerView.backgroundColor = colorWithTable;
    
    //平台兜底
    
    UILabel *titleLabel = [[UILabel alloc]init];
    titleLabel.textColor = colorWithBlack;
    titleLabel.font = [UIFont systemFontOfSize:YGFontSizeBigOne];
    titleLabel.text = @"平台兜底规则描述";
    titleLabel.frame = CGRectMake(10, 10,YGScreenWidth-20, 20);
    [footerView addSubview:titleLabel];
    
    UILabel *contentLabel = [[UILabel alloc]init];
    contentLabel.textColor = colorWithDeepGray;
    contentLabel.font = [UIFont systemFontOfSize:YGFontSizeNormal];
    contentLabel.text = _dozenDis;
    contentLabel.frame = CGRectMake(10, titleLabel.y+titleLabel.height+10,YGScreenWidth-20, 30);
    [footerView addSubview:contentLabel];
    CGFloat height = [self getLabelHeightWithText:_dozenDis withLabel:contentLabel];
    contentLabel.frame = CGRectMake(10, contentLabel.y,YGScreenWidth-20, height+10);
    footerView.frame = CGRectMake(0, 0, YGScreenWidth, contentLabel.y+contentLabel.height+20);
    
    
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,_collectionView.height+_collectionView.y, YGScreenWidth, YGScreenHeight) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.separatorColor = colorWithLine;
    _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0.001)];
    _tableView.scrollEnabled = NO;
    _tableView.tableFooterView = footerView;
    [_tableView registerClass:[SeccondHandExchangePublishTableViewCell class] forCellReuseIdentifier:@"SeccondHandExchangePublishTableViewCell"];
    [_scrollView addSubview:_tableView];
    

    _tableView.y = _collectionView.y+_collectionView.height;
    _scrollView.contentSize = CGSizeMake(YGScreenWidth, _collectionView.y+_collectionView.height+45*6+30+45+footerView.height);

}
- (CGFloat)getLabelHeightWithText:(NSString *)content withLabel:(UILabel *)label
{
    // 调整行间距
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:content];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:5];
    paragraphStyle.paragraphSpacingBefore = 0.0;//段首行空白空间
    paragraphStyle.paragraphSpacing = 0.0; //段与段之间间距
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [content length])];
    //attributedText设置后之前设置的都失效
    
    label.attributedText = attributedString;
    
    [label sizeToFitVerticalWithMaxWidth:YGScreenWidth -20];
    
    NSDictionary *attribute =@{NSFontAttributeName:label.font,NSParagraphStyleAttributeName:paragraphStyle,NSForegroundColorAttributeName:colorWithDeepGray};
    
    CGSize size = [content boundingRectWithSize:CGSizeMake(YGScreenWidth -20, MAXFLOAT) options:NSStringDrawingTruncatesLastVisibleLine |NSStringDrawingUsesLineFragmentOrigin |NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
    
    return size.height;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SeccondHandExchangePublishTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SeccondHandExchangePublishTableViewCell" forIndexPath:indexPath];
    cell.delegate = self;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell setModel:_dataArray[indexPath.row] withIndexPath:indexPath];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //indexPath.section == 0
    if (indexPath.row == 0) {
        SeccondHandExchangePublishModel *model = _dataArray[indexPath.row];
        if (model.isSelect == NO) {
            return;
        }
        SeccondHandExchangeChooseTypeViewController *vc = [[SeccondHandExchangeChooseTypeViewController alloc] init];
        vc.pageType = @"SeccondHandExchangePublish";
        vc.delegate = self;
        [self.navigationController pushViewController:vc animated:YES];
        
    }
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, YGScreenWidth, 35)];
    headerView.backgroundColor = colorWithPlateSpacedColor;
    
    //热门推荐label
    UILabel *titleLabel = [[UILabel alloc]init];
    titleLabel.textColor = colorWithDeepGray;
    titleLabel.font = [UIFont systemFontOfSize:YGFontSizeNormal];
    titleLabel.text = @"请至少选择一种交易方式";
    titleLabel.frame = CGRectMake(10, 0,YGScreenWidth-100-15, 35);
    [headerView addSubview:titleLabel];
    
    return headerView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 35;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, YGScreenWidth, 45)];
    footerView.backgroundColor = colorWithYGWhite;
    
    //热门推荐label
    UILabel *titleLabel = [[UILabel alloc]init];
    titleLabel.textColor = colorWithDeepGray;
    titleLabel.font = [UIFont systemFontOfSize:YGFontSizeNormal];
    titleLabel.text = _doDiTitle;
    titleLabel.frame = CGRectMake(10, 0,YGScreenWidth-100-15, 45);
    [footerView addSubview:titleLabel];
    
    _checkButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _checkButton.frame = CGRectMake(YGScreenWidth-40, 5, 35, 35);
    _checkButton.tag = 1994;
    [_checkButton setImage:[UIImage imageNamed:@"nochoice_btn_gray"] forState:UIControlStateNormal];
    [_checkButton setImage:[UIImage imageNamed:@"choice_btn_green"] forState:UIControlStateSelected];
    _checkButton.contentMode = UIViewContentModeCenter;
    [_checkButton addTarget:self action:@selector(isAgreeClick:) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:_checkButton];
    _checkButton.selected = YES;
    return footerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 45;
}


#pragma mark - TZImagePickerController

- (void)pushImagePickerController
{
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:9-_urlCount columnNumber:4 delegate:self];
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

    
    //    for(int i = 0; i < photos.count; i++)
    //    {
    //        NSData *data = nil;
    //        if(!UIImagePNGRepresentation(photos[i])) {
    //            data =UIImageJPEGRepresentation(photos[i],0.1);
    //        }else{
    //            data =UIImagePNGRepresentation(photos[i]);
    //        }
    //    }
    
    //把相册里的移除掉
    _urlCount = 0;
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (int  i = 0; i<_selectedPhotos.count; i++) {
        if ([_selectedPhotos[i] isKindOfClass:[NSString class]])
        {
            [array addObject:_selectedPhotos[i]];
            _urlCount += 1;
        }
    }
    [_selectedPhotos removeAllObjects];
    [_selectedPhotos addObjectsFromArray:array];

    [_selectedPhotos addObjectsFromArray:photos];

    _selectedAssets = [NSMutableArray arrayWithArray:assets];
    _isSelectOriginalPhoto = isSelectOriginalPhoto;
    [UIView animateWithDuration:0.3 animations:^{
        if (_selectedPhotos.count >2)
        {
            int count = (_selectedPhotos.count < 3)?1:((_selectedPhotos.count <6)?2:3);
            _collectionView.frame = CGRectMake(0, 0, YGScreenWidth, _itemWH * count + _margin+_headerHeight);
            
        }
        else
        {
            _collectionView.frame = CGRectMake(0, 0, YGScreenWidth, _itemWH * 1 + _margin+_headerHeight);
        }
    }];
    [_collectionView reloadData];
    _addressView.y = _collectionView.height-30;

//    _collectionView.contentSize = CGSizeMake(YGScreenWidth, _whiteView.height);
    _tableView.y = _collectionView.y+_collectionView.height;
    _scrollView.contentSize = CGSizeMake(YGScreenWidth, _tableView.height+_tableView.y);

}


#pragma mark Click Event

- (void)deleteBtnClik:(UIButton *)sender {
    
    if (![_selectedPhotos[sender.tag] isKindOfClass:[NSString class]]) {
        [_selectedAssets removeObjectAtIndex:sender.tag-_urlCount];
    }
    [_selectedPhotos removeObjectAtIndex:sender.tag];

    [UIView animateWithDuration:0.3 animations:^{
        if (_selectedPhotos.count >2)
        {
            int count = (_selectedPhotos.count < 3)?1:((_selectedPhotos.count <6)?2:3);
            _collectionView.frame = CGRectMake(0, 0, YGScreenWidth, _itemWH * count + _margin+_headerHeight);

        }
        else
        {
            _collectionView.frame = CGRectMake(0, 0, YGScreenWidth, _itemWH * 1 + _margin+_headerHeight);
        }
    }];
    _addressView.y = _collectionView.height-30;
    _tableView.y = _collectionView.y+_collectionView.height;
    _scrollView.contentSize = CGSizeMake(YGScreenWidth, _tableView.height+_tableView.y);
    _urlCount = 0;
    for (int  i = 0; i<_selectedPhotos.count; i++) {
        if ([_selectedPhotos[i] isKindOfClass:[NSString class]])
        {
            _urlCount += 1;
        }
    }
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


//提交
-(void)submitInfo:(UIButton *)button
{
    
    
    if ( [YGAppTool isTooLong:_titleContentTextfield.text maxLength:15 name:@"标题"]) {
        if (_titleContentTextfield.text.length == 0) {
            [YGAppTool showToastWithText:@"请填写标题！"];
        }
        return;
    }
    
    if(!self.detailTextView.text.length)
    {
        [YGAppTool showToastWithText:@"请填写描述哦"];
        return;
    }
    
    if ([YGAppTool isTooLong:self.detailTextView.text maxLength:70 name:@"商品描述"]) {
        return;
    }
    
    if (_selectedPhotos.count == 0)
    {
        [YGAppTool showToastWithText:@"请至少选择一张图片上传哦"];
        return;
    }
    //至少选择一种方式
    BOOL atlessSelectOne = NO;
    for (int i = 0; i<4; i++) {
        SeccondHandExchangeTypeModel *model = _dataArray[i];
        if (model.isSelect == YES) {
            atlessSelectOne = YES;
            break;
        }
    }
    if (atlessSelectOne == NO) {
        [YGAppTool showToastWithText:@"请至少选择一种交易方式"];
        return;
    }

    SeccondHandExchangePublishModel *chooseTypeModel = _dataArray[0];//选择的类别
    SeccondHandExchangePublishModel *ensureMoneyModel = _dataArray[1];//保证金
    SeccondHandExchangePublishModel *pointsModel = _dataArray[2];//选择的类别
    SeccondHandExchangePublishModel *moneyModel = _dataArray[3];//选择的类别
    SeccondHandExchangePublishModel *aliAccountModel = _dataArray[4];//选择的类别
    SeccondHandExchangePublishModel *phoneModel = _dataArray[5];//选择的类别

    if (chooseTypeModel.isSelect == YES) {
        if (_typeIdsString == nil) {
            [YGAppTool showToastWithText:@"请选择商品类别"];
            return;
        }
        if (ensureMoneyModel.content.length == 0 ) {
            [YGAppTool showToastWithText:@"请填写预付交易保证金"];
            return;
        }
        if (![YGAppTool isPureInt:ensureMoneyModel.content]) {
            [YGAppTool showToastWithText:@"请输入正确数字格式~"];
            return ;
        }
        if ([ensureMoneyModel.content floatValue] <=0) {
            [YGAppTool showToastWithText:@"预付交易保证金金额不得小于1元！ "];
            return;
        }
    }else
    {
        ensureMoneyModel.content = @"";
    }
    
    if (pointsModel.isSelect == YES) {
        if (pointsModel.content.length == 0) {
            [YGAppTool showToastWithText:@"请输入兑换所需青币"];
            return;
        }
    }
    
    if (moneyModel.isSelect == YES) {
        if (moneyModel.content.length == 0) {
            [YGAppTool showToastWithText:@"请输入兑换所需金额"];
            return;
        }
    }
    if (aliAccountModel.content.length == 0) {
        [YGAppTool showToastWithText:@"请填写支付宝账号"];
        return;
    }
   
    if (phoneModel.content.length == 0) {
        [YGAppTool showToastWithText:@"请填写您的手机号"];
        return;
    }
    if ([YGAppTool isNotPhoneNumber:phoneModel.content])
    {
        return;
    }
    
    [YGNetService showLoadingViewWithSuperView:YGAppDelegate.window];
    NSMutableArray *strArray = [[NSMutableArray alloc] init];
    NSMutableArray *imageArray = [[NSMutableArray alloc] init];

    for (id obj in _selectedPhotos) {
        if ([obj isKindOfClass:[NSString class]]) {
            [strArray addObject:obj];
        }else
        {
            [imageArray addObject:obj];
        }
    }
    button.userInteractionEnabled = NO;
    if (imageArray.count>0) {
        [UploadImageTool uploadImages:imageArray progress:^(CGFloat progress) {
            
        } success:^(NSArray *urlArray) {
            
            [strArray addObjectsFromArray:urlArray];
            
            NSString *imgString = [strArray componentsJoinedByString:@","];
            
            [YGNetService YGPOST:REQUEST_ReleaseGoods parameters:
             @{
               @"id":_editModel == nil?@"":_editModel.ID,
               @"classificationId":self.tyepId,
               @"userId":YGSingletonMarco.user.userId,
               @"title":_titleContentTextfield.text,
               @"introduce":self.detailTextView.text,
               @"address":_addressLabel.text,
               @"phone":phoneModel.content,
               @"zhifubaoNum":aliAccountModel.content,
               @"margin":ensureMoneyModel.content,
               @"integral":pointsModel.isSelect==YES?pointsModel.content:@"",
               @"money":moneyModel.isSelect==YES?moneyModel.content:@"",
               @"bottomLine":[NSString stringWithFormat:@"%d",_checkButton.selected],
               @"classify":chooseTypeModel.isSelect==YES?_typeIdsString:@"",
               @"picture":imgString
               
               } showLoadingView:NO scrollView:_scrollView success:^(id responseObject) {
                   [YGNetService dissmissLoadingView];
                   
                   NSLog(@"%@",responseObject);
                   if ([self.pageType isEqualToString:@"SeccondHandExchangeMain"] || [self.pageType isEqualToString:@"SeccondHandExchangeCertify"]) {
                       //返回首页
                       UINavigationController *navc = self.navigationController;
                       NSMutableArray *viewControllers = [[NSMutableArray alloc] init];
                       for (UIViewController *vc in [navc viewControllers]) {
                           [viewControllers addObject:vc];
                           if ([vc isKindOfClass:[SeccondHandExchangeViewController class]]) {
                               break;
                           }
                       }
                       [navc setViewControllers:viewControllers];
                   }else if ([self.pageType isEqualToString:@"addSeccondHandExchange"]) {
                       //返回首页
                       UINavigationController *navc = self.navigationController;
                       NSMutableArray *viewControllers = [[NSMutableArray alloc] init];
                       for (UIViewController *vc in [navc viewControllers]) {
                           [viewControllers addObject:vc];
                           if ([vc isKindOfClass:[BabyDetailsController class]]) {
                               break;
                           }
                       }
                       [navc setViewControllers:viewControllers];
                   }else
                   {
                       [self.navigationController popViewControllerAnimated:YES];
                   }
                   
               } failure:^(NSError *error) {
                   [YGNetService dissmissLoadingView];
                   NSLog(@"提交失败");
                   button.userInteractionEnabled = YES;
               }];
            
            
        } failure:^{
            NSLog(@"传图失败");
            [YGNetService dissmissLoadingView];
            button.userInteractionEnabled = YES;
        }];
    }else
    {
        NSString *imgString = [strArray componentsJoinedByString:@","];
        
        [YGNetService YGPOST:REQUEST_ReleaseGoods parameters:
         @{
           @"id":_editModel == nil?@"":_editModel.ID,
           @"classificationId":self.tyepId,
           @"userId":YGSingletonMarco.user.userId,
           @"title":_titleContentTextfield.text,
           @"introduce":self.detailTextView.text,
           @"address":_addressLabel.text,
           @"phone":phoneModel.content,
           @"zhifubaoNum":aliAccountModel.content,
           @"margin":ensureMoneyModel.content,
           @"integral":pointsModel.isSelect==YES?pointsModel.content:@"",
           @"money":moneyModel.isSelect==YES?moneyModel.content:@"",
           @"bottomLine":[NSString stringWithFormat:@"%d",_checkButton.selected],
           @"classify":chooseTypeModel.isSelect==YES?_typeIdsString:@"",
           @"picture":imgString
           
           } showLoadingView:NO scrollView:_scrollView success:^(id responseObject) {
               [YGNetService dissmissLoadingView];
               
               NSLog(@"%@",responseObject);
               if ([self.pageType isEqualToString:@"SeccondHandExchangeMain"] || [self.pageType isEqualToString:@"SeccondHandExchangeCertify"]) {
                   //返回首页
                   UINavigationController *navc = self.navigationController;
                   NSMutableArray *viewControllers = [[NSMutableArray alloc] init];
                   for (UIViewController *vc in [navc viewControllers]) {
                       [viewControllers addObject:vc];
                       if ([vc isKindOfClass:[SeccondHandExchangeViewController class]]) {
                           break;
                       }
                   }
                   [navc setViewControllers:viewControllers];
               } else if ([self.pageType isEqualToString:@"addSeccondHandExchange"]) {
                   //返回首页
                   UINavigationController *navc = self.navigationController;
                   NSMutableArray *viewControllers = [[NSMutableArray alloc] init];
                   for (UIViewController *vc in [navc viewControllers]) {
                       [viewControllers addObject:vc];
                       if ([vc isKindOfClass:[BabyDetailsController class]]) {
                           break;
                       }
                   }
                   [navc setViewControllers:viewControllers];
               }else
               {
                   [self.navigationController popViewControllerAnimated:YES];
               }
               
           } failure:^(NSError *error) {
               [YGNetService dissmissLoadingView];
               NSLog(@"提交失败");
               button.userInteractionEnabled = YES;

           }];
        
    }
   
    
    

}

//当前页面cell的代理
- (void)SeccondHandExchangePublishTableViewCelltextfieldReturnValue:(NSString *)value withTextIndexPath:(NSIndexPath *)indexPath
{
    SeccondHandExchangePublishModel *model;
    model = _dataArray[indexPath.row];
    model.content = value;
    [_tableView reloadData];
}

- (void)isAgreeClick:(UIButton *)btn
{
    btn.selected = !btn.selected;
}

- (void)addressButtonAction
{
    AreaSelectViewController * areaView =[[AreaSelectViewController alloc]init];
    areaView.tag = 4;//申请维护
    [self.navigationController pushViewController:areaView animated:YES];
}

- (void)chooseTypeWithModelsArray:(NSArray *)modelsArray
{
    NSString *typeString = @"";
    NSMutableArray *typeArray = [[NSMutableArray alloc] init];
    for ( int  i = 0 ;i<modelsArray.count ;i++) {
        SeccondHandExchangeTypeModel *model = modelsArray[i];
        typeString = [typeString stringByAppendingString:[NSString stringWithFormat:@" %@",model.title]];
        [typeArray addObject:model.id];
    }
    
  SeccondHandExchangePublishModel *cellModel = _dataArray[0];
    cellModel.content = typeString;
    _typeIdsString  = [typeArray componentsJoinedByString:@","];
    [_tableView reloadData];
}

- (void)SeccondHandExchangePublishTableViewCellSelectButtonActionWithIndexPath:(NSIndexPath *)indexPath
{
    SeccondHandExchangePublishModel *model;
    model = _dataArray[indexPath.row];
    model.isSelect = !model.isSelect;
    SeccondHandExchangePublishModel *rowModel = _dataArray[1];
    if (indexPath.row == 0)
    {
        if (model.isSelect == YES) {
            rowModel.isSelect = YES;
        }else
        {
            rowModel.isSelect = NO;

        }
    }
    [_tableView reloadData];
}
@end


