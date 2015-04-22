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

@interface PostViewController ()<UITextViewDelegate, FaceIconDelegate>

@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) UILabel *placeText;
@property (nonatomic, strong) UIView *btnView;
@property (nonatomic, strong) UIButton *selectPhoto;
@property (nonatomic, strong) UIButton *faceKey;
@property (nonatomic, strong) NSString *textString;

@end

@implementation PostViewController {
    NSInteger keyBoardHeight;
    FaceIconView *view;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = T(@"发帖");
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
    
    self.textView = [[UITextView alloc] initWithFrame:CGRectMake(H_0, H_0, WIDTH, TOTAL_HEIGHT-H_40)];
    self.textView.delegate = self;
    [self.textView setFont:FONT_16];
    [self.textView setBackgroundColor:GREENCOLOR];
    [self.view addSubview:self.textView];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.textView.y = IOS7_CONTENT_OFFSET_Y;
    self.textView.height = TOTAL_HEIGHT - IOS7_CONTENT_OFFSET_Y - H_40;
    
    self.btnView = [[UIView alloc] initWithFrame:CGRectMake(H_0, TOTAL_HEIGHT-H_40, WIDTH, H_40)];
    [self.btnView setBackgroundColor:REDCOLOR];
    [self.view addSubview:self.btnView];
    
    self.faceKey = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.faceKey setFrame:CGRectMake(H_20, H_10, H_40, H_20)];
    [self.faceKey setTitle:@"表情" forState:UIControlStateNormal];
    [self.faceKey addTarget:self action:@selector(onFaceIconClick) forControlEvents:UIControlEventTouchUpInside];
    [self.btnView addSubview:self.faceKey];
    
    
    self.selectPhoto = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.selectPhoto setFrame:CGRectMake(H_80, H_10, H_40, H_20)];
    [self.selectPhoto setTitle:@"照片" forState:UIControlStateNormal];
    [self.selectPhoto addTarget:self action:@selector(onSelectPhotoClick) forControlEvents:UIControlEventTouchUpInside];
    [self.selectPhoto setBackgroundColor:BlACKALPHACOLOR];
    [self.btnView addSubview:self.selectPhoto];
    
}

- (void)createRightBarButton {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:CGRectMake(0, 0, 50, 50)];
    [button setTitle:@"发帖" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(onRightBarBtnClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = rightBtn;
}

- (void)postData {

    NSString *postUrl = @"http://192.168.1.199/home/post/add";
    NSDictionary *postDict = @{@"userid": @"2032",
                               @"context": self.textView.text};
//    NSData *imageData = UIImageJPEGRepresentation(mediaInfo.circularEditedImage, 0.0);
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:postUrl parameters:postDict constructingBodyWithBlock:^(id formData) {
        for (NSInteger i = 1; i < 10; i++) {
//            [formData appendPartWithFileData:nil name:[NSString stringWithFormat:@"file[%d]", i] fileName:[NSString stringWithFormat:@"file[%d].jpg", i] mimeType:@"image/jpeg"];
        }
    }];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"%@", responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [DataTrans showWariningTitle:T(@"发帖失败") andCheatsheet:ICON_TIMES andDuration:1.0f];
        NSLog(@"fail :%@",error);
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
    self.faceKey.userInteractionEnabled = YES;
    self.selectPhoto.userInteractionEnabled = YES;
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    keyBoardHeight= keyboardRect.size.height;
    self.btnView.y = TOTAL_HEIGHT-keyBoardHeight-self.btnView.height;
    self.textView.height = TOTAL_HEIGHT-H_40 - keyBoardHeight;
}

//当键退出时调用
- (void)keyboardWillHide:(NSNotification *)aNotification {
    
    self.btnView.y = TOTAL_HEIGHT-H_40;
    self.textView.height = TOTAL_HEIGHT-H_40;
    
}

/** 选择图片 */
- (void)onSelectPhotoClick {
    if (view != nil) {
        [view removeFromSuperview];
        view = nil;
    }
        self.faceKey.userInteractionEnabled = YES;
    [self.textView resignFirstResponder];
    self.selectPhoto.userInteractionEnabled = NO;
    self.textView.height = self.textView.height - H_50;
    
}

/** 表情 */
- (void)onFaceIconClick {
    self.faceKey.userInteractionEnabled = NO;
    self.selectPhoto.userInteractionEnabled = YES;
    [self.textView resignFirstResponder];
    if (view == nil) {
    view = [[FaceIconView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-H_160, self.view.frame.size.width, H_160)];
    }
    view.delegate = self;
    [view initView];
    [self.view addSubview:view];
    self.btnView.y = TOTAL_HEIGHT-view.height-self.btnView.height;
    self.textView.height = TOTAL_HEIGHT-H_40 - view.height-self.btnView.height;
}

/** 发帖 */
- (void)onRightBarBtnClick {
    [self postData];
}


#pragma mark facialView delegate 点击表情键盘上的文字
-(void)selectedFacialView:(NSString*)str {
    NSLog(@"%@", str);
    if ([str isEqualToString:@"delete"]) {
        if (self.textView.text.length>0) {
            if ([[Emoji allEmoji] containsObject:[self.textView.text substringFromIndex:self.textView.text.length-2]]) {
                self.textView.text = [self.textView.text substringToIndex:self.textView.text.length-2];
            } else {
                self.textView.text = [self.textView.text substringToIndex:self.textView.text.length-1];
            }
        }
    } else {
        self.textView.text = [NSString stringWithFormat:@"%@%@", self.textView.text, [str emojizedString]];
        NSLog(@"%@", self.textView.text);
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}


@end
