//
//  CallBackViewController.m
//  ZdywClient
//
//  Created by ddm on 7/2/14.
//  Copyright (c) 2014 Guoling. All rights reserved.
//

#import "CallBackViewController.h"
#import "CallWrapper.h"
#import "ContactRecordNode.h"
#import "ContactManager.h"
#import "UCSTokenManager.h"
#import "ZdywAppDelegate.h"
#define Pointcount   3

@interface CallBackViewController (){
    NSTimer                         *_backDismissTimer;     //回拨视图消失计时器
    BOOL                            isUCSConnection;       //云之讯是否连接成功
}
@end

@implementation CallBackViewController

#pragma mark - lifeCycle

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
    NSMutableArray *signalList = [[NSMutableArray alloc] initWithCapacity:0];
    for (int i = 0 ;i < Pointcount; i++ ) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"callback_point%d",i+1]];
        [signalList addObject:image];
    }
    _pointImageView.animationImages = signalList;
    _pointImageView.animationDuration = 0.5*Pointcount;
    [_pointImageView startAnimating];
    _nameLable.text = _myCallInfoNode.calleeName;
    if (_myCallInfoNode.calleeName == nil) {
        _nameLable.text = _myCallInfoNode.calleePhone;
    }
    _areaLable.text = [self phoneAttributionForPhone:_myCallInfoNode.calleePhone];
    [self addObservers];
    //添加返回控件操作
    [self addNavigation];
    self.isFirstCall=NO;
    //云之讯组件拨打
    ZdywAppDelegate *app=(ZdywAppDelegate*)[[UIApplication sharedApplication] delegate];
    [app.ucsFuncEngine setUIDelegate:self];
    if ([app.ucsFuncEngine isConnected]) {//已连接
        isUCSConnection=YES;
        [app.ucsFuncEngine callBack:self.myCallInfoNode.calleePhone];
    }else{//未连接
        isUCSConnection=NO;
        int64_t delayInSeconds = 2.0f;
        dispatch_time_t popTime =dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            //2秒过后执行其它操作
             [self showCallBackErr:@"呼叫失败,请稍后重新拨打。" isErr:YES];
        });
       
    }

}
//添加返回导航行
- (void)addNavigation{
    CGFloat Height=[[[UIDevice currentDevice] systemVersion] floatValue]<7.0?44:64;
    UINavigationBar *navBar=[[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, Height)];
    navBar.barStyle=UIBarStyleBlackTranslucent;
    [self.view addSubview:navBar];
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        [navBar setBarTintColor:kNavigationBarBgColor];
        [navBar setTintColor:kNavigationBarBackGroundColor];
    } else {
        [navBar setTintColor:kNavigationBarBgColor];
    }
    [navBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                    kNavigationBarTitleFontColor,
                                    UITextAttributeTextColor,
                                    kNavigationBarTitleFontSize,
                                    UITextAttributeFont,nil]];
    UIBarButtonItem *leftBarBtn=[[UIBarButtonItem alloc] initWithTitle:@"< 返回" style:UIBarButtonItemStylePlain target:self action:@selector(dismissController)];
    UINavigationItem *leftNavItem=[[UINavigationItem alloc] initWithTitle:@"回拨"];
    leftNavItem.leftBarButtonItem=leftBarBtn;
    [navBar setItems:[NSArray arrayWithObjects:leftNavItem, nil]];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    self.navigationController.navigationBarHidden = YES;
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    
}
//回拨页面返回
- (void)dismissController{
    
    [self dismissBackCallView];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc{
    [self removeObservers];
}

#pragma mark - PublicMethod

- (void)startCall:(CallInfoNode *)callInfoNode{
    _myCallInfoNode = callInfoNode;
    _nameLable.text = callInfoNode.calleeName;
    if (callInfoNode.calleeName == nil) {
        _nameLable.text = callInfoNode.calleePhone;
    }
    _areaLable.text = [self phoneAttributionForPhone:callInfoNode.calleePhone];
    [self startCallBackRequest];
}

#pragma mark - Observers

- (void)addObservers{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveCallBackData:)
                                                 name:kNotificationCallFinish
                                               object:nil];
}

- (void)removeObservers{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:kNotificationCallFinish
                                                  object:nil];
}

#pragma mark - HttpAction

- (void)receiveCallBackData:(NSNotification *)notification
{
    NSDictionary *dic = [notification userInfo];
    int nRet = [[dic objectForKey:@"result"] intValue];
    NSString *strReason = [dic objectForKey:@"reason"];
    [self removeObservers];
    switch (nRet)
    {
        case 0:
        {
        }
            break;
        default:
        {
        }
            break;
    }
    [self showCallBackErr:strReason isErr:(nRet != 0)];
}

//展示回拨错误码
- (void)showCallBackErr:(NSString *)errMsg isErr:(BOOL)isErr
{
    [SVProgressHUD showInView:[ZdywAppDelegate appDelegate].window
                       status:errMsg
             networkIndicator:NO
                         posY:-1
                     maskType:SVProgressHUDMaskTypeClear];
    
    [self insertOneCallRecord];
    //重连
    ZdywAppDelegate *app=(ZdywAppDelegate*)[[UIApplication sharedApplication] delegate];
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
    if (isErr)
    {
        [SVProgressHUD dismissWithError:errMsg afterDelay:4.5];
        [self dismissBackCallView];
        return;
    }
    else
    {
        [SVProgressHUD dismissWithSuccess:errMsg afterDelay:4.5];
    }
    if (_backDismissTimer)
    {
        if ([_backDismissTimer isValid])
        {
            [_backDismissTimer invalidate];
        }
        _backDismissTimer = nil;
    }
    _backDismissTimer = [NSTimer scheduledTimerWithTimeInterval:10.0
                                                         target:self
                                                       selector:@selector(dismissBackCallView)
                                                       userInfo:nil
                                                        repeats:NO];
}

- (void)dismissBackCallView
{
    if(_backDismissTimer != nil)
    {
        [_backDismissTimer invalidate];
        _backDismissTimer = nil;
    }
    [self performSelectorOnMainThread:@selector(dimissBackCallViewInMain)
                           withObject:nil
                        waitUntilDone:YES];
}

//回拨页面消失
- (void)dimissBackCallViewInMain
{
    [CallWrapper shareCallWrapper].isCalling = NO;
    [_pointImageView stopAnimating];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    [self.navigationController.view removeFromSuperview];
    [[ZdywAppDelegate appDelegate].window makeKeyAndVisible];
}

//插入通话记录
- (void)insertOneCallRecord
{
    NSDate *startDate = [NSDate dateWithTimeIntervalSinceNow:-0];
    ContactRecordNode *oneRecord = [[ContactRecordNode alloc] init];
    oneRecord.contactID = self.myCallInfoNode.calleeRecordID;
    oneRecord.phoneNum = self.myCallInfoNode.calleePhone;
    [oneRecord dateStringFromDate:startDate];    //通话时间
    oneRecord.recordType = self.myCallInfoNode.calltype;  //通话类型
    //处理呼叫号码
    NSString  *countryCode = [ZdywUtils getLocalStringDataValue:kCurrentCountryCode];
    
    if ([self.myCallInfoNode.calleePhone hasPrefix:@"+"]) {    //处理呼叫号码
        oneRecord.phoneNum = [NSString stringWithFormat:@"86%@",[[ContactManager shareInstance] deleteCountryCodeFromPhoneNumber:self.myCallInfoNode.calleePhone
                                                                                                                     countryCode:countryCode]];
    } else if(![[self.myCallInfoNode.calleePhone substringToIndex:2] isEqualToString:@"86"]){
        oneRecord.phoneNum = [[ContactManager shareInstance] deleteCountryCodeFromPhoneNumber:self.myCallInfoNode.calleePhone
                                                                                  countryCode:countryCode];
    }
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

#pragma mark - PrivateMethod

//开始回拨呼叫请求
- (void)startCallBackRequest
{
    NSString *strData = @"callee=%@";
    //获取callee(被叫号码)
    //处理呼叫号码
    NSString  *countryCode = [ZdywUtils getLocalStringDataValue:kCurrentCountryCode];
    //去掉电话号码的特殊字符
    NSString *callNumberStr = [[ContactManager shareInstance] deleteCountryCodeFromPhoneNumber:_myCallInfoNode.calleePhone
                                                                                   countryCode:countryCode];
    
    NSString *strCallee = [self dealPhoneNumbe:callNumberStr];
    strData = [NSString stringWithFormat:strData, strCallee];
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:0];
    [dic setObject:strData forKey:kAGWDataString];
    [[ZdywServiceManager shareInstance] requestService:ZdywServiceBackCall
                                              userInfo:nil
                                              postDict:dic];
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
#pragma mark - ModelEngineUIDelegate

-(void)responseVoipManagerStatus:(UCSCallStatus)event callID:(NSString*)callid data:(UCSReason *)data
{
    self.callUCSId=callid;
    
    switch (event)
    {
        case UCSCallStatus_Alerting:
        {
        }
            break;
            
        case UCSCallStatus_Answered:
        {

        }
            break;
        case UCSCallStatus_Released:
        {
            ZdywAppDelegate *app=(ZdywAppDelegate*)[[UIApplication sharedApplication] delegate];
            NSString *msg=[app.ucsFuncEngine messageWithErrorCode:data.reason];
            if ([msg length]==0) {
                msg=data.msg;
            }
            [self showCallBackErr:msg isErr:NO];
        }
            break;
        case UCSCallStatus_Failed:
        {
            ZdywAppDelegate *app=(ZdywAppDelegate*)[[UIApplication sharedApplication] delegate];
            NSString *msg=[app.ucsFuncEngine messageWithErrorCode:data.reason];
            if ([msg length]==0) {
                msg=@"呼叫失败,请稍后重新拨打。";
            }
            [self showCallBackErr:msg isErr:YES];
        }
            break;
        case UCSCallStatus_CallBack:
        {
           [self showCallBackErr:@"回拨成功,请注意系统来电!" isErr:NO];
        }
            break;
        case UCSCallStatus_CallBackFailed:
        {
            ZdywAppDelegate *app=(ZdywAppDelegate*)[[UIApplication sharedApplication] delegate];
            NSString *msg=[app.ucsFuncEngine messageWithErrorCode:data.reason];
            if ([msg length]==0) {
                msg=@"回拨失败";
            }
            [self showCallBackErr:msg isErr:YES];
        }
            break;
        default:
            break;
    }
}
@end
