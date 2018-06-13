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

#import "SQDecorationDetailModel.h"

#import "UILabel+SQAttribut.h"

@interface SQApplyAfterSaleViewController ()<SQAddTicketApplyInputCellDelegate>

@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, strong) UIView *lineView;

@property (nonatomic, strong) UILabel *tipLabel;

@property (nonatomic, strong) UIButton *confirmButton;

@property (nonatomic, strong) SQAddTicketApplyInputCell *inputCell;

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
    [((UIButton *)rightBarButton.customView) setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = rightBarButton;
}

- (void)setupSubviews {
    
    _bgView = [UIView new];
    _bgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_bgView];
    
    _inputCell = [[SQAddTicketApplyInputCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@""];
    [_inputCell configTitle:@"问题描述" placeHodler:@"请描述您的问题" content:@"" necessary:YES];
    _inputCell.delegate = self;
    [_bgView addSubview:_inputCell];
    
    _lineView = [UIView new];
    _lineView.backgroundColor = colorWithLine;
    [_bgView addSubview:_lineView];
    
    _tipLabel = [UILabel labelWithFont:KSCAL(28.0) textColor:kCOLOR_333 text:@"上传凭证（最多3张）"];
    [_tipLabel setTextColor:colorWithLightGray andRange:NSMakeRange(4, 6)];
    [_bgView addSubview:_tipLabel];
    
    _confirmButton = [UIButton buttonWithTitle:@"提交申请" titleFont:KSCAL(38) titleColor:[UIColor whiteColor] bgColor:KCOLOR_MAIN];
    [_confirmButton addTarget:self action:@selector(click_confirmButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_confirmButton];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(0);
        make.height.mas_equalTo(KSCAL(350));
    }];
    
    [_confirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.height.mas_equalTo(KSCAL(100));
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
   
}

- (void)click_listButton {
    SQAfterSaleListViewController *next = [SQAfterSaleListViewController new];
    [self.navigationController pushViewController:next animated:YES];
}
- (void)click_confirmButton {
    [YGNetService showLoadingViewWithSuperView:YGAppDelegate.window];
    
    NSString *images = @"1.jpg,2.jpg";
    NSDictionary *param = @{@"orderNum": self.orderInfo.order_info.orderNum,
                            @"apply_images": images,
                            @"desc": @""
                            };
    [SQRequest post:KAPI_APPLYAFTERSALE param:param success:^(id response) {
        if ([response[@"code"] isEqualToString:@"0"]) {
            [YGAppTool showToastWithText:@"申请成功"];
            [YGNetService dissmissLoadingView];
            [self performSelector:@selector(click_listButton) withObject:nil afterDelay:1.5];
        }
        else {
            [YGNetService dissmissLoadingView];
            [YGAppTool showToastWithText:response[@"msg"]];
        }
    } failure:^(NSError *error) {
        [YGNetService dissmissLoadingView];
        [YGAppTool showToastWithText:@"网络错误"];
    }];
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
    }];
    imagePickerVc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:imagePickerVc animated:YES completion:nil];
}

#pragma mark - SQAddTicketApplyInputCellDelegate
- (void)cell:(SQAddTicketApplyInputCell *)cell didEditTextField:(UITextField *)textField {
    
}


@end
