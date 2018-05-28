//
//  SQBaseWebViewController.h
//  SQAPPSTART
//
//  Created by apple on 2018/4/25.
//  Copyright © 2018年 apple. All rights reserved.
//  webviewController基类（所有webviewController请继承自本控制器）

#import "SQBaseViewController.h"
#import <WebKit/WebKit.h>

@interface WeakScriptMessageDelegate : NSObject<WKScriptMessageHandler>
@property (nonatomic,weak)id<WKScriptMessageHandler> scriptDelegate;
- (instancetype)initWithDelegate:(id<WKScriptMessageHandler>)scriptDelegate;
@end





@interface SQBaseWebViewController : SQBaseViewController

/** webview */
@property (nonatomic, strong) WKWebView     *webView;

/** 必传参数（地址） */
@property (nonatomic, copy) NSString        *webUrl;

/** 注册js方法数组 */
@property (nonatomic, strong) NSArray       *jsMethodArr;

/** oc调用js方法及回调 */
//eg:@"remarkCount(0)",()内必须传值
- (void)ocCallJsWithMethodName:(NSString    *)method back:(void(^)(_Nullable id))block;

/** 前端调用js方法回调 */
- (void)htmlCallMethodName:(NSString    *)name withBody:(NSString   *)body;




@end
