//
//  ManageMailPostModel.h
//  QingYouProject
//
//  Created by nefertari on 2017/10/30.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ManageMailPostModel : NSObject
@property (nonatomic,strong) NSString * name;
@property (nonatomic,strong) NSString * sex;
@property (nonatomic,strong) NSString * phone;
@property (nonatomic,strong) NSString * city;
@property (nonatomic,strong) NSString * dist;
@property (nonatomic,strong) NSString * prov;
@property (nonatomic,strong) NSString * address;
@property (nonatomic,strong) NSString * ID;
@property (nonatomic,assign) BOOL  isManager;
@property (nonatomic,strong) NSString * defAddress;

@property (nonatomic, assign) long long cityId;
@property (nonatomic, assign) long long distId;
@property (nonatomic, assign) long long provId;
@property (nonatomic,strong) NSString *detail;


@end
