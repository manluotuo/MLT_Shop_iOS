//
//  HostViewController.m
//  bitmedia
//
//  Created by meng qian on 14-1-22.
//  Copyright (c) 2014年 thinktube. All rights reserved.
//

#import "HostViewController.h"
#import "ListMainViewController.h"
#import "HostListViewController.h"
#import "ListViewController.h"
#import "ColorNavigationController.h"
#import "AppRequestManager.h"
#import "PassValueDelegate.h"
#import "AppDelegate.h"
#import <AFNetworking/UIImageView+AFNetworking.h>
#import "ModelHelper.h"
#import "UIViewController+ImageBackButton.h"
#import "NSString+Size.h"
#import "FAHoverButton.h"
#import "ZBarScanViewController.h"
#import "WebViewController.h"
#import "GoodsDetailViewController.h"
#import "ForumViewController.h"
#import "ForumRootViewController.h"

#import "JPushViewController.h"
#import "XXYNavigationController.h"

@interface HostViewController ()<ViewPagerDataSource, ViewPagerDelegate, PassValueDelegate>
@property(nonatomic, strong)NSString *currentCategoryID;
@property(nonatomic, strong)FAHoverButton *leftDrawerAvatarButton;
@property (nonatomic, strong)UITabBarController *tabbar;
@end

@implementation HostViewController  {
    NSInteger indexNum;
    CGFloat countSet;
    FAHoverButton *forumButton;
}
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
    
    NSUserDefaults *user = USER_DEFAULTS;
    if ([user valueForKey:T(@"url")]) {
        JPushViewController *pushVC = [[JPushViewController alloc] init];
        ColorNavigationController *nav = [[ColorNavigationController alloc] initWithRootViewController:pushVC];
        [self presentViewController:nav animated:YES completion:nil];
    }
    
    if ([user valueForKey:T(@"goods")]) {
        GoodsDetailViewController *VC = [[GoodsDetailViewController alloc]initWithNibName:nil bundle:nil];
        VC.passDelegate = self;
        GoodsModel *theGoods = [[GoodsModel alloc]init];
        theGoods.goodsId = [user valueForKey:@"goods"];
        [VC setGoodsData:theGoods];
        [user removeObjectForKey:@"goods"];
        [user synchronize];
        [self presentViewController:VC animated:YES completion:nil];
        
    }
    
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
    self.tabArray = [[NSMutableArray alloc]init];
    if (ArrayHasValue(XAppDelegate.allCategory)) {
        NSLog(@"%@",XAppDelegate.allCategory);
        [self.tabArray addObject:@{@"name": @"首页", @"catId":STR_INT(0)}];
        for (CategoryModel *item in XAppDelegate.allCategory) {
            [self.tabArray addObject:@{@"name": item.catName, @"catId": item.catId}];
        }
    }else{
        self.tabArray = [[NSMutableArray alloc]initWithArray:
                         @[@{@"name": @"首页", @"catId":STR_INT(0)},
                           @{@"name": @"服饰鞋帽", @"catId":STR_INT(4)},
                           @{@"name": @"毛绒玩具", @"catId":STR_INT(7)},
                           @{@"name": @"模型雕塑", @"catId":STR_INT(3)},
                           @{@"name": @"精品挂饰", @"catId":STR_INT(6)},
                           @{@"name": @"卡通箱包", @"catId":STR_INT(9)},
                           @{@"name": @"生活娱乐", @"catId":STR_INT(2)}]
                         ];
    }
    
    
    
    //    NSLog(@"Host view tabarray: %@",self.tabArray);
    
    // TODO 机器默认的分类
    // 可以考虑写入数据库 用户定制完 也从数据库读取
    
    [self setupLeftMenuButton];
    [self setupRightMenuButton];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(rightDrawerButtonPress:)
                                                 name:NOTIFICATION_QUICK_ADD_STEP object:nil];
    
    
    /** 论坛入口按钮 */
    // TODO: 论坛按钮需要改进
    [self createForumButton];
    
}

/** 创建论坛入口按钮 */
- (void)createForumButton {
    
    forumButton = [[FAHoverButton alloc] initWithFrame:CGRectMake(WIDTH-H_80, TOTAL_HEIGHT-H_80, H_50, H_50)];
    UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(12, 12, 23, 23)];
    image.image = [UIImage imageNamed:T(@"ic_add_white_24dp")];
    [forumButton addSubview:image];
    [forumButton setBackgroundColor:ORANGECOLOR];
    [forumButton setRounded];
    [forumButton setIconFont:FONT_AWESOME_30];
    [forumButton addTarget:self action:@selector(onForumButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:forumButton];
    
}

/////////////////////////////////////////////////////
#pragma mark -  customNavigationView
/////////////////////////////////////////////////////

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self navigationGreenStyle];
    //    [self disableScroll];
    [MobClick beginLogPageView:@"PageOne"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Button Handlers

- (void)setupLeftMenuButton {
    self.leftDrawerAvatarButton = [FAHoverButton buttonWithType:UIButtonTypeCustom];
    [self.leftDrawerAvatarButton setTitle:ICON_BARS forState:UIControlStateNormal];
    [self.leftDrawerAvatarButton setFrame:CGRectMake(0, 0, ROUNDED_BUTTON_HEIGHT, ROUNDED_BUTTON_HEIGHT)];
    
    [self.leftDrawerAvatarButton addTarget:self action:@selector(leftDrawerButtonPress:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem * leftDrawerButton = [[UIBarButtonItem alloc]initWithCustomView:self.leftDrawerAvatarButton];
    
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
    
    ZBarScanViewController *viewController = [[ZBarScanViewController alloc]initWithNibName:nil bundle:nil];
    viewController.passDelegate = self;
    ColorNavigationController *popNavController = [[ColorNavigationController alloc]initWithRootViewController:viewController];
    
    [self.navigationController presentViewController:popNavController animated:YES completion:^{}];
    
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
        listVC.passDelegate = self;
        return listVC;
    }else{
        HostListViewController *listOnlineVC = [[HostListViewController alloc]initWithNibName:nil bundle:nil];
        listOnlineVC.search = [[SearchModel alloc]initWithDict:@{@"catId":rowData[@"catId"]}];
        listOnlineVC.delegateForHostView = self;
        return listOnlineVC;
    }
    
}

- (void)passSignalValue:(NSString *)value andData:(id)data
{
    
    if ([value isEqualToString:SIGNAL_BARCODE_SCAN_SUCCESS]) {
        NSLog(@"data %@",data);
        
        //        HTProgressHUD *HUD = [[HTProgressHUD alloc] init];
        //        HUD.indicatorView = [HTProgressHUDIndicatorView indicatorViewWithType:HTProgressHUDIndicatorTypeActivityIndicator];
        //        HUD.text = T(@"正在为你打开页面");
        //        [HUD showInView:self.view];
        
        id parsed = [DataTrans parseDataFromURL:data];
        if ([parsed isKindOfClass:[SearchModel class]]) {
            if ([[(SearchModel*)parsed brandId] isEqualToString:@"all"]) {
                // FIXME: goto 品牌街
                
            }else{
                ListViewController *VC = [[ListViewController alloc]initWithNibName:nil bundle:nil];
                VC.search = parsed;
                VC.title = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"];
                [VC setUpDownButton:0];
                ColorNavigationController *nav = [[ColorNavigationController alloc]initWithRootViewController:VC];
                [self.navigationController presentViewController:nav animated:YES completion:nil];
            }
            
        } else {
            if (DictionaryHasValue(parsed)) {
                if ([parsed[@"type"] isEqualToString:@"url"]) {
                    NSString *urlString = parsed[@"id"];
                    WebViewController *VC = [[WebViewController alloc]initWithNibName:nil bundle:nil];
                    VC.titleString = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"];
                    VC.urlString = urlString;
                    [VC setUpDownButton:0];
                    ColorNavigationController *nav = [[ColorNavigationController alloc]initWithRootViewController:VC];
                    [self.navigationController presentViewController:nav animated:YES completion:nil];
                } else if ([parsed[@"type"] isEqualToString:@"goods"]){
                    GoodsDetailViewController *VC = [[GoodsDetailViewController alloc]initWithNibName:nil bundle:nil];
                    VC.passDelegate = self;
                    GoodsModel *theGoods = [[GoodsModel alloc]init];
                    theGoods.goodsId = parsed[@"id"];
                    NSLog(@"%@", parsed[@"id"]);
                    [VC setGoodsData:theGoods];
                    
                    [self.navigationController presentViewController:VC animated:YES completion:^{
                        //                        [HUD removeFromSuperview];
                    }];
                }
            }
        }
    }
    if ([value isEqualToString:@"40000"]) {
        if (forumButton.y == TOTAL_HEIGHT-H_80) {
            [UIView animateWithDuration:0.3 animations:^{
                forumButton.y = TOTAL_HEIGHT + H_10;
            }];
        }
    }
    
    if ([value isEqualToString:@"40001"]) {
        if (forumButton.y == TOTAL_HEIGHT + H_10) {
            [UIView animateWithDuration:0.3 animations:^{
                forumButton.y = TOTAL_HEIGHT - H_80;
            }];
        }
    }
}

////////////////////////////////////////
#pragma mark - ViewPagerDelegate
////////////////////////////////////////

- (void)viewPager:(ViewPagerController *)viewPager didChangeTabToIndex:(NSUInteger)index
{
    indexNum = (NSInteger)index;
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

- (void)onForumButtonClick {
    if (XAppDelegate.me.userId == nil) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"登录后才能使用社区功能哦" delegate: self cancelButtonTitle:@"确定" otherButtonTitles: nil, nil];
        [alert show];
        return;
    }

    ForumViewController *forVC = [[ForumViewController alloc] init];
    XXYNavigationController *navc = [[XXYNavigationController alloc] initWithRootViewController:forVC];

    [navc setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
    [self presentViewController:navc animated:YES completion:^{
        [MobClick event:UM_FORUM];
    }];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"PageOne"];
}

@end
