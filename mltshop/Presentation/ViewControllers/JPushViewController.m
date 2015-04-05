//
//  JPushViewController.m
//  mltshop
//
//  Created by 小新 on 15/4/3.
//  Copyright (c) 2015年 manluotuo. All rights reserved.
//

#import "JPushViewController.h"
#import "FAHoverButton.h"


@interface JPushViewController ()

@property (nonatomic, strong) UIWebView *webView;

@end

@implementation JPushViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:WHITECOLOR];
    [self setupleftButton];
    [self customWebView];
}

- (void)customWebView {
    self.webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.webView setBackgroundColor:WHITECOLOR];
    self.webView.y = IOS7_CONTENT_OFFSET_Y;
    self.webView.height = TOTAL_HEIGHT - IOS7_CONTENT_OFFSET_Y;
    NSUserDefaults *user = USER_DEFAULTS;
    self.title = T(@"漫骆驼");
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[user valueForKey:@"url"]]]];
    [self.webView reload];
    [self.view addSubview:self.webView];
    [user removeObjectForKey:@"url"];
    [user synchronize];
}

- (void)setupleftButton
{
    CGFloat leftMargin = 10.0f;
    FAHoverButton *backButton = [[FAHoverButton alloc] initWithFrame:CGRectMake(0, 0, 12+leftMargin, 21)];
    [backButton setTitle:ICON_BACK forState:UIControlStateNormal];
    [backButton.titleLabel setFont:FONT_AWESOME_36];
    [backButton setImageEdgeInsets:UIEdgeInsetsMake(0, leftMargin, 0, 0)];
    
    
    UIBarButtonItem *barBackButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    [backButton addTarget:self action:@selector(onLeftBtnClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = barBackButtonItem;
    self.navigationItem.hidesBackButton = YES;
}

- (void)onLeftBtnClick {
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
