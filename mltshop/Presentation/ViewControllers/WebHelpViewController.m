//
//  WebHelpViewController.m
//  remote
//
//  Created by Mactive on 4/19/14.
//  Copyright (c) 2014 wukongtv. All rights reserved.
//

#import "WebHelpViewController.h"
@interface WebHelpViewController ()

@end

@implementation WebHelpViewController

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
//    [self.webViewController.navigationController setToolbarHidden:YES];
}

- (void)setWebViewToolbarHidden:(BOOL)hidden
{
//    [self.webViewController.navigationController setToolbarHidden:hidden];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
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
