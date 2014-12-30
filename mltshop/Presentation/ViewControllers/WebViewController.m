//
//  WebViewController.m
//  iMedia
//
//  Created by meng qian on 12-11-9.
//  Copyright (c) 2012年 Li Xiaosi. All rights reserved.
//

#import "WebViewController.h"
#import <NJKWebViewProgress/NJKWebViewProgressView.h>
#import <NJKWebViewProgress/NJKWebViewProgress.h>

@interface WebViewController ()<UIWebViewDelegate,NJKWebViewProgressDelegate>
{
    NJKWebViewProgress *_progressProxy;
    NJKWebViewProgressView *_progressView;
}

@property(strong, nonatomic)UIWebView *webView;
@property(readwrite, nonatomic)BOOL firstLoad;
@end

@implementation WebViewController

@synthesize urlString;
@synthesize webView;
@synthesize titleString;
@synthesize webType;
@synthesize firstLoad;

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
    self.title = self.titleString;
    
    self.webView  = [[UIWebView alloc]initWithFrame:self.view.bounds];
    
    self.webView.delegate = self;

    [self.view addSubview:self.webView];
	// Do any additional setup after loading the view.
    
    /**
     * NJKWebView
     */
    _progressProxy = [[NJKWebViewProgress alloc] init]; // instance variable
    webView.delegate = _progressProxy;
    _progressProxy.webViewProxyDelegate = self;
    _progressProxy.progressDelegate = self;
    
    CGFloat progressBarHeight = 2.5f;
    CGRect navigaitonBarBounds = self.navigationController.navigationBar.bounds;
    CGRect barFrame = CGRectMake(0, navigaitonBarBounds.size.height - progressBarHeight, navigaitonBarBounds.size.width, progressBarHeight);
    _progressView = [[NJKWebViewProgressView alloc] initWithFrame:barFrame];

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.firstLoad = YES;
    
    NSURL *url = [NSURL URLWithString:self.urlString];
    NSURLRequest * request = [[NSURLRequest alloc] initWithURL:url];
    [self.webView loadRequest:request];
    
    [_progressView setHidden:YES];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [_progressView removeFromSuperview];


}

-(void)webViewProgress:(NJKWebViewProgress *)webViewProgress updateProgress:(float)progress
{
    [_progressView setHidden:NO];
    [_progressView setProgress:progress animated:YES];
}

////////////////////////////////////////////////////

- (void)webViewDidFinishLoad:(UIWebView *)_webView
{
    if ([self.webView isEqual:_webView] && self.firstLoad ) {
        self.firstLoad = NO;
    }

}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
