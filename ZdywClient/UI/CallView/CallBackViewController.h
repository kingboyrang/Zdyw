//
//  CallBackViewController.h
//  ZdywClient
//
//  Created by ddm on 7/2/14.
//  Copyright (c) 2014 Guoling. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CallInfoNode.h"
#import "UCSFuncEngine.h"
@interface CallBackViewController : UIViewController<UCSEngineUIDelegate>

@property (nonatomic, strong) IBOutlet UIImageView *pointImageView;
@property (nonatomic, strong) CallInfoNode  *myCallInfoNode;
@property (nonatomic, strong) IBOutlet UILabel     *nameLable;
@property (nonatomic, strong) IBOutlet UILabel     *areaLable;


@property (nonatomic, strong) NSString *callUCSId;
@property (nonatomic, assign) BOOL isFirstCall;

- (void)startCall:(CallInfoNode *)callInfoNode;

@end
