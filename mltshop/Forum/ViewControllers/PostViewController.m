//
//  PostViewController.m
//  mltshop
//
//  Created by 小新 on 15/4/21.
//  Copyright (c) 2015年 manluotuo. All rights reserved.
//

#import "PostViewController.h"
#import <AFNetworking/AFNetworking.h>
#import "FSMediaPicker.h"
#import "ZLPhoto.h"
#import "NSString+Emojize.h"
#import "FaceIconView.h"
#import "Emoji.h"
#import "ZLPhotoAssets.h"
#import "PhotoScrollView.h"

@interface PostViewController ()<UITextViewDelegate, FaceIconDelegate, PassValueDelegate>

@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) UILabel *placeText;
@property (nonatomic, strong) UIView *btnView;
@property (nonatomic, strong) UIButton *selectPhoto;
@property (nonatomic, strong) UIButton *faceKey;
@property (nonatomic, strong) NSString *textString;
@property (nonatomic, strong) NSMutableArray *assets;
@property (nonatomic, strong) UIScrollView *scrollView;

@end

@implementation PostViewController {
    NSInteger keyBoardHeight;
    FaceIconView *view;
    UIButton *button;
    PhotoScrollView *photoScrollView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = T(@"发帖");
    self.textString = @"";
    [self.view setBackgroundColor:MY_WHITE];
    self.assets = [[NSMutableArray alloc] init];
    self.navigationController.navigationBarHidden = NO;
    [self.view setBackgroundColor:WHITECOLOR];
    [self createUI];
    [self createRightBarButton];
    
    //增加监听，当键盘出现或改变时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    //增加监听，当键退出时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
}

- (void)createUI {
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(H_0, H_0, WIDTH, TOTAL_HEIGHT-H_40)];
    self.scrollView.delegate = self;
    self.scrollView.contentSize = CGSizeMake(WIDTH, TOTAL_HEIGHT-39);
    [self.scrollView setBackgroundColor:MY_WHITE];
    [self.view addSubview:self.scrollView];
    
    self.textView = [[UITextView alloc] initWithFrame:CGRectMake(H_0, H_0, WIDTH, TOTAL_HEIGHT-H_40)];
    self.textView.delegate = self;
    [self.textView setFont:FONT_16];
    [self.textView setDelegate:self];
    [self.scrollView addSubview:self.textView];
    self.textView.textColor = BlACKCOLOR;
    self.textView.backgroundColor = MY_WHITE;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.textView.y = IOS7_CONTENT_OFFSET_Y;
    self.textView.height = TOTAL_HEIGHT - IOS7_CONTENT_OFFSET_Y - H_40;
    
    self.placeText = [[UILabel alloc] initWithFrame:CGRectMake(5, 8, WIDTH, 16)];
    self.placeText.text = @"@说点什么吧~~~";
    [self.placeText setTextColor:GRAYLIGHTCOLOR];
    [self.textView addSubview:self.placeText];
    
    self.btnView = [[UIView alloc] initWithFrame:CGRectMake(H_0, TOTAL_HEIGHT-H_40, WIDTH, H_40)];
    [self.btnView setBackgroundColor:MY_WHITE];
    [self.view addSubview:self.btnView];
    
    self.faceKey = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.faceKey setFrame:CGRectMake(H_10, H_0, H_30, H_30)];
    [self.faceKey setImage:[UIImage imageNamed:@"expression_n"] forState:UIControlStateNormal];
    [self.faceKey setImage:[UIImage imageNamed:@"expression_s"] forState:UIControlStateSelected];
    [self.faceKey setSelected:NO];
    [self.faceKey addTarget:self action:@selector(onFaceIconClick) forControlEvents:UIControlEventTouchUpInside];
    [self.btnView addSubview:self.faceKey];
    
    
    self.selectPhoto = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.selectPhoto setFrame:CGRectMake(H_50, H_0, H_30, H_30)];
    [self.selectPhoto setImage:[UIImage imageNamed:@"add_pic_n"] forState:UIControlStateNormal];
    [self.selectPhoto setImage:[UIImage imageNamed:@"add_pic_s"] forState:UIControlStateSelected];
    [self.selectPhoto setSelected:NO];
    [self.selectPhoto addTarget:self action:@selector(onSelectPhotoClick) forControlEvents:UIControlEventTouchUpInside];
    [self.btnView addSubview:self.selectPhoto];
    
}

- (void)createRightBarButton {
    button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:CGRectMake(0, 0, 50, 50)];
    [button setTitle:@"发帖" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(onRightBarBtnClick) forControlEvents:UIControlEventTouchUpInside];
    button.userInteractionEnabled = NO;
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = rightBtn;
}

- (void)postData {
    
    HTProgressHUD *HUD = [[HTProgressHUD alloc] init];
    HUD.indicatorView = [HTProgressHUDIndicatorView indicatorViewWithType:HTProgressHUDIndicatorTypeActivityIndicator];
    HUD.text = T(@"正在发送...请稍等");
    [HUD showInView:self.view];
    NSString *postUrl = @"http://sj.manluotuo.com/home/post/add";
    NSDictionary *postDict = @{@"userid": [[NSUserDefaults standardUserDefaults] valueForKey:@"userid"],
                               @"context": self.textView.text};
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:postUrl parameters:postDict constructingBodyWithBlock:^(id formData) {
        for (NSInteger i = 0; i < [self.assets count]; i++) {
            [formData appendPartWithFileData:UIImageJPEGRepresentation([self.assets[i] originImage], 1.0) name:[NSString stringWithFormat:@"file[%d]", i] fileName:[NSString stringWithFormat:@"file[%d].jpg", i] mimeType:@"image/jpeg"];
        }
    }];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        [HUD removeFromSuperview];
        [DataTrans showWariningTitle:T(@"发帖成功") andCheatsheet:ICON_INFO andDuration:1.0f];
        int64_t delayInSeconds = 1.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [self.navigationController popViewControllerAnimated:YES];
        });
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [HUD removeFromSuperview];
        [DataTrans showWariningTitle:T(@"发帖失败") andCheatsheet:ICON_TIMES andDuration:1.0f];
    }];
    
    [operation start];
}

//当键盘出现或改变时调用
- (void)keyboardWillShow:(NSNotification *)aNotification {
    //获取键盘的高度
    if (view != nil) {
        [view removeFromSuperview];
        view = nil;
    }
    [self.placeText setHidden:YES];
    self.faceKey.selected = NO;
    self.selectPhoto.selected = NO;
    self.faceKey.userInteractionEnabled = YES;
    self.selectPhoto.userInteractionEnabled = YES;
    [photoScrollView removeFromSuperview];
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    keyBoardHeight= keyboardRect.size.height;
    self.btnView.y = TOTAL_HEIGHT-keyBoardHeight-self.btnView.height;
    self.textView.height = TOTAL_HEIGHT-H_40 - keyBoardHeight;
}

//当键退出时调用
- (void)keyboardWillHide:(NSNotification *)aNotification {
    
    if (self.textView.text.length == 0) {
        [self.placeText setHidden:NO];
    }
    self.btnView.y = TOTAL_HEIGHT-H_40;
    self.textView.height = TOTAL_HEIGHT-H_40;
    
}

/** 选择图片 */
- (void)onSelectPhotoClick {
    if (view != nil) {
        [view removeFromSuperview];
        view = nil;
    }
    
    self.faceKey.selected = NO;
    self.selectPhoto.selected = YES;
    self.faceKey.userInteractionEnabled = YES;
    [self.textView resignFirstResponder];
    self.selectPhoto.userInteractionEnabled = NO;
    photoScrollView = [[PhotoScrollView alloc] initWithFrame:CGRectMake(0, TOTAL_HEIGHT-160, WIDTH, 160)];
    [photoScrollView initData:self.assets];
    photoScrollView.passDelegate = self;
    photoScrollView.userInteractionEnabled = YES;
    [self.view addSubview:photoScrollView];
    [UIView animateWithDuration:0.3 animations:^{
        self.btnView.y = TOTAL_HEIGHT - H_160 - self.btnView.height;
        self.textView.height = TOTAL_HEIGHT - H_160 - self.btnView.height - H_40;
    }];
}

- (void)passSignalValue:(NSString *)value andData:(id)data {
    if ([value isEqualToString:ON_ADD_BTN]) {
        [photoScrollView removeFromSuperview];
            ZLPhotoPickerViewController *pickerVc = [[ZLPhotoPickerViewController alloc] init];
            pickerVc.minCount = 9;
            pickerVc.status = PickerViewShowStatusCameraRoll;
            pickerVc.callBack = ^(NSArray *status){
                [self.assets removeAllObjects];
                [self.assets addObjectsFromArray:status];
                photoScrollView = [[PhotoScrollView alloc] initWithFrame:CGRectMake(0, TOTAL_HEIGHT-160, WIDTH, 160)];
                NSLog(@"%d", self.assets.count);
                [photoScrollView initData:self.assets];
                photoScrollView.passDelegate = self;
                photoScrollView.userInteractionEnabled = YES;
                [self.view addSubview:photoScrollView];
                self.selectPhoto.userInteractionEnabled = YES;
            };
        [pickerVc show];
    }
    /** 删除图片 */
    if ([value isEqualToString:ON_DELETE_BTN]) {
        
    }
}

/** 表情 */
- (void)onFaceIconClick {
    [photoScrollView removeFromSuperview];
    self.faceKey.userInteractionEnabled = NO;
    self.selectPhoto.userInteractionEnabled = YES;
    self.faceKey.selected = !self.faceKey.selected;
    self.selectPhoto.selected = NO;
    [self.textView resignFirstResponder];
    if (view == nil) {
        view = [[FaceIconView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-H_160, self.view.frame.size.width, H_160)];
    }
    view.alpha = 0;
    view.delegate = self;
    [view initView];
    [self.view addSubview:view];
    
    [UIView animateWithDuration:0.3 animations:^{
        view.alpha = 1;
        self.btnView.y = TOTAL_HEIGHT-view.height-self.btnView.height;
        self.textView.height = TOTAL_HEIGHT-H_40 - view.height-self.btnView.height;
    }];
}

/** 发帖 */
- (void)onRightBarBtnClick {
    [self postData];
}

- (BOOL)textView:(UITextView *)atextView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    NSString * aString = [self.textView.text stringByReplacingCharactersInRange:range withString:text];
    if (self.textView == atextView)
    {
        if ([aString length] > 256) {
            self.textView.text = [aString substringToIndex:256];
            [DataTrans showWariningTitle:T(@"发帖字数不能超过256个") andCheatsheet:nil andDuration:1.0f];
            [self.textView resignFirstResponder];
            return NO;
        }
    }
    return YES;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.textView resignFirstResponder];
}

#pragma mark facialView delegate 点击表情键盘上的文字
-(void)selectedFacialView:(NSString*)str {
    if ([str isEqualToString:@"delete"]) {
        if (self.textView.text.length>0) {
            NSRange range = NSMakeRange(self.textView.text.length-1, 1);
            NSString *str = [self.textView.text substringWithRange:range];
            if ([str isEqualToString:@"]"]) {
                self.textView.text = [self.textView.text substringToIndex:self.textView.text.length-4];
            } else {
                self.textView.text = [self.textView.text substringToIndex:self.textView.text.length-1];
            }
        }
    } else {
        button.userInteractionEnabled = YES;
        [self.placeText setHidden:YES];
        self.textView.text = [NSString stringWithFormat:@"%@%@", self.textView.text, str];
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    [self.textView resignFirstResponder];
    [view removeFromSuperview];
    self.faceKey.userInteractionEnabled = YES;
    self.selectPhoto.userInteractionEnabled = YES;
    [UIView animateWithDuration:0.3 animations:^{
        self.btnView.y = TOTAL_HEIGHT-H_40;
        self.textView.height = TOTAL_HEIGHT-H_40;
    }];
    
}

- (void)textViewDidChange:(UITextView *)textView {
    if (textView.text.length > 0) {
        [self.placeText setHidden:YES];
        button.selected = YES;
        button.userInteractionEnabled = YES;
    } else {
        [self.placeText setHidden:NO];
        button.selected = NO;
        button.userInteractionEnabled = NO;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (void)viewWillAppear:(BOOL)animated {
    self.btnView.y = TOTAL_HEIGHT-H_40;
    self.textView.height = TOTAL_HEIGHT-H_40;
}

@end
