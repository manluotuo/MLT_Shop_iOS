 //
//  LeftMenuViewController.m
//  bitmedia
//
//  Created by meng qian on 14-1-20.
//  Copyright (c) 2014年 thinktube. All rights reserved.
//

#import "LeftMenuViewController.h"
#import "MMNavigationController.h"
#import "GreenNavigationController.h"
//#import "LMViewController.h"
#import "AppDelegate.h"
#import "Me.h"
#import "AppRequestManager.h"
#import "ModelHelper.h"
#import "PassValueDelegate.h"
#import "RoundedAvatarButton.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "UIViewController+ImageBackButton.h"


//#import "AccountListViewController.h"
//#import "ProfileFormViewController.h"
//#import "WebHelpViewController.h"
//#import "HistoryListViewController.h"
//#import "MoreViewController.h"
//#import "ProfileTableViewCell.h"

@interface LeftMenuViewController ()<UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate, PassValueDelegate>
{
    NSString *nickName;
    NSString *avatarUrl;
}

@property(nonatomic, strong)UITableView *tableView;
@property(nonatomic, strong)NSMutableArray *dataSource;
@property(nonatomic, strong)UIView *loginContainerView;
@property(nonatomic, strong)UIView *avatarContainerView;
@property(nonatomic, strong)RoundedAvatarButton *avatarView;
@property(nonatomic, strong)UILabel *nicknameLabel;


@end

#define LOGIN_AREA_HEIGHT 20.0


@implementation LeftMenuViewController

@synthesize tableView;
@synthesize dataSource;
@synthesize loginContainerView;
@synthesize avatarView;
@synthesize nicknameLabel;

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
    [self.navigationItem setLeftBarButtonItem:nil];
    
	// Do any additional setup after loading the view.
//    self.title = T(@"用户菜单");
    self.view.backgroundColor = BlACKCOLOR;
    
    NSDictionary *dict8 = [[NSDictionary alloc]initWithObjectsAndKeys:
                           T(@"商家个人信息"), @"title",
                           ICON_MINE, @"icon",
                           INT(LeftMenuProfile), @"function",
                           nil];
    
    NSDictionary *dict9 = [[NSDictionary alloc]initWithObjectsAndKeys:
                           T(@"推广账号绑定"), @"title",
                           ICON_CHAIN, @"icon",
                           INT(LeftMenuBinding), @"function",
                           nil];
    
    NSDictionary *dictA = [[NSDictionary alloc]initWithObjectsAndKeys:
                           T(@"车辆管理"), @"title",
                           ICON_LIST, @"icon",
                           INT(LeftMenuList), @"function",
                           nil];

//    NSDictionary *dictE = [[NSDictionary alloc]initWithObjectsAndKeys:
//                           T(@"市场价格"), @"title",
//                           ICON_INFO, @"icon",
//                           INT(LeftMenuFeedback), @"function",
//                           nil];
    
    NSDictionary *dictF = [[NSDictionary alloc]initWithObjectsAndKeys:
                           T(@"快速添加车辆"), @"title",
                           ICON_PLUS, @"icon",
                           INT(LeftMenuQuickAdd), @"function",
                           nil];
    
    NSDictionary *dictB = [[NSDictionary alloc]initWithObjectsAndKeys:
                           T(@"发布历史"), @"title",
                           ICON_CLOCK, @"icon",
                           INT(LeftMenuHistory), @"function",
                           nil];
    
    
//    NSDictionary *dictH = [[NSDictionary alloc]initWithObjectsAndKeys:
//                           T(@"查看帮助"), @"title",
//                           ICON_HELP, @"icon",
//                           INT(LeftMenuHelp), @"function",
//                           nil];

    
    NSString *nowVersion = NOWVERSION;
    NSString *nowBuild = NOWBUILD;
    nowVersion = [NSString stringWithFormat:@"V_%@#%@", nowVersion, nowBuild];
    
    NSDictionary *dictI = [[NSDictionary alloc]initWithObjectsAndKeys:
                           nowVersion, @"title",
                           ICON_INFO, @"icon",
                           INT(LeftMenuUpdate), @"function",
                           nil];
    
    
    NSDictionary *dictJ = [[NSDictionary alloc]initWithObjectsAndKeys:
                           T(@"更多"), @"title",
                           ICON_MORE, @"icon",
                           INT(LeftMenuMore), @"function",
                           nil];
    
//    NSDictionary *dictG = [[NSDictionary alloc]initWithObjectsAndKeys:
//                           T(@"退出登录"), @"title",
//                           ICON_LOGOUT, @"icon",
//                           INT(LeftMenuLogout), @"function",
//                           nil];

    // init left side menu
    self.dataSource = [[NSMutableArray alloc]initWithObjects:dict8,dictA,dict9,dictF,dictB, dictJ,nil];
//    if (XAppDelegate.me.userToken) {
//        [self.dataSource addObject:dictG];
//    }
    

    
    CGRect tableViewFrame = self.view.bounds;
    tableViewFrame.origin.y = LOGIN_AREA_HEIGHT;
    tableViewFrame.size.height = tableViewFrame.size.height - tableViewFrame.origin.y;

    self.tableView = [[UITableView alloc]initWithFrame:tableViewFrame style:UITableViewStylePlain];
    self.tableView.backgroundColor = BlACKCOLOR;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.separatorColor = [UIColor blackColor];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
//    self.tableView.scrollEnabled = NO;
    
    
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    [self.view addSubview:self.tableView];
    
    // bar tint color

    
    if([self.navigationController.navigationBar respondsToSelector:@selector(setBarTintColor:)]){
        [self.navigationController.navigationBar setBarTintColor:BlACKCOLOR];
    }
    else {
        [self.navigationController.navigationBar setTintColor:BlACKCOLOR];
    }
    
//    [self initAvatarContainerView];
//    [self initloginContainerView];
//    [self checkVersion];
    
    // 绑定 passdelegate
    [ModelHelper sharedHelper].modelHelperDelegateForLeftMenuVC = self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    

    [[self navigationController] setNavigationBarHidden:YES animated:NO];
    
//    if (XAppDelegate.me.group > UserGroupGuest) {
//        [self.loginContainerView setHidden:YES];
//    }else{
//        [self.avatarContainerView setHidden:YES];
//    }
    
    //  重新获取昵称和头像
    nickName = XAppDelegate.me.nickname;
    avatarUrl = XAppDelegate.me.avatarURL;
    
    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
}

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

#endif

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
//    [self navigationGreenStyle];
}

- (void)initAvatarContainerView
{
    CGRect loginFrame;
    if (OSVersionIsAtLeastiOS7()) {
        loginFrame = CGRectMake(0, STATUS_BAR_HEIGHT, MAX_LEFT_DRAWER_WIDTH, LOGIN_AREA_HEIGHT);
    }else{
        loginFrame = CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), LOGIN_AREA_HEIGHT);
    }
    
    self.avatarContainerView  = [[UIView alloc]initWithFrame:loginFrame];
    self.avatarContainerView.backgroundColor = BlACKCOLOR;

    self.nicknameLabel = [[UILabel alloc]initWithFrame:CGRectMake(80, loginFrame.origin.y + 15, 150, LABEL_HEIGHT)];
    self.nicknameLabel.text = nickName;
    self.nicknameLabel.textColor = WHITECOLOR;
    [self.nicknameLabel setFont:FONT_BLACK_15];
    
    NSLog(@"XAppDelegate.me.avatarURL: %@",XAppDelegate.me.avatarURL);
    
    self.avatarView = [[RoundedAvatarButton alloc]initWithFrame:CGRectMake(10, loginFrame.origin.y, 50, 50)];

    [self.avatarView.avatarImageView sd_setImageWithURL:[NSURL URLWithString:XAppDelegate.me.avatarURL]
                                    placeholderImage:[UIImage imageNamed:@"114.png"]];
//    [self.avatarView addTarget:self action:@selector(viewProfileAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *oneLineView = [[UIView alloc]initWithFrame:CGRectMake(0, loginFrame.size.height-1, TOTAL_WIDTH, 1.0)];
    oneLineView.backgroundColor = [UIColor blackColor];
    
    [self.avatarContainerView addSubview:oneLineView];
    [self.avatarContainerView addSubview:self.avatarView];
    [self.avatarContainerView addSubview:self.nicknameLabel];
    
    [self.view addSubview:self.avatarContainerView];

}

- (void)checkVersion
{
    [[AppRequestManager sharedManager]getSystemNotificationWithBlock:^(id responseObject, NSError *error) {
        if (responseObject) {
            NSLog(@"SystemNotification: %@", responseObject);
            if (responseObject != nil) {
                NSString *newVersion = [responseObject valueForKey:@"version"];
                NSNumber *forceUpdate = [responseObject valueForKey:@"forceUpdate"];
                NSString *url = [responseObject valueForKey:@"url"];
                
                NSString *nowVersion = NOWVERSION;
                if (StringHasValue(nowVersion) ) {
                    
                    NSArray *arrayNew = [newVersion componentsSeparatedByString:@"."];
                    NSArray *arrayNow = [nowVersion componentsSeparatedByString:@"."];
                    
                    NSUInteger newVersionInt = [(NSString *)[arrayNew lastObject]integerValue];
                    NSUInteger nowVersionInt = [(NSString *)[arrayNow lastObject]integerValue];
                    
                    if (newVersionInt > nowVersionInt ) {
                        // shou bubble in data
                        NSLog(@"show the update tap");
                        [self.tableView beginUpdates];
                        UITableViewCell * cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]];
                        
                        UILabel *bubbleLabel = (UILabel *)[cell viewWithTag:CELL_BUBBLE_TAG];
                        bubbleLabel.text = @"NEW";
                        [bubbleLabel setHidden:NO];
                        
                        [self.tableView endUpdates];

                    }
                }
                
                
            }
        }
    }];
}

////////////////////////////////////////////////
#pragma mark - passValueDelegate
////////////////////////////////////////////////

- (void)passSignalValue:(NSString *)value andString:(NSString *)string
{
    if ([value isEqualToString:SIGNAL_WEIBO_BINDING]) {
        
        [self getBindUserInfo];
        [self.loginContainerView setHidden:YES];
        [self.avatarContainerView setHidden:NO];
        
        NSDictionary *dictG = [[NSDictionary alloc]initWithObjectsAndKeys:
                               T(@"退出登录"), @"title",
                               ICON_LOGOUT, @"icon",
                               INT(LeftMenuLogout), @"function",
                               nil];
    
        [self.dataSource addObject:dictG];
        [self.tableView reloadData];
    }
    
    if ([value isEqualToString:SIGNAL_WEIBO_UNBINDING]) {
        
        [self.loginContainerView setHidden:NO];
        [self.avatarContainerView setHidden:YES];
        
        [self.dataSource removeLastObject];
        [self.tableView reloadData];
    }

}

- (void)passStringValue:(NSString *)value andIndex:(NSUInteger)index
{
    if ([value isEqualToString:SIGNAL_LEFT_MENU]) {
        NSLog(@"LEFT_MENU_FUNCTION %@",INT(index));
    }
}

#pragma mark - thrid party login


-(void)getBindUserInfo
{
    self.nicknameLabel.text = XAppDelegate.me.nickname;
    [self.avatarView.avatarImageView sd_setImageWithURL:[NSURL URLWithString:XAppDelegate.me.avatarURL]
                                    placeholderImage:[UIImage imageNamed:@"placeHolderSmall.png"]];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 120;
    }
    return CELL_HEIGHT;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataSource count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
        static NSString *CellIdentifier = @"LeftSettingCell";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil) {
            cell = [self tableViewCellWithReuseIdentifier:CellIdentifier];
        }
        [self configureCell:cell forIndexPath:indexPath];
        return cell;
}


- (UITableViewCell *)tableViewCellWithReuseIdentifier:(NSString *)identifier
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    
    UILabel *iconLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 10, 40 ,40)];
    iconLabel.tag = CELL_ICON_TAG;
    iconLabel.font = FONT_AWESOME_24;
    iconLabel.textColor = WHITECOLOR;
    iconLabel.backgroundColor = [UIColor clearColor];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(70, 10, 120, 40)];
    titleLabel.tag = CELL_TITLE_TAG;
    titleLabel.font = FONT_BLACK_15;
    titleLabel.textColor = WHITECOLOR;
    titleLabel.backgroundColor = [UIColor clearColor];
    
    UILabel *detailLabel = [[UILabel alloc]initWithFrame:CGRectMake(70, 40, H_120, H_14)];
    detailLabel.backgroundColor = [UIColor clearColor];
    detailLabel.font = FONT_11;
    detailLabel.tag = CELL_TITLE_DETAIL_TAG;
    detailLabel.textColor = GRAYCOLOR;

    UILabel *bubbleLabel = [[UILabel alloc]initWithFrame:CGRectMake(130, 20, 90, 20)];
    
    [bubbleLabel setBackgroundColor:REDCOLOR];
    [bubbleLabel setTextColor:WHITECOLOR];
    [bubbleLabel setFont:FONT_12];
    [bubbleLabel setTextAlignment:NSTextAlignmentCenter];
    [bubbleLabel setHidden:YES];
    bubbleLabel.tag = CELL_BUBBLE_TAG;
    [bubbleLabel setHidden:YES];
    bubbleLabel.backgroundColor = [UIColor clearColor];

    [cell.contentView addSubview:titleLabel];
    [cell.contentView addSubview:iconLabel];
    [cell.contentView addSubview:detailLabel];
    [cell.contentView addSubview:bubbleLabel];
    [cell.contentView setBackgroundColor:BlACKCOLOR];
    [cell setBackgroundColor:BlACKCOLOR];
    
    return  cell;
}



- (void)configureCell:(UITableViewCell *)cell forIndexPath:(NSIndexPath *)indexPath {
    
    // two type
    NSDictionary *cellData = [[NSDictionary alloc]init];
    cell.contentView.backgroundColor = BlACKCOLOR;
    
    UIView *selectionColor = [[UIView alloc] init];
    selectionColor.backgroundColor = DARKCOLOR;
    cell.selectedBackgroundView = selectionColor;

    cellData = [self.dataSource objectAtIndex:indexPath.row];

    
    UILabel *iconLabel = (UILabel *)[cell viewWithTag:CELL_ICON_TAG];
    iconLabel.text = [cellData objectForKey:@"icon"];
    
    UILabel *titleLabel = (UILabel *)[cell viewWithTag:CELL_TITLE_TAG];
    titleLabel.text = [cellData objectForKey:@"title"];
    
    if ([[cellData objectForKey:@"function"] integerValue ] == LeftMenuUpdate) {
        UILabel *detailLabel = (UILabel *)[cell viewWithTag:CELL_TITLE_DETAIL_TAG];
        detailLabel.text = BASE_API;
    }

}


//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    LMViewController* viewController;
//    ProfileFormViewController* profileViewController;
//    AccountListViewController* accountListViewController;
//    HistoryListViewController* historyListViewController;
//    MoreViewController *moreViewController;
//    
//    NSDictionary *cellData = (NSDictionary *)[self.dataSource objectAtIndex:indexPath.row];
//    NSInteger function = [(NSNumber *)[cellData objectForKey:@"function"] integerValue];
//    
//    switch (function) {
//        case LeftMenuBinding:
//            accountListViewController = [[AccountListViewController alloc]initWithNibName:nil bundle:nil];
//            break;
//        case LeftMenuProfile:
//            profileViewController = [[ProfileFormViewController alloc]initWithNibName:nil bundle:nil];
//            [profileViewController initFormUserId:XAppDelegate.me.userId];
//            break;
//        case LeftMenuHistory:
//            historyListViewController = [[HistoryListViewController alloc]initWithNibName:nil bundle:nil];
//            historyListViewController.isSingle = NO;
//            break;
//        case LeftMenuMore:
//            moreViewController = [[MoreViewController alloc] initWithNibName:nil bundle:nil];
//            break;
//        default:
//            break;
//    }
//    
//    if (function == LeftMenuHelp){
//        
//        NSString *strUrl = @"http://app.kanche.com/help";
//        // TODO: hold on
////        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:strUrl]];
//        
//        
//        WebHelpViewController *webViewController = [[WebHelpViewController alloc] initWithAddress:strUrl];
//        webViewController.barsTintColor = WHITECOLOR;
//        [self presentViewController:webViewController animated:YES completion:nil];
//
//        
//        
//    }else if(function == LeftMenuBinding){
//        
//        CATransition *transition = [CATransition animation];
//        transition.duration = 0.3;
//        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
//        transition.type = kCATransitionPush;
//        transition.subtype = kCATransitionFromRight;
//        [self.view.window.layer addAnimation:transition forKey:kCATransition];
//        
//        GreenNavigationController *popNavController = [[GreenNavigationController alloc]initWithRootViewController:accountListViewController];
//        
//        [self presentViewController:popNavController animated:YES completion:nil];
//        [accountListViewController changeNavigationUIForLeftSide];
//
////        [self.navigationController presentViewController:popNavController animated:NO completion:^{
////            //
////            [accountListViewController changeNavigationUIForLeftSide];
////
////        }];
//    }
//    else if(function == LeftMenuProfile){
//                
//        CATransition *transition = [CATransition animation];
//        transition.duration = 0.3;
//        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
//        transition.type = kCATransitionPush;
//        transition.subtype = kCATransitionFromRight;
//        [self.view.window.layer addAnimation:transition forKey:kCATransition];
//        
//        GreenNavigationController *popNavController = [[GreenNavigationController alloc]initWithRootViewController:profileViewController];
//        [profileViewController changeNavigationUIForLeftSide];
//        [self presentViewController:popNavController animated:YES completion:nil];
//        
////        [self.navigationController presentViewController:popNavController animated:NO completion:^{
////            //
////        }];
//    }
//    
//    else if(function == LeftMenuHistory){
//        CATransition *transition = [CATransition animation];
//        transition.duration = 0.3;
//        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
//        transition.type = kCATransitionPush;
//        transition.subtype = kCATransitionFromRight;
//        [self.view.window.layer addAnimation:transition forKey:kCATransition];
//        
//        GreenNavigationController *popNavController = [[GreenNavigationController alloc]initWithRootViewController:historyListViewController];
//        [historyListViewController changeNavigationUIForLeftSide];
//        [self presentViewController:popNavController animated:YES completion:nil];
//        
//    }
//    
//    else if (function == LeftMenuMore) {
//        CATransition *transition = [CATransition animation];
//        transition.duration = 0.3;
//        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
//        transition.type = kCATransitionPush;
//        transition.subtype = kCATransitionFromRight;
//        [self.view.window.layer addAnimation:transition forKey:kCATransition];
//        GreenNavigationController *popNavController = [[GreenNavigationController alloc]initWithRootViewController:moreViewController];
//        [self presentViewController:popNavController animated:YES completion:nil];
//    }
//    
//    else if (function == LeftMenuQuickAdd){
//        [MobClick event:UMENG_QuickAdd];
//        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_QUICK_ADD_STEP
//                                                            object:self
//                                                          userInfo:nil];
//    }else if (function == LeftMenuList){
//
//    }
//    else{
//        [DataTrans showWariningTitle:@"制作中" andCheatsheet:ICON_TIMES];
//    }
//    
//    [self.mm_drawerController closeDrawerAnimated:YES completion:^(BOOL finished) {}];
//
//}



/////////////////////////////////////////////////////
#pragma mark - clear section line when cell is empty
/////////////////////////////////////////////////////
- (float)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01f;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [UIView new];
}


@end
