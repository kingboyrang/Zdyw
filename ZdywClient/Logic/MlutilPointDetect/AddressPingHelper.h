//
//  AddressPingHelper.h
//  SkyClient
//
//  Created by dyn on 13-6-22.
//  Copyright (c) 2013年 D-TONG-TELECOM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SimplePing.h"

@protocol AddressPingHelperDelegate <NSObject>

// 网络异常
- (void)testNetDidAbnormal;

// 网络正常
- (void)testNetDidNormal;

@end

@interface AddressPingHelper : NSObject<SimplePingDelegate>
{
    NSTimer                             *_timeoutTimer;
}

@property(assign)id<AddressPingHelperDelegate> delegate;

@property(nonatomic, retain)SimplePing *pinger;

- (void)pingHostName:(NSString *)hostName;

@end
