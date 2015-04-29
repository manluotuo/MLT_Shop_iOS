//
//  ForumProfileController.m
//  个人中心
//
//  Created by Col on 15/4/26.
//  Copyright (c) 2015年 colin. All rights reserved.
//

#import "ForumProfileController.h"
#import "CExpandHeader.h"
#import "FAHoverButton.h"
#import <AFNetworking/AFNetworking.h>
#import <SDWebImage/UIButton+WebCache.h>
#import "AppDelegate.h"
#import "FSMediaPicker.h"
#import "ModelHelper.h"
#import "KKFlatButton.h"

@interface ForumProfileController ()<UIScrollViewDelegate,FSMediaPickerDelegate>
@property (nonatomic, strong)CExpandHeader *expandView;
@property (nonatomic, strong)UIView *customView;
@property (nonatomic, weak)UIButton *iconView;
@property (nonatomic, strong)UILabel *nameView;
@property (nonatomic, assign)NSInteger dynamicCount;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, copy) NSString *nickName;
@property (nonatomic, copy) NSURL *iconURL;
@property (nonatomic, strong) UIView *FootView;
@property (nonatomic, strong) UIView *naView;
@property (nonatomic, assign)BOOL isMe;
@end

@implementation ForumProfileController

-(void) setUpNavigation{
    self.naView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 64)];
    [self.view addSubview:self.naView];
    CGFloat leftMargin = 10.0f;
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(15, 30, 12+leftMargin, 21)];
    [backButton setTitle:ICON_BACK forState:UIControlStateNormal];
    [backButton.titleLabel setFont:FONT_AWESOME_36];
    
    [backButton setImageEdgeInsets:UIEdgeInsetsMake(0, leftMargin, 0, 0)];
    [self.naView addSubview:backButton];
 
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:CGRectMake(0, 30, 100, 100)];
    [button addTarget:self action:@selector(onLeftBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.naView addSubview:button];
    
    UILabel *titleLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 27, WIDTH, 30)];
    titleLable.textAlignment = UIBaselineAdjustmentAlignCenters;
    
    titleLable.text = self.isMe?@"我的资料":@"用户资料";
    titleLable.textColor = WHITECOLOR;
    [titleLable setFont:FONT_16];
    [self.naView addSubview:titleLable];
}

-(void) onLeftBtnClick{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if ([self.userId isEqualToString:XAppDelegate.me.userId])
        _isMe = YES;
    [self getUserInfo];
    [self setUpScrollView];
    [self setUpCustomView];
    [self setUpFootView];
    [self setUpNavigation];
    
    self.expandView = [CExpandHeader expandWithScrollView:self.scrollView expandView:self.customView];
}

- (void) setUpScrollView{
    self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, TOTAL_HEIGHT + H_20 )];
    [self.scrollView setContentSize:CGSizeMake(TOTAL_WIDTH, TOTAL_HEIGHT-200)];
    self.scrollView.delegate = self;
    self.scrollView.backgroundColor = [UIColor whiteColor];
    [self.scrollView setContentOffset:CGPointMake(0, -20)];
    KKFlatButton *btn = [KKFlatButton buttonWithType:UIButtonTypeCustom];
    [btn setBackgroundColor:WHITECOLOR];
    btn.frame = CGRectMake(1, 10, WIDTH-2, 60);
    
    [self.view addSubview:self.scrollView];
}

-(void) setUpFootView{
    self.FootView  = [[UIView alloc] initWithFrame:self.scrollView.frame];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, H_60, WIDTH, 100)];
    label.text = @"暂时无法展示更多内容";
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = GRAYCOLOR;
    [self.FootView addSubview:label];
    [self.scrollView addSubview:self.FootView];
    
}

-(void) setUpCustomView{
    _customView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, TOTAL_WIDTH, TOTAL_HEIGHT/2 + H_20)];
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:self.customView.frame];
    
    [imageView setImage:[UIImage imageNamed:@"image"]];
    imageView.autoresizingMask = UIViewAutoresizingFlexibleHeight| UIViewAutoresizingFlexibleWidth;
    imageView.clipsToBounds = YES;
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    [_customView addSubview:imageView];
    
}
/**
 *  获取用户信息
 */
- (void)getUserInfo {
    NSString *httpUrl = @"http://sj.manluotuo.com/home/user/info";
    AFHTTPRequestOperationManager *rom=[AFHTTPRequestOperationManager manager];
    rom.responseSerializer.acceptableContentTypes=[NSSet setWithObjects:@"text/json",@"text/html", nil];
    NSDictionary *postDict = @{@"userid": self.userId};
    [rom POST:httpUrl parameters:postDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([responseObject[@"SUCESS"] integerValue] == 1) {
            
            _iconURL = responseObject[@"data"][@"headerimg"];
            _nickName = responseObject[@"data"][@"nickname"];
            [self setUpIconView];
            [self setUpNickName];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
    }];

}

-(void) setUpNickName{
    self.nameView = [[UILabel alloc] init];
    [self.nameView setText:self.nickName];
    [_nameView setFrame:CGRectMake(0, self.iconView.y+self.iconView.height+H_20, WIDTH, 30)];
    CGSize titleSize = [self.nameView.text sizeWithFont:[UIFont systemFontOfSize:18] constrainedToSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    _nameView.width = titleSize.width;
    _nameView.height = titleSize.height;
    _nameView.x = WIDTH/2 - titleSize.width/2;
    _nameView.textAlignment = NSTextAlignmentCenter;
    _nameView.font = [UIFont systemFontOfSize:15];
    _nameView.backgroundColor = NameBackgroundColor;
    _nameView.layer.cornerRadius = 5;
    _nameView.layer.masksToBounds = YES;
    _nameView.textColor = ORANGECOLOR;
    [self.customView addSubview:self.nameView];
}

-(void) setUpIconView{
    _iconView = [UIButton buttonWithType:UIButtonTypeCustom];
    _iconView.frame = CGRectMake(WIDTH/2-50, 100, 100, 100);
    [self.iconView.layer setCornerRadius:_iconView.width/2];
    self.iconView.layer.masksToBounds = YES;
    [_iconView sd_setImageWithURL:self.iconURL forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"logo_luotuo"]];
    [_iconView addTarget:self action:@selector(iconClick) forControlEvents:UIControlEventTouchUpInside];
    _iconView.userInteractionEnabled = self.isMe;
    [self.customView addSubview:self.iconView];
}

-(void)iconClick{
    FSMediaPicker *mediaPicker = [[FSMediaPicker alloc] init];
    mediaPicker.mediaType = FSMediaTypePhoto;
    mediaPicker.editMode = FSEditModeCircular;
    mediaPicker.delegate = self;
    [mediaPicker showFromView:self.iconView];
    return;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    self.iconView.y = -scrollView.contentOffset.y/2 -H_36;
    self.nameView.y =-scrollView.contentOffset.y/2 + self.iconView.width -H_15;
}

-(void)mediaPicker:(FSMediaPicker *)mediaPicker didFinishWithMediaInfo:(NSDictionary *)mediaInfo{
    
    HTProgressHUD *HUD = [[HTProgressHUD alloc] init];
    HUD.indicatorView = [HTProgressHUDIndicatorView indicatorViewWithType:HTProgressHUDIndicatorTypeActivityIndicator];
    HUD.text = T(@"正在上传头像");
    [HUD showInView:self.view];
    
    NSString *postUrl = @"http://sj.manluotuo.com/home/user/changeHeaderPicture";
    NSDictionary *postDict = @{@"userid": XAppDelegate.me.userId};
    NSData *imageData = UIImageJPEGRepresentation(mediaInfo.circularEditedImage, 0.5);
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:postUrl parameters:postDict constructingBodyWithBlock:^(id formData) {
        [formData appendPartWithFileData:imageData name:@"file" fileName:@"file.jpg" mimeType:@"image/jpeg"];
    }];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *httpUrl = @"http://sj.manluotuo.com/home/user/info";
        AFHTTPRequestOperationManager *rom=[AFHTTPRequestOperationManager manager];
        rom.responseSerializer.acceptableContentTypes=[NSSet setWithObjects:@"text/json",@"text/html", nil];
        NSDictionary *postDict = @{@"userid": [DataTrans
                                               noNullStringObj: XAppDelegate.me.userId]};
        [rom POST:httpUrl parameters:postDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [HUD removeFromSuperview];
            if ([responseObject[@"SUCESS"] integerValue] == 1) {
                Me *theMe = [[ModelHelper sharedHelper]findOnlyMe];
                theMe.avatarURL =  responseObject[@"data"][@"headerimg"];
                MRSave();
                XAppDelegate.me = theMe;
                
                [self.iconView setBackgroundImage:mediaInfo.circularEditedImage forState:UIControlStateNormal];
                [self.passDelegate passSignalValue:SIGNAL_AVATAR_UPLOAD_DONE andData:nil];
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [HUD removeFromSuperview];
            NSLog(@"%@",error);
        }];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [HUD removeFromSuperview];
        [DataTrans showWariningTitle:T(@"头像上传失败\n请检查网络设置") andCheatsheet:ICON_TIMES andDuration:1.0f];
        NSLog(@"fail :%@",error);
    }];
    [operation start];
}
@end
