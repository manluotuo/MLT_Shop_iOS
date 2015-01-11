 //
//  LeftMenuViewController.m
//  bitmedia
//
//  Created by meng qian on 14-1-20.
//  Copyright (c) 2014年 thinktube. All rights reserved.
//

#import "LeftMenuViewController.h"
#import "MMNavigationController.h"
#import "ColorNavigationController.h"
//#import "LMViewController.h"
#import "AppDelegate.h"
#import "Me.h"
#import "AppRequestManager.h"
#import "ModelHelper.h"
#import "PassValueDelegate.h"
#import "RoundedAvatarButton.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "UIViewController+ImageBackButton.h"
#import <LBBlurredImage/UIImageView+LBBlurredImage.h>

#import "CartListViewController.h"

//#import "AccountListViewController.h"
#import "ProfileViewController.h"
#import "SearchCategoryViewController.h"
#import "WebHelpViewController.h"
#import "WebViewController.h"
#import "SGActionView.h"
//#import "HistoryListViewController.h"
//#import "MoreViewController.h"
//#import "ProfileTableViewCell.h"

@interface LeftMenuViewController ()<UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate, PassValueDelegate>
{
    
}

@property(nonatomic, strong)UITableView *tableView;
@property(nonatomic, strong)NSMutableArray *dataSource;
@property(nonatomic, strong)UIView *loginContainerView;
@property(nonatomic, strong)UIView *avatarContainerView;
@property(nonatomic, strong)RoundedAvatarButton *avatarView;
@property(nonatomic, strong)UILabel *nicknameLabel;
@property(nonatomic, strong)UIImageView *bgView;

@end

#define LOGIN_AREA_HEIGHT 120.0


@implementation LeftMenuViewController

@synthesize tableView;
@synthesize dataSource;
@synthesize loginContainerView;
@synthesize avatarView;
@synthesize nicknameLabel;
@synthesize bgView;

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
    

    NSDictionary *dictB = [[NSDictionary alloc]initWithObjectsAndKeys:
                           T(@"首页"), @"title",
                           [NSString fontAwesomeIconStringForEnum:FAslack], @"icon",
                           INT(LeftMenuMain), @"function",
                           nil];

    NSDictionary *dictC = [[NSDictionary alloc]initWithObjectsAndKeys:
                           T(@"个人中心"), @"title",
                           [NSString fontAwesomeIconStringForEnum:FAUser], @"icon",
                           INT(LeftMenuProfile), @"function",
                           nil];
    
    NSDictionary *dictD = [[NSDictionary alloc]initWithObjectsAndKeys:
                           T(@"分类搜索"), @"title",
                           [NSString fontAwesomeIconStringForEnum:FASearch], @"icon",
                           INT(LeftMenuSearch), @"function",
                           nil];

    NSDictionary *dictE = [[NSDictionary alloc]initWithObjectsAndKeys:
                           T(@"购物车"), @"title",
                           [NSString fontAwesomeIconStringForEnum:FAShoppingCart], @"icon",
                           INT(LeftMenuCart), @"function",
                           nil];
    
    NSDictionary *dictF = [[NSDictionary alloc]initWithObjectsAndKeys:
                           T(@"帮助/客服"), @"title",
                           [NSString fontAwesomeIconStringForEnum:FAPhone], @"icon",
                           INT(LeftMenuService), @"function",
                           nil];
    
    NSDictionary *dictG = [[NSDictionary alloc]initWithObjectsAndKeys:
                           T(@"设置"), @"title",
                           [NSString fontAwesomeIconStringForEnum:FACog], @"icon",
                           INT(LeftMenuSetting), @"function",
                           nil];
    
    NSDictionary *dictH = [[NSDictionary alloc]initWithObjectsAndKeys:
                           T(@"退出"), @"title",
                           [NSString fontAwesomeIconStringForEnum:FASignOut], @"icon",
                           INT(LeftMenuLogout), @"function",
                           nil];

    

    
    NSString *nowVersion = NOWVERSION;
    NSString *nowBuild = NOWBUILD;
    nowVersion = [NSString stringWithFormat:@"V_%@#%@", nowVersion, nowBuild];
    
    // init left side menu
    self.dataSource = [[NSMutableArray alloc]initWithObjects:dictB,dictC,dictD,dictE, dictF,nil];

    // transform bg view
    self.bgView = [[UIImageView alloc]initWithFrame:self.view.bounds];
    [self.bgView setImageToBlur:[UIImage imageNamed:@"train_bg"] completionBlock:^{
        //
    }];
    [self.view addSubview:self.bgView];
    
    
    CGRect tableViewFrame = self.view.bounds;

    self.tableView = [[UITableView alloc]initWithFrame:tableViewFrame style:UITableViewStylePlain];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.separatorColor = WHITEALPHACOLOR2;
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsMake(0, 30, 0, 0)];
    }
    
    [self.view addSubview:self.tableView];
    
    [self initAvatarContainerView];
//    [self initloginContainerView];
//    [self checkVersion];
    
    // 绑定 passdelegate
    [ModelHelper sharedHelper].modelHelperDelegateForLeftMenuVC = self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    

    [[self navigationController] setNavigationBarHidden:YES animated:NO];
    
    // 已经登录了才有退出
    if (StringHasValue(XAppDelegate.me.sessionId)) {
        NSDictionary *dictH = [[NSDictionary alloc]initWithObjectsAndKeys:
                               T(@"退出"), @"title",
                               [NSString fontAwesomeIconStringForEnum:FASignOut], @"icon",
                               INT(LeftMenuLogout), @"function",
                               nil];
        [self.dataSource addObject:dictH];
    }
    [self.tableView reloadData];
    //  重新获取昵称和头像
    [self refreshAvatarContainerView];
    
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
    CGRect avatarFrame;
    if (OSVersionIsAtLeastiOS7()) {
        avatarFrame = CGRectMake(0, STATUS_BAR_HEIGHT, MAX_LEFT_DRAWER_WIDTH, LOGIN_AREA_HEIGHT);
    }else{
        avatarFrame = CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), LOGIN_AREA_HEIGHT);
    }
    
    self.avatarContainerView  = [[UIView alloc]initWithFrame:avatarFrame];

    self.nicknameLabel = [[UILabel alloc]initWithFrame:CGRectMake(105, avatarFrame.origin.y+H_40, 150, LABEL_HEIGHT)];
    self.nicknameLabel.textColor = WHITECOLOR;
    [self.nicknameLabel setFont:FONT_DIN_20];
    
    NSLog(@"XAppDelegate.me.avatarURL: %@",XAppDelegate.me.avatarURL);
    
    self.avatarView = [[RoundedAvatarButton alloc]initWithFrame:CGRectMake(35, avatarFrame.origin.y+H_24, 50, 50)];

    [self.avatarView.avatarImageView setImage:[UIImage imageNamed:XAppDelegate.me.avatarURL]];

//    [self.avatarView.avatarImageView sd_setImageWithURL:[NSURL URLWithString:XAppDelegate.me.avatarURL]
//                                    placeholderImage:[UIImage imageNamed:@"logo_luotuo"]];
    [self.avatarView addTarget:self action:@selector(viewProfileAction:) forControlEvents:UIControlEventTouchUpInside];
    
    
    [self.avatarContainerView addSubview:self.avatarView];
    [self.avatarContainerView addSubview:self.nicknameLabel];
    
    self.tableView.tableHeaderView = self.avatarContainerView;
}

- (void)refreshAvatarContainerView
{
    self.nicknameLabel.text = XAppDelegate.me.username;
    [self.avatarView.avatarImageView setImage:[UIImage imageNamed:XAppDelegate.me.avatarURL]];
//    [self.avatarView.avatarImageView sd_setImageWithURL:[NSURL URLWithString:XAppDelegate.me.avatarURL]
//                                       placeholderImage:[UIImage imageNamed:@"logo_luotuo"]];

}

- (void)viewProfileAction:(id)sender
{
    ProfileViewController *VC = [[ProfileViewController alloc]init];
    [self.mm_drawerController setCenterViewController:VC];
    [self.mm_drawerController closeDrawerAnimated:YES completion:^(BOOL finished) {}];
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

- (void)passSignalValue:(NSString *)value andData:(id)data
{
    if ([value isEqualToString:SIGNAL_AVATAR_UPLOAD_DONE]) {
        [self refreshAvatarContainerView];
    }
}
#pragma mark - thrid party login


-(void)getBindUserInfo
{
    self.nicknameLabel.text = XAppDelegate.me.username;
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
    return CELL_HEIGHT-H_10;
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
    
    UILabel *iconLabel = [[UILabel alloc]initWithFrame:CGRectMake(30, 10, 30 ,30)];
    iconLabel.tag = CELL_ICON_TAG;
    iconLabel.font = FONT_AWESOME_20;
    iconLabel.textColor = WHITECOLOR;
    iconLabel.backgroundColor = [UIColor clearColor];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(80, 10, 120, 30)];
    titleLabel.tag = CELL_TITLE_TAG;
    titleLabel.font = FONT_16;
    titleLabel.textColor = WHITECOLOR;
    titleLabel.backgroundColor = [UIColor clearColor];
    
    UILabel *detailLabel = [[UILabel alloc]initWithFrame:CGRectMake(80, 40, H_120, H_14)];
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
    [cell.contentView setBackgroundColor:[UIColor clearColor]];
    [cell setBackgroundColor:[UIColor clearColor]];
    
    return  cell;
}



- (void)configureCell:(UITableViewCell *)cell forIndexPath:(NSIndexPath *)indexPath {
    
    // two type
    NSDictionary *cellData = [[NSDictionary alloc]init];
    cell.contentView.backgroundColor = [UIColor clearColor];
    
    UIView *selectionColor = [[UIView alloc] init];
    selectionColor.backgroundColor = WHITEALPHACOLOR;
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *cellData = (NSDictionary *)[self.dataSource objectAtIndex:indexPath.row];
    NSInteger function = [(NSNumber *)[cellData objectForKey:@"function"] integerValue];

    switch (function) {
        case LeftMenuLogout:
        {
            [[ModelHelper sharedHelper]meLogoutWithBlock:^(BOOL exeStatus) {
                [self.dataSource removeObject:self.dataSource.lastObject];
                [self.mm_drawerController closeDrawerAnimated:YES completion:^(BOOL finished) {
                    [XAppDelegate showLoginView];
                }];
            }];
        }
        break;
            
        case LeftMenuMain:
        {
            [XAppDelegate showDrawerView];
            [self.mm_drawerController closeDrawerAnimated:YES completion:^(BOOL finished) {}];
        }
            break;
        case LeftMenuCart:
        {
            CartListViewController *VC = [[CartListViewController alloc]init];
            ColorNavigationController *nav = [[ColorNavigationController alloc]initWithRootViewController:VC];
            [VC setupLeftMMButton];
            [self.mm_drawerController setCenterViewController:nav];
            [self.mm_drawerController closeDrawerAnimated:YES completion:^(BOOL finished) {}];
            
        }
            break;
        case LeftMenuSearch:
        {
            SearchCategoryViewController *VC = [[SearchCategoryViewController alloc]init];
            ColorNavigationController *nav = [[ColorNavigationController alloc]initWithRootViewController:VC];
            [VC setupLeftMMButton];
            [self.mm_drawerController setCenterViewController:nav];
            [self.mm_drawerController closeDrawerAnimated:YES completion:^(BOOL finished) {}];

        }
            break;
        case LeftMenuService:
        {
            NSString *urlString = CUSTOMER_SERVICE_URL;
            WebViewController *VC = [[WebViewController alloc]initWithNibName:nil bundle:nil];
            VC.titleString = T(@"帮助/客服");
            VC.urlString = urlString;
            [VC setupLeftMMButton];
            ColorNavigationController *nav = [[ColorNavigationController alloc]initWithRootViewController:VC];

            [self.mm_drawerController setCenterViewController:nav];
            [self.mm_drawerController closeDrawerAnimated:YES completion:^(BOOL finished) {}];
            
        }
            break;
        case LeftMenuProfile:
        {
            if (StringHasValue(XAppDelegate.me.sessionId)) {
                ProfileViewController *VC = [[ProfileViewController alloc]init];
                VC.passDelegate = self;
                [self.mm_drawerController setCenterViewController:VC];
                [self.mm_drawerController closeDrawerAnimated:YES completion:^(BOOL finished) {}];
            }else{
                [SGActionView showAlertWithTitle:T(@"请先登录") message:T(@"查看个人中心需要登录") leftButtonTitle:T(@"取消") rightButtonTitle:T(@"去登录") selectedHandle:^(NSInteger index) {
                    if (index == 1) {
                        [self.mm_drawerController closeDrawerAnimated:YES completion:^(BOOL finished) {
                            [XAppDelegate showLoginView];
                        }];
                    }
                }];
                
            }


        }
            break;
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
//        ColorNavigationController *popNavController = [[ColorNavigationController alloc]initWithRootViewController:accountListViewController];
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
//        ColorNavigationController *popNavController = [[ColorNavigationController alloc]initWithRootViewController:profileViewController];
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
//        ColorNavigationController *popNavController = [[ColorNavigationController alloc]initWithRootViewController:historyListViewController];
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
//        ColorNavigationController *popNavController = [[ColorNavigationController alloc]initWithRootViewController:moreViewController];
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
