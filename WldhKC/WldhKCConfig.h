//
//  ZdywConfig.h
//  ZdywMini
//
//  Created by mini1 on 14-5-28.
//  Copyright (c) 2014年 Guoling. All rights reserved.
//

#ifndef ZdywMini_WldhKCConfig_h
#define ZdywMini_WldhKCConfig_h

#define kAppStoreVersion      1  //是否为越狱版，1为否，0为否
#define kAppSpecialVersion    0  //是否为特殊渠道包，0否，1是

#pragma mark - 基础配置信息

#define kWldhBrandid           @"kc" //brandid

#if kAppStoreVersion
#define kWldhPhoneType         @"iphone-app" //pv
#else
#define kWldhPhoneType         @"iphone"     //pv
#endif

#define kWldhPublicKey         @"keepc_mobilephone!@#456" //public_key
#define kWldhAppleID           @"653349359"  //appID
#define kWldhHttpServer        @"http://agw.keepc.com:2001" //http server
//#define kWldhHttpServer     @"http://agw.keepc.com:2001" //http test server
#define kPaySource             @"59"
#define kCustomerServicePhone  @"075561363066"  //客服电话
#define kCustomerServiceQQ     @"800005998"     //客服QQ
#define kInvite                @"14700"         //默认联盟id

#pragma mark - QQ互联

//qq登录绑定相关参数配置
#define kQQAppId               @"100352391"
#define kQQZoneTitle           @"KC网络电话"
#define kQQZoneURL             @"http://wap.keepc.com"

//微信相关参数
#define kWeixinAppId           @"wxc303d16e6abb831a"
#define kWeixinAppKey          @"234c71a7468656b34273623c5a4c1d8c"
#define kWeixinUrl             @"http://wap.keepc.com"

#pragma mark - URL scheme

#define kQQLoginScheme         @"tencent100352391" //qq登陆相关
#define kAdSpaceScheme         @"kcadspace"        //wap页充值
#define kWeixinScheme          @"wxc303d16e6abb831a" //微信
#define kWldhAppScheme         @"kc"


#pragma mark - 积分墙配置信息

//极智
#define kJZAppstoreKey         @"000000003e1bdc63013e3ad215c40005"
//多盟
#define kDMengAppStoreKey      @"96ZJ1bDAzewzzwTAxY"

#pragma mark - 其他配置

#define kMoSidPrefix           @"k"  //MO注册sid的前缀

#if kAppSpecialVersion

#else
#define kUMStatisticsAppID     @"523119de56240b7a560a3a79" //友盟统计App ID
#endif

#endif
