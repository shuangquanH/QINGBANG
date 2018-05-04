//
//  AdvertisementInstructionCell.h
//  QingYouProject
//
//  Created by zhaoao on 2017/9/22.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

@interface AdvertisementInstructionCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property(nonatomic,strong)WKWebView *webView;

@property(nonatomic,strong)NSString *htmlString;


@end
