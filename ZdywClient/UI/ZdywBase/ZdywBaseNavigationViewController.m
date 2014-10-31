//
//  ZdywBaseNavigationViewController.m
//  ZdywClient
//
//  Created by ddm on 6/16/14.
//  Copyright (c) 2014 Guoling. All rights reserved.
//

#import "ZdywBaseNavigationViewController.h"

@interface ZdywBaseNavigationViewController ()

@end

@implementation ZdywBaseNavigationViewController

#pragma mark - LiftCycle

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(id)initWithRootViewController:(UIViewController *)rootViewController{
    if (self = [super initWithRootViewController:rootViewController]){
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
            [self.navigationBar setBarTintColor:[UIColor colorWithRed:28.0/255 green:28.0/255 blue:28.0/255 alpha:1.0]];
            [self.navigationBar setTintColor:[UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0]];
        } else {
            [self.navigationBar setTintColor:[UIColor colorWithRed:28.0/255 green:28.0/255 blue:28.0/255 alpha:1.0]];
        }
        [self.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                    [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0],
                                                    UITextAttributeTextColor,
                                                    [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.8],
                                                    UITextAttributeTextShadowColor,
                                                    [NSValue valueWithUIOffset:UIOffsetMake(0, -1)],
                                                    UITextAttributeTextShadowOffset,
                                                    [UIFont fontWithName:@"Arial-Bold" size:22.0],
                                                    UITextAttributeFont,nil]];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setDelegate:self];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
