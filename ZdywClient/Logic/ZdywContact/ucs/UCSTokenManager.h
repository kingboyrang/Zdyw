//
//  UCSTokenManager.h
//  ZdywClient
//
//  Created by wulanzhou-mini on 14-9-23.
//  Copyright (c) 2014年 Guoling. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UCSTokenManager : NSObject
//单例模式
+ (UCSTokenManager *)sharedInstance;
//取云之讯token
- (void)connectionUCSToken;
@end
