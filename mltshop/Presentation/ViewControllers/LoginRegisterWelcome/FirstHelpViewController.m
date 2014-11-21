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
@property(strong, nonatomic)NSArray *scrollImageArray;
@property(strong, nonatomic)KKFlatButton *checkButton;

@end

@implementation FirstHelpViewController
@synthesize pagedScrollView;
@synthesize scrollImageArray;
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
    self.scrollImageArray = [[NSArray alloc]initWithObjects:
                             @"intro_1.png",
                             @"intro_2.png",
                             @"intro_3.png",
                             @"intro_4.png",
                             @"intro_5.png",
                             nil];
    
    CGRect scrollFrame = CGRectMake(0, 0, TOTAL_WIDTH, TOTAL_HEIGHT);
    self.pagedScrollView = [[GCPagedScrollView alloc] initWithFrame:scrollFrame andPageControl:NO];
    self.pagedScrollView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
    self.pagedScrollView.backgroundColor = GRAYEXLIGHTCOLOR;
    self.pagedScrollView.minimumZoomScale = 1; //最小到0.3倍
    self.pagedScrollView.maximumZoomScale = 3.0; //最大到3倍
    self.pagedScrollView.clipsToBounds = YES;
    self.pagedScrollView.scrollEnabled = YES;
    self.pagedScrollView.pagingEnabled = YES;
    self.pagedScrollView.delegate = self;
    [self.pagedScrollView removeAllContentSubviews];
    
    
    
    for (int i = 0 ; i < [self.scrollImageArray count]; i++) {
        // last one
        UIImageView *page = [[UIImageView alloc]
                             initWithFrame:scrollFrame];
        [page setContentMode:UIViewContentModeCenter];
        page.image = [UIImage imageNamed:[self.scrollImageArray objectAtIndex:i]];
        [self.pagedScrollView addContentSubview:page];
    }
    
    [self.view addSubview:self.pagedScrollView];
    
    
    self.checkButton = [KKFlatButton buttonWithType:UIButtonTypeCustom];
    [checkButton setTitle:T(@"立即体验") forState:UIControlStateNormal];
    [checkButton setFrame:CGRectMake(90, TOTAL_HEIGHT-H_60, 140, H_50)];
    [checkButton addTarget:self action:@selector(skipAction) forControlEvents:UIControlEventTouchUpInside];
    [checkButton.titleLabel setFont:FONT_20];
    [checkButton setHidden:YES];
    [self.view addSubview:checkButton];
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    NSLog(@"frame: %f", scrollView.contentOffset.x);
    if(scrollView.contentOffset.x > TOTAL_WIDTH*([self.scrollImageArray count]-1) + H_40){
        [self skipAction];
    }
    if (scrollView.contentOffset.x >  TOTAL_WIDTH*([self.scrollImageArray count]-1) - H_40) {
        [self.checkButton setHidden:NO];
        [UIView animateWithDuration:0.5f animations:^{
            [self.checkButton setY:TOTAL_HEIGHT-H_100];
        }];
    }else{
        [self.checkButton setHidden:YES];
    }
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
