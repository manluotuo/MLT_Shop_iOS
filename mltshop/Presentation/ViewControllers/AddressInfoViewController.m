//
//  AddressInfoViewController.m
//  mltshop
//
//  Created by mactive.meng on 21/12/14.
//  Copyright (c) 2014 manluotuo. All rights reserved.
//

#import "AddressInfoViewController.h"
#import "AppRequestManager.h"
#import "KKFlatButton.h"
#import "KKTextField.h"
#import <BlocksKit/BlocksKit+UIKit.h>
#import "AreaPickerViewController.h"
#import "AppDelegate.h"
#import "Me.h"

@interface AddressInfoViewController ()<UITextFieldDelegate, UIScrollViewDelegate, PassValueDelegate>
{
    AddressModel *theAddress;
}

@property(nonatomic, strong) UIScrollView *loginPanel;
@property(nonatomic, strong) KKTextField *consigneeTextView;
@property(nonatomic, strong) KKTextField *telTextView;
@property(nonatomic, strong) KKTextField *emailTextView;
@property(nonatomic, strong) KKTextField *zipcodeTextView;
@property(nonatomic, strong) KKTextField *locationTextView;
@property(nonatomic, strong) KKTextField *addressTextView;

@property(nonatomic, strong) KKFlatButton *saveButton;
@property(nonatomic, strong) KKFlatButton *defaultButton;
@property(nonatomic, strong) KKFlatButton *deleteButton;

@end

@implementation AddressInfoViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = T(@"收货地址");
        [self initView];
        [self initButton];

    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupRightAddButton];
}

- (void)passSignalValue:(NSString *)value andData:(id)data
{
    AddressModel *theModel = (AddressModel *)data;
    NSString * dataString =
    [NSString stringWithFormat:@"%@ %@ %@", theModel.provinceName, theModel.cityName, theModel.districtName];
    self.locationTextView.text = dataString;
    
    // reset theAddress
    theAddress.provinceCode = theModel.provinceCode;
    theAddress.provinceName = theModel.provinceName;
    theAddress.cityCode = theModel.cityCode;
    theAddress.cityName = theModel.cityName;
    theAddress.districtCode = theModel.districtCode;
    theAddress.districtName = theModel.districtName;
    
}

- (void)transTextViewToAddress
{
    theAddress.consignee = self.consigneeTextView.text;
    theAddress.address = self.addressTextView.text;
    theAddress.tel = self.telTextView.text;
    theAddress.email = self.emailTextView.text;
    theAddress.zipcode = self.zipcodeTextView.text;
}

- (void)setNewData:(AddressModel *)address;
{
    theAddress = address;
    theAddress.email = XAppDelegate.me.email;
    
    self.consigneeTextView.text =theAddress.consignee;
    self.telTextView.text = theAddress.tel;
    self.emailTextView.text = theAddress.email;
    self.addressTextView.text = theAddress.address;
    self.zipcodeTextView.text = theAddress.zipcode;
    if (StringHasValue(theAddress.provinceCode) &&
        StringHasValue(theAddress.cityCode) &&
        StringHasValue(theAddress.districtCode)) {
        self.locationTextView.text = [NSString stringWithFormat:@"%@ %@ %@",  theAddress.provinceName,
                                      theAddress.cityName,  theAddress.districtName];

    }
    
    
    
    
    [self.saveButton setEnabled:NO];
    [self.defaultButton setEnabled:NO];
    [self.deleteButton setEnabled:NO];

    if (StringHasValue(theAddress.consignee) &&
        StringHasValue(theAddress.tel) &&
        StringHasValue(theAddress.email) &&
        StringHasValue(theAddress.address) &&
        StringHasValue(theAddress.provinceCode) &&
        StringHasValue(theAddress.cityCode) &&
        StringHasValue(theAddress.districtCode)
        ) {
        [self.saveButton setEnabled:YES];
        [self.defaultButton setEnabled:YES];
        [self.deleteButton setEnabled:YES];
    }
    
}

- (BOOL)verifyAddress
{
    if (StringHasValue(self.consigneeTextView.text) &&
        StringHasValue(self.telTextView.text) &&
        StringHasValue(self.emailTextView.text) &&
        StringHasValue(self.addressTextView.text) &&
        StringHasValue(self.locationTextView.text) &&
        StringHasValue(theAddress.provinceCode) &&
        StringHasValue(theAddress.cityCode) &&
        StringHasValue(theAddress.districtCode)
        ) {
        [self transTextViewToAddress];
        return YES;
    }else{
        return NO;
    }
}

-(void)saveAction
{
    if ([self verifyAddress]) {
        if (StringHasValue(theAddress.addressId)) {
            [[AppRequestManager sharedManager]operateAddressWithAddress:theAddress operation:AddressOpsUpdate andBlock:^(id responseObject, NSError *error) {
                [DataTrans showWariningTitle:T(@"更新成功") andCheatsheet:ICON_CHECK];
                [self.navigationController popViewControllerAnimated:YES];
                [self.passDelegate passSignalValue:SIGNAL_ADDRESS_OPERATE_DONE andData:nil];

            }];
        }else{
            [[AppRequestManager sharedManager]operateAddressWithAddress:theAddress operation:AddressOpsCreate andBlock:^(id responseObject, NSError *error) {
                [DataTrans showWariningTitle:T(@"新建成功") andCheatsheet:ICON_CHECK];
                [self.navigationController popViewControllerAnimated:YES];
                [self.passDelegate passSignalValue:SIGNAL_ADDRESS_OPERATE_DONE andData:nil];

            }];

        }
    }
}

- (void)deleteAction
{
    if (StringHasValue(theAddress.addressId) ) {
        NSString *message = [NSString stringWithFormat:@"删除%@",theAddress.consignee];
        
        [UIAlertView bk_showAlertViewWithTitle:T(@"确认删除") message:message cancelButtonTitle:T(@"取消") otherButtonTitles:@[T(@"确定")] handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
            if (buttonIndex == 1) {
                [[AppRequestManager sharedManager]operateAddressWithAddress:theAddress operation:AddressOpsDelete andBlock:^(id responseObject, NSError *error) {
                    [DataTrans showWariningTitle:T(@"删除成功") andCheatsheet:ICON_CHECK];
                    [self.navigationController popViewControllerAnimated:YES];
                    [self.passDelegate passSignalValue:SIGNAL_ADDRESS_OPERATE_DONE andData:nil];
                }];
            }
        }];
    }
}

-(void)defaultAction
{
    if ([self verifyAddress]) {
        [[AppRequestManager sharedManager]operateAddressWithAddress:theAddress operation:AddressOpsDefault andBlock:^(id responseObject, NSError *error) {
            [DataTrans showWariningTitle:T(@"默认收货地址设置成功") andCheatsheet:ICON_CHECK];
            [self.navigationController popViewControllerAnimated:YES];
            [self.passDelegate passSignalValue:SIGNAL_ADDRESS_OPERATE_DONE andData:nil];

        }];
    }
}

#define OFFSET_Y            H_30
#define INVITE_TAG          101
#define CONSIGNEE_TAG       102
#define TEL_TAG             103
#define EMAIL_TAG           104
#define ZIPCODE_TAG         105
#define LOCATION_TAG        106
#define ADDRESS_TAG         107
#define TEXT_INDENT         20.0f

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField.tag == ZIPCODE_TAG || textField.tag == ADDRESS_TAG) {
        [UIView animateWithDuration:0.5f animations:^{
            [self.loginPanel setY:-IOS7_CONTENT_OFFSET_Y];
        }];
    }else if(textField.tag == LOCATION_TAG){
        AreaPickerViewController *viewController = [[AreaPickerViewController alloc]initWithNibName:nil bundle:nil];
        viewController.passDelegate = self;
        ColorNavigationController *popNavController = [[ColorNavigationController alloc]initWithRootViewController:viewController];
        
        [self.navigationController presentViewController:popNavController animated:YES completion:^{}];
    }
}





- (void)initView
{
    // consigneeTextView
    self.consigneeTextView = [[KKTextField alloc]initWithFrame:CGRectMake(LEFT_PADDING*2, OFFSET_Y,TOTAL_WIDTH-LEFT_PADDING*4, H_50)];
    self.consigneeTextView.delegate = self;
    [self.consigneeTextView setPlaceholder:T(@"收件人")];
    self.consigneeTextView.keyboardType = UIKeyboardTypeDefault;
    self.consigneeTextView.returnKeyType = UIReturnKeyNext;
    self.consigneeTextView.tag = CONSIGNEE_TAG;
    
    // telTextView
    self.telTextView = [[KKTextField alloc]initWithFrame:CGRectMake(LEFT_PADDING*2, OFFSET_Y+H_50*1, TOTAL_WIDTH-LEFT_PADDING*4 , H_50)];
    self.telTextView.delegate = self;
    [self.telTextView setPlaceholder:T(@"手机")];
    self.telTextView.keyboardType = UIKeyboardTypePhonePad;
    self.telTextView.returnKeyType = UIReturnKeyNext;
    self.telTextView.tag = TEL_TAG;
    
    // emailTextView
    self.emailTextView = [[KKTextField alloc]initWithFrame:CGRectMake(LEFT_PADDING*2, OFFSET_Y+H_50*2, TOTAL_WIDTH-LEFT_PADDING*4 , H_50)];
    self.emailTextView.delegate = self;
    [self.emailTextView setPlaceholder:T(@"邮箱")];
    self.emailTextView.returnKeyType = UIReturnKeyNext;
    self.emailTextView.tag = EMAIL_TAG;
    
    // emailTextView
    self.locationTextView = [[KKTextField alloc]initWithFrame:CGRectMake(LEFT_PADDING*2, OFFSET_Y+H_50*3, TOTAL_WIDTH-LEFT_PADDING*4 , H_50)];
    self.locationTextView.delegate = self;
    [self.locationTextView setPlaceholder:T(@"所在地区")];
    self.locationTextView.returnKeyType = UIReturnKeyNext;
    self.locationTextView.tag = LOCATION_TAG;
    
    // emailTextView
    self.addressTextView = [[KKTextField alloc]initWithFrame:CGRectMake(LEFT_PADDING*2, OFFSET_Y+H_50*4, TOTAL_WIDTH-LEFT_PADDING*4 , H_50)];
    self.addressTextView.delegate = self;
    [self.addressTextView setPlaceholder:T(@"详细地址")];
    self.addressTextView.returnKeyType = UIReturnKeyDone;
    self.addressTextView.tag = ADDRESS_TAG;
    
    // zipcodeTextView
    self.zipcodeTextView = [[KKTextField alloc]initWithFrame:CGRectMake(LEFT_PADDING*2, OFFSET_Y+H_50*5, TOTAL_WIDTH-LEFT_PADDING*4 , H_50)];
    self.zipcodeTextView.delegate = self;
    [self.zipcodeTextView setPlaceholder:T(@"邮编")];
    self.zipcodeTextView.returnKeyType = UIReturnKeyNext;
    self.zipcodeTextView.tag = ZIPCODE_TAG;
    
    
    self.consigneeTextView.textIndent = TEXT_INDENT;
    self.telTextView.textIndent = TEXT_INDENT;
    self.emailTextView.textIndent = TEXT_INDENT;
    self.zipcodeTextView.textIndent = TEXT_INDENT;
    self.locationTextView.textIndent = TEXT_INDENT;
    self.addressTextView.textIndent = TEXT_INDENT;

    
    // change corner
    self.consigneeTextView = (KKTextField *)[DataTrans roundCornersOnView:self.consigneeTextView onTopLeft:YES topRight:YES bottomLeft:NO bottomRight:NO radius:10.0f];
    self.telTextView = (KKTextField *)[DataTrans roundCornersOnView:self.telTextView onTopLeft:YES topRight:YES bottomLeft:YES bottomRight:YES radius:0.0f];
    self.emailTextView = (KKTextField *)[DataTrans roundCornersOnView:self.emailTextView onTopLeft:YES topRight:YES bottomLeft:YES bottomRight:YES radius:0.0f];
    self.locationTextView = (KKTextField *)[DataTrans roundCornersOnView:self.locationTextView onTopLeft:YES topRight:YES bottomLeft:YES bottomRight:YES radius:0.0f];
    self.addressTextView = (KKTextField *)[DataTrans roundCornersOnView:self.addressTextView onTopLeft:YES topRight:YES bottomLeft:YES bottomRight:YES radius:0.0f];
    self.zipcodeTextView = (KKTextField *)[DataTrans roundCornersOnView:self.zipcodeTextView onTopLeft:NO topRight:NO bottomLeft:YES bottomRight:YES radius:10.0f];

    self.loginPanel = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, TOTAL_WIDTH, TOTAL_HEIGHT)];
    [self.loginPanel setContentSize:CGSizeMake(TOTAL_WIDTH, TOTAL_HEIGHT)];
    self.loginPanel.delegate = self;
    
    [self.loginPanel addSubview:self.consigneeTextView];
    [self.loginPanel addSubview:self.telTextView];
    [self.loginPanel addSubview:self.emailTextView];
    [self.loginPanel addSubview:self.zipcodeTextView];
    [self.loginPanel addSubview:self.locationTextView];
    [self.loginPanel addSubview:self.addressTextView];
    
    [self.view addSubview:self.loginPanel];
}

- (void)initButton
{
    // verifyButton
    self.saveButton = [KKFlatButton buttonWithType:UIButtonTypeCustom];
    [self.saveButton setTitle:T(@"保存地址") forState:UIControlStateNormal];
    [self.saveButton setFrame:CGRectMake(LEFT_PADDING*2, OFFSET_Y+H_50*6+TOP_PADDING*2, TOTAL_WIDTH-LEFT_PADDING*4 , H_40)];
    [self.saveButton addTarget:self action:@selector(saveAction) forControlEvents:UIControlEventTouchUpInside];
    [self.saveButton setTitleColor:GREENCOLOR andStyle:KKFlatButtonStyleLight];
    
    // verifyButton
    self.defaultButton = [KKFlatButton buttonWithType:UIButtonTypeCustom];
    [self.defaultButton setTitle:T(@"设为默认") forState:UIControlStateNormal];
    [self.defaultButton setFrame:CGRectMake(LEFT_PADDING*2, OFFSET_Y+H_50*7+TOP_PADDING*2, TOTAL_WIDTH/2-LEFT_PADDING*4 , H_40)];
    [self.defaultButton addTarget:self action:@selector(defaultAction) forControlEvents:UIControlEventTouchUpInside];
    [self.defaultButton setTitleColor:ORANGE_DARK_COLOR andStyle:KKFlatButtonStyleLight];
    
    // verifyButton
    self.deleteButton = [KKFlatButton buttonWithType:UIButtonTypeCustom];
    [self.deleteButton setTitle:T(@"删除地址") forState:UIControlStateNormal];
    [self.deleteButton setFrame:CGRectMake(LEFT_PADDING*2+TOTAL_WIDTH/2, OFFSET_Y+H_50*7+TOP_PADDING*2, TOTAL_WIDTH/2-LEFT_PADDING*4 , H_40)];
    [self.deleteButton addTarget:self action:@selector(deleteAction) forControlEvents:UIControlEventTouchUpInside];
    [self.deleteButton setTitleColor:REDCOLOR andStyle:KKFlatButtonStyleLight];
    
    
    [self.loginPanel addSubview:self.saveButton];
    [self.loginPanel addSubview:self.defaultButton];
    [self.loginPanel addSubview:self.deleteButton];
    
}

- (void)setupRightAddButton
{
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 30)];
    [backButton setTitle:T(@"保存") forState:UIControlStateNormal];
    
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.rightBarButtonItem = leftBarButtonItem;
    [backButton addTarget:self action:@selector(saveAction) forControlEvents:UIControlEventTouchUpInside];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    self.editing = NO;
    [self.consigneeTextView resignFirstResponder];
    [self.telTextView resignFirstResponder];
    [self.emailTextView resignFirstResponder];
    [self.zipcodeTextView resignFirstResponder];
    [self.locationTextView resignFirstResponder];
    [self.addressTextView resignFirstResponder];
    
    [UIView animateWithDuration:0.5f animations:^{
        [self.loginPanel setY:0];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
