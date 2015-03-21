//
//  ZBarScanViewController.m
//  merchant
//
//  Created by mactive.meng on 30/7/14.
//  Copyright (c) 2014 kkche. All rights reserved.
//

#import "ZBarScanViewController.h"
#import "ScanOverlayView.h"
#import "FAHoverButton.h"
#import "AppRequestManager.h"

#import "HuoDongViewController.h"

#import "HttpRequest.h"

@interface ZBarScanViewController ()<NSURLSessionDataDelegate, HttpRequestDelegate>
@property(nonatomic, strong)ScanOverlayView *overlayView;
@property(nonatomic, strong)FAHoverButton *cancelButton;
@property(nonatomic, strong)UILabel *warningLabel;
@property(nonatomic, strong)NSString *scanData;
@end

@implementation ZBarScanViewController {
    NSURLConnection *_connection;
    NSMutableData *_responseData;
    HttpRequest *_request;
}
@synthesize reader;
@synthesize overlayView;
@synthesize cancelButton;
@synthesize warningLabel;
@synthesize scanData;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = T(@"扫描漫骆驼二维码");
        _responseData = [[NSMutableData alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self init_camera];
    [self initOverlayView];
    self.scanData = @"";
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void) init_camera
{
    ZBarImageScanner * scanner = [[ZBarImageScanner alloc]init];
    [scanner setSymbology:ZBAR_PARTIAL config:0 to:0];
    
    self.reader = [[ZBarReaderView alloc] initWithImageScanner:scanner];
    self.reader.torchMode = UIImagePickerControllerCameraFlashModeOff;
    self.reader.readerDelegate = self;
    
    CGRect reader_rect = self.view.bounds;
    self.reader.frame = reader_rect;
    self.reader.backgroundColor = [UIColor redColor];
    [self.reader start];
    
    [self.view addSubview: self.reader];
    
}

- (void)initOverlayView
{
    self.overlayView = [[ScanOverlayView alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:self.overlayView];
    
    self.cancelButton = [FAHoverButton buttonWithType:UIButtonTypeCustom];
    [self.cancelButton setTitle:ICON_TIMES_CIRCLE_O forState:UIControlStateNormal];
    [self.cancelButton setFrame:CGRectMake(H_10, H_40, H_60, H_60)];
    [self.cancelButton setBackgroundColor:[UIColor clearColor]];
    [self.cancelButton setIconFont:FONT_AWESOME_36];
    [self.cancelButton setIconColor:GRAYLIGHTCOLOR];
    [self.cancelButton addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.cancelButton];
    
    CGFloat xOffset = 0.0;
    if (OSVersionIsAtLeastiOS7()) {
        if (IS_IPHONE_5) {
            xOffset = H_0; // 5s 5 5c
        }else{
            xOffset = H_40; //4s
        }
    }
    
    self.warningLabel = [[UILabel alloc] initWithFrame:CGRectMake( 0, H_60, TOTAL_WIDTH, H_24)];
    self.warningLabel.font = FONT_16;
    self.warningLabel.textColor = WHITECOLOR;
    self.warningLabel.textAlignment = NSTextAlignmentCenter;
    self.warningLabel.text = T(@"请扫描漫骆驼二维码");
    self.warningLabel.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.warningLabel];
}

- (void)cancelAction
{
    [self dismissViewControllerAnimated:YES completion:^{
        [self.passDelegate passSignalValue:SIGNAL_BARCODE_SCAN_SUCCESS andData:self.scanData];
    }];
}

- (void)dismissCollection {
    [self dismissViewControllerAnimated:YES completion:nil];
}

//if ([responseObject[@"status"] isEqualToString:@"no"]) {
//    [DataTrans showWariningTitle:T(@"亲~您太着急了哦\n活动还没有开始呢") andCheatsheet:nil andDuration:3.0f];
//} else {
//    self.scanData = responseObject[@"goodis"];
//    [self cancelAction];
//}

- (void)readerView:(ZBarReaderView *)readerView didReadSymbols: (ZBarSymbolSet *)symbols fromImage:(UIImage *)image
{
    ZBarSymbol * s = nil;
    for (s in symbols)
    {
        if ([s.data isEqualToString:@"http://www.manluotuo.com/huodong.php"]) {
            [HttpRequest requestWithString:s.data andTarget:self];
        } else {
            [DataTrans showWariningTitle:T(@"扫描成功,正在打开") andCheatsheet:ICON_INFO andDuration:3.0];
            [self cancelAction];
            NSLog(@"%@", s.data);
            self.scanData = s.data;
        }
        //        [self.passDelegate passSignalValue:SIGNAL_BARCODE_SCAN_SUCCESS andData:s.data];
        //        text.text = s.data;
        //        image_view.image = image;
    }
}


- (void)requestDidFinishLoadingWithData:(NSData *)data {
    NSDictionary *responseObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    NSLog(@"%@", responseObject);
    
    

    
}

//数据请求成功
- (void)httpRequestFinished:(HttpRequest *)request {
    
    NSDictionary *responseObject = [NSJSONSerialization JSONObjectWithData:request.respondsData options:NSJSONReadingAllowFragments error:nil];
    
    NSLog(@"%@", responseObject);
    NSString *str = responseObject[@"status"];
    NSLog(@"%@", str);
    
    if ([str isEqualToString:@"no"]) {
        
        [DataTrans showWariningTitle:T(@"亲~您太着急了哦\n活动还没有开始呢!") andCheatsheet:nil andDuration:2.0f];
        [self dismissCollection];
        
    }
    if ([str isEqualToString:@"yes"]){
        NSString *str = [NSString stringWithFormat:@"http://www.manluotuo.com/goods-%@.html", responseObject[@"goods"]];
        self.scanData = str;
        [self cancelAction];
    }
    if ([str isEqualToString:@"none"]) {
        [DataTrans showWariningTitle:T(@"亲~实在不好意思哦\n您来晚了，活动已经结束了呢！") andCheatsheet:nil andDuration:2.0f];
        [self dismissCollection];
    }
}
//数据请求失败
- (void)httpRequestFailed:(HttpRequest *)request {
    NSLog(@"失败");
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
