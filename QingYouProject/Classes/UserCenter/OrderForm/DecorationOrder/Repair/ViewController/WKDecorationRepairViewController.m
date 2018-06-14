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

#import "SQDecorationDetailModel.h"
#import "WKOrderRepairModel.H"

#import "NSString+SQStringSize.h"

const CGFloat kItemHorizontalMargin = 10;

@interface WKDecorationRepairViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, WKDecorationRepairPhotoCellDelegate>
//申请补登相关
@property (nonatomic, strong) UILabel *topTipLabel;

@property (nonatomic, strong) UILabel *tipLabl;

@property (nonatomic, strong) UIButton *addPhotoBtn;

@property (nonatomic, strong) UIButton *confirmButton;

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) NSMutableArray<UIImage *> *repairImageArray;

@property (nonatomic, assign) NSInteger selectIndex;

//重新补登相关
@property (nonatomic, strong) WKOrderRepairModel *repairInfo;

@property (nonatomic, strong) UIView *roundRectBgView;

@property (nonatomic, strong) UIView  *repairFailBgView;

@property (nonatomic, strong) UILabel *repairFailReasonLabel;

@end

@implementation WKDecorationRepairViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.naviTitle = @"我要补登";
    self.repairImageArray = [NSMutableArray array];
    _selectIndex = -1;
    
    [self sendRepairStateRequest];
}

- (void)setupSubviews {
    
    self.view.backgroundColor = colorWithTable;
    
    _topTipLabel = [UILabel labelWithFont:KSCAL(30.0) textColor:kCOLOR_333 textAlignment:NSTextAlignmentCenter text:@"我已在线下完成付款，申请补登更新订单状态："];
    _topTipLabel.backgroundColor = kCOLOR_RGB(210, 211, 212);
    [self.view addSubview:_topTipLabel];
    
    _addPhotoBtn = [UIButton new];
    [_addPhotoBtn setBackgroundImage:[UIImage imageNamed:@"repair_bg_btn"] forState:UIControlStateNormal];
    [_addPhotoBtn setBackgroundImage:[UIImage imageNamed:@"repair_bg_btn"] forState:UIControlStateHighlighted];
    [_addPhotoBtn addTarget:self action:@selector(pushImagePickerController) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_addPhotoBtn];
    
    CGFloat itemW = (kScreenW - 4 * KSCAL(kItemHorizontalMargin) - 2 * KSCAL(30)) / 5.0;
    CGFloat itemH = KSCAL(240);
    UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
    layout.itemSize = CGSizeMake(itemW-1, itemH);
    layout.minimumInteritemSpacing = KSCAL(kItemHorizontalMargin);
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.backgroundColor = self.view.backgroundColor;
    [_collectionView registerClass:[WKDecorationRepairPhotoCell class] forCellWithReuseIdentifier:@"photoCell"];
    [self.view addSubview:_collectionView];
    
    if (self.repairInfo.repairState == 0) {//还没有申请过补登，展示申请补登状态
        _confirmButton = [UIButton buttonWithTitle:@"提交" titleFont:KSCAL(38) titleColor:[UIColor whiteColor] bgColor:KCOLOR_MAIN];
        [_confirmButton addTarget:self action:@selector(click_confirmButton) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_confirmButton];
        
        _tipLabl = [UILabel labelWithFont:KSCAL(38) textColor:kCOLOR_333 text:@"上传回执单"];
        [self.view addSubview:_tipLabl];
    }
    else if (self.repairInfo.repairState == 1) {//申请补登失败，重新申请
        
        _topTipLabel.alpha = 0.0;
        _addPhotoBtn.alpha = 0.0;
        _collectionView.alpha = 0.0;
        
        _confirmButton = [UIButton
                          buttonWithTitle:@"重新申请补登"
                          titleFont:KSCAL(38)
                          titleColor:[UIColor whiteColor]
                          bgColor:KCOLOR_MAIN];
        _confirmButton.layer.cornerRadius = 5.0;
        [_confirmButton addTarget:self
                           action:@selector(click_confirmButton)
                 forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_confirmButton];
        
        _tipLabl = [UILabel labelWithFont:KSCAL(38) textColor:kCOLOR_333 text:@"系统回复"];
        [self.view addSubview:_tipLabl];
        
        _roundRectBgView = [UIView new];
        [self.view addSubview:_roundRectBgView];
        
        _repairFailBgView = [UIView new];
        _repairFailBgView.backgroundColor = [UIColor whiteColor];
        [_roundRectBgView addSubview:_repairFailBgView];
        
        _repairFailReasonLabel = [UILabel labelWithFont:KSCAL(28) textColor:kCOLOR_333 textAlignment:NSTextAlignmentCenter];
        [_repairFailBgView addSubview:_repairFailReasonLabel];
    }
    
    [self makeContraints];

}

- (void)makeContraints {
    [_topTipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(0);
        make.height.mas_equalTo(KSCAL(110));
    }];
    
    if (self.repairInfo.repairState == 1) {
        [_tipLabl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(KSCAL(210));
            make.centerX.mas_equalTo(0);
        }];
    }
    else {
        [_tipLabl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_topTipLabel.mas_bottom).offset(KSCAL(130));
            make.centerX.mas_equalTo(0);
        }];
    }

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
    
    if (self.repairInfo.repairState == 1) {
        
        
        NSString *reasonStr = [NSString stringWithFormat:@"您与%@提交的补登审核未通过，原因是：%@", self.repairInfo.createDate, self.repairInfo.reason];
        NSMutableParagraphStyle *para = [[NSMutableParagraphStyle alloc] init];
        [para setLineSpacing:KSCAL(14)];
        NSAttributedString *reason = [[NSAttributedString alloc] initWithString:reasonStr attributes:@{NSParagraphStyleAttributeName: para}];
        _repairFailReasonLabel.attributedText = reason;
        
        CGFloat reasonH = [reasonStr labelAutoCalculateRectWithLineSpace:KSCAL(14) Font:KFONT(28) MaxSize:CGSizeMake(kScreenW-2*KSCAL(85), MAXFLOAT)].height;
        
        [_roundRectBgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(0);
            make.top.equalTo(_tipLabl.mas_bottom).offset(KSCAL(50));
            make.left.mas_equalTo(KSCAL(30));
            make.height.mas_equalTo(reasonH + KSCAL(70));
        }];
        
        [_repairFailBgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(0);
            make.top.mas_equalTo(KSCAL(20));
            make.left.mas_equalTo(KSCAL(20));
        }];
        
        [_repairFailReasonLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(0);
            make.left.mas_equalTo(KSCAL(35));
            make.top.mas_equalTo(KSCAL(15));
        }];
        
        [_confirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(0);
            make.size.mas_equalTo(CGSizeMake(KSCAL(500), KSCAL(98)));
            make.top.equalTo(_roundRectBgView.mas_bottom).offset(KSCAL(100));
        }];
    }
    else {
        [_confirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.right.mas_equalTo(0);
            make.height.mas_equalTo(KSCAL(100));
        }];
    }
    

    [self.view layoutIfNeeded];
    
    CGFloat kCircleW = 4.0;
    CGFloat width = _roundRectBgView.width;
    NSInteger hCount = width / kCircleW / 2.0 + 1;
    CAReplicatorLayer *topReplicatorLayer = [CAReplicatorLayer layer];
    topReplicatorLayer.instanceCount = hCount;
    topReplicatorLayer.instanceTransform = CATransform3DMakeTranslation(kCircleW * 2, 0, 0);
    [topReplicatorLayer addSublayer:[self circleLayer]];
    topReplicatorLayer.frame = CGRectMake(0, 0, width, kCircleW);
    topReplicatorLayer.masksToBounds = YES;
    [_roundRectBgView.layer addSublayer:topReplicatorLayer];
    
    CAReplicatorLayer *bottomReplicatorLayer = [CAReplicatorLayer layer];
    bottomReplicatorLayer.instanceCount = hCount;
    bottomReplicatorLayer.instanceTransform = CATransform3DMakeTranslation(kCircleW * 2, 0, 0);
    [bottomReplicatorLayer addSublayer:[self circleLayer]];
    bottomReplicatorLayer.frame = CGRectMake(0, _roundRectBgView.height - kCircleW, width, kCircleW);
    bottomReplicatorLayer.masksToBounds = YES;
    [_roundRectBgView.layer addSublayer:bottomReplicatorLayer];
    
    //左右
    CGFloat height = _roundRectBgView.height;
    NSInteger vCount = height / kCircleW / 2 + 1;
    CAReplicatorLayer *leftReplicatorLayer = [CAReplicatorLayer layer];
    leftReplicatorLayer.instanceCount = vCount;
    leftReplicatorLayer.instanceTransform = CATransform3DMakeTranslation(0, kCircleW * 2, 0);
    [leftReplicatorLayer addSublayer:[self circleLayer]];
    leftReplicatorLayer.frame = CGRectMake(0, 0, kCircleW, height);
    leftReplicatorLayer.masksToBounds = YES;
    [_roundRectBgView.layer addSublayer:leftReplicatorLayer];
    
    CAReplicatorLayer *rightReplicatorLayer = [CAReplicatorLayer layer];
    rightReplicatorLayer.instanceCount = vCount;
    rightReplicatorLayer.instanceTransform = CATransform3DMakeTranslation(0, kCircleW * 2, 0);
    [rightReplicatorLayer addSublayer:[self circleLayer]];
    rightReplicatorLayer.frame = CGRectMake(width-kCircleW, 0, kCircleW, height);
    rightReplicatorLayer.masksToBounds = YES;
    [_roundRectBgView.layer addSublayer:rightReplicatorLayer];
}

#pragma mark - request
- (void)sendRepairStateRequest {
    [YGNetService showLoadingViewWithSuperView:YGAppDelegate.window];
    [SQRequest post:KAPI_GETREPAIRINFO
              param:@{@"orderNum": self.orderInfo.orderNum,
                      @"stageId": self.orderInfo.stage_list[self.stageIndex].stageId}
            success:^(id response) {
        [YGNetService dissmissLoadingView];
        if ([response[@"code"] isEqualToString:@"0"]) {
            self.repairInfo = [WKOrderRepairModel yy_modelWithJSON:response[@"data"][@"repairInfo"]];
            [self setupSubviews];
        }
        else {
            [YGAppTool showToastWithText:response[@"msg"]];
            [self.navigationController performSelector:@selector(popViewControllerAnimated:) withObject:@(YES) afterDelay:1.5];
        }
    } failure:^(NSError *error) {
        [YGNetService dissmissLoadingView];
        [YGAppTool showToastWithText:@"网络错误，请检查网络"];
        [self.navigationController performSelector:@selector(popViewControllerAnimated:) withObject:@(YES) afterDelay:1.5];
    }];
}

- (void)click_confirmButton {
    
    if (self.repairInfo.repairState == 1) {//进入申请状态
        self.confirmButton.enabled = NO;
        
        [_confirmButton setTitle:@"提交" forState:UIControlStateNormal];
        _tipLabl.text = @"上传回执单";
        [self.view layoutIfNeeded];
        
        [UIView animateWithDuration:0.7 animations:^{
            _topTipLabel.alpha = 1.0;
            _collectionView.alpha = 1.0;
            _addPhotoBtn.alpha = 1.0;
            _roundRectBgView.alpha = 0.0;
            
            [_tipLabl mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(_topTipLabel.mas_bottom).offset(KSCAL(130));
                make.centerX.mas_equalTo(0);
            }];
            
            [_confirmButton mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.bottom.right.mas_equalTo(0);
                make.height.mas_equalTo(KSCAL(100));
            }];
            
            [self.view layoutIfNeeded];

        } completion:^(BOOL finished) {
            self.confirmButton.enabled = YES;
            self.repairInfo.repairState = 0;
            [_repairFailBgView removeFromSuperview];
        }];
        
        return;
    }
    
    if (!self.repairImageArray.count) {
        [YGAppTool showToastWithText:@"请至少添加一张回执单图片"];
        return;
    }
    
    
    [YGNetService showLoadingViewWithSuperView:YGAppDelegate.window];
    
    WKDecorationStageModel *stage = [self.orderInfo.stage_list objectAtIndex:self.stageIndex];
    
    NSDictionary *param = @{@"orderNum": self.orderInfo.orderNum,
                            @"images": @"1.jpg,2.jpg",
                            @"stageId": stage.stageId
                            };
    [SQRequest post:KAPI_APPLYREPAIR param:param success:^(id response) {
        [YGNetService dissmissLoadingView];
        if ([response[@"code"] isEqualToString:@"0"]) {
            stage.stageState = 3;
            if (self.repairSuccess) {
                self.repairSuccess(self.orderInfo);
            }
            [YGAppTool showToastWithText:@"申请成功，等待人员审核"];
            [self.navigationController performSelector:@selector(popViewControllerAnimated:) withObject:@(YES) afterDelay:1.5];
        }
        else {
            [YGAppTool showToastWithText:response[@"msg"]];
        }
    } failure:^(NSError *error) {
        [YGNetService dissmissLoadingView];
        [YGAppTool showToastWithText:@"网络错误"];
    }];
}

- (void)pushImagePickerController {

    if (self.repairImageArray.count == 5) {
        return;
    }
    
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:(5 - self.repairImageArray.count) columnNumber:4 delegate:nil];
    imagePickerVc.allowTakePicture = YES; // 在内部显示拍照按钮
    imagePickerVc.allowPickingVideo = NO;
    imagePickerVc.allowPickingImage = YES;
    imagePickerVc.allowPickingOriginalPhoto = YES;
    imagePickerVc.sortAscendingByModificationDate = YES;
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        [self.repairImageArray insertObjects:photos atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, photos.count)]];
        if (self.selectIndex == -1) {
            self.selectIndex = 0;
        }
        [self.collectionView reloadData];
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
    
    if (_selectIndex != -1) {
        WKDecorationRepairPhotoCell *selectCell = (WKDecorationRepairPhotoCell *)[collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:_selectIndex inSection:0]];
        selectCell.photoSelect = NO;
    }
    _selectIndex = indexPath.item;
    WKDecorationRepairPhotoCell *cell = (WKDecorationRepairPhotoCell *)[collectionView cellForItemAtIndexPath:indexPath];
    cell.photoSelect = YES;
}

#pragma mark - WKDecorationRepairPhotoCellDelegate
- (void)photoCellDidClickDelete:(WKDecorationRepairPhotoCell *)photoCell {
    NSIndexPath *deleteIndexPath = [self.collectionView indexPathForCell:photoCell];
    if (deleteIndexPath) {
        [self.repairImageArray removeObjectAtIndex:deleteIndexPath.item];
        if (deleteIndexPath.item == _selectIndex) {//删除索引为选中索引，如果还有图片选择第一张，如果没有回到初始化状态
            if (!self.repairImageArray.count) {
                _selectIndex = -1;
            }
            else {
                _selectIndex = 0;
            }
        }
        else if (deleteIndexPath.item < _selectIndex) {//删除索小于选择索引，选择索引前移
            _selectIndex -= 1;
        }
        [self.collectionView reloadData];
    }
}

- (CALayer *)circleLayer {
    CALayer *layer = [CALayer layer];
    layer.frame = CGRectMake(0, 0, 4.0, 4.0);
    layer.cornerRadius = 2.0;
    layer.backgroundColor = [UIColor whiteColor].CGColor;
    return layer;
}

@end
