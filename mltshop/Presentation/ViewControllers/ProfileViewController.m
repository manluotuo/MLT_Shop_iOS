//
//  ProfileViewController.m
//  mltshop
//
//  Created by mactive.meng on 30/11/14.
//  Copyright (c) 2014 manluotuo. All rights reserved.
//

#import "ProfileViewController.h"
#import "RoundedAvatarButton.h"
#import "AppDelegate.h"
#import "KKFlatButton.h"
#import "FAHoverButton.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <LBBlurredImage/UIImageView+LBBlurredImage.h>
#import <NYXImagesKit/NYXImagesKit.h>
#import "AddressListViewController.h"

@interface ProfileViewController ()<UIScrollViewDelegate>

@property(nonatomic, strong)UIView *avatarView;
@property(nonatomic, strong)UIScrollView *scrollView;
@property(nonatomic, strong)UIView *orderView;

@end

#define AVATAR_Y_OFFSET 40.0f
#define LINE_W          0.5f

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initBgView];
    [self initScrollView];
    [self initOrderView];
}


- (void)initBgView
{
    UIImageView *bgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, TOTAL_WIDTH, TOTAL_HEIGHT)];
    UIImage *cropImage = [[UIImage imageNamed:@"Default-568h"] cropToSize:CGSizeMake(TOTAL_WIDTH, TOTAL_HEIGHT) usingMode:NYXCropModeCenter];
    
    [bgView setImageToBlur:cropImage blurRadius:5.0f completionBlock:^{
    }];
    
    [self.view addSubview:bgView];
}


- (void)initScrollView
{
    self.scrollView = [[UIScrollView alloc]initWithFrame:self.view.bounds];
    [self.scrollView setContentSize:CGSizeMake(TOTAL_WIDTH, TOTAL_HEIGHT+100)];
    [self.view addSubview:self.scrollView];
    
    
    self.avatarView = [[UIView alloc]initWithFrame:CGRectMake(H_30, AVATAR_Y_OFFSET, H_260, H_90)];

    // 头像
    RoundedAvatarButton *avatarButton = [[RoundedAvatarButton alloc]initWithFrame:CGRectMake(self.avatarView.width/2-H_90/2, 0, H_90, H_90)];
    
    [avatarButton.avatarImageView sd_setImageWithURL:[NSURL URLWithString:XAppDelegate.me.avatarURL]
                                       placeholderImage:[UIImage imageNamed:@"avatarIronMan"]];
    [avatarButton addTarget:self action:@selector(avatarAction) forControlEvents:UIControlEventTouchUpInside];
    
    [self.avatarView addSubview:avatarButton];

    // 左右按钮
    KKFlatButton *leftButton = [KKFlatButton buttonWithType:UIButtonTypeCustom];
    [leftButton setTitle:T(@"我的收藏") forState:UIControlStateNormal];
    [leftButton setFrame:CGRectMake(0, H_90/2-H_24/2, H_56, H_24)];
    [leftButton addTarget:self action:@selector(collectionAction) forControlEvents:UIControlEventTouchUpInside];
    [leftButton.titleLabel setFont:FONT_12];
    [leftButton setTitleColor:DARKCOLOR forState:UIControlStateNormal];
    [leftButton setBackgroundColor:WHITEALPHACOLOR2];
    [self.avatarView addSubview:leftButton];
    
    KKFlatButton *rightButton = [KKFlatButton buttonWithType:UIButtonTypeCustom];
    [rightButton setTitle:T(@"在线客服") forState:UIControlStateNormal];
    [rightButton setFrame:CGRectMake(self.avatarView.width-H_56, H_90/2-H_24/2, H_56, H_24)];
    [rightButton addTarget:self action:@selector(callcenterAction) forControlEvents:UIControlEventTouchUpInside];
    [rightButton.titleLabel setFont:FONT_12];
    [rightButton setTitleColor:DARKCOLOR forState:UIControlStateNormal];
    [rightButton setBackgroundColor:WHITEALPHACOLOR2];
    [self.avatarView addSubview:rightButton];

    
    [self.scrollView addSubview:self.avatarView];
    self.scrollView.delegate = self;
}

- (void)initOrderView
{
    self.orderView  = [[UIView alloc]initWithFrame:CGRectMake(0, H_160, TOTAL_WIDTH, TOTAL_HEIGHT)];
    [self.orderView setBackgroundColor:WHITECOLOR];
    
    [self.scrollView addSubview:self.orderView];
    
    UILabel *orderLabel = [[UILabel alloc]initWithFrame:CGRectMake(LEFT_PADDING*2, TOP_PADDING*2, H_200, H_20)];
    orderLabel.text  = T(@"我的订单");
    [orderLabel setTextColor:DARKCOLOR];
    
    
    FAHoverButton *buttonA = [[FAHoverButton alloc]initWithFrame:CGRectMake(-LINE_W, H_45, TOTAL_WIDTH/3+LINE_W*2, H_60)];
    [buttonA setIconFont:FONT_16];
    [buttonA setIconString:T(@"待付款")];
    [buttonA setBubbleString:@"3"];
    [buttonA setIconColor:DARKCOLOR];
    [buttonA setBorder];
    
    FAHoverButton *buttonB = [[FAHoverButton alloc]initWithFrame:CGRectMake(TOTAL_WIDTH/3, H_45, TOTAL_WIDTH/3, H_60)];
    [buttonB setIconFont:FONT_16];
    [buttonB setIconString:T(@"待发货")];
//    [buttonB setBubbleString:@"3"];
    [buttonB setIconColor:DARKCOLOR];
    [buttonB setBorder];
    
    
    FAHoverButton *buttonC = [[FAHoverButton alloc]initWithFrame:CGRectMake(TOTAL_WIDTH/3*2-LINE_W, H_45, TOTAL_WIDTH/3+LINE_W*2, H_60)];
    [buttonC setIconFont:FONT_16];
    [buttonC setIconString:T(@"待收货")];
    [buttonC setBubbleString:@"2"];
    [buttonC setIconColor:DARKCOLOR];
    [buttonC setBorder];

    [self.orderView addSubview:orderLabel];
    [self.orderView addSubview:buttonA];
    [self.orderView addSubview:buttonB];
    [self.orderView addSubview:buttonC];
    
    
    KKFlatButton *buttonBigA = [KKFlatButton buttonWithType:UIButtonTypeCustom];
    [buttonBigA setTitle:T(@"历史订单") forState:UIControlStateNormal];
    [buttonBigA setFrame:CGRectMake(H_40, H_140, H_240, H_50)];
    [buttonBigA.titleLabel setFont:FONT_14];
    [buttonBigA setTitleColor:DARKCOLOR forState:UIControlStateNormal];
    [buttonBigA setBackgroundColor:GREENLIGHTCOLOR2];
    [buttonBigA addTarget:self action:@selector(historyOrderAction) forControlEvents:UIControlEventTouchUpInside];
    
    KKFlatButton *buttonBigB = [KKFlatButton buttonWithType:UIButtonTypeCustom];
    [buttonBigB setTitle:T(@"地址管理") forState:UIControlStateNormal];
    [buttonBigB setFrame:CGRectMake(H_40, H_140+H_60, H_240, H_50)];
    [buttonBigB.titleLabel setFont:FONT_14];
    [buttonBigB setTitleColor:DARKCOLOR forState:UIControlStateNormal];
    [buttonBigB setBackgroundColor:GREENLIGHTCOLOR2];
    [buttonBigB addTarget:self action:@selector(addressAction) forControlEvents:UIControlEventTouchUpInside];
    
    KKFlatButton *buttonBigC = [KKFlatButton buttonWithType:UIButtonTypeCustom];
    [buttonBigC setTitle:T(@"我的收藏") forState:UIControlStateNormal];
    [buttonBigC setFrame:CGRectMake(H_40, H_140+H_60*2, H_240, H_50)];
    [buttonBigC.titleLabel setFont:FONT_14];
    [buttonBigC setTitleColor:DARKCOLOR forState:UIControlStateNormal];
    [buttonBigC setBackgroundColor:GREENLIGHTCOLOR2];
    [buttonBigC addTarget:self action:@selector(collectionAction) forControlEvents:UIControlEventTouchUpInside];

    
    [self.orderView addSubview:buttonBigA];
    [self.orderView addSubview:buttonBigB];
    [self.orderView addSubview:buttonBigC];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSLog(@"scrollView %.2f",scrollView.contentOffset.y);
    self.avatarView.y = AVATAR_Y_OFFSET + scrollView.contentOffset.y/2;
}

- (void)avatarAction
{
    NSLog(@"avatarAction");
}

- (void)addressAction
{
    AddressListViewController *VC = [[AddressListViewController alloc]init];
    ColorNavigationController *nav = [[ColorNavigationController alloc]initWithRootViewController:VC];
    [self presentViewController:nav animated:YES completion:nil];
}

- (void)collectionAction
{
    
}

- (void)callcenterAction
{
    
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
