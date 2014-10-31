//
//  DirectCallViewController.h
//  ZdywClient
//
//  Created by ddm on 7/1/14.
//  Copyright (c) 2014 Guoling. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CallInfoNode.h"
#import "UCSFuncEngine.h"
@interface DirectCallViewController : UIViewController<UCSEngineUIDelegate>

@property (nonatomic, strong) CallInfoNode *callInfoNode;

@property (nonatomic, strong) IBOutlet UIScrollView *mianScrollView;
@property (nonatomic, strong) IBOutlet UIButton     *muteBtn;//静音
@property (nonatomic, strong) IBOutlet UIButton     *handsfreeBtn;//免提
@property (nonatomic, strong) IBOutlet UIButton     *dialKeyBtn;//键盘
@property (nonatomic, strong) IBOutlet UIButton     *contactBtn;//联系人
@property (nonatomic, strong) IBOutlet UIButton     *hangupCallBtn;//结束通话

@property (nonatomic, strong) IBOutlet UILabel      *contactNameLable;//显示名称
@property (nonatomic, strong) IBOutlet UIImageView  *signalsImageView;
@property (nonatomic, strong) IBOutlet UILabel      *directLable;//显示拨打状态

@property (nonatomic, strong) IBOutlet UIView       *dialPlateView;//拨号键盘view
@property (nonatomic, strong) IBOutlet UIButton     *dialHangupCallBtn;//结束通话
@property (nonatomic, strong) IBOutlet UIButton     *hideDialPlateBtn;//隐藏键盘

@property (nonatomic, strong) IBOutlet UILabel      *phoneArea;//显示电话号码所在区域
@property (nonatomic, strong) UILabel  *clickKeyLable;

@property (nonatomic, strong) NSString *callUCSId;
@property (nonatomic, assign) BOOL isFirstCall;


- (IBAction)clickDialPlate:(id)sender;

- (void)startCall:(CallInfoNode *)callInfoNode;

@end
