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

#import "SQAddTicketApplyInputCell.h"
#import "WKImageCollectionView.h"

#import "WKDecorationOrderDetailModel.h"

#import "UILabel+SQAttribut.h"

@interface SQApplyAfterSaleViewController ()<SQAddTicketApplyInputCellDelegate>

@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, strong) UIView *lineView;

@property (nonatomic, strong) UILabel *tipLabel;

@property (nonatomic, strong) UIButton *confirmButton;

@property (nonatomic, strong) WKImageCollectionView *imageCollectView;

@property (nonatomic, strong) SQAddTicketApplyInputCell *inputCell;

@property (nonatomic, strong) NSMutableArray *afterSaleImageArray;

@property (nonatomic, assign) NSInteger selectImageIndex;

@property (nonatomic, copy  ) NSString *afterSaleText;

@end

@implementation SQApplyAfterSaleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
        
    self.afterSaleImageArray = [NSMutableArray arrayWithObjects:@"", @"", @"", nil];
    
    [self layoutNavigation];
    
    [self setupSubviews];
}

- (void)layoutNavigation {
    self.naviTitle = @"申请售后";

    UIBarButtonItem *rightBarButton = [self createBarbuttonWithNormalTitleString:@"售后记录" selectedTitleString:@"售后记录" selector:@selector(click_listButton)];
    [((UIButton *)rightBarButton.customView) setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = rightBarButton;
}

- (void)setupSubviews {
    
    _bgView = [UIView new];
    _bgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_bgView];
    
    _inputCell = [[SQAddTicketApplyInputCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@""];
    _inputCell.limitTextCount = 200;
    [_inputCell configTitle:@"问题描述" placeHodler:@"请描述您的问题" content:@"" necessary:YES];
    _inputCell.delegate = self;
    [_bgView addSubview:_inputCell];
    
    _lineView = [UIView new];
    _lineView.backgroundColor = KCOLOR_LINE;
    [_bgView addSubview:_lineView];
    
    _tipLabel = [UILabel labelWithFont:KSCAL(28.0) textColor:kCOLOR_333 text:@"上传凭证（最多3张）"];
    [_tipLabel setTextColor:colorWithLightGray andRange:NSMakeRange(4, 6)];
    [_tipLabel setTextFont:KFONT(24) andRange:NSMakeRange(4, 6)];
    [_bgView addSubview:_tipLabel];
    
    _imageCollectView = [[WKImageCollectionView alloc] initWithMaxCount:3 hasDeleteAction:YES];
    [_bgView addSubview:_imageCollectView];
    
    _confirmButton = [UIButton buttonWithTitle:@"提交申请" titleFont:KSCAL(38) titleColor:[UIColor whiteColor] bgColor:KCOLOR_MAIN];
    [_confirmButton addTarget:self action:@selector(click_confirmButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_confirmButton];
    
    @weakify(self)
    _imageCollectView.viewClicker = ^(UIView *view, NSInteger index) {
        @strongify(self)
        self.selectImageIndex = index;
        [self pushImagePickerController];
    };
    
    _imageCollectView.deleteClicker = ^(UIView *view, NSInteger index) {
        @strongify(self)
        [self.imageCollectView setImage:nil forIndex:index];
        [self.afterSaleImageArray replaceObjectAtIndex:index withObject:@""];
    };
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(0);
    }];

    [_inputCell mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(0);
        make.height.mas_equalTo(KSCAL(90));
    }];
    
    [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(KSCAL(30));
        make.top.equalTo(_inputCell.mas_bottom);
        make.centerX.mas_equalTo(0);
        make.height.mas_equalTo(1);
    }];
    
    [_tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_lineView);
        make.top.equalTo(_lineView.mas_bottom).offset(KSCAL(26));
    }];
    
    [_imageCollectView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_lineView);
        make.width.mas_equalTo(KSCAL(130) * 3 + KSCAL(20) * 2);
        make.top.equalTo(_tipLabel.mas_bottom).offset(KSCAL(24));
        make.bottom.mas_equalTo(-KSCAL(40));
    }];
   
    [_confirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.height.mas_equalTo(KSCAL(100));
    }];
}

- (void)click_listButton {
    SQAfterSaleListViewController *next = [SQAfterSaleListViewController new];
    [self.navigationController pushViewController:next animated:YES];
}

- (void)pushToListClearSelf {
    SQAfterSaleListViewController *next = [SQAfterSaleListViewController new];
    [self.navigationController pushViewController:next animated:YES];
    
    NSMutableArray *tmp = [self.navigationController.viewControllers mutableCopy];
    [tmp removeObject:self];
    [self.navigationController setValue:[tmp copy] forKey:@"viewControllers"];
}

- (void)click_confirmButton {
    
    if (!_afterSaleText.length) {
        [YGAppTool showToastWithText:@"请填写问题描述"];
        return;
    }
    
    NSMutableArray *total = [NSMutableArray array];
    for (id obj in self.afterSaleImageArray) {
        if ([obj isKindOfClass:[UIImage class]]) {
            [total addObject:obj];
        }
    }
    
    if (!total.count) {
        [YGAppTool showToastWithText:@"请至少添加一张凭证图片"];
        return;
    }

    [YGNetService showLoadingViewWithSuperView:YGAppDelegate.window];
    
    [SQRequest uploadImages:total param:nil progress:^(float progress) {

    } success:^(id response) {
        NSString *images = [((NSArray *)response) componentsJoinedByString:@","];
        NSDictionary *param = @{
                                @"apply_images": images,
                                @"desc": _afterSaleText,
                                @"orderNum": self.orderInfo.orderInfo.orderNum,
                                @"orderId": @([self.orderInfo.orderInfo.ID longLongValue])
                                };
        [SQRequest post:KAPI_APPLYAFTERSALE param:param success:^(id response) {
            if ([response[@"code"] longLongValue] == 0) {
                [YGNetService dissmissLoadingView];
                [YGAppTool showToastWithText:@"申请成功"];
                [self performSelector:@selector(pushToListClearSelf) withObject:nil afterDelay:1.0];
            }
            else {
                [YGNetService dissmissLoadingView];
                [YGAppTool showToastWithText:response[@"msg"]];
            }
        } failure:^(NSError *error) {
            [YGNetService dissmissLoadingView];
            [YGAppTool showToastWithText:@"网络错误"];
        }];
    } failure:^(NSError *error) {
        [YGNetService dissmissLoadingView];
        [YGAppTool showToastWithText:@"上传售后图片失败，请重试"];
    }];
    
}

- (void)pushImagePickerController {
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:1 columnNumber:4 delegate:nil];
    imagePickerVc.allowTakePicture = YES; // 在内部显示拍照按钮
    imagePickerVc.allowPickingVideo = NO;
    imagePickerVc.allowPickingImage = YES;
    imagePickerVc.allowPickingOriginalPhoto = YES;
    imagePickerVc.sortAscendingByModificationDate = YES;
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        [self.imageCollectView setImage:photos.firstObject forIndex:self.selectImageIndex];
        [self.afterSaleImageArray replaceObjectAtIndex:self.selectImageIndex withObject:photos.firstObject];
    }];
    imagePickerVc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:imagePickerVc animated:YES completion:nil];
}

#pragma mark - SQAddTicketApplyInputCellDelegate
- (void)cell:(SQAddTicketApplyInputCell *)cell didEditTextField:(UITextField *)textField {
    _afterSaleText = textField.text;
}

@end
