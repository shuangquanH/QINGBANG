//
//  AddAddressViewController.h
//  NiXiSchool
//
//  Created by 郭松阳的Mac on 2016/12/12.
//  Copyright © 2016年 ccyouge. All rights reserved.
//

#import "RootViewController.h"
#import "ManageMailPostModel.h"

@interface AddAddressViewController : RootViewController
@property (nonatomic,strong) ManageMailPostModel * model;
@property (nonatomic,strong) UITextField * nameTextField;
@property (nonatomic,strong) UITextView * addressTextView;
@property (nonatomic,strong) UILabel * placeHolderLabel;

@property (nonatomic,copy) NSString *navTitle;
@property (nonatomic,strong) NSString * state;
@property (nonatomic,strong) UIButton * tmpBtn;
@property (nonatomic,strong) NSString * ID;




@end
