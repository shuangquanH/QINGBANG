//
//  AdvertisementApplyCell.h
//  QingYouProject
//
//  Created by zhaoao on 2017/9/25.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AlreadyProcessedViewController.h"
#import "OrderListModel.h"

@interface AdvertisementApplyCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *topLabel;
@property (weak, nonatomic) IBOutlet UILabel *centerLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *instructionLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *receiverLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UIView *remarkView;
@property (weak, nonatomic) IBOutlet UILabel *processingLabel;
@property (weak, nonatomic) IBOutlet UILabel *processedLabel;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;
@property (weak, nonatomic) IBOutlet UILabel *bottomLineLabel;
@property (weak, nonatomic) IBOutlet UILabel *remarkBottomLabel;
@property(nonatomic,assign)AlreadyProcessedType pageType;

@property(nonatomic,strong)OrderListModel *orderModel;


@end
