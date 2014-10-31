//
//  ZdywConfig.h
//  ZdywMini
//
//  Created by mini1 on 14-5-28.
//  Copyright (c) 2014年 Guoling. All rights reserved.
//

#define kZdywClientIsIphone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)

#define kAppStoreVersion                0        //修改宏定义为1 让其支持上传AppStore
#define kZdywBrandID                    @"dd"                                           //brandid
// AppStore版本用 iphone-app 企业版用iphone
//DD因为企业版占住iphone-app 所以AppStore版用iphone

#define kZdywPhoneType                  @"iphone"                                   //pv
#define kZdywPublicKey                  @"9d,t543210!@#$%^"                         //public_key
#define kZdywAppleID                    @"845078110"                                //apple id
#define kZdywHttpServer                 @"http://202.105.136.106:11314"  //测试地址
/***
#define kZdywServiceHosts               [NSArray arrayWithObjects:@"http://202.105.136.106:11314",@"http://agw.ddtel.cn:2001",@"http://agw1.ddtel.cn:2002",@"http://agw2.ddtel.cn:2003",@"http://agw3.ddtel.cn:2004",@"http://agw4.ddtel.cn:2005",@"http://access.guoling.com/
 zd",nil]  //多服务器地址配置
 ***/
#define kZdywServiceHosts               [NSArray arrayWithObjects:@"http://202.105.136.106:11314",nil]  //多服务器地址配置

#define kPaySource                      @"59"
#define kCustomerServicePhone           @"02868712503"                   //客服电话
#define kCustomerServiceQQ              @"2263398703"                    //客服QQ
#define kInvite                         @"5"
#define kCustomerServiceTime            @"8:00-23:00"