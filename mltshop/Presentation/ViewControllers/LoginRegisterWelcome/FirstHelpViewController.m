//
//  FirstHelpViewController.m
//  remote
//
//  Created by meng qian on 14-4-1.
//  Copyright (c) 2014年 wukongtv. All rights reserved.
//

#import "FirstHelpViewController.h"
#import "GCPagedScrollView.h"
#import "KKFlatButton.h"
#import "AppDelegate.h"

@interface FirstHelpViewController ()<UIScrollViewDelegate>

@property(strong, nonatomic)GCPagedScrollView *pagedScrollView;
@property(strong, nonatomic)NSArray *scrollInfoArray;
@property(strong, nonatomic)KKFlatButton *checkButton;


@end

@implementation FirstHelpViewController
@synthesize pagedScrollView;
@synthesize scrollInfoArray;
@synthesize checkButton;

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
    
    UIImageView *bgView = [[UIImageView alloc]initWithFrame:self.view.bounds];
    [bgView setImage:[UIImage imageNamed:@"Default-568h"]];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, H_50, TOTAL_WIDTH, H_30)];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = FONT_DIN_24;
    titleLabel.textColor = WHITECOLOR;
    titleLabel.text = @"Welcome!";
    
    [bgView addSubview:titleLabel];
    
    [self.view addSubview:bgView];
    
    [self initScrollView];
}

- (void)initScrollView
{
    self.scrollInfoArray = [[NSArray alloc]initWithObjects:
                             @{@"icon":@"fa-bank",@"title":@"这里只有原创和正版",@"summary":@"漫骆驼向您承诺\n我们的商品都是由品牌授权厂家直接生成供货,都是正品!"},
                             @{@"icon":@"fa-truck",@"title":@"满198元包邮",@"summary":@"手机购物享受更多折扣\n订单实付金额满198元（不限件数）快递包邮"},
                             @{@"icon":@"fa-film",@"title":@"正品电影动漫周边商城",@"summary":@"为电影动漫爱好者提供优质、优惠的正品周边商品"},
                             nil];
    
    CGRect scrollFrame = CGRectMake(0, 0, TOTAL_WIDTH, TOTAL_HEIGHT);
    self.pagedScrollView = [[GCPagedScrollView alloc] initWithFrame:scrollFrame andPageControl:YES];
    self.pagedScrollView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
    self.pagedScrollView.backgroundColor = [UIColor clearColor];
    self.pagedScrollView.minimumZoomScale = 1; //最小到0.3倍
    self.pagedScrollView.maximumZoomScale = 3.0; //最大到3倍
    self.pagedScrollView.clipsToBounds = YES;
    self.pagedScrollView.scrollEnabled = YES;
    self.pagedScrollView.pagingEnabled = YES;
    self.pagedScrollView.delegate = self;
    [self.pagedScrollView removeAllContentSubviews];
    
    
    
    for (int i = 0 ; i < [self.scrollInfoArray count]; i++) {
        // last one
        UIView *page = [[UIImageView alloc]
                             initWithFrame:CGRectMake(H_30, H_90, H_260, 330.0f)];
        page.backgroundColor = GRAYEXLIGHTCOLOR;
        [page.layer setCornerRadius:H_5];
        
        NSDictionary *info = self.scrollInfoArray[i];
        
        //icon
        UILabel *icon = [[UILabel alloc]initWithFrame:CGRectMake(H_90, H_80, H_80, H_80)];
        [icon setFont:FONT_AWESOME_70];
        [icon setText:[NSString fontAwesomeIconStringForIconIdentifier:info[@"icon"]]];
        [icon setTextColor:GREENDARKCOLOR];
        
        UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(H_20, H_200, H_220, H_30)];
        [title setTextColor:GREENDARKCOLOR];
        [title setText:info[@"title"]];
        [title setFont:FONT_20];
        [title setTextAlignment:NSTextAlignmentCenter];
        
        UILabel *summary = [[UILabel alloc]initWithFrame:CGRectMake(H_40, H_240, H_180, H_90)];
        [summary setTextColor:GREENDARKCOLOR];
        [summary setText:info[@"summary"]];
        [summary setNumberOfLines:0];
        [summary setFont:FONT_14];
        [summary setTextAlignment:NSTextAlignmentCenter];
        [summary setTextColor:GREENCOLOR];
        
        
        [page addSubview:icon];
        [page addSubview:title];
        [page addSubview:summary];
        
        [self.pagedScrollView addContentSubview:page];
    }
    
    [self.view addSubview:self.pagedScrollView];
    
    
    self.checkButton = [KKFlatButton buttonWithType:UIButtonTypeCustom];
    [checkButton setTitle:T(@"立即体验") forState:UIControlStateNormal];
    [self.checkButton setBackgroundColor:ORANGECOLOR];
    [checkButton setFrame:CGRectMake(H_30, TOTAL_HEIGHT-H_80, H_260, H_50)];
    [checkButton addTarget:self action:@selector(skipAction) forControlEvents:UIControlEventTouchUpInside];
    [checkButton.titleLabel setFont:FONT_20];
    [self.view addSubview:checkButton];
    
}



// FIXME: checkButton touch no response
-(void)skipAction
{
    SET_DEFAULT(NUM_BOOL(YES), @"HELPSEEN_INTRO");
    [XAppDelegate skipIntroView];
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
