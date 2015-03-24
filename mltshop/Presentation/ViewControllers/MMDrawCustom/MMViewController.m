//
//  MMViewController.m
//  bitmedia
//
//  Created by meng qian on 14-1-20.
//  Copyright (c) 2014年 thinktube. All rights reserved.
//

#import "MMViewController.h"
#import "AppDelegate.h"
#import "PassValueDelegate.h"
#import <AFNetworking/UIImageView+AFNetworking.h>
#import "FAHoverButton.h"

@interface MMViewController ()<PassValueDelegate>
@end

@implementation MMViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setClick) name:SIGNAL_PAN object:nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if(OSVersionIsAtLeastiOS7()){
        [[NSNotificationCenter defaultCenter]
         addObserver:self
         selector:@selector(contentSizeDidChangeNotification:)
         name:UIContentSizeCategoryDidChangeNotification
         object:nil];
    }
    self.view.backgroundColor = BGCOLOR;
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter]
     removeObserver:self];
}

-(void)contentSizeDidChangeNotification:(NSNotification*)notification{
    [self contentSizeDidChange:notification.userInfo[UIContentSizeCategoryNewValueKey]];
}

#pragma mark - setup Buttons
/**
 *  left and rigt menu
 */

-(void)setupLeftMMButton{
    FAHoverButton *leftDrawerAvatarButton = [FAHoverButton buttonWithType:UIButtonTypeCustom];
    [leftDrawerAvatarButton setTitle:ICON_BARS forState:UIControlStateNormal];
    [leftDrawerAvatarButton setFrame:CGRectMake(0, 0, ROUNDED_BUTTON_HEIGHT, ROUNDED_BUTTON_HEIGHT)];
    
    [leftDrawerAvatarButton addTarget:self action:@selector(leftDrawerButtonPress:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem * leftDrawerButton = [[UIBarButtonItem alloc]initWithCustomView:leftDrawerAvatarButton];
    
    [self.navigationItem setLeftBarButtonItem:leftDrawerButton animated:YES];
}

-(void)setupRightMMButton{
    MMDrawerBarButtonItem * rightDrawerButton = [[MMDrawerBarButtonItem alloc] initWithTarget:self action:@selector(rightDrawerButtonPress:)];
    [self.navigationItem setRightBarButtonItem:rightDrawerButton animated:YES];
}

#pragma mark - Button Handlers

- (void)setClick {
    [self leftDrawerButtonPress:nil];
}
-(void)leftDrawerButtonPress:(id)sender{
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}

-(void)rightDrawerButtonPress:(id)sender{
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideRight animated:YES completion:nil];
}


-(void)contentSizeDidChange:(NSString *)size{
    //Implement in subclass
}

@end
