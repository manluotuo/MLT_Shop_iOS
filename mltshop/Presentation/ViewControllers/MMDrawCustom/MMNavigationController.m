//
//  MMNavigationController.m
//  bitmedia
//
//  Created by meng qian on 14-1-20.
//  Copyright (c) 2014年 thinktube. All rights reserved.
//

#import "MMNavigationController.h"
#import "UIViewController+MMDrawerController.h"

@interface MMNavigationController ()

@end

@implementation MMNavigationController

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000

-(UIStatusBarStyle)preferredStatusBarStyle{
    if(self.mm_drawerController.showsStatusBarBackgroundView){
        return UIStatusBarStyleLightContent;
    }
    else {
        return UIStatusBarStyleLightContent;
    }
}

#endif

- (BOOL)shouldAutorotate
{
    return self.topViewController.shouldAutorotate;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return self.topViewController.supportedInterfaceOrientations;
}


@end
