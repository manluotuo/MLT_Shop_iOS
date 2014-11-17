//
//  LMViewController.m
//  bitmedia
//
//  Created by meng qian on 14-2-21.
//  Copyright (c) 2014年 thinktube. All rights reserved.
//

#import "LMViewController.h"
#import "FAHoverButton.h"

@interface LMViewController ()

@end

@implementation LMViewController
@synthesize passDelegate;
@synthesize leftMenuFunction;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self setUpImageBackButton];
    self.leftMenuFunction = 0;
}

- (void)setUpImageBackButton
{
    FAHoverButton *backButton = [[FAHoverButton alloc] initWithFrame:CGRectMake(0, 0, 34, 34)];
    [backButton setTitle:ICON_BACK forState:UIControlStateNormal];
    [backButton.titleLabel setFont:FONT_AWESOME_30];
    [backButton.titleLabel setTextAlignment:NSTextAlignmentLeft];
    [backButton setTitleColor:WHITECOLOR forState:UIControlStateNormal];
    
    UIBarButtonItem *barBackButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    [backButton addTarget:self action:@selector(doneAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = barBackButtonItem;
    self.navigationItem.hidesBackButton = YES;
}

- (void)doneAction
{
    
    CATransition *transition = [CATransition animation];
    transition.duration = 0.3;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromLeft;
    
    
    [self.view.window.layer addAnimation:transition forKey:kCATransition];
    
    [self dismissViewControllerAnimated:NO completion:^{}];
    
    [self.passDelegate passStringValue:SIGNAL_LEFT_MENU andIndex:self.leftMenuFunction];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
