//
//  UCSTokenManager.m
//  ZdywClient
//
//  Created by wulanzhou-mini on 14-9-23.
//  Copyright (c) 2014年 Guoling. All rights reserved.
//

#import "UCSTokenManager.h"

@interface UCSTokenManager ()
- (void)requestUCSToken;
@end

@implementation UCSTokenManager
//单例模式
+ (UCSTokenManager *)sharedInstance{
    static dispatch_once_t  onceToken;
    static UCSTokenManager * sSharedInstance;
    
    dispatch_once(&onceToken, ^{
        sSharedInstance = [[UCSTokenManager alloc] init];
    });
    return sSharedInstance;
}
- (void)connectionUCSToken{
    
    NSString *uidStr = [ZdywUtils getLocalIdDataValue:kZdywDataKeyUserID];
    NSString *pwdStr = [ZdywUtils getLocalIdDataValue:kZdywDataKeyUserPwd];
    NSString *phoneStr = [ZdywUtils getLocalIdDataValue:kZdywDataKeyUserPhone];
    if (![uidStr length] || ![pwdStr length] || ![phoneStr length]) {
       //表示未登陆
    }else{//表示已登陆
        //NSString *token = [ZdywUtils getLocalStringDataValue:kUCSTokenId];
        PhoneNetType netType = [ZdywUtils getCurrentPhoneNetType];
        if(netType == PNT_UNKNOWN){//表示无网络
            return;
        }
        [self requestUCSToken];
    }
}
- (void)requestUCSToken{
    //取得云之讯token
    NSString *strData = @"brandid=%@";
    //获取BrandID
    NSString *strBrandID = [ZdywUtils getLocalStringDataValue:kZdywDataKeyBrandID];
    strData = [NSString stringWithFormat:strData,strBrandID];
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:0];
    [dic setObject:strData forKey:kAGWDataString];
    [[ZdywServiceManager shareInstance]requestService:ZdywServiceUCSTokenType
                                             userInfo:nil
                                             postDict:dic];
}
@end
