//
//  WebViewController.m
//  iMedia
//
//  Created by meng qian on 12-11-9.
//  Copyright (c) 2012年 Li Xiaosi. All rights reserved.
//

#import "WebViewController.h"
#import "UIViewController+ImageBackButton.h"
#import <NJKWebViewProgress/NJKWebViewProgressView.h>
#import <NJKWebViewProgress/NJKWebViewProgress.h>
#import "GoodsDetailViewController.h"
#import "MJRefresh.h"

@interface WebViewController ()<UIWebViewDelegate, NJKWebViewProgressDelegate, PassValueDelegate>
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

- (void)setUpDownButton:(NSInteger)position
{
    [self setUpImageDownButton:0];
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

    self.firstLoad = YES;
    NSURL *url = [NSURL URLWithString:self.urlString];
    NSURLRequest * request = [[NSURLRequest alloc] initWithURL:url];
    [self.webView loadRequest:request];
    
    [_progressView setHidden:YES];
    
}

/** 敏！ */
-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
    NSString *requestString = [[request URL] absoluteString];//获取请求的绝对路径.
    id parsed = [DataTrans parseDataFromURL:requestString];
    if (![parsed isKindOfClass:[SearchModel class]]) {
        if (DictionaryHasValue(parsed)) {
            if ([parsed[@"type"] isEqualToString:@"goods"]){
                GoodsDetailViewController *VC = [[GoodsDetailViewController alloc]initWithNibName:nil bundle:nil];
                VC.passDelegate = self;
                GoodsModel *theGoods = [[GoodsModel alloc]init];
                theGoods.goodsId = parsed[@"id"];
                [VC setGoodsData:theGoods];
                [self.navigationController presentViewController:VC animated:YES completion:nil];
                return NO;
            }
        }
    }
    self.urlString = requestString;
    return YES;
}

    
//    NSLog(@"******%@", requestString);
//    NSArray *components = [requestString componentsSeparatedByString:@":"];//提交请求时候分割参数的分隔符
//    NSLog(@"!!!!!%@", components[0]);
//    NSLog(@"&&&&&%@", components[1]);
//    
//    if ([components count] > 1 && [(NSString *)[components objectAtIndex:0] isEqualToString:@"openGood"]) {
//        //过滤请求是否是我们需要的.不需要的请求不进入条件
//        NSLog(@"openGood == openGood == openGood == openGood");
//        
//        GoodsDetailViewController *VC = [[GoodsDetailViewController alloc]initWithNibName:nil bundle:nil];
//        VC.passDelegate = self;
//        GoodsModel *theGoods = [[GoodsModel alloc]init];
//        theGoods.goodsId = [components objectAtIndex:1];
//        [VC setGoodsData:theGoods];
//        [self presentViewController:VC animated:YES completion:nil];
//        
//        return NO;
//    }
//    
//    if ([components count] > 1 && [(NSString *)[components objectAtIndex:0] isEqualToString:@"openCatagory"]) {
//        //过滤请求是否是我们需要的.不需要的请求不进入条件
//        
//        return NO;
//    }


- (void)openGood {
    NSLog(@"111");
}

- (void)openCatagory {
    NSLog(@"222");
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
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
