//
//  YGSocketServe.h
//  AsyncSocketDemo
//
//  Created by zhangkaifeng on 15/4/3.
//  Copyright (c) 2015年 ccyouge. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AsyncSocket.h"


typedef NS_ENUM(NSInteger, YGSocketOfflineType){
    YGSocketOfflineByServer = 0,    //服务器掉线
    YGSocketOfflineByUser = 1,        //用户断开
    YGSocketOfflineWifiCut = 2,         //wifi 断开
};

typedef NS_ENUM(NSInteger, YGSocketJSONType)
{
    YGSocketJSONTypeHeartBeat = 0,          //心跳
    YGSocketJSONTypeEnterRoom = 1,          //进入房间
    YGSocketJSONTypeNormalMessage = 2,      //普通消息
    YGSocketJSONTypeSendGift = 3,           //送礼物
    YGSocketJSONTypeConcern = 4,            //关注
    YGSocketJSONTypeCloseRoom = 5,          //关闭
    YGSocketJSONTypeNoTalking = 6,          //被禁言
    YGSocketJSONTypeAddGood = 7,            //添加商品
};

@protocol YGSocketServeDelegate <NSObject>

/**
 *  当收到服务器一条新消息
 *
 *  @param serverMessageDic 消息字典（从服务器转换而来，如服务器发的不是json，则为nil）
 */
-(void)YGSocketServeDidReceiveServerMessage:(NSDictionary *)serverMessageDic;

@end

@interface YGSocketServe : NSObject<AsyncSocketDelegate>

//主socket
@property (nonatomic, strong) AsyncSocket         *socket;
//心跳计时器
@property (nonatomic, retain) NSTimer             *heartTimer;
//断开原因
@property (nonatomic,assign) YGSocketOfflineType offlineType;
//房间id
@property (nonatomic,strong) NSString * liveid;
//如果是重连
@property (nonatomic,assign) BOOL reconnet;
//代理
@property (nonatomic, assign) id <YGSocketServeDelegate>delegate;
//自用block，不用管
@property (nonatomic,copy) void(^successSendBlock)();
//自用block，不用管
@property (nonatomic,copy) void(^successConnectServer)(NSString * host,UInt16 port);

/**
 *  单例方法
 *
 *  @return 单例
 */
+ (YGSocketServe *)sharedSocketServe;

/**
 *  连接socket服务器
 *
 *  @param successConnectServer 连接成功回调block
 */
- (void)startConnectSocketSuccess:(void (^)(NSString * host,UInt16 port))successConnectServer;

/**
 *  断开socket
 */
-(void)cutOffSocket;

/**
 *  向服务器发送一条消息
 *
 *  @param message          要发送的消息
 *  @param successSendBlock 成功block
 */
- (void)sendMessage:(id)message success:(void (^)())successSendBlock;

// 心跳连接
-(void)checkLongConnectByServeWithLiveId:(NSString *)liveId;

@end
