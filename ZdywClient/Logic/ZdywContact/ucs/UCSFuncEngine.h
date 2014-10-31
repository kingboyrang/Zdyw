//
//  UCSFuncEngineViewController.h
//  UCSVoipDemo
//
//  Created by tongkucky on 14-5-24.
//  Copyright (c) 2014年 UCS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UCSEvent.h"
#import "UCSService.h"
#import "UCSPubEnum.h"
@protocol UCSEngineUIDelegate <NSObject>
@optional
//来电信息
-(void)incomingCallID:(NSString*)callid caller:(NSString*)caller phone:(NSString*)phone name:(NSString*)name callStatus:(int)status callType:(NSInteger)calltype;
-(void)responseVoipManagerStatus:(UCSCallStatus)event callID:(NSString*)callid data:(UCSReason *)data;

//voip文字信息管理
-(void)responseMessageStatus:(UCSMsgStatusResult)event callNumber:(NSString*)callNumber data:(NSString *)data;
-(void)responseRecordingAmplitude:(double) amplitude;

//发送IM结果回调
- (void) onSendInstanceMessageWithReason: (UCSReason *) reason andMsg:(UCSMessage*) data;

//播放完成
-(void)responseFinishedPlaying;

-(void)responseDownLoadMediaMessageStatus:(UCSReason *)reason;
@end







@interface UCSFuncEngine : NSObject<UCSEventDelegate>



@property (nonatomic, retain)UCSService            *ucsCallService;
@property (nonatomic, retain)id<UCSEventDelegate>  actionbackDelegate;
@property (nonatomic, assign)NSString  *callerNum;
@property (nonatomic, assign)NSString  *phoneNum;

@property (nonatomic, assign)id<UCSEngineUIDelegate> UIDelegate;//UI业务代理


- (void)setUCSEngineDelegate:(id)delegate;
- (NSString*)messageWithErrorCode:(NSInteger)code;//取得错误码提示文字

+(UCSFuncEngine *)getInstance;



-(NSInteger)connect:(NSString *)accountSid withAccountToken:(NSString *)accountToken withClientNumber:(NSString *)clientNumber withClientPwd:(NSString *)clientPwd;



//连接服务器（密文）
-(NSInteger)connect:(NSString *)token;

//连接服务器（明文,指定IP，Port）
-(NSInteger)connect:(NSString*)host_addr withPort:(NSString*)host_port withwithAccountSid:(NSString *)accountSid withAccountToken:(NSString *)accountToken withClientNumber:(NSString *)clientNumber withClientPwd:(NSString *)clientPwd;

//连接服务器（密文,指定IP，Port）
-(NSInteger)connect:(NSString*)host_addr withPort:(NSString*)host_port withToken:(NSString *)token;


- (BOOL)isConnected;



#pragma mark - 呼叫控制函数
/**
 * 拨打电话
 * @param callType 电话类型
 * @param called 电话号(加国际码)或者VoIP号码
 * @return
 */
- (void)dial:(NSInteger)callType andCalled:(NSString *)calledNumber;


//
///**
// * 挂断电话
// * @param callid 电话id
// * @param reason 预留参数
// */

- (void) hangUp: (NSString*)called;
//
///**
// * 接听电话
// * @param callid 电话id
// * V2.0
// */
- (void) answer: (NSString*)callId;

/**
 * 拒绝呼叫(挂断一样,当被呼叫的时候被呼叫方的挂断状态)
 * @param callid 电话id
 * @param reason 拒绝呼叫的原因, 可以传入ReasonDeclined:用户拒绝 ReasonBusy:用户忙
 */
- (void)reject: (NSString*)called;


/**
 * 回拨电话
 *
 * @param dest 被叫的电话（加国际码）
 *
 *
 */
- (void)callBack:(NSString *)phoneNumber;


/**
 * 回拨电话
 *
 * @param phoneNumber 被叫的电话（加国际码）
 * @param fromNum     显示主叫号码（可选）
 * @param toNum       显示被叫号码 （可选）
 *
 *
 */

- (void)callBack:(NSString *)phoneNumber showFromNum:(NSString*)fromNum showToNum:(NSString*)toNum;



#pragma mark - DTMF函数
/**
 * 发送DTMF
 * @param callid 电话id
 * @param dtmf 键值
 */
- (BOOL)sendDTMF: (char)dtmf;

#pragma mark - 本地功能函数

/**
 * 免提设置
 * @param enable false:关闭 true:打开
 */
- (void) setSpeakerphone:(BOOL)enable;


/**
 * 获取当前免提状态
 * @return false:关闭 true:打开
 */
- (BOOL) isSpeakerphoneOn;


/**
 * 静音设置
 * @param on false:正常 true:静音
 */
- (void)setMicMute:(BOOL)on;

/**
 * 获取当前静音状态
 * @return false:正常 true:静音
 */
- (BOOL)isMicMute;



#pragma mark IM能力函数
//--------------------------------------------IM能力分割线-------------------------------------------------------//
/**
 * 发送IM消息
 *
 */

- (NSString*) sendUcsMessage:(NSString*) receiver andText:(NSString*) text   andFilePath:(NSString*) filePath andExpandData:(NSInteger)Data;
/**
 * 开始录制音频
 *
 */
- (NSString*) startVoiceRecord:(NSString*)filePath;
/**
 * 停止录制语音
 *
 */
-(void) stopVoiceRecord;
/**
 * 播放语音
 *
 */
-(void) playVoice :(NSString*) filePath;
/**
 * 停止播放语音
 *
 */
-(void) stopVoice;
/**
 * 获取语音时长
 *
 */
-(long) getVoiceDuration:(NSString*) filePath;
/**
 * 下载附件API
 *
 */
- (void) downloadAttached:(NSString*) fileUrl andFilePath:(NSString*) filePath andMsgID:(NSString*)MessageID;
///**
// * 确认已成功收到消息
// *
// *///－－－－－－－－－－－－－－－－文档已经删除
//- (void) confirmUcsMessage:(NSArray*) msgId  andExpandData: (NSString*) expandData;

/**
 * 获取SDK版本信息
 *
 */
- (NSString*) getUCSSDKVersion;

/**
 * 获取流量分类统计信息
 *
 */
-(NSDictionary*) getNetWorkFlow;

/**
 * 获取clientNumber和phoneNumber（绑定的手机号）
 *
 */
-(NSDictionary*) getUserInfo;

/**
 * 获取当前应用下的路径
 *
 */
- (NSString *) getIMMediaDir:(NSString *) strPhoneNumber;


//--------------------------------------------视频能力分割线-------------------------------------------------------//

/**
 * 设置视频显示参数
 *
 *参数 localVideoView 设置本地视频显示控件
 *参数 remoteView     设置对方视频显示控件
 *参数 width          设置发给对方视频的宽度
 *参数 height         设置发给对方视频的高度
 *
 *@return NO:  YES:
 */

- (BOOL)setVideoConfig:(UIImageView*)localVideoView withRemoteVideoView:(UIImageView*)remoteView showtoRemoteVideoWidth:(int)width showtoRemoteVideoHeight:(int) height;



/**
 * 设置视频显示参数
 *获取摄像头个数
 */
- (int) getCameraNum;

/**
 * 摄像头切换
 *return YES 成功 NO 失败
 */
- (BOOL) switchCameraDevice:(int)CameraIndex;

/**
 * 开启视频预览
 *return YES 成功 NO 失败
 */
- (BOOL) openCamera:(int)CameraIndex;

/**
 * 关闭视频预览
 * return YES 成功 NO 失败
 */
- (BOOL)closeCamera:(int)CameraIndex;



@end
