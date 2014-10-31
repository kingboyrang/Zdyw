//
//  UCSCallEvent.h
//  yzxapisdk
//
//  Created by tongkucky on 14-4-2.
//  Copyright (c) 2014年 yzx. All rights reserved.
//
#import "UCSCommonClass.h"


@protocol UCSEventDelegate<NSObject>
#pragma mark 初始化函数代理
/********************初始化回调********************/
@required
//与云通讯平台连接成功
- (void)onConnectionSuccessful:(NSInteger)result;
//与云通讯平台连接失败或连接断开
-(void)onConnectionFailed:(NSInteger)reason;




@optional

#pragma mark VoIP通话的代理
/********************VoIP通话的代理********************/
//获取当电通话Callid，前提是收到APNS推送消息后初始化callid

//收到来电回调
- (void)onIncomingCall:(NSString*)callid withcalltype:(UCSCallTypeEnum) callType withcallerNumber:(NSString*)callerNumber;
//呼叫振铃回调
- (void) onAlerting:(NSString*)callid;
//接听回调
-(void) onAnswer:(NSString*)callid;
//呼叫失败回调
- (void) onDialFailed:(NSString*)callid  withReason:(UCSReason*)reason;
//释放通话回调
- (void) onHangUp:(NSString*)callid withReason:(UCSReason*)reason;
//回拨结果回调
- (void)onCallBackWithReason:(UCSReason*)reason;

#pragma mark IM通讯的代理
/********************IM通讯的代理********************/
//收到消息回调
- (void) onReceiveUcsMessage:(UCSReason*) reason withData:(UCSMessage*)msg;
//发送IM消息回调
-(void)onSendUcsMessage:(UCSReason*)reason  withData:(UCSMessage*)data;
//下载IM附件回调
-(void)onDownloadAttached:(UCSReason*)reason withFilePath:(NSString*)filePath withMsgID:(NSString*)msgID;

//播放录音结束回调
-(void) onFinishedPlayingVoice;
//停止录音回调 停止录音时，语音的时间长度
-(void)onStopVoiceRecord:(long) duration;


/********************在线状态回调********************/
- (void)onUserState:(NSMutableArray *)Result class:(NSString *)UCSUserState;		//返回查询到的用户状态

// 云获取验证码成功  0：已经验证成功，1:已下发验证码到用户
- (void) onGetValiateCodeSuccessful:(NSInteger)nResult;
// 云获取验证码失败
- (void) onGetValiateCodeFailed:(NSInteger)reason;

// 云验证成功
- (void) onDoValiateCodeSuccessful:(NSInteger)nResult;
// 云验证失败
- (void) onDoValiateCodeFailed:(NSInteger)reason;

@end