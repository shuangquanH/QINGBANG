//
//  MeetingChildIndructionController.m
//  QingYouProject
//
//  Created by zhaoao on 2017/10/20.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "MeetingChildIndructionController.h"

@interface MeetingChildIndructionController ()

@property(nonatomic,strong)UILabel *describeLabel;

@end

@implementation MeetingChildIndructionController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIView *whiteView = [[UIView alloc]init];
    whiteView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:whiteView];
    
    self.describeLabel = [[UILabel alloc]init];
    self.describeLabel.frame = CGRectMake(0, 0, YGScreenWidth - 30,100);
    self.describeLabel.numberOfLines = 0;
    self.describeLabel.font = [UIFont systemFontOfSize:15.0];
    self.describeLabel.text = self.noteString;
    if(!self.noteString.length)
    {
        self.describeLabel.text = @"    无";
    }
    self.describeLabel.backgroundColor = [UIColor whiteColor];
    [whiteView addSubview:self.describeLabel];
    // 调整行间距
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:self.describeLabel.text];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:4];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [self.describeLabel.text length])];
    [self.describeLabel sizeToFit];
    [self.describeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(whiteView).offset(15);
        make.left.equalTo(whiteView).offset(15);
        make.right.equalTo(whiteView).offset(-15);
        make.bottom.equalTo(whiteView).offset(-15);
    }];
    
    CGFloat labelHeight = self.describeLabel.height;
    whiteView.frame = CGRectMake(0, 0, YGScreenWidth, labelHeight + 30);
    
}
-(void)configAttribute
{
    self.view.frame = self.controllerFrame;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
