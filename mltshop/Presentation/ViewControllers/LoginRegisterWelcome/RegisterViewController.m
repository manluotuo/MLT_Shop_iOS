//
//  RegisterViewController.m
//  merchant
//
//  Created by mactive.meng on 23/6/14.
//  Copyright (c) 2014 kkche. All rights reserved.
//

#import "RegisterViewController.h"
#import "AppRequestManager.h"
#import "AppDelegate.h"
#import "KKTextField.h"
#import "KKFlatButton.h"
#import "UIViewController+ImageBackButton.h"
#import "Me.h"
#import "ModelHelper.h"
#import <HTProgressHUD/HTProgressHUD.h>
#import <HTProgressHUD/HTProgressHUDIndicatorView.h>


@interface RegisterViewController ()<UITextFieldDelegate, UIScrollViewDelegate>
@property(nonatomic, strong)UIScrollView *loginPanel;
@property(nonatomic, strong)KKTextField *inviteTextView;
@property(nonatomic, strong)KKTextField *myTextView;
@property(nonatomic, strong)KKTextField *codeTextView;
@property(nonatomic, strong)KKTextField *passTextView;
@property(nonatomic, strong)KKTextField *rePassTextView;
@property(nonatomic, strong)KKFlatButton *verifyButton;
@property(nonatomic, assign)NSInteger nowEditing;

// 编辑完成按钮
@property(nonatomic, strong)UIView *editAssistView;
@property(nonatomic, strong)UIButton *doneButton;


@end

#define LOGO_SIDE           140.0f
#define ANIMATION_OFFSET    TOTAL_HEIGHT * 0.3
#define OFFSET_Y            H_20
#define INVITE_TAG          101
#define MY_TAG              102
#define CODE_TAG            103
#define PASSWORD_TAG        104
#define REPASSWORD_TAG      105


@implementation RegisterViewController
@synthesize loginPanel;
@synthesize inviteTextView, passTextView, myTextView, codeTextView,rePassTextView;
@synthesize verifyButton;
@synthesize editAssistView, doneButton;
@synthesize inviteMobile;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = [NSString stringWithFormat:T(@"注册%@"),APP_NAME];
        self.view.backgroundColor = WHITECOLOR;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.loginPanel = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, TOTAL_WIDTH, TOTAL_HEIGHT-1)];
    self.loginPanel.contentSize = CGSizeMake(TOTAL_WIDTH,TOTAL_HEIGHT);
    self.loginPanel.scrollEnabled = YES;
    self.loginPanel.delegate = self;
    self.loginPanel.showsVerticalScrollIndicator = NO;
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapGestureCaptured:)];
    [self.loginPanel addGestureRecognizer:singleTap];
    
    // inviteTextView
    
    self.inviteTextView = [[KKTextField alloc]initWithFrame:CGRectMake(LEFT_PADDING*3, OFFSET_Y+TOP_PADDING, TOTAL_WIDTH-LEFT_PADDING*6 , H_40)];
    self.inviteTextView.delegate = self;
    [self.inviteTextView setPlaceholder:T(@"输入邀请人手机号")];
    [self.inviteTextView setIconString:ICON_MOBILE];
    self.inviteTextView.keyboardType = UIKeyboardTypeNumberPad;
    self.inviteTextView.returnKeyType = UIReturnKeyNext;
    self.inviteTextView.tag = INVITE_TAG;
    [self.inviteTextView setEnabled:NO];
    self.inviteTextView.textColor = GRAYEXLIGHTCOLOR;

    
    self.myTextView = [[KKTextField alloc]initWithFrame:CGRectMake(LEFT_PADDING*3, OFFSET_Y+H_40+TOP_PADDING*2 ,TOTAL_WIDTH-LEFT_PADDING*6, H_40)];
    self.myTextView.delegate = self;
    [self.myTextView setPlaceholder:T(@"我的手机号")];
    [self.myTextView setIconString:ICON_MOBILE];
    self.myTextView.keyboardType = UIKeyboardTypeNumberPad;
    self.myTextView.returnKeyType = UIReturnKeyNext;
    self.myTextView.tag = MY_TAG;
    
    
    self.codeTextView = [[KKTextField alloc]initWithFrame:CGRectMake(LEFT_PADDING*3, OFFSET_Y+H_40*2+TOP_PADDING*3 ,TOTAL_WIDTH-LEFT_PADDING*6, H_40)];
    self.codeTextView.delegate = self;
    [self.codeTextView setPlaceholder:T(@"短信验证码")];
    [self.codeTextView setIconString:ICON_MOBILE];
    self.codeTextView.keyboardType = UIKeyboardTypeNumberPad;
    self.codeTextView.returnKeyType = UIReturnKeyNext;
    self.codeTextView.tag = CODE_TAG;
    
    
    // passTextView
    
    self.passTextView = [[KKTextField alloc]initWithFrame:CGRectMake(LEFT_PADDING*3, OFFSET_Y+H_40*3+TOP_PADDING*4, TOTAL_WIDTH-LEFT_PADDING*6 , H_40)];
    self.passTextView.delegate = self;
    [self.passTextView setPlaceholder:T(@"密码")];
    [self.passTextView setIconString:ICON_LOCK];
    self.passTextView.returnKeyType = UIReturnKeyDone;
    self.passTextView.tag = PASSWORD_TAG;
    self.passTextView.secureTextEntry = YES;

    // repassword
    self.rePassTextView = [[KKTextField alloc]initWithFrame:CGRectMake(LEFT_PADDING*3, OFFSET_Y+H_40*4+TOP_PADDING*5, TOTAL_WIDTH-LEFT_PADDING*6 , H_40)];
    self.rePassTextView.delegate = self;
    [self.rePassTextView setPlaceholder:T(@"再次输入密码")];
    [self.rePassTextView setIconString:ICON_LOCK];
    self.rePassTextView.returnKeyType = UIReturnKeyDone;
    self.rePassTextView.tag = REPASSWORD_TAG;
    self.rePassTextView.secureTextEntry = YES;
    
    // verifyButton
    self.verifyButton = [KKFlatButton buttonWithType:UIButtonTypeCustom];
    [self.verifyButton setTitle:T(@"注册") forState:UIControlStateNormal];
    [self.verifyButton setFrame:CGRectMake(LEFT_PADDING*3, OFFSET_Y+H_40*5+TOP_PADDING*6, TOTAL_WIDTH-LEFT_PADDING*6 , H_40)];
    [self.verifyButton addTarget:self action:@selector(registerAction) forControlEvents:UIControlEventTouchUpInside];
    
    //
    
    [self.loginPanel addSubview:self.inviteTextView];
    [self.loginPanel addSubview:self.myTextView];
    [self.loginPanel addSubview:self.codeTextView];
    [self.loginPanel addSubview:self.passTextView];
    [self.loginPanel addSubview:self.rePassTextView];
    [self.loginPanel addSubview:self.verifyButton];
    
    [self.view addSubview:self.loginPanel];

    
    [self setUpImageDownButton:0];
    
//    self.myTextView.text = @"18610205279";
    [self.verifyButton setEnabled:NO];

}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.inviteTextView.text = self.inviteMobile;
}




- (void)checkCodeAction
{
    [[AppRequestManager sharedManager]checkSMSWithMobile:self.myTextView.text andCode:self.codeTextView.text andBlock:^(id responseObject, NSError *error) {
        //
        NSNumber *checkResult = responseObject[@"result"];
        
        if ([checkResult boolValue]) {
            [DataTrans showWariningTitle:T(@"验证码无误") andCheatsheet:ICON_CHECK];
        }else{
            [DataTrans showWariningTitle:T(@"验证码输入错误，请重新输入\n或获取新的验证码") andCheatsheet:ICON_TIMES  andDuration:1.5f];
        }
    }];
}

- (void)registerAction
{
    if ([self checkAllTextField]) {
        [[AppRequestManager sharedManager]signUpWithMobile:self.myTextView.text password:self.passTextView.text code:self.codeTextView.text andBlock:^(id responseObject, NSError *error) {
            //
            if (responseObject != nil) {
//                [DataTrans showWariningTitle:T(@"注册成功,正在登陆") andCheatsheet:ICON_CHECK andDuration:1.0f];
//                run login and go main
                SET_DEFAULT(NUM_BOOL(NO), @"HELPSEEN_INTRO");
                SET_DEFAULT(NUM_BOOL(NO), @"HAS_SETTING_BINDING");
                [self verifyPasswordAction];
                
            }
            
            if (error != nil) {
                if ([(NSNumber *)responseObject[@"code"] integerValue] == 4006) {
                    [DataTrans showWariningTitle:T(@"该手机号已注册过") andCheatsheet:ICON_TIMES andDuration:1.0f];
                }
            }
            
        }];
    }
}


- (void)verifyPasswordAction
{
    // sign_in
    
    HTProgressHUD *HUD = [[HTProgressHUD alloc] init];
    HUD.indicatorView = [HTProgressHUDIndicatorView indicatorViewWithType:HTProgressHUDIndicatorTypeActivityIndicator];
    HUD.text = T(@"登录中...");
    [HUD showInView:self.view];
    
    
    [[AppRequestManager sharedManager] signInWithUsername:self.myTextView.text password:self.passTextView.text andBlock:^(id responseObject, NSError *error) {
        [HUD removeFromSuperview];

        if (responseObject != nil) {
            
            NSMutableDictionary *dict = [[NSMutableDictionary alloc]initWithDictionary:responseObject];
            //            dict[@"token"]  = responseObject[@"token"];
            //            dict[@"username"]   = responseObject[@"username"];
            
            [[ModelHelper sharedHelper]updateMeWithJsonData:dict];
            
            [XAppDelegate skipIntroView];
        }
        
        if(error != nil)
        {
            [HUD removeFromSuperview];
            [DataTrans showFontAwesomeWithTitle:T(@"用户名或密码错误") andCheatsheet:ICON_TIMES];
        }
        
    }];
}

- (void)checkPasswordAction
{
    NSString *pass = self.passTextView.text;
    NSString *repass = self.rePassTextView.text;
    
    if (StringHasValue(pass) && StringHasValue(repass)) {
        if (![DataTrans isValidatePassword:pass] || ![DataTrans isValidatePassword:repass]) {
            [DataTrans showWariningTitle:T(@"密码应该设置为6位以上\n数字或字母组合") andCheatsheet:ICON_TIMES andDuration:1.0f];
        }else{
            if (![pass isEqualToString:repass]) {
                [DataTrans showWariningTitle:T(@"两次密码不同") andCheatsheet:ICON_CHECK andDuration:1.0f];
            }else{
                [self checkAllTextField];
            }
        }
    }else{
        if (StringHasValue(pass) && ![DataTrans isValidatePassword:pass] ) {
            [DataTrans showWariningTitle:T(@"密码应该设置为6位以上\n数字或字母组合") andCheatsheet:ICON_TIMES andDuration:1.0f];
        }
        if (StringHasValue(repass) && ![DataTrans isValidatePassword:repass] ) {
            [DataTrans showWariningTitle:T(@"密码应该设置为6位以上\n数字或字母组合") andCheatsheet:ICON_TIMES andDuration:1.0f];
        }
//        [DataTrans showWariningTitle:T(@"密码不可以为空") andCheatsheet:ICON_CHECK andDuration:1.0f];
    }
}



- (BOOL)checkAllTextField
{
    if (StringHasValue(self.codeTextView.text)) {
        [self checkCodeAction];
    }
    if (!StringHasValue(self.passTextView.text) || !StringHasValue(self.rePassTextView.text)) {
        [DataTrans showWariningTitle:T(@"密码不能为空") andCheatsheet:ICON_TIMES andDuration:1.0f];
    }
    if ([DataTrans isValidateMobile:self.inviteTextView.text] &&
        [DataTrans isValidateMobile:self.myTextView.text] &&
        StringHasValue(self.codeTextView.text) &&
        [DataTrans isValidatePassword:self.passTextView.text] &&
        [DataTrans isValidatePassword:self.rePassTextView.text] &&
        [self.passTextView.text isEqualToString:self.rePassTextView.text]) {
        
        [self.verifyButton setEnabled:YES];
        return YES;
    }else{
        [self.verifyButton setEnabled:NO];
        return NO;
    }
}


/////////////////////////////////////////////////////////
#pragma mark - uitextfield delegate
/////////////////////////////////////////////////////////

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    if (textField.tag == INVITE_TAG || textField.tag == MY_TAG) {
        if (![DataTrans isValidateMobile:textField.text]) {
            [textField.layer setBorderColor:REDCOLOR.CGColor];
            [DataTrans showWariningTitle:T(@"手机号格式有误") andCheatsheet:ICON_TIMES andDuration:1.0f];
        }else{
            [textField.layer setBorderColor:GRAYEXLIGHTCOLOR.CGColor];
        }
    }
    else if (textField.tag == CODE_TAG) {
        if ([DataTrans isValidateMobile:self.myTextView.text] && StringHasValue(self.codeTextView.text)) {
            [self checkCodeAction];
        }
    }
    else if (textField.tag == PASSWORD_TAG || textField.tag == REPASSWORD_TAG){
        [self checkPasswordAction];
    }
    else{
        [self checkAllTextField];
    }
    
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    self.nowEditing = textField.tag;
    [UIView animateWithDuration:0.5f animations:^{
        [self.loginPanel setY:-IOS7_CONTENT_OFFSET_Y];
    }];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField.tag == INVITE_TAG || textField.tag == MY_TAG) {
        if (![DataTrans isValidateMobile:textField.text]) {
            [textField.layer setBorderColor:REDCOLOR.CGColor];
            [DataTrans showWariningTitle:T(@"手机号格式有误") andCheatsheet:ICON_TIMES andDuration:1.0f];
        }else{
            [textField.layer setBorderColor:GRAYEXLIGHTCOLOR.CGColor];
        }
    }
    else if (textField.tag == CODE_TAG) {
        if ([DataTrans isValidateMobile:self.myTextView.text] && StringHasValue(self.codeTextView.text)) {
            [self checkCodeAction];
        }
    }
    else if (textField.tag == PASSWORD_TAG || textField.tag == REPASSWORD_TAG){
        [self checkPasswordAction];
    }
    else{
        [self checkAllTextField];
    }
    
    return YES;
}


/*
- (void)doneEditAction{
    if (self.nowEditing == INVITE_TAG) {
        if ([DataTrans isValidateMobile:self.inviteTextView.text]) {
            // verify from server
            // 邀请人手机号必须是我站的已注册用户使用的手机号
            [self.inviteTextView resignFirstResponder];
            // next
            [self.myTextView becomeFirstResponder];
        }else{
            [DataTrans showWariningTitle:T(@"手机号有误") andCheatsheet:ICON_TIMES];
        }
    }
    else if (self.nowEditing == MY_TAG) {
        if ([DataTrans isValidateMobile:self.myTextView.text]) {
            // verify from server
            [self.myTextView resignFirstResponder];
            
        }else{
            [DataTrans showWariningTitle:T(@"手机号有误") andCheatsheet:ICON_TIMES];
        }
    }
    else if(self.nowEditing == CODE_TAG){
        [self.codeTextView resignFirstResponder];
    }
    else if(self.nowEditing == PASSWORD_TAG){
        [self.passTextView resignFirstResponder];
    }else{
        
    }
}
*/

/////////////////////////////////////////////////////////
#pragma mark - delegate
/////////////////////////////////////////////////////////


- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.inviteTextView resignFirstResponder];
    [self.myTextView resignFirstResponder];
    [self.codeTextView resignFirstResponder];
    [self.passTextView resignFirstResponder];
    [self.rePassTextView resignFirstResponder];
    
    [UIView animateWithDuration:0.5f animations:^{
        [self.loginPanel setY:0];
    }];
    
    if (self.inviteTextView.text.length == 0) {
        [self.inviteTextView setPlaceholder:T(@"手机号")];
    }
    
    if (self.passTextView.text.length == 0) {
        [self.passTextView setPlaceholder:T(@"密码")];
    }
    
}

- (void)singleTapGestureCaptured:(UITapGestureRecognizer *)gesture
{
    [self.inviteTextView resignFirstResponder];
    [self.myTextView resignFirstResponder];
    [self.codeTextView resignFirstResponder];
    [self.passTextView resignFirstResponder];
    [self.rePassTextView resignFirstResponder];
    
    [UIView animateWithDuration:0.5f animations:^{
        [self.loginPanel setY:0];
    }];
    
//    [self checkAllTextField];
}


- (void)dealloc
{

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
