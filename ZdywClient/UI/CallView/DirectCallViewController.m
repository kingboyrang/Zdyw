//
//  DirectCallViewController.m
//  ZdywClient
//
//  Created by ddm on 7/1/14.
//  Copyright (c) 2014 Guoling. All rights reserved.
//

#import "DirectCallViewController.h"
#import "UIImage+Scale.h"
#import "CallWrapper.h"
#import "ContactRecordNode.h"
#import "ContactManager.h"
#import "ContactViewController.h"
#import "ZdywBaseNavigationViewController.h"
#import "UCSTokenManager.h"
#import "ZdywAppDelegate.h"
#define    Signalcount   9

@interface DirectCallViewController (){
    BOOL isMute;
    BOOL isLouder;
    BOOL _isDialPlateHide;
    BOOL _isHangup;
    NSTimer                         *_detectRegTimer;       //探测是否注册成功计时器
    int                             _callTimeCount;         //通话时间
    NSTimer                         *_callingTimer;         //呼叫中计时器
    BOOL                            isUCSConnection;       //云之讯是否连接成功
}

@property (nonatomic, strong) ZdywBaseNavigationViewController * navigation;

@end

@implementation DirectCallViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
   
    // Do any additional setup after loading the view from its nib.
    isLouder=NO;
    isMute = NO;
    _isDialPlateHide = YES;
    _callTimeCount = 0;
    _isHangup = NO;
    self.callUCSId=@"";
    [self handleUI];
    [self addObservers];
    [self updateDirectCallView];
    
    //云之讯组件拨打
    ZdywAppDelegate *app=(ZdywAppDelegate*)[[UIApplication sharedApplication] delegate];
    [app.ucsFuncEngine setUIDelegate:self];
    [app.ucsFuncEngine setSpeakerphone:isLouder];
    
    self.isFirstCall=NO;
    if ([app.ucsFuncEngine isConnected]) {//已连接
        isUCSConnection=YES;
        [app.ucsFuncEngine  dial:1 andCalled:self.callInfoNode.calleePhone];
    }else{
        isUCSConnection=NO;
         _directLable.text = @"呼叫失败,请稍后重新拨打。";
        [NSTimer scheduledTimerWithTimeInterval:2.0f target:self selector:@selector(hangUpCallAction) userInfo:nil repeats:NO];
    }
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    self.navigationController.navigationBarHidden = YES;
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc{
    [self removeObservers];
}

#pragma mark - PrivateMethod

- (void)handleUI{
    _dialPlateView.frame = CGRectMake(0, self.view.frame.size.height, 320, _dialPlateView.frame.size.height);
    [self.view addSubview:_dialPlateView];
    
    _clickKeyLable = [[UILabel alloc] initWithFrame:CGRectMake(_directLable.frame.origin.x, _directLable.frame.origin.y, _directLable.frame.size.width, _directLable.frame.size.height)];
    _clickKeyLable.textColor = [UIColor whiteColor];
    _clickKeyLable.backgroundColor = [UIColor clearColor];
    _clickKeyLable.font = [UIFont systemFontOfSize:15.0];
    _clickKeyLable.textAlignment = NSTextAlignmentCenter;
    _clickKeyLable.hidden = YES;
    [self.view addSubview:_clickKeyLable];
    
    _hangupCallBtn.layer.masksToBounds = YES;
    _hangupCallBtn.layer.cornerRadius = 10.0;
    [_hangupCallBtn setBackgroundImage:[[[UIImage imageNamed:@"call_hangup_defaut"] stretchableImageWithLeftCapWidth:45 topCapHeight:43] ZdywScaleToSize:CGSizeMake(_hangupCallBtn.frame.size.width*2, _dialHangupCallBtn.frame.size.height*2)] forState:UIControlStateNormal];
    [_hangupCallBtn setBackgroundImage:[[[UIImage imageNamed:@"call_hangup_light"] stretchableImageWithLeftCapWidth:45 topCapHeight:43] ZdywScaleToSize:CGSizeMake(_hangupCallBtn.frame.size.width*2, _dialHangupCallBtn.frame.size.height*2)] forState:UIControlStateNormal];
    [_hangupCallBtn addTarget:self action:@selector(hangUpCallAction) forControlEvents:UIControlEventTouchUpInside];
    
    [_muteBtn addTarget:self action:@selector(mute) forControlEvents:UIControlEventTouchUpInside];
    [_handsfreeBtn addTarget:self action:@selector(handsFree) forControlEvents:UIControlEventTouchUpInside];
    [_dialKeyBtn addTarget:self action:@selector(showDialPlateView) forControlEvents:UIControlEventTouchUpInside];
    [_contactBtn addTarget:self action:@selector(showContact) forControlEvents:UIControlEventTouchUpInside];
    
    NSMutableArray *signalList = [[NSMutableArray alloc] initWithCapacity:0];
    for (int i = 0 ;i < Signalcount; i++ ) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"call_signal%d",i+1]];
        [signalList addObject:image];
    }
    _signalsImageView.animationImages = signalList;
    _signalsImageView.animationDuration = 0.2*Signalcount;
    [_signalsImageView startAnimating];
    
    _dialHangupCallBtn.layer.masksToBounds = YES;
    _dialHangupCallBtn.layer.cornerRadius = 10.0;
    [_dialHangupCallBtn setBackgroundImage:[[[UIImage imageNamed:@"call_hangup_defaut"] stretchableImageWithLeftCapWidth:45 topCapHeight:43] ZdywScaleToSize:CGSizeMake(_dialHangupCallBtn.frame.size.width*2, _dialHangupCallBtn.frame.size.height*2)] forState:UIControlStateNormal];
    [_dialHangupCallBtn setBackgroundImage:[[[UIImage imageNamed:@"call_hangup_light"] stretchableImageWithLeftCapWidth:45 topCapHeight:43] ZdywScaleToSize:CGSizeMake(_dialHangupCallBtn.frame.size.width*2, _dialHangupCallBtn.frame.size.height*2)] forState:UIControlStateHighlighted];
    [_dialHangupCallBtn addTarget:self action:@selector(hangUpCallAction) forControlEvents:UIControlEventTouchUpInside];
    
    _hideDialPlateBtn.layer.masksToBounds = YES;
    _hideDialPlateBtn.layer.cornerRadius = 10.0;
    [_hideDialPlateBtn setBackgroundImage:[[[UIImage imageNamed:@"dialplate_key_default"] stretchableImageWithLeftCapWidth:32 topCapHeight:32] ZdywScaleToSize:CGSizeMake(_hideDialPlateBtn.frame.size.width*2, _hideDialPlateBtn.frame.size.height*2)] forState:UIControlStateNormal];
    [_hideDialPlateBtn setBackgroundImage:[[[UIImage imageNamed:@"dialplate_key_light"] stretchableImageWithLeftCapWidth:32 topCapHeight:32] ZdywScaleToSize:CGSizeMake(_hideDialPlateBtn.frame.size.width*2, _hideDialPlateBtn.frame.size.height*2)] forState:UIControlStateNormal];
    [_hideDialPlateBtn addTarget:self action:@selector(showDialPlateView) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - Observers

- (void)addObservers{
    /***
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onRegisterFailed:)
                                                 name:kNotifyCallRegisterFailed
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onCallConnected:)
                                                 name:kNotifyCallConnect
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onCallFailed:)
                                                 name:kNotifyCallFailed
                                               object:nil];
    ***/
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(requestUCSTokenFinshed:)
                                                 name:kNotificationUCSTokenFinished
                                               object:nil];
    
}

#pragma mark - RemoveObservers

- (void)removeObservers{
    /***
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotifyCallRegisterFailed object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotifyCallConnect object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotifyCallFailed object:nil];
     ***/
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotificationUCSTokenFinished object:nil];
}

#pragma mark handle direct call
//表示取到云之讯token,重新连接
- (void)requestUCSTokenFinshed:(NSNotification *)notification{
    ZdywAppDelegate *app=(ZdywAppDelegate*)[[UIApplication sharedApplication] delegate];
    NSString *token = [ZdywUtils getLocalStringDataValue:kUCSTokenId];
    //NSString *clientNumber = [ZdywUtils getLocalStringDataValue:kUCSClientNumberId];
    if (!app.ucsFuncEngine.isConnected) {
        [app.ucsFuncEngine  connect:token];
    }
    
}
- (void)handleCallConnected
{
    //更新界面
    _directLable.text = @"直拨通话中";
    
    _callingTimer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                                     target:self
                                                   selector:@selector(timerCalling)
                                                   userInfo:nil
                                                    repeats:YES];
}

- (void)timerCalling
{
    int nHours = 0;
    int nMinutes = 0;
    int nSeconds = 0;
    ++_callTimeCount;
    nHours = _callTimeCount / 3600;
    nMinutes = (_callTimeCount % 3600) / 60;
    nSeconds = _callTimeCount % 60;
    NSString *strHours;
    NSString *strMinutes;
    NSString *strSeconds;
    if (nHours > 0)
    {
        if (nHours < 10)
        {
            strHours = [NSString stringWithFormat:@"0%i", nHours];
        } else {
            strHours = [NSString stringWithFormat:@"%i", nHours];
        }
    }
    if (nMinutes > 0)
    {
        if (nMinutes < 10)
        {
            strMinutes = [NSString stringWithFormat:@"0%i", nMinutes];
        } else {
            strMinutes = [NSString stringWithFormat:@"%i", nMinutes];
        }
    } else {
        strMinutes = [NSString stringWithFormat:@"00"];
    }
    if (nSeconds > 0)
    {
        if (nSeconds < 10)
        {
            strSeconds = [NSString stringWithFormat:@"0%i", nSeconds];
        } else {
            strSeconds = [NSString stringWithFormat:@"%i", nSeconds];
        }
    } else {
        strSeconds = [NSString stringWithFormat:@"00"];
    }
    NSString *strCallTime = @"";
    if (nHours > 0)
    {
        strCallTime = [NSString stringWithFormat:@"%@:%@:%@", strHours, strMinutes, strSeconds];
    } else {
        strCallTime = [NSString stringWithFormat:@"%@:%@", strMinutes, strSeconds];
    }
    _directLable.text = strCallTime;
}

// 挂断电话
- (void)hangupCall
{
    [self endCall];
}

// 结束通话的相关操作
- (void)endCall
{

    if (_isHangup == NO) {
        [self insertOneCallRecord];
    }
    _isHangup = YES;
    //挂机
     ZdywAppDelegate *app=(ZdywAppDelegate*)[[UIApplication sharedApplication] delegate];
    [app.ucsFuncEngine hangUp:self.callUCSId];
    
    [UIDevice currentDevice].proximityMonitoringEnabled = NO;
    [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
    //[CallWrapper shareCallWrapper].isCalling = NO;
    // 播放呼叫结束提示音
    [ZdywUtils playBigResourceSound:@"CallEnded"
                      withExtension:@"mp3"
                    withRepeatTimes:0
                  playOnLoudSpeaker:NO
                         withVolume:1.0];
    if (!isUCSConnection) {//表示未连接成功
        NSString *token = [ZdywUtils getLocalStringDataValue:kUCSTokenId];
        if ([token length]>0) {
            if (![app.ucsFuncEngine isConnected]) {//重连
                [app.ucsFuncEngine  connect:token];
            }
        }else{//表示未取到token
            [[UCSTokenManager sharedInstance] connectionUCSToken];
        }
    }
    [self.navigationController.view removeFromSuperview];
}

//插入通话记录
- (void)insertOneCallRecord
{
    NSDate *startDate = [NSDate dateWithTimeIntervalSinceNow:-_callTimeCount];
    NSString  *countryCode = [ZdywUtils getLocalStringDataValue:kCurrentCountryCode];
    
    ContactRecordNode *oneRecord = [[ContactRecordNode alloc] init];
    oneRecord.contactID = self.callInfoNode.calleeRecordID;
    oneRecord.phoneNum = self.callInfoNode.calleePhone;
    if ([self.callInfoNode.calleePhone hasPrefix:@"+"]) {    //处理呼叫号码
        oneRecord.phoneNum = [NSString stringWithFormat:@"86%@",[[ContactManager shareInstance] deleteCountryCodeFromPhoneNumber:self.callInfoNode.calleePhone
                                                                                                                     countryCode:countryCode]];
    } else if(![[self.callInfoNode.calleePhone substringToIndex:2] isEqualToString:@"86"]){
        oneRecord.phoneNum = [[ContactManager shareInstance] deleteCountryCodeFromPhoneNumber:self.callInfoNode.calleePhone
                                                                                  countryCode:countryCode];
    }
    oneRecord.recordTotalTime = _callTimeCount;     //通话时长
    [oneRecord dateStringFromDate:startDate];    //通话时间
    oneRecord.recordType = self.callInfoNode.calltype;  //通话类型
    
    NSLog(@"通话开始时间:%@_%@",oneRecord.recordDateString,startDate);
    if ([[ContactManager shareInstance].myRecordEngine insertOneRecord:oneRecord])
    {
        NSArray *aList = [[ContactManager shareInstance].myRecordEngine allRecord];
        if ([aList count] > 0)
        {
            ContactRecordNode *resultRecord = [[ContactRecordNode alloc] initWithDictionary:[aList objectAtIndex:0]];
            if (resultRecord && [resultRecord isKindOfClass:[ContactRecordNode class]])
            {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"CallRecordRefresh"
                                                                    object:nil
                                                                  userInfo:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                            resultRecord,@"Record",
                                                                            nil]];
            }
        }
    }
}

- (void)startDirectCallInThread
{
    [self performSelectorOnMainThread:@selector(onDirectCall)
                           withObject:nil
                        waitUntilDone:YES];
}

// 检查电话号码，手机号码前面加‘0’
- (NSString *)checkNumber:(NSString *) strNumber
{
    NSMutableString *strTemp = [NSMutableString stringWithString:strNumber];
    
    // 手机号码前加'0'
    unichar index0 = [strTemp characterAtIndex:0];
    if (index0 == '1' && 11 == [strTemp length])
    {
        [strTemp insertString:@"0" atIndex:0];
    }
    
    return strTemp;
}

// 发起直拨呼叫
- (void) onDirectCall
{
    //处理呼叫号码
    NSString  *countryCode = [ZdywUtils getLocalStringDataValue:kCurrentCountryCode];
    //去掉电话号码的特殊字符
    NSString *callNumberStr = [[ContactManager shareInstance] deleteCountryCodeFromPhoneNumber:_callInfoNode.calleePhone
                                                                                   countryCode:countryCode];

    NSString *strTemp = [self checkNumber:[self dealPhoneNumbe:callNumberStr]];
    
    _detectRegTimer = [NSTimer scheduledTimerWithTimeInterval:0.2
                                                       target:self
                                                     selector:@selector(timerStartCall)
                                                     userInfo:strTemp
                                                      repeats:YES];
}

// 定时器，当确定呼叫方式后，等待注册成功，然后发起呼叫
- (void)timerStartCall
{
    [_detectRegTimer invalidate];
    _detectRegTimer = nil;
}

//处理电话号码，判断是否加上区号
- (NSString *)dealPhoneNumbe:(NSString *)phoneNum
{
    NSString *resutlNumber = [NSString stringWithFormat:@"%@",phoneNum];
    if ([ZdywUtils getLocalDataBoolen:kIsChinaAcount])
    {
        //如果不是手机号 第一位是非零 = 座机
        BOOL isMobile = [ZdywUtils isMobileNumber:phoneNum];
        if(!isMobile)
        {
            int h = [[phoneNum substringWithRange:NSMakeRange(0,1)] intValue];
            if (h != 0)
            {
                NSString *userID = [ZdywUtils getLocalStringDataValue:kZdywDataKeyUserID];
                NSString *aKey = [NSString stringWithFormat:@"%@_%@",
                                  userID,
                                  kUserDefaultZone];
                NSString *defaultZone = [ZdywUtils getLocalStringDataValue:aKey];
                if ([defaultZone length] > 0)
                {
                    resutlNumber = [NSString stringWithFormat:@"%@%@", defaultZone, phoneNum];
                }
            }
        }
    }
    
    return resutlNumber;
}

// 更新直拨界面
- (void)updateDirectCallView{
    //设置通话过程中自动感应，黑屏，避免耳朵按到其他按键
    [UIDevice currentDevice].proximityMonitoringEnabled = YES;
    //设置不自动进入锁屏待机状态
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
    //上部界面
    _contactNameLable.text = _callInfoNode.calleeName;
    if (_callInfoNode.calleeName == nil) {
        _contactNameLable.text = _callInfoNode.calleePhone;
    }
    _directLable.text = @"网络电话直拨中...";
    _phoneArea.text = [self phoneAttributionForPhone:_callInfoNode.calleePhone];
}

#pragma mark - Common
//获取联系人号码归属地
- (NSString *)phoneAttributionForPhone:(NSString *)phoneNumber
{
    
    NSString *attStr = [[ContactManager shareInstance] phoneAttributionWithPhoneNumber:phoneNumber
                                                                           countryCode:[ZdywUtils getLocalStringDataValue:kCurrentCountryCode]];
    if (0 == [attStr length])
    {
        attStr = @"未知";
    }
    return attStr;
}

#pragma mark - PublicMethod

- (void)startCall:(CallInfoNode *)callInfoNode{
    _callInfoNode = callInfoNode;
    [self updateDirectCallView];
    [self startDirectCallInThread];
}

#pragma mark - BtnAction
//结束通话或挂机
- (void)hangUpCallAction{
    [_signalsImageView stopAnimating];
    _signalsImageView = nil;
    //[self.ucsService hangUp:self.callUCSId];
    [self hangupCall];
}
//免提事件
- (void)handsFree{
   
    ZdywAppDelegate *app=(ZdywAppDelegate*)[[UIApplication sharedApplication] delegate];
    //免提关：NO 免提开：YES
    BOOL returnValue = [app.ucsFuncEngine isSpeakerphoneOn];
    if (returnValue==NO)//免提关
    {
        [app.ucsFuncEngine setSpeakerphone:YES];
        [_handsfreeBtn setImage:[UIImage imageNamed:@"call_handsfree_light"] forState:UIControlStateNormal];
        isLouder = YES;
    }
    else//免提开：YES
    {
        [app.ucsFuncEngine  setSpeakerphone:NO];
         [_handsfreeBtn setImage:[UIImage imageNamed:@"call_handsfree_default"] forState:UIControlStateNormal];
        isLouder = NO;
    }
}
//切换到联系人
- (void)showContact{
    ContactViewController *contactView = [[ContactViewController alloc] initWithNibName:
                                          NSStringFromClass([ContactViewController class])
                                          
                                                                                 bundle:nil];
    contactView.contactListType = ContactListTypeCall;
    _navigation = [[ZdywBaseNavigationViewController alloc] initWithRootViewController:contactView];
    [self.navigationController presentModalViewController:_navigation animated:YES];
}
//静音
- (void)mute{
   
    ZdywAppDelegate *app=(ZdywAppDelegate*)[[UIApplication sharedApplication] delegate];
    BOOL muteFlag = [app.ucsFuncEngine isMicMute];
    if (muteFlag==NO) {
        [_muteBtn setImage:[UIImage imageNamed:@"call_funcmute_light"] forState:UIControlStateNormal];
        [app.ucsFuncEngine setMicMute:YES];//设置为静音
        isMute = YES;
    } else {
       [_muteBtn setImage:[UIImage imageNamed:@"call_funcmute_default"] forState:UIControlStateNormal];
       [app.ucsFuncEngine setMicMute:NO];//设置为非静音
        isMute = NO;
    }
}
//手机号码点击事件
- (IBAction)clickDialPlate:(id)sender{
    NSString *key = nil;
    UIButton *keyBtn = (UIButton*)sender;
    switch (keyBtn.tag-100) {
        case 0:
        case 1:
        case 2:
        case 3:
        case 4:
        case 5:
        case 6:
        case 7:
        case 8:
        case 9:{
            key = [NSString stringWithFormat:@"%d",keyBtn.tag - 100];
        }
            break;
        case 10:{
            key = @"*";
        }
            break;
        case 11:{
            key = @"#";
        }
            break;
        default:
            break;
    }
    char ch = [key characterAtIndex:0];
    _clickKeyLable.hidden = NO;
    _directLable.frame = CGRectMake(_clickKeyLable.frame.origin.x, _clickKeyLable.frame.origin.y+24, _directLable.frame.size.width, _directLable.frame.size.height);
    //[[CallManager shareInstance] sp_send_DTMF:ch];
    ZdywAppDelegate *app=(ZdywAppDelegate*)[[UIApplication sharedApplication] delegate];
    [app.ucsFuncEngine sendDTMF:ch];
    if ([_clickKeyLable.text length]) {
        _clickKeyLable.text = [_clickKeyLable.text stringByAppendingString:key];
    } else {
        _clickKeyLable.text = key;
    }
}
//显示与隐藏键盘
- (void)showDialPlateView{
    if (_isDialPlateHide) {
        _isDialPlateHide = NO;
        [UIView animateWithDuration:0.35 animations:^{
            _dialPlateView.frame = CGRectMake(0, self.view.frame.size.height - _dialPlateView.frame.size.height, 320, _dialPlateView.frame.size.height);
        }];
    } else {
        _isDialPlateHide = YES;
        [UIView animateWithDuration:0.35 animations:^{
            _dialPlateView.frame = CGRectMake(0, self.view.frame.size.height, 320, _dialPlateView.frame.size.height);
        }];
    }
}
/******************************云之讯接口**************************************/
#pragma mark - ModelEngineUIDelegate
-(void)responseVoipManagerStatus:(UCSCallStatus)event callID:(NSString*)callid data:(UCSReason *)data
{
     self.callUCSId=callid;
    switch (event)
    {
        case UCSCallStatus_Calling:{
           
            _directLable.text = @"正在为您呼叫对方,请稍后";
        }
            break;
        case UCSCallStatus_Alerting:
        {
            
            _directLable.text = @"正在响铃,等待对方接听";
        }
            break;
            
        case UCSCallStatus_Answered:
        {
            [self performSelectorOnMainThread:@selector(handleCallConnected)
                                   withObject:nil
                                waitUntilDone:YES];
        }
            break;
        case UCSCallStatus_Released:
        {
            ZdywAppDelegate *app=(ZdywAppDelegate*)[[UIApplication sharedApplication] delegate];
            NSString *msg=[app.ucsFuncEngine messageWithErrorCode:data.reason];
            if ([msg length]>0) {
                _directLable.text =msg;
            }else{
                _directLable.text =data.msg;
            }
            //延迟1.5秒后执行
            int64_t delayInSeconds = 1.5f;
            dispatch_time_t popTime =dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                //1.5秒过后执行其它操作
                [self endCall];
            });
 

        }
            break;
        case UCSCallStatus_Failed:
        {
            ZdywAppDelegate *app=(ZdywAppDelegate*)[[UIApplication sharedApplication] delegate];
            NSString *msg=[app.ucsFuncEngine messageWithErrorCode:data.reason];
            if ([msg length]>0) {
                _directLable.text =msg;
            }else{
                _directLable.text =@"呼叫失败,请稍后重新拨打。";
            }
            [NSTimer scheduledTimerWithTimeInterval:1
                                             target:self
                                           selector:@selector(hangupCall)
                                           userInfo:nil
                                            repeats:NO];
           
        }
            break;
        default:
            break;
    }
}
@end
