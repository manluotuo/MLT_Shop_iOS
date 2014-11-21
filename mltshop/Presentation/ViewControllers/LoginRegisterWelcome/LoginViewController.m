//
//  LoginViewController.m
//  merchant
//
//  Created by mactive.meng on 4/5/14.
//  Copyright (c) 2014 kkche. All rights reserved.
//

#import "LoginViewController.h"
#import "AppRequestManager.h"
#import "AppDelegate.h"
#import "KKTextField.h"
#import "KKFlatButton.h"
#import "UIViewController+ImageBackButton.h"
#import "Me.h"
#import "ModelHelper.h"
#import <HTProgressHUD/HTProgressHUD.h>
#import <HTProgressHUD/HTProgressHUDIndicatorView.h>

@interface LoginViewController ()<UITextFieldDelegate, UIScrollViewDelegate>
@property(nonatomic, strong)UIScrollView *loginPanel;
@property(nonatomic, strong)KKTextField *userTextView;
@property(nonatomic, strong)KKTextField *passTextView;
@property(nonatomic, strong)KKFlatButton *verifyButton;
@property(nonatomic, strong)UIButton *forgotButton;
@property(nonatomic, strong)UIImageView *logoView;
@end

@implementation LoginViewController
@synthesize loginPanel;
@synthesize logoView;
@synthesize userTextView, passTextView;
@synthesize verifyButton;
@synthesize forgotButton;

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
#define OFFSET_Y            H_60

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = [NSString stringWithFormat:T(@"欢迎使用%@"),APP_NAME];
    self.view.backgroundColor = GREENCOLOR;
    
    self.loginPanel = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, TOTAL_WIDTH, TOTAL_HEIGHT-1)];
    self.loginPanel.contentSize = CGSizeMake(TOTAL_WIDTH,TOTAL_HEIGHT);
    self.loginPanel.scrollEnabled = YES;
    self.loginPanel.delegate = self;
    self.loginPanel.showsVerticalScrollIndicator = NO;

    self.logoView = [[UIImageView alloc] initWithFrame:
                     CGRectMake((TOTAL_WIDTH-LOGO_SIDE)/2, (TOTAL_HEIGHT/2-LOGO_SIDE)/2, LOGO_SIDE, LOGO_SIDE)];
    [self.logoView setImage:[UIImage imageNamed:@"logoTitle"]];
    
    
    // userTextView
    
    self.userTextView = [[KKTextField alloc]initWithFrame:CGRectMake(LEFT_PADDING*3, OFFSET_Y+TOP_PADDING*3, TOTAL_WIDTH-LEFT_PADDING*6 , H_40)];
    self.userTextView.delegate = self;
    [self.userTextView setPlaceholder:T(@"手机号")];
    [self.userTextView setIconString:ICON_MOBILE];
    self.userTextView.keyboardType = UIKeyboardTypeNumberPad;
    self.userTextView.returnKeyType = UIReturnKeyNext;
    
    // passTextView
    
    self.passTextView = [[KKTextField alloc]initWithFrame:CGRectMake(LEFT_PADDING*3, OFFSET_Y+H_40+TOP_PADDING*5, TOTAL_WIDTH-LEFT_PADDING*6 , H_40)];
    self.passTextView.delegate = self;
    [self.passTextView setPlaceholder:T(@"密码")];
    [self.passTextView setIconString:ICON_LOCK];
    self.passTextView.returnKeyType = UIReturnKeyDone;
    self.passTextView.secureTextEntry = YES;

    // verifyButton
    
    self.verifyButton = [KKFlatButton buttonWithType:UIButtonTypeCustom];
    [self.verifyButton setTitle:T(@"登录") forState:UIControlStateNormal];
    [self.verifyButton setFrame:CGRectMake(LEFT_PADDING*3, OFFSET_Y+H_40*2+TOP_PADDING*7, TOTAL_WIDTH-LEFT_PADDING*6 , H_40)];
    [self.verifyButton addTarget:self action:@selector(verifyPasswordAction) forControlEvents:UIControlEventTouchUpInside];
    
//    [self.loginPanel addSubview:self.logoView];
    [self.loginPanel addSubview:self.userTextView];
    [self.loginPanel addSubview:self.passTextView];
    [self.loginPanel addSubview:self.verifyButton];
    
    [self.view addSubview:self.loginPanel];
    
    [self setUpImageDownButton:0];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self navigationGreenStyle];
//    self.userTextView.text = @"18600000000";
//    self.passTextView.text = @"mengqian";
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
    [self.passTextView resignFirstResponder];
    [self.userTextView resignFirstResponder];
    
    // sign_in
    
    if (![DataTrans isValidateMobile:self.userTextView.text]) {
        [DataTrans showWariningTitle:T(@"手机号格式有误") andCheatsheet:ICON_TIMES andDuration:1.5f];
        return;
    }
    if (!StringHasValue(self.passTextView.text)) {
        [DataTrans showWariningTitle:T(@"密码不能为空") andCheatsheet:ICON_TIMES andDuration:1.0f];
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
            
            NSMutableDictionary * dict = [[NSMutableDictionary alloc] initWithDictionary:responseObject];
            [[ModelHelper sharedHelper]updateMeWithJsonData:dict];
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
