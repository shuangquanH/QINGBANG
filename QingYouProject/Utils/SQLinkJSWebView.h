//
//  SQBaseWebView.h
//  QingYouProject
//
//  Created by qwuser on 2018/6/5.
//  Copyright © 2018年 ccyouge. All rights reserved.
//

#import <WebKit/WebKit.h>

typedef void(^jsCallBack)(NSString *, _Nullable id);


@interface SQLinkJSWebView : WKWebView <WKScriptMessageHandler>
@property (nonatomic, copy) jsCallBack       webJSCallBack;

/** 使用这个构造方法  */


/** 加载html页面,输入地址  */
- (void)loadWebWithUrl:(NSString    *)url;


/** 原生应用调用js方法及回调 */
//eg:@"remarkCount(0)",()内必须传值
//bklock回调方法名,返回值
- (void)ocCallJsWithMethodName:(NSString    *)method back:(void(^)(NSString*, id))block;

/** html调用js方法  */
//bklock回调方法名,参数
- (void)registJSFunctionWithName:(NSString  *)jsName back:(void(^)(NSString*, _Nullable id))block;




@end
