//
//  LoginViewController.m
//  merchant
//
//  Created by mactive.meng on 4/5/14.
//  Copyright (c) 2014 kkche. All rights reserved.
//

#import "LoginViewController.h"
#import "RegisterViewController.h"
#import "AppRequestManager.h"
#import "AppDelegate.h"
#import "KKTextField.h"
#import "FAHoverButton.h"
#import "KKFlatButton.h"
#import "UIViewController+ImageBackButton.h"
#import "Me.h"
#import "ModelHelper.h"
#import <LBBlurredImage/UIImageView+LBBlurredImage.h>

@interface LoginViewController ()<UITextFieldDelegate, UIScrollViewDelegate>
@property(nonatomic, strong)UIScrollView *loginPanel;
@property(nonatomic, strong)UIView *logoView;
@property(nonatomic, strong)KKTextField *userTextView;
@property(nonatomic, strong)KKTextField *passTextView;
@property(nonatomic, strong)KKFlatButton *verifyButton;
@property(nonatomic, strong)UIButton *forgotButton;
@property(nonatomic, strong)KKFlatButton *signinButton;
@property(nonatomic, strong)KKFlatButton *tourButton;

@end

@implementation LoginViewController
@synthesize loginPanel;
@synthesize logoView;
@synthesize userTextView, passTextView;
@synthesize verifyButton;
@synthesize forgotButton;
@synthesize signinButton;
@synthesize tourButton;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
#define LOGO_SIDE           140.0f
#define ANIMATION_OFFSET    TOTAL_HEIGHT * 0.3
#define OFFSET_Y            H_100

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *str = [user valueForKey:@"HELLO"];
    if ([str isEqualToString:@"YES"]) {
        [self tourAction];
    }
    
    self.title = [NSString stringWithFormat:T(@"欢迎使用%@"),APP_NAME];
    
    self.loginPanel = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, TOTAL_WIDTH, TOTAL_HEIGHT-1)];
    self.loginPanel.contentSize = CGSizeMake(TOTAL_WIDTH,TOTAL_HEIGHT);
    self.loginPanel.scrollEnabled = YES;
    self.loginPanel.delegate = self;
    self.loginPanel.showsVerticalScrollIndicator = NO;

    // logoview
    self.logoView = [[UIView alloc] initWithFrame:CGRectMake(130, H_50, H_60, H_60)];
    [self.logoView setBackgroundColor:GREENLIGHTCOLOR];
    [self.logoView.layer setCornerRadius:H_30];
    [self.logoView.layer setMasksToBounds:YES];
    
    UIImageView *logoImageView = [[UIImageView alloc]initWithFrame:CGRectMake(12, 15, 36, 30)];
    [logoImageView setImage:[UIImage imageNamed:@"logo_luotuo"]];
    [self.logoView addSubview:logoImageView];
    
    
    // userTextView
    self.userTextView = [[KKTextField alloc]initWithFrame:CGRectMake(LEFT_PADDING*3, OFFSET_Y+H_50,TOTAL_WIDTH-LEFT_PADDING*6, H_50)];
    self.userTextView.delegate = self;
    [self.userTextView setPlaceholder:T(@"用户名")];
    [self.userTextView setIconString:[NSString fontAwesomeIconStringForEnum:FAUser]];
    self.userTextView.keyboardType = UIKeyboardTypeDefault;
    self.userTextView.returnKeyType = UIReturnKeyNext;
    
    // passTextView
    self.passTextView = [[KKTextField alloc]initWithFrame:CGRectMake(LEFT_PADDING*3, OFFSET_Y+H_50*2, TOTAL_WIDTH-LEFT_PADDING*6 , H_50)];
    self.passTextView.delegate = self;
    [self.passTextView setPlaceholder:T(@"密码")];
    [self.passTextView setIconString:[NSString fontAwesomeIconStringForEnum:FALock]];
    self.passTextView.returnKeyType = UIReturnKeyDone;
    self.passTextView.secureTextEntry = YES;

    // verifyButton
    
    self.verifyButton = [KKFlatButton buttonWithType:UIButtonTypeCustom];
    [self.verifyButton setTitle:T(@"登录") forState:UIControlStateNormal];
    [self.verifyButton setFrame:CGRectMake(LEFT_PADDING*3, OFFSET_Y+H_50*3+TOP_PADDING*2, TOTAL_WIDTH-LEFT_PADDING*6 , H_50)];
    [self.verifyButton setBackgroundColor:BLUECOLOR];
    [self.verifyButton addTarget:self action:@selector(verifyPasswordAction) forControlEvents:UIControlEventTouchUpInside];
    
    // change corner
    self.userTextView = (KKTextField *)[DataTrans roundCornersOnView:self.userTextView onTopLeft:YES topRight:YES bottomLeft:NO bottomRight:NO radius:5.0f];
    
    self.passTextView = (KKTextField *)[DataTrans roundCornersOnView:self.passTextView onTopLeft:NO topRight:NO bottomLeft:YES bottomRight:YES radius:5.0f];

    
    [self.loginPanel addSubview:self.logoView];
    [self.loginPanel addSubview:self.userTextView];
    [self.loginPanel addSubview:self.passTextView];
    [self.loginPanel addSubview:self.verifyButton];
    
    self.signinButton = [KKFlatButton buttonWithType:UIButtonTypeCustom];
    [self.signinButton setTitle:T(@"注册") forState:UIControlStateNormal];
    [self.signinButton setFrame:CGRectMake(0, TOTAL_HEIGHT-H_60*2, TOTAL_WIDTH , H_60)];
    [self.signinButton addTarget:self action:@selector(registerAction) forControlEvents:UIControlEventTouchUpInside];
    [self.signinButton setBackgroundColor:GREENCOLOR];
    self.signinButton = (KKFlatButton *)[DataTrans roundCornersOnView:self.signinButton onTopLeft:YES topRight:YES bottomLeft:YES bottomRight:YES radius:0.0f];
    
    
    self.tourButton = [KKFlatButton buttonWithType:UIButtonTypeCustom];
    [self.tourButton setTitle:T(@"随便看看") forState:UIControlStateNormal];
    [self.tourButton setFrame:CGRectMake(0, TOTAL_HEIGHT-H_60, TOTAL_WIDTH , H_60)];
    [self.tourButton addTarget:self action:@selector(tourAction) forControlEvents:UIControlEventTouchUpInside];
    [self.tourButton setBackgroundColor:GREENLIGHTCOLOR];
    self.tourButton = (KKFlatButton *)[DataTrans roundCornersOnView:self.tourButton onTopLeft:YES topRight:YES bottomLeft:YES bottomRight:YES radius:0.0f];
    
    
    
    UIImageView *bgView = [[UIImageView alloc]initWithFrame:self.view.bounds];
    [bgView setImageToBlur:[UIImage imageNamed:@"train_bg"] completionBlock:^{
        [self.view addSubview:self.loginPanel];
        [self.view addSubview:self.signinButton];
        [self.view addSubview:self.tourButton];

    }];
    
    [self.view addSubview:bgView];
    
    [self setUpImageDownButton:0];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self navigationGreenStyle];
}


- (void)registerAction
{
    [MobClick event:UM_REGISTER];
    RegisterViewController *vc = [[RegisterViewController alloc]initWithNibName:nil bundle:nil];
    [self presentViewController:vc animated:YES completion:^{}];
}

- (void)tourAction
{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    [user setValue:@"NO" forKey:@"HELLO"];
    [user synchronize];
    
    [XAppDelegate showDrawerView];
}


/////////////////////////////////////////////////////////
#pragma mark - textview delegate
/////////////////////////////////////////////////////////


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ([textField isEqual:self.userTextView]) {
        [self.passTextView becomeFirstResponder];
    }
    
    if ([textField isEqual:self.passTextView]) {
        [self verifyPasswordAction];
    }
    
    return NO;
}

//- (void)textFieldDidBeginEditing:(UITextField *)textField
//{
//    if ([textField isEqual:self.userTextView]) {
//        self.userTextView.text = @"";
//    }
//    
//    if ([textField isEqual:self.passTextView]) {
//        self.passTextView.text = @"";
//    }
//}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.userTextView resignFirstResponder];
    [self.passTextView resignFirstResponder];
    [UIView animateWithDuration:0.5f animations:^{
        [self.loginPanel setY:0];
    }];
}


/**
 *  验证邀请码
 */
- (void)verifyPasswordAction
{
    self.editing = NO;
    [self.passTextView resignFirstResponder];
    [self.userTextView resignFirstResponder];
    
    // sign_in
    
    if (!StringHasValue(self.passTextView.text)) {
        [DataTrans showWariningTitle:T(@"密码不能为空") andCheatsheet:ICON_TIMES andDuration:1.0f];
        return;
    }
    if (![DataTrans isValidatePassword:self.passTextView.text]) {
        [DataTrans showWariningTitle:T(@"密码为6-16位\n数字或字母组合") andCheatsheet:ICON_TIMES andDuration:1.5f];
        return;
    }
    
    HTProgressHUD *HUD = [[HTProgressHUD alloc] init];
    HUD.indicatorView = [HTProgressHUDIndicatorView indicatorViewWithType:HTProgressHUDIndicatorTypeActivityIndicator];
    HUD.text = T(@"登录中...");
    [HUD showInView:self.view];



    [[AppRequestManager sharedManager] signInWithUsername:self.userTextView.text password:self.passTextView.text andBlock:^(id responseObject, NSError *error) {

        [HUD removeFromSuperview];

        if (responseObject != nil) {
            
            NSLog(@"%@", responseObject);
            NSMutableDictionary * dict = [[NSMutableDictionary alloc] initWithDictionary:responseObject];
            dict[@"password"] = self.passTextView.text;

            [[ModelHelper sharedHelper]updateMeWithJsonData:dict];
            [MobClick event:UM_LOGIN];
            [XAppDelegate skipIntroView];

        }
        
        if(error != nil)
        {
            if (error.code == -1004) {
                [DataTrans showWariningTitle:T(@"网络错误") andCheatsheet:ICON_TIMES];
            }else{
                [DataTrans showWariningTitle:T(@"用户名或密码错误") andCheatsheet:ICON_TIMES];
            }
        }

     }];
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
