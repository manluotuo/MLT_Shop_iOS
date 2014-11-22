//
//  HostViewController.m
//  bitmedia
//
//  Created by meng qian on 14-1-22.
//  Copyright (c) 2014年 thinktube. All rights reserved.
//

#import "HostViewController.h"
#import "ListMainViewController.h"
#import "ListOnlineViewController.h"
#import "ColorNavigationController.h"
#import "AppRequestManager.h"
#import "PassValueDelegate.h"
#import "AppDelegate.h"
#import <AFNetworking/UIImageView+AFNetworking.h>
#import "ModelHelper.h"
#import "UIViewController+ImageBackButton.h"
#import "NSString+Size.h"
#import "FAHoverButton.h"


@interface HostViewController ()<ViewPagerDataSource, ViewPagerDelegate, PassValueDelegate>
@property(nonatomic, strong)NSString *currentCategoryID;
@property(nonatomic, strong)FAHoverButton *leftDrawerAvatarButton;
@end

@implementation HostViewController
@synthesize tabArray;
@synthesize currentCategoryID;
@synthesize leftDrawerAvatarButton;

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
    [ModelHelper sharedHelper].modelHelperDelegateForHostVC = self;
    
//  TODO click logo and refresh current view
    UILabel *logoLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 80, TITLE_HEIGHT)];
    [logoLabel setText:T(@"漫骆驼")];
    [logoLabel setTextAlignment:NSTextAlignmentCenter];
    [logoLabel setTextColor:WHITECOLOR];
    [logoLabel setFont:[UIFont boldSystemFontOfSize:18.0f]];
    [logoLabel setBackgroundColor:[UIColor clearColor]];
    [self.navigationItem setTitleView:logoLabel];
    
    
    self.dataSource = self;
    self.delegate = self;
    
    // last is empty for add button
    
    self.tabArray = @[@{@"name": @"首页", @"categoryId":INT(0)},
                      @{@"name": @"毛绒玩具", @"categoryId":INT(1)},
                      @{@"name": @"下架维护", @"categoryId":INT(2)}];
    
//    NSLog(@"Host view tabarray: %@",self.tabArray);
    
    // TODO 机器默认的分类
    // 可以考虑写入数据库 用户定制完 也从数据库读取
    
    [self setupLeftMenuButton];
    [self setupRightMenuButton];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(rightDrawerButtonPress:)
                                                 name:NOTIFICATION_QUICK_ADD_STEP object:nil];

}

/////////////////////////////////////////////////////
#pragma mark -  customNavigationView
/////////////////////////////////////////////////////

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self navigationGreenStyle];
    
    [self disableScroll];

    // TODO: 显示数据
//    NSFNanoSearch *search = [NSFNanoSearch searchWithStore:XAppDelegate.nanoStore];
//    
//    search.attribute = @"gallery";
//    search.match = NSFNotEqualTo;
//    search.value = @"xxxxx";
//    
//    // Returns a dictionary with the UUID of the object (key) and the NanoObject (value).
//    NSDictionary *searchResults = [search searchObjectsWithReturnType:NSFReturnObjects error:nil];
//    NSDictionary *theValues = [searchResults allValues];
//    
//    for (NSFNanoObject *item in theValues) {
//        NSLog(@"%@",item.info);
//    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Button Handlers

- (void)setupLeftMenuButton{
    self.leftDrawerAvatarButton = [FAHoverButton buttonWithType:UIButtonTypeCustom];
    [self.leftDrawerAvatarButton setTitle:ICON_BARS forState:UIControlStateNormal];
    [self.leftDrawerAvatarButton setFrame:CGRectMake(0, 0, ROUNDED_BUTTON_HEIGHT, ROUNDED_BUTTON_HEIGHT)];

    [self.leftDrawerAvatarButton addTarget:self action:@selector(leftDrawerButtonPress:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem * leftDrawerButton = [[UIBarButtonItem alloc]initWithCustomView:self.leftDrawerAvatarButton];
    
//    MMDrawerBarButtonItem * leftDrawerButton = [[MMDrawerBarButtonItem alloc] initWithTarget:self action:@selector(leftDrawerButtonPress:)];
    [self.navigationItem setLeftBarButtonItem:leftDrawerButton animated:YES];
}

-(void)leftDrawerButtonPress:(id)sender{
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}

-(void)setupRightMenuButton{
    FAHoverButton *rightButton = [FAHoverButton buttonWithType:UIButtonTypeCustom];

    [rightButton setTitle:[NSString fontAwesomeIconStringForEnum:FAQrcode] forState:UIControlStateNormal];
    [rightButton setFrame:CGRectMake(0, 0, ROUNDED_BUTTON_HEIGHT, ROUNDED_BUTTON_HEIGHT)];
    
    [rightButton addTarget:self action:@selector(rightDrawerButtonPress:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *rightDrawerButton = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
    
    [self.navigationItem setRightBarButtonItem:rightDrawerButton animated:YES];
}

- (void)rightDrawerButtonPress:(id)sender
{
    // TODO: 打开扫描界面
    NSLog(@"rightDrawerButtonPress");
}

/////////////////////////////////////////////////////
#pragma mark - viewPagerDataSource
/////////////////////////////////////////////////////

- (NSUInteger)numberOfTabsForViewPager:(ViewPagerController *)viewPager
{
    return [self.tabArray count];
}

- (UIView *)viewPager:(ViewPagerController *)viewPager viewForTabAtIndex:(NSUInteger)index {
    
    NSDictionary *rowData  = [self.tabArray objectAtIndex:index];
    
    UILabel *label = [UILabel new];
    label.backgroundColor = [UIColor clearColor];
    label.font = FONT_14;
    label.text = rowData[@"name"];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor blackColor];
    [label sizeToFit];
    
    return label;
}

- (UIViewController *)viewPager:(ViewPagerController *)viewPager contentViewControllerForTabAtIndex:(NSUInteger)index {
    
    NSDictionary *rowData  = [self.tabArray objectAtIndex:index];
    
    
    if (index == HOST_LOCAL_TAB) {
        ListMainViewController *listVC = [[ListMainViewController alloc]initWithNibName:nil bundle:nil];
        listVC.delegateForHostView = self;
        return listVC;
    }else{
        ListOnlineViewController *listOnlineVC = [[ListOnlineViewController alloc]initWithNibName:nil bundle:nil];
        listOnlineVC.categoryId = rowData[@"categoryId"];
        listOnlineVC.delegateForHostView = self;
        return listOnlineVC;
    }
}

- (void)passSignalValue:(NSString *)value andData:(id)data
{
    
}

////////////////////////////////////////
#pragma mark - ViewPagerDelegate
////////////////////////////////////////

- (void)viewPager:(ViewPagerController *)viewPager didChangeTabToIndex:(NSUInteger)index
{
    NSLog(@"didChangeTabToIndex index: %lu",(unsigned long)index);
}

- (CGFloat)viewPager:(ViewPagerController *)viewPager valueForOption:(ViewPagerOption)option withDefault:(CGFloat)value {
    
    switch (option) {
        case ViewPagerOptionStartFromSecondTab:
            return 0.0;
        case ViewPagerOptionCenterCurrentTab:
            return 1.0;
        case ViewPagerOptionTabLocation:
            return 1.0;
        case ViewPagerOptionTabHeight:
            return TABS_VIEW_HEIGHT;
        case ViewPagerOptionTabViewWidth: // 整个宽度
            return TOTAL_WIDTH;
        case ViewPagerOptionTabOffset:
            return TABS_VIEW_HEIGHT;
        case ViewPagerOptionTabWidth: // 单个宽度
            return TABS_VIEW_WIDTH;
        case ViewPagerOptionFixFormerTabsPositions:
            return 0.0;
        case ViewPagerOptionFixLatterTabsPositions:
            return 0.0;
        default:
            return value;
    }
}

- (NSArray *)viewPager:(ViewPagerController *)viewPager valueArrayForOption:(ViewPagerOption)option
{
    NSMutableArray *result = [[NSMutableArray alloc]init];
    for (int index=0; index<[self.tabArray count]; index++) {
        NSDictionary *rowData  = [self.tabArray objectAtIndex:index];
        [result addObject:INT(TABS_VIEW_WIDTH)];
        
//        自适应宽度
//        NSString *name = rowData[@"name"];
//        CGSize size = [name sizeWithHeight:H_16 andFont:FONT_14];
//        [result addObject:INT(size.width + H_26)];
    }

    switch (option) {
        case ViewPagerOptionTabWidthArray:
            return result;
            break;
            
        default:
            return [[NSArray alloc]init];
    }
}

- (UIColor *)viewPager:(ViewPagerController *)viewPager colorForComponent:(ViewPagerComponent)component withDefault:(UIColor *)color {
    
    switch (component) {
        case ViewPagerIndicator:
            return DARKCOLOR;
        case ViewPagerTabsView:
            return TABBGCOLOR;
        case ViewPagerContent:
            return WHITECOLOR;
        default:
            return color;
    }
}



@end
