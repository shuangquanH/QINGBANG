//
//  SQHouseRentPushTool.m
//  QingYouProject
//
//  Created by qwuser on 2018/6/22.
//  Copyright © 2018年 ccyouge. All rights reserved.
//

#import "SQHouseRentPushTool.h"
#import "HouseRentAuditViewController.h"
#import "CheckUserInfoViewController.h"
#import "UpLoadIDFatherViewController.h"

/** 水电缴费的type  */
#define KHOUSERENTTYPE @"1"
/** 跳转列表的plist文件  */
#define KSQPUSHTYPEPLIST @"SQPushTypePlist"

@implementation SQHouseRentPushTool

+ (void)pushControllerWithType:(NSString    *)target controller:(RootViewController *)vc {
    
    if ([target isEqualToString: KHOUSERENTTYPE]) {
        [self pushToHouseRentWithController:vc];
    } else {
        NSString    *plistFile = KPLIST_FILE(KSQPUSHTYPEPLIST);
        NSArray     *pushControlArray = [NSArray arrayWithContentsOfFile: plistFile];
        
        for (NSDictionary *dic in pushControlArray) {
            if ([target isEqualToString:dic[@"targetTpye"]]) {
                Class controllerClass = NSClassFromString(dic[@"targetController"]);
                RootViewController *viewController = [[controllerClass alloc] init];
                viewController.funcs_target_params = dic[@"funcs_target_params"];
                bool    needlogin = [dic[@"needLogin"] boolValue];
                if (needlogin) {
                    if ([vc loginOrNot]) {
                        [vc.navigationController pushViewController:viewController animated:YES];
                    }
                } else {
                    [vc.navigationController pushViewController:viewController animated:YES];
                }
            }
        }
    }
}

+ (void)pushToHouseRentWithController:(RootViewController *)vc {
    if ([vc loginOrNot]) {
        
        [YGNetService YGPOST:REQUEST_HouserAudit parameters:@{@"userid":YGSingletonMarco.user.userId} showLoadingView:YES scrollView:nil success:^(id responseObject) {
            //返回值state=0是请提交审核材料,=1待审核,=2审核通过直接跳到房租缴纳首页,=3审核不通过跳到传身份证页面并提示请重新上传资料审核
            if ([responseObject[@"state"] isEqualToString:@"1"]) {
                HouseRentAuditViewController *controller = [[HouseRentAuditViewController alloc]init];
                [vc.navigationController pushViewController:controller animated:YES];
                
            } else if([responseObject[@"state"] isEqualToString:@"2"]) {
                CheckUserInfoViewController *controller = [[CheckUserInfoViewController alloc]init];
                [vc.navigationController pushViewController:controller animated:YES];
                
            } else if ([responseObject[@"state"] isEqualToString:@"3"]) {
                UpLoadIDFatherViewController *controller = [[UpLoadIDFatherViewController alloc]init];
                controller.notioceString = @"您的资料未通过审核,请重新上传资料";
                [vc.navigationController pushViewController:controller animated:YES];
                
            } else {
                UpLoadIDFatherViewController *controller = [[UpLoadIDFatherViewController alloc]init];
                controller.notioceString = @"请上传资料进行审核，审核通过后可进行房租缴纳";
                [vc.navigationController pushViewController:controller animated:YES];
            }
        } failure:nil];
        
    }

}



@end
