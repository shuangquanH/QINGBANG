//
//  EncryptAndDecrypt.h
//  FindingSomething
//
//  Created by 韩伟 on 16/4/1.
//  Copyright © 2016年 韩伟. All rights reserved.
//

#import <Foundation/Foundation.h>

@class NSString;

@interface NSData (Encryption)

- (NSData *)AES256EncryptWithKey:(NSData *)key;     //加密
- (NSData *)AES256DecryptWithKey:(NSData *)key;     //解密
- (NSString *)newStringInBase64FromData;            //追加64编码
+ (NSString*)base64encode:(NSString*)str;           //同上64编码

+ (NSData *)getYoGeeKey;

// 加密
+ (NSString *)getEncryptValueWithContent:(NSString *)content;

// 加密
+ (NSString *)getEncryptValueWithDic:(NSDictionary *)dic;


@end
