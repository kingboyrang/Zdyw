//
//  ZdywAppDelegate.h
//  ZdywMini
//
//  Created by mini1 on 14-5-28.
//  Copyright (c) 2014年 Guoling. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MutilPointDetectController.h"
#import "SystemNoticeView.h"
#import "SysMessageObj.h"
#import "UCSFuncEngine.h"
@interface ZdywAppDelegate : UIResponder <UIApplicationDelegate,UIActionSheetDelegate,MutilPointDetectControllerDelegate,UIAlertViewDelegate>

@property (nonatomic, strong) UIWindow          *window;
@property (nonatomic, assign) BOOL              userIsLogined;
@property (nonatomic, assign) BOOL              isNewMsg;
@property (nonatomic, strong) SysMessageObj         *sysMessage;
@property (retain, nonatomic) UCSFuncEngine     *ucsFuncEngine;
//@property (retain, nonatomic) UCSService     *ucsService;

+ (ZdywAppDelegate *)appDelegate;

- (void)afterClientActived;

- (void)startCallWithPhoneNumber:(NSString *)phoneNumber
                     contactName:(NSString *)contactName
                       contactID:(NSInteger)contactID;

- (void)callWithContactID:(NSInteger)contactID;

- (void)showLoginView;

- (void)displayUpdateView;

- (void)handleTokenReport;

- (void)showSystemNoticeView;

@end
