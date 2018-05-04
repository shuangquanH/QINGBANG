//
//  SecondhandReplacementMyInteractionModel.h
//  QingYouProject
//
//  Created by apple on 2017/12/21.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import <Foundation/Foundation.h>
/*
 {
 "id": "",
 "wantChange": "想换的商品id",(那句话里第二个商品)
 "wantChangeName": "想换的商品名",(那句话里第二个商品)
 "tobeChange": "用来换的商品id",（话里第一个商品）
 "tobeChangeName": "用来换的商品名",（话里第一个商品名）
 "buyerName": "出现的昵称",
 "status": ""
 1出现同意或拒绝按钮  2被同意出现去支付按钮 3被拒绝
 }
 ]
 */
@interface SecondhandReplacementMyInteractionModel : NSObject
@property(nonatomic,strong)NSString *ID;
@property(nonatomic,strong)NSString *wantChange;
@property(nonatomic,strong)NSString *wantChangeName;
@property(nonatomic,strong)NSString *tobeChange;
@property(nonatomic,strong)NSString *tobeChangeName;
@property(nonatomic,strong)NSString *buyerName;
@property(nonatomic,strong)NSString *status;

@end
