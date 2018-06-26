//
//  WKInvoiceModel.h
//  QingYouProject
//
//  Created by mac on 2018/6/5.
//  Copyright © 2018年 ccyouge. All rights reserved.
//

#import <Foundation/Foundation.h>

/*id = 1,
updateBy = "",
bankName = "象牙山大银行",
createDate = "2018-06-26 05:42:37",
default = 1,
type = "2",
*/

@interface WKInvoiceModel : NSObject
/** 是否默认 */
@property (nonatomic, assign) BOOL isDefault;
/** 1个人 2企业 */
@property (nonatomic, assign) NSInteger type;
/** 企业地址 */
@property (nonatomic, copy  ) NSString *address;
/** 开户银行 */
@property (nonatomic, copy  ) NSString *bankName;
/** 银行账户 */
@property (nonatomic, copy  ) NSString *bankNo;
/** 电话号码 */
@property (nonatomic, copy  ) NSString *tel;
/** 抬头名称 */
@property (nonatomic, copy  ) NSString *title;
/*  税号  **/
@property (nonatomic, copy  ) NSString *taxNo;
/** 抬头id */
@property (nonatomic, copy  ) NSString *ID;

@end
