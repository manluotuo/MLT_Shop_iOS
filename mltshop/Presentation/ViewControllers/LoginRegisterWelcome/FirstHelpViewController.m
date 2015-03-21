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
#import "LoginViewController.h"

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
    
    [self initScrollView];
}

- (void)initScrollView
{
    
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
    if (WIDTH == 320) {
        self.scrollInfoArray = @[@"splash1.jpg", @"splash2.jpg", @"splash3.jpg"];
    } else {
        self.scrollInfoArray = @[@"splash1.jpg", @"splash2.jpg", @"splash3.jpg"];
    }
    
    for (int i = 0 ; i < [self.scrollInfoArray count]; i++) {
        
        UIImageView *image = [[UIImageView alloc] initWithFrame:self.view.bounds];
        [image setImage:[UIImage imageNamed:self.scrollInfoArray[i]]];
        [self.pagedScrollView addContentSubview:image];
        
    }
    [self.view addSubview:self.pagedScrollView];
}

//- (void)initLoginView {
//    UIView *loginView = [[UIView alloc] initWithFrame:self.view.bounds];
//
//}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    //    NSLog(@"%f", scrollView.contentOffset.x);
    if (scrollView.contentOffset.x > WIDTH*2+H_50) {
        [self skipAction];
    }
}



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
