  //
//  UCSFuncEngineViewController.m
//  UCSVoipDemo
//
//  Created by tongkucky on 14-5-24.
//  Copyright (c) 2014年 UCS. All rights reserved.
//

#import "UCSFuncEngine.h"
#import "UCSService.h"
@interface UCSFuncEngine ()
{
    NSString *tempNum;
}

@end

@implementation UCSFuncEngine

@synthesize ucsCallService = _ucsCallService;
@synthesize actionbackDelegate = _actionbackDelegate;
@synthesize callerNum = _callerNum;//当前登录的ClientNum
@synthesize phoneNum = _phoneNum; //与当前登录的ClientNum绑定都手机号
@synthesize UIDelegate = _UIDelegate;


UCSFuncEngine* gUCSFuncEngine = nil;

+(UCSFuncEngine *)getInstance
{
    @synchronized(self){
        if(gUCSFuncEngine == nil){
            gUCSFuncEngine = [[[self alloc] init] autorelease];
        }
    }
	return gUCSFuncEngine;
}


- (id)init
{
    if (self = [super init])
    {

        UCSService* ucsService = [[UCSService alloc] init];
        [ucsService setDelegate:self];
        self.ucsCallService = ucsService;
        [ucsService release];
        
        
        
    }
    
    return self;
}

- (void)dealloc
{
    [_UIDelegate release];
    self.callerNum = nil;
    self.phoneNum = nil;
    [super dealloc];
}

- (NSString*)messageWithErrorCode:(NSInteger)code{
    switch (code) {
        case 10001:return @"用户名或密码错误,请重新登陆。";
        case 10002:return @"您的帐户已被冻结,请联系客服。";
        case 10003:return @"您的帐户已过期,请联系客服。";
        case 10004:return @"请绑定手机号。";
        case 10005:return @"您当前帐户余额不足。";
        default:
            break;
    }
    if (code>=10006&&code<=20000) {
        return @"呼叫失败,请稍后重新拨打。";
    }
    switch (code) {
        case 401001:
        case 401002:
        case 401003:
        case 401004:
        case 401007:
        case 401008:return @"用户名或密码错误,请重新登陆。";
        case 401014:return @"您的账号在其它地方登录,请注意帐号安全。";
        case 401005:
        case 401006:
        case 401015:
        case 401021:
        case 401022:
        case 401009:
        case 401010:
        case 401011:
        case 401012:
        case 401013:
            return @"呼叫失败,请稍后重新拨打。";
        case 402001:return @"您当前帐户余额不足。";
        case 402002:
        case 402003:
        case 402004:return @"呼叫失败,请稍后重新拨打。";
        case 402005:return @"您的帐户已被冻结,请联系客服。";
        case 402006:return @"您的帐户已过期,请联系客服。";
        case 402007:return @"呼叫失败,请稍后重新拨打";//未知的呼叫错误
        case 402008:return @"请确认您拨打的电话。";
        case 402009:
        case 402010:return @"呼叫失败,请稍后重新拨打。";
        case 402011:return @"网络环境不好,请稍后重新拨打。";
        case 402012:return @"对方拒绝接听,请稍后重新拨打。";
        case 402013:return @"对方忙,请稍后重新拨打。";
        case 402014:return @"主动取消呼叫。";
        case 402015:return @"已挂机。";
        case 402016:return @"对方已挂机。";
        case 402017:return @"网络环境不好,请稍后重新拨打。";
        case 402018:return @"您当前帐户余额不足。";
        case 402019:return @"呼叫失败,请稍后重新拨打。";
        case 402020:return @"不能拨打自己。";
        case 402021:return @"呼叫失败,请稍后重新拨打。";
        case 402022:return @"不能拨打自己。";
        default:
            break;
    }
    return @"";
}
//--------------------------------------------------功能函数放置区域------------------------------------------------


- (void)setUCSEngineDelegate:(id)delegate //设置业务回调代理
{
      self.UIDelegate = [delegate retain];
}

-(void)setDelegate:(id< UCSEventDelegate>)delegate//设置UCPaaS业务能力代理
{
    self.actionbackDelegate = delegate;

}

//连接服务器（明文）
-(NSInteger)connect:(NSString *)accountSid withAccountToken:(NSString *)accountToken withClientNumber:(NSString *)clientNumber withClientPwd:(NSString *)clientPwd
{
   NSInteger mResult =  [self.ucsCallService connect:accountSid withAccountToken:accountToken withClientNumber:clientNumber withClientPwd:clientPwd];
    
 
   

    
    return mResult;
}



//连接服务器（密文）
-(NSInteger)connect:(NSString *)token
{

    NSInteger mResult =  [self.ucsCallService connect:token];
    
    
    
    return mResult;

}

//连接服务器（明文,指定IP，Port）
-(NSInteger)connect:(NSString*)host_addr withPort:(NSString*)host_port withwithAccountSid:(NSString *)accountSid withAccountToken:(NSString *)accountToken withClientNumber:(NSString *)clientNumber withClientPwd:(NSString *)clientPwd
{
    NSInteger mResult =  [self.ucsCallService connect:host_addr withPort:host_port withwithAccountSid:accountSid withAccountToken:accountToken withClientNumber:clientNumber withClientPwd:clientPwd];
    
    
    
    return mResult;

}

//连接服务器（密文,指定IP，Port）
-(NSInteger)connect:(NSString*)host_addr withPort:(NSString*)host_port withToken:(NSString *)token
{
    NSInteger mResult =  [self.ucsCallService connect:host_addr withPort:host_port withToken:token];
    
    
    
    return mResult;

}



//查询帐号与服务器连接状态
- (BOOL)isConnected
{
    return [self.ucsCallService isConnected];
}



#pragma mark - 呼叫控制函数
/**
 * 拨打电话
 * @param callType 电话类型
 * @param called 电话号(加国际码)或者VoIP号码
 * @return
 */
- (void)dial:(NSInteger)callType andCalled:(NSString *)calledNumber
{
    [self.ucsCallService dial:callType andCalled:calledNumber];
}


//
///**
// * 挂断电话
// * @param callid 电话id
// * @param reason 预留参数
// */

- (void) hangUp: (NSString*)called
{
    [self.ucsCallService hangUp:called];
}
//
///**
// * 接听电话
// * @param callid 电话id
// * V2.0
// */
- (void) answer: (NSString*)callId
{
    [self.ucsCallService answer:callId];
}

/**
 * 拒绝呼叫(挂断一样,当被呼叫的时候被呼叫方的挂断状态)
 * @param callid 电话id
 * @param reason 拒绝呼叫的原因, 可以传入ReasonDeclined:用户拒绝 ReasonBusy:用户忙
 */
- (void)reject: (NSString*)called
{
     [self.ucsCallService reject:called];
}

/**
 * 回拨电话
 *
 * @param dest 被叫的电话（加国际码）
 *
 *
 */
- (void)callBack:(NSString *)phoneNumber
{
    [self.ucsCallService callBack:phoneNumber];
}

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
{
    [self.ucsCallService callBack:phoneNumber showFromNum:fromNum showToNum:toNum];
}




#pragma mark - DTMF函数
/**
 * 发送DTMF
 * @param callid 电话id
 * @param dtmf 键值
 */
- (BOOL)sendDTMF: (char)dtmf
{
    return [self.ucsCallService sendDTMF:dtmf];
}

#pragma mark - 本地功能函数

/**
 * 免提设置
 * @param enable false:关闭 true:打开
 */
- (void) setSpeakerphone:(BOOL)enable
{
    [self.ucsCallService setSpeakerphone:enable];
}


/**
 * 获取当前免提状态
 * @return false:关闭 true:打开
 */
- (BOOL) isSpeakerphoneOn
{
    return  [self.ucsCallService isSpeakerphoneOn];
}


/**
 * 静音设置
 * @param on false:正常 true:静音
 */
- (void)setMicMute:(BOOL)on
{
    [self.ucsCallService setMicMute:on];
}

/**
 * 获取当前静音状态
 * @return false:正常 true:静音
 */
- (BOOL)isMicMute
{
  return [self.ucsCallService isMicMute];
}



#pragma mark IM能力函数
//--------------------------------------------IM能力分割线-------------------------------------------------------//
/**
 * 发送IM消息
 *
 */

- (NSString*) sendUcsMessage:(NSString*) receiver andText:(NSString*) text   andFilePath:(NSString*) filePath andExpandData:(NSInteger)Data
{
    NSString *msgId = [self.ucsCallService sendUcsMessage:receiver andText:text andFilePath:filePath andExpandData:Data];
   
    return msgId;
    
}
/**
 * 开始录制音频
 *
 */
- (NSString*) startVoiceRecord:(NSString*)filePath;
{
    
    return [self.ucsCallService startVoiceRecord:filePath];

}
/**
 * 停止录制语音
 *
 */
-(void) stopVoiceRecord
{
    [self.ucsCallService stopVoiceRecord];
}
/**
 * 播放语音
 *
 */
-(void) playVoice :(NSString*) filePath
{
    [self.ucsCallService playVoice:filePath];
}
/**
 * 停止播放语音
 *
 */
-(void) stopVoice
{
    [self.ucsCallService stopVoice];
}
/**
 * 获取语音时长
 *
 */
-(long) getVoiceDuration:(NSString*) filePath
{
    return [self.ucsCallService getVoiceDuration:filePath];
}
/**
 * 下载附件API
 *
 */
- (void) downloadAttached:(NSString*) fileUrl andFilePath:(NSString*) filePath andMsgID:(NSString*)MessageID;
{
    [self.ucsCallService downloadAttached:fileUrl andFilePath:filePath andMsgID:MessageID];
}
///**
// * 确认已成功收到消息
// *
// *///－－－－－－－－－－－－－－－－文档已经删除
//- (void) confirmUcsMessage:(NSArray*) msgId  andExpandData: (NSString*) expandData;

/**
 * 获取SDK版本信息
 *
 */
- (NSString*) getUCSSDKVersion
{
    return [self.ucsCallService getUCSSDKVersion];
}

/**
 * 获取流量分类统计信息
 *
 */
-(NSDictionary*) getNetWorkFlow
{
    return [self.ucsCallService getNetWorkFlow];
}

-(NSDictionary*) getUserInfo
{
    return [self.ucsCallService getUserInfo];
    
    
}

#pragma mark - 视频能力
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

- (BOOL)setVideoConfig:(UIImageView*)localVideoView withRemoteVideoView:(UIImageView*)remoteView showtoRemoteVideoWidth:(int)width showtoRemoteVideoHeight:(int) height
{
    return [self.ucsCallService setVideoConfig:localVideoView withRemoteVideoView:remoteView showtoRemoteVideoWidth:width showtoRemoteVideoHeight:height];

}



/**
 * 设置视频显示参数
 *获取摄像头个数
 */
- (int) getCameraNum
{
    return [self.ucsCallService getCameraNum];
}

/**
 * 摄像头切换
 * CameraIndex 摄像头位置
 *return YES 成功 NO 失败
 */
- (BOOL) switchCameraDevice:(int)CameraIndex
{
    return [self.ucsCallService switchCameraDevice:CameraIndex];

}

/**
 * 开启视频预览
 * CameraIndex 摄像头位置
 *return YES 成功 NO 失败
 */
- (BOOL) openCamera:(int)CameraIndex
{
    return [self.ucsCallService openCamera:CameraIndex];
}

/**
 * 关闭视频预览
 * CameraIndex 摄像头位置
 * return YES 成功 NO 失败
 */
- (BOOL)closeCamera:(int)CameraIndex
{
    return [self.ucsCallService closeCamera:CameraIndex];

}

//--------------------------------------------------功能函数放置区域------------------------------------------------







//--------------------------------------------------回调函数放置区域------------------------------------------------

#pragma mark  云通讯平台连接成功的代理
- (void)onConnectionSuccessful:(NSInteger)result
{

    NSLog(@"平台连接成功");
    if (result==0) {
        
        NSDictionary *userDic = [self getUserInfo];
        
        self.callerNum = [[userDic objectForKey:@"clientNumber"] retain];
        self.phoneNum = [[userDic objectForKey:@"phoneNumber"] retain];
        

    }
    
    [self.actionbackDelegate onConnectionSuccessful:result];
}
//与云通讯平台连接失败或连接断开
-(void)onConnectionFailed:(NSInteger)reason
{
    [self.actionbackDelegate onConnectionFailed:reason];
}




#pragma mark VoIP通话的代理

//收到来电回调

- (void)onIncomingCall:(NSString*)callId withcalltype:(UCSCallTypeEnum) callType withcallerNumber:(NSString*)callerNumber
{
    
    
    if (self.UIDelegate && [self.UIDelegate respondsToSelector:@selector(incomingCallID:caller:phone:name:callStatus:callType:)])
    {
 
        [self.UIDelegate incomingCallID:callId caller:callerNumber phone:callerNumber name:callerNumber  callStatus:0 callType:[[NSNumber numberWithInt:callType] intValue] ];

    }
    if (self.UIDelegate && [self.UIDelegate respondsToSelector:@selector(responseVoipManagerStatus:callID:data:)]) //更新拨号界面状态
    {
//        [self.UIDelegate responseVoipManagerStatus:ECallStatus_Incoming callID:callid data:caller];
    }
    

}

//呼叫处理回调--------------------->待定
//- (void)onCallProceeding:(NSString*)callId{}
//呼叫振铃回调
- (void) onAlerting:(NSString*)called
{

    if (self.UIDelegate && [self.UIDelegate respondsToSelector:@selector(responseVoipManagerStatus:callID:data:)])
    {
        [self.UIDelegate responseVoipManagerStatus:UCSCallStatus_Alerting callID:called data:nil];
    }

}
//接听回调
-(void) onAnswer:(NSString*)called
{
    if (self.UIDelegate && [self.UIDelegate respondsToSelector:@selector(responseVoipManagerStatus:callID:data:)])
    {
        [self.UIDelegate responseVoipManagerStatus:UCSCallStatus_Answered callID:called data:nil];
    }
}
//呼叫失败回调
- (void) onDialFailed:(NSString*)callId  withReason:(UCSReason *) reason
{

    
    if (self.UIDelegate && [self.UIDelegate respondsToSelector:@selector(responseVoipManagerStatus:callID:data:)])
    {
        [self.UIDelegate responseVoipManagerStatus:UCSCallStatus_Failed callID:callId data:reason];
    }
    


    
}
//释放通话回调
- (void) onHangUp:(NSString*)called withReason:(UCSReason *)reason
{
 

    
    if (self.UIDelegate && [self.UIDelegate respondsToSelector:@selector(responseVoipManagerStatus:callID:data:)])
    {
        [self.UIDelegate responseVoipManagerStatus:UCSCallStatus_Released callID:called data:reason];
    }


}

- (void)onCallBackWithReason:(UCSReason*)reason
{
    if (self.UIDelegate && [self.UIDelegate respondsToSelector:@selector(responseVoipManagerStatus:callID:data:)])
    {
        if (reason.reason==0) {
            
            [self.UIDelegate responseVoipManagerStatus:UCSCallStatus_CallBack callID:nil data:reason];
        }
        else
        {
            [self.UIDelegate responseVoipManagerStatus:UCSCallStatus_CallBackFailed callID:nil data:reason];
        }
        
    }


}


#pragma mark IM通讯的代理
/********************IM通讯的代理********************/
//收到消息回调
- (void) onReceiveUcsMessage:(UCSReason*) reason withData:(UCSMessage*)msg
{
    
    
    
    
}
//发送IM消息回调
-(void)onSendUcsMessage:(UCSReason*)reason  withData:(UCSMessage*)data
{
    if (self.UIDelegate && [self.UIDelegate respondsToSelector:@selector(onSendInstanceMessageWithReason:andMsg:)])
    {
        [self.UIDelegate onSendInstanceMessageWithReason:reason andMsg:data];
    }
}
//下载IM附件回调
-(void)onDownloadAttached:(UCSReason*)reason withFilePath:(NSString*)filePath withMsgID:(NSString*)msgID;
{
    
  


}
//确认下载已成功消息回调
//- (void)onConfirmUcsMessage:(UCSReason*) reason
//{
////    [self.actionbackDelegate onConfirmUcsMessage:reason];
//}
//录音超时回调
//-(void)onRecordingTimeOut:(long) ms
//{
////    [self.actionbackDelegate onRecordingTimeOut:ms];
//}
//录音振幅回调
-(void)onRecordingAmplitude:(double) amplitude
{
    if (self.UIDelegate && [self.UIDelegate respondsToSelector:@selector(responseRecordingAmplitude:)])
    {
        [self.UIDelegate responseRecordingAmplitude:amplitude];
    }

}
//播放录音结束回调
-(void) onFinishedPlayingVoice
{
    if (self.UIDelegate && [self.UIDelegate respondsToSelector:@selector(responseFinishedPlaying)])
    {
        
        [self.UIDelegate responseFinishedPlaying];
    }
    
}
//停止录音回调
-(void)onStopVoiceRecord:(long) duration;
{
    
    if (self.UIDelegate && [self.UIDelegate respondsToSelector:@selector(onStopVoiceRecord:)])
    {
        
       //[self.UIDelegate onStopVoiceRecord:duration];
    }
    
}

//--------------------------------------------------回调函数放置区域------------------------------------------------




@end
