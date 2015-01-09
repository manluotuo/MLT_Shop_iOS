//
//  AppDelegate.m
//  mltshop
//
//  Created by mactive.meng on 12/11/14.
//  Copyright (c) 2014 manluotuo. All rights reserved.
//

#import "AppDelegate.h"
#import "ColorNavigationController.h"
#import "MMNavigationController.h"
#import <MMDrawerController/MMDrawerController.h>
#import <MMDrawerController/MMDrawerVisualState.h>
#import "LeftMenuViewController.h"
#import "RightMenuViewController.h"
#import "AppRequestManager.h"
#import "KKDrawerViewController.h"
#import "ModelHelper.h"
#import "ProfileViewController.h"
#import <AlipaySDK/AlipaySDK.h>


//#import "LoginViewController.h"
//#import "WelcomeViewController.h"
//#import "InitDataHelper.h"
//#import "ModelHelper.h"
#import "FirstHelpViewController.h"
#import "RegisterViewController.h"
#import "LoginViewController.h"
//#import "ProfileFormViewController.h"
//#import "AccountListViewController.h"

//#import "ShareHelper.h"
//#import "WXApi.h"
//#import "WeiboSDK.h"
#define MR_LOGGING_ENABLED 0
@interface AppDelegate ()
@property(nonatomic, strong)KKDrawerViewController * drawerController;
@property (strong, nonatomic)RightMenuViewController *rightSideDrawerViewController;
@property(nonatomic, strong)LoginViewController *loginViewController;
@property(nonatomic, strong)RegisterViewController *registerViewController;
@property(nonatomic, strong)FirstHelpViewController *firstHelpViewController;
@property(nonatomic, strong)NSString *versonUrl;

@end

@implementation AppDelegate
@synthesize drawerController;
@synthesize firstHelpViewController;
@synthesize loginViewController;
@synthesize registerViewController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
//    [MobClick startWithAppkey:UMENG_APPKEY reportPolicy:BATCH channelId:nil];
//    NSString *nowVersion = NOWVERSION;
//    NSString *nowBuild = NOWBUILD;
//    [MobClick setAppVersion:[NSString stringWithFormat:@"V_%@#%@",nowVersion,nowBuild]];
//    
//    [WXApi registerApp:WXAPI_APP_ID];
//    [WeiboSDK registerApp:WEIBO_APP_KEY];
    
    
    // TODO: 先初始化 用来none insert vehicle
    //    [self managedObjectContext];
    
    // MagicalRecord
    //    [MagicalRecord setupCoreDataStack];
    NSString *storeNamed = @"manluotuo.sqlite";
    [MagicalRecord setupCoreDataStackWithAutoMigratingSqliteStoreNamed:storeNamed];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.me = [[ModelHelper sharedHelper]findOnlyMe];

    
    
    
    /**
     *  DRAWER ViewController
     */
    UIViewController *leftSideDrawerViewController = [[LeftMenuViewController alloc]init];
    self.centerViewController = [[HostViewController alloc] init];
    self.rightSideDrawerViewController = [[RightMenuViewController alloc]init];
    
    UINavigationController * navigationController = [[MMNavigationController alloc] initWithRootViewController:self.centerViewController];
    [navigationController setRestorationIdentifier:@"MMExampleCenterNavigationControllerRestorationKey"];
    
    UINavigationController * rightSideNavController = [[MMNavigationController alloc] initWithRootViewController:self.rightSideDrawerViewController];
    [rightSideNavController setRestorationIdentifier:@"MMExampleRightNavigationControllerRestorationKey"];
    UINavigationController * leftSideNavController = [[MMNavigationController alloc] initWithRootViewController:leftSideDrawerViewController];
    [leftSideNavController setRestorationIdentifier:@"MMExampleLeftNavigationControllerRestorationKey"];
    self.drawerController = [[KKDrawerViewController alloc]
                             initWithCenterViewController:navigationController
                             leftDrawerViewController:leftSideNavController
                             rightDrawerViewController:nil];
    [self.drawerController setShowsShadow:NO];
    
    // custom drawer style
    
    [self.drawerController setRestorationIdentifier:@"MMDrawer"];
    [self.drawerController setMaximumLeftDrawerWidth:MAX_LEFT_DRAWER_WIDTH];
    [self.drawerController setMaximumRightDrawerWidth:MAX_LEFT_DRAWER_WIDTH];
    [self.drawerController setShowsShadow:YES];
    [self.drawerController setDrawerVisualStateBlock:[MMDrawerVisualState slideAndScaleVisualStateBlock]];
    
    // 打开侧边栏 关闭侧边栏
    [self.drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
    [self.drawerController setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeAll];
    
//    [self checkUserLogin];
    
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    [[UINavigationBar appearance] setTintColor:WHITECOLOR];
    
//    if (!OSVersionIsAtLeastiOS7()) {
//        [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleDefault];
//    }
    
    [self skipIntroView];
    
    
    return YES;
}

- (void)showDrawerView
{
    NSLog(@"showMainView");
    
    UINavigationController * navigationController = [[MMNavigationController alloc] initWithRootViewController:self.centerViewController];
    [navigationController setRestorationIdentifier:@"MMExampleCenterNavigationControllerRestorationKey"];

    [self.drawerController setCenterViewController:navigationController];
    [self.window setRootViewController:self.drawerController];
    [self.window addSubview:self.drawerController.view];
    [self.window makeKeyAndVisible];
}

- (void)skipIntroView
{
    [self getAllCategory];
    // 用户第一次打开
    NSNumber *result = GET_DEFAULT(@"HELPSEEN_INTRO");
    
    if (!result.boolValue) {
        [self showIntroductionView];
    }else{
        NSLog(@"APP ME  %@",self.me);

        if (!StringHasValue(self.me.userId)) {
            NSLog(@"会记住登录信息,用户还没有登录");
            [self showRegisterView];
        }else{
            [self loginWithSavedUserInfo];
//            NSLog(@"用户已经登录");
//            [self showDrawerView];
        }
    }
}

// 利用现有的用户名密码登陆
- (void)loginWithSavedUserInfo
{
//    HTProgressHUD *HUD = [[HTProgressHUD alloc] init];
//    HUD.indicatorView = [HTProgressHUDIndicatorView indicatorViewWithType:HTProgressHUDIndicatorTypeActivityIndicator];
//    HUD.text = T(@"登录中...");
//    [HUD showInView:self.window.rootViewController.view];
    
    // 缺一不可
    if (!StringHasValue(self.me.username) ||  !StringHasValue(self.me.password)) {
        [self showLoginView];
        return;
    }
    
    [[AppRequestManager sharedManager] signInWithUsername:self.me.username password:self.me.password andBlock:^(id responseObject, NSError *error) {
        
//        [HUD removeFromSuperview];
        
        if (responseObject != nil) {
            
            NSMutableDictionary * dict = [[NSMutableDictionary alloc] initWithDictionary:responseObject];
            [[ModelHelper sharedHelper]updateMeWithJsonData:dict];
            // 显示主页面
            [self showDrawerView];
        }
        
        if(error != nil)
        {
            // 显示登陆页面
            [self showLoginView];
        }
        
    }];

}

- (void)showIntroductionView
{
    NSLog(@"showIntroductionView");
    self.firstHelpViewController = [[FirstHelpViewController alloc]initWithNibName:nil bundle:nil];
    
    [self.window setRootViewController:self.firstHelpViewController];
    [self.window addSubview:self.firstHelpViewController.view];
    [self.window makeKeyAndVisible];
}

- (void)showRegisterView
{
    NSLog(@"showRegisterView");
    self.registerViewController = [[RegisterViewController alloc]initWithNibName:nil bundle:nil];
    
    [self.window setRootViewController:self.registerViewController];
    [self.window addSubview:self.registerViewController.view];
    [self.window makeKeyAndVisible];
}

- (void)showLoginView
{
    NSLog(@"showRegisterView");
    self.loginViewController = [[LoginViewController alloc]initWithNibName:nil bundle:nil];
    
    [self.window setRootViewController:self.loginViewController];
    [self.window addSubview:self.loginViewController.view];
    [self.window makeKeyAndVisible];
}

- (void)getAllCategory
{
    self.allCategory = [[NSMutableArray alloc]init];
    [[AppRequestManager sharedManager]getCategoryAllWithBlock:^(id responseObject, NSError *error) {
        if (responseObject != nil) {
            for (int i = 0 ; i < [responseObject count]; i++) {
                CategoryModel *model = [[CategoryModel alloc]initWithDict:responseObject[i]];
                [self.allCategory addObject:model];
            }
        }
    }];
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    
    //跳转支付宝钱包进行支付，需要将支付宝钱包的支付结果回传给SDK
    if ([url.host isEqualToString:@"safepay"]) {
        [[AlipaySDK defaultService]
         processOrderWithPaymentResult:url
         standbyCallback:^(NSDictionary *resultDic) {
             NSLog(@"result = %@", resultDic);
             
             // 付款成功查看订单
             if([resultDic[@"resultStatus"] isEqualToString:@"9000"]){
                 
                 ProfileViewController *VC = [[ProfileViewController alloc]init];
                 [self.drawerController setCenterViewController:VC];
             }

         }];
    }
    
    return YES;
}




- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
}

@end
