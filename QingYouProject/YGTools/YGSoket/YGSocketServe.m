//
//  YGSocketServe.m
//  AsyncSocketDemo
//
//  Created by zhangkaifeng on 15/4/3.
//  Copyright (c) 2015年 ccyouge. All rights reserved.
//

#import "YGSocketServe.h"
//#import "FBRetainCycleDetector.h"

//自己设定

//设置连接超时
#define TIME_OUT 20

//设置读取超时 -1 表示不会使用超时
#define READ_TIME_OUT -1

//设置写入超时 -1 表示不会使用超时
#define WRITE_TIME_OUT -1

//心跳写入tag
#define HEART_WRITE_TAG 1000


@implementation YGSocketServe


static YGSocketServe *socketServe = nil;

#pragma mark public static methods


//单例创建
+ (YGSocketServe *)sharedSocketServe {
    @synchronized(self) {
        if(socketServe == nil) {
            socketServe = [[[self class] alloc] init];
        }
    }
    return socketServe;
}

//单例创建
+(id)allocWithZone:(NSZone *)zone
{
    @synchronized(self)
    {
        if (socketServe == nil)
        {
            socketServe = [super allocWithZone:zone];
            return socketServe;
        }
    }
    return nil;
}

//开始连接
- (void)startConnectSocketSuccess:(void (^)(NSString * host,UInt16 port))successConnectServer;
{
    //socket连接前先断开连接以免之前socket连接没有断开导致闪退
    [self cutOffSocket];
    
    self.socket = [[AsyncSocket alloc] initWithDelegate:self];
    [self.socket setRunLoopModes:[NSArray arrayWithObject:NSRunLoopCommonModes]];
    if ([self SocketOpen:YGSocketURL port:YGSocketPort] )
    {
        NSLog(@"开始连接");
        
    }
    else
    {
        NSLog(@"已有正在连接的socket，返回");
    }
    _successConnectServer = successConnectServer;
}

//开始连接调用方法
- (NSInteger)SocketOpen:(NSString*)addr port:(NSInteger)port
{
    
    if ([self.socket isConnected])
    {
        return 0;
    }
    else
    {
        NSError *error = nil;
        [self.socket connectToHost:addr onPort:port withTimeout:TIME_OUT error:&error];
        NSLog(@"%@",error.localizedDescription);
        return 1;
    }
    
}

//用户手动中断连接
-(void)cutOffSocket
{
    _offlineType = YGSocketOfflineByUser;
    [self.socket disconnect];
    self.socket.delegate = nil;
    self.socket = nil;
    _reconnet = NO;
    [self.heartTimer invalidate];
    self.heartTimer = nil;
    _successConnectServer = nil;
    _successSendBlock = nil;
    
//    FBRetainCycleDetector *detector = [FBRetainCycleDetector new];
//    [detector addCandidate:self];
//    NSSet *retainCycles = [detector findRetainCycles];
//    NSLog(@"%@", retainCycles);
}

//向服务器发送数据
- (void)sendMessage:(id)message success:(void (^)())successSendBlock;
{
    NSMutableData *sendData = [[NSMutableData alloc]init];
    
    //发送json
    if ([message isKindOfClass:[NSDictionary class]])
    {
        [sendData appendData:[NSJSONSerialization dataWithJSONObject:message options:NO error:nil]];
    }
    //
    [sendData appendData:[AsyncSocket CRLFData]];
    
    [self.socket writeData:sendData withTimeout:WRITE_TIME_OUT tag:0];
    _successSendBlock = successSendBlock;
}


#pragma mark - Delegate

//断开连接回调
- (void)onSocketDidDisconnect:(AsyncSocket *)sock
{
    NSLog(@"断开了连接");
}


//断开连接发生错误回调
- (void)onSocket:(AsyncSocket *)sock willDisconnectWithError:(NSError *)err
{
    NSData * unreadData = [sock unreadData]; // ** This gets the current buffer
    if(unreadData.length > 0) {
        [self onSocket:sock didReadData:unreadData withTag:0]; // ** Return as much data that could be collected
    } else {

        // 服务器掉线，重连
        NSLog(@"发生错误断开连接，将在2秒重新连接，原因:%@",err.localizedDescription);
        [self performSelector:@selector(reconnetServer) withObject:nil afterDelay:2];
    }
    
}

-(void)reconnetServer
{
    _reconnet = YES;
    if ([self SocketOpen:YGSocketURL port:YGSocketPort] )
    {
        NSLog(@"开始连接");
        
    }
    else
    {
        NSLog(@"已有正在连接的socket，返回");
    }
}

//连接服务器成功回调
- (void)onSocket:(AsyncSocket *)sock didConnectToHost:(NSString *)host port:(UInt16)port
{
    if (!_reconnet)
    {
        if (_successConnectServer)
        {
            _successConnectServer(host,port);
        }
    }
    //接收消息
    [self.socket readDataToData:[AsyncSocket CRLFData] withTimeout:READ_TIME_OUT tag:0];
    //这是异步返回的连接成功，
    NSLog(@"连接服务器成功：didConnectToHost");
    
}

// 心跳连接
-(void)checkLongConnectByServeWithLiveId:(NSString *)liveId
{
    _liveid = liveId;
    //通过定时器不断发送消息，来检测长连接
    self.heartTimer = [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(heartBeatMethod) userInfo:nil repeats:YES];
    [self.heartTimer fire];
    
}

// 向服务器发送固定可是的消息，来检测长连接
-(void)heartBeatMethod
{
    NSDictionary *sendDic = @{@"type":[YGAppTool stringValueWithInt:YGSocketJSONTypeHeartBeat],@"userid":YGSingletonMarco.user.userid,@"liveid":_liveid};
    NSMutableData *data = [[NSMutableData alloc]initWithData:[NSJSONSerialization dataWithJSONObject:sendDic options:NO error:nil]];
    [data appendData:[AsyncSocket CRLFData]];
    [self.socket writeData:data withTimeout:WRITE_TIME_OUT tag:HEART_WRITE_TAG];
}



//接受消息成功之后回调
- (void)onSocket:(AsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
    [self.socket readDataToData:[AsyncSocket CRLFData] withTimeout:READ_TIME_OUT tag:0];
    NSLog(@"%@",[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding]);
    NSDictionary *receiveDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    
    YGSocketJSONType type = [receiveDic[@"type"] intValue];
    if (type == YGSocketJSONTypeHeartBeat)
    {
        NSLog(@"receive heartbeat success");
    }
    //解析出来的消息，可以通过通知、代理、block等传出去
    [_delegate YGSocketServeDidReceiveServerMessage:receiveDic];
}


//发送消息成功之后回调
- (void)onSocket:(AsyncSocket *)sock didWriteDataWithTag:(long)tag
{
    //读取消息
    if (tag == HEART_WRITE_TAG)
    {
        NSLog(@"send heartbeat success");
        return;
    }
    if (_successSendBlock)
    {
        _successSendBlock();
    }
}

@end
