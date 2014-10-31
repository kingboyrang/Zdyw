//
//  ZdywCommonFun.m
//  ZdywMini
//
//  Created by zhaojun on 14-6-4.
//  Copyright (c) 2014年 Guoling. All rights reserved.
//

#import "ZdywCommonFun.h"
#import "ZdywColorFont.h"
#import "ZdywUtils.h"

@implementation ZdywCommonFun

// 获取客服电话
+ (NSString *)getCustomerPhone
{
    NSString *strPhone = [ZdywUtils getLocalStringDataValue:kCustomerPhone];
    
    if([strPhone length] <= 0)
    {
        strPhone = kCustomerServicePhone;
    }
    
    return strPhone;
}

// 获取客服服务时间
+ (NSString *)getServiceTime{
    NSString *strService = [ZdywUtils getLocalStringDataValue:kServiceTime];
    if ([strService length] <= 0) {
        strService = kCustomerServiceTime;
    }
    return strService;
}

//根据图片和文字创建一个button
+ (UIButton *)createCustomButtonText:(NSString *)str
                         normalImage:(UIImage*)normalImg
                    highlightedImage:(UIImage *)highlightedImg{
    CGRect backframe = CGRectMake(0, 10, 60, 20);
    if(normalImg)
    {
        backframe = CGRectMake(0, 0, normalImg.size.width/2, normalImg.size.height/2);
    }
    
    UIButton  *tempBackButton= [UIButton buttonWithType:UIButtonTypeCustom];
    
    
    
    tempBackButton.frame = backframe;
    if(normalImg)
    {
        [tempBackButton setBackgroundImage:normalImg
                                  forState:UIControlStateNormal];
        [tempBackButton setBackgroundImage:highlightedImg forState:UIControlStateHighlighted];
    }
    
    
    [tempBackButton setTitleColor:kCustomNavigationBarBackButtonTextColor forState:UIControlStateNormal];
    [tempBackButton setTitleColor:kCustomNavigationBarBackButtonTextHighlightedColor forState:UIControlStateHighlighted];
    tempBackButton.titleLabel.textAlignment = NSTextAlignmentRight;
    tempBackButton.titleLabel.font=kCustomNavigationBarBackButtonTextFont;
    if(str)
    {
        [tempBackButton setTitle:str forState:UIControlStateHighlighted];
        [tempBackButton setTitle:str forState:UIControlStateNormal];
        
    }
    return tempBackButton;
}

+ (void) ShowMessageBox:(int)msgboxID
              titleName:(NSString *)strTitle
            contentText:(NSString *)strContent
          cancelBtnName:(NSString *)strBtnName
                 confim:(NSString *)confimBtnName
               delegate:(id)delegate
{
    UIAlertView *box = [[UIAlertView alloc] initWithTitle:strTitle
                                                  message:strContent
                                                 delegate:delegate
                                        cancelButtonTitle:strBtnName
                                        otherButtonTitles:confimBtnName
                        ,nil];
    
    box.tag = msgboxID;
    [box show];
}

+ (void) ShowMessageBox:(int)msgboxID
              titleName:(NSString *)strTitle
            contentText:(NSString *)strContent
          cancelBtnName:(NSString *)strBtnName
               delegate:(id)delegate
{
    UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:strTitle
                                                     message:strContent
                                                    delegate:delegate
                                           cancelButtonTitle:strBtnName
                                           otherButtonTitles:nil];
    msgbox.tag = msgboxID;
    [msgbox show];
}

+ (NSString *)getRc4Pwd
{
    NSString *strPwd = [ZdywUtils getLocalStringDataValue:kZdywDataKeyUserID];
    
    if([strPwd length] > 0)
    {
        strPwd = [Zdyw_rc4 RC4Encrypt:strPwd withKey:@"1bb762f7ce24ceee"];
        strPwd = [strPwd lowercaseString];
    }
    
    return strPwd;
}

// 获取查询话单url
+ (NSString *)getCallLogUrl
{
    NSString *strCallLogUrl = [ZdywUtils getLocalStringDataValue:kAccountPayListWebURL];
    if([strCallLogUrl length] > 0)
    {
        strCallLogUrl = [NSString stringWithFormat:strCallLogUrl, [ZdywUtils getLocalStringDataValue:kZdywDataKeyUserID], [ZdywCommonFun getRc4Pwd]];
    }
    return strCallLogUrl;
}

+ (BOOL)validateEmail:(NSString *)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

+ (BOOL)validateQQ:(NSString *)QQ{
    NSString *QQRegex = @"[0-9]{5,12}";
    NSPredicate *QQTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", QQRegex];
    return [QQTest evaluateWithObject:QQ];
}

@end
