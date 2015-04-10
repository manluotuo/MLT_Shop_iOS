//
//  ColorNavigationController.m
//  bitmedia
//
//  Created by meng qian on 14-3-21.
//  Copyright (c) 2014年 thinktube. All rights reserved.
//

#import "ColorNavigationController.h"
#import "UIViewController+ImageBackButton.h"



@interface ColorNavigationController ()

@end

@implementation ColorNavigationController

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
    [self customNavigationView];
}

- (void)customNavigationView
{
    if (OSVersionIsAtLeastiOS7()) {
        self.navigationBar.barTintColor = ORANGECOLOR;
        self.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:WHITECOLOR};
        self.navigationBar.barStyle = UIStatusBarStyleLightContent;
    }else{
        [[UINavigationBar appearance] setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
        [[UINavigationBar appearance] setBackgroundColor:ORANGECOLOR];
    }
}


- (BOOL)shouldAutorotate
{
    return self.topViewController.shouldAutorotate;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return self.topViewController.supportedInterfaceOrientations;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
