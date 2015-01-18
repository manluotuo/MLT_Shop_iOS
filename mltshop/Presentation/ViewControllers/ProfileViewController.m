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
#import "WebViewController.h"
#import "NSString+FontAwesome.h"
#import "SGActionView.h"
#import "ModelHelper.h"
#import "OrderListViewController.h"
#import "AppRequestManager.h"

@interface ProfileViewController ()<UIScrollViewDelegate>

@property(nonatomic, strong)UIView *avatarView;
@property(nonatomic, strong)UIScrollView *scrollView;
@property(nonatomic, strong)UIView *orderView;
@property(nonatomic, strong)RoundedAvatarButton *avatarButton;

@end

#define AVATAR_Y_OFFSET 40.0f
#define LINE_W          0.5f

#define AWAIT_PAY_TAG       201
#define AWAIT_SHIPPING_TAG  202
#define SHIPPED_TAG         203
#define ALL_ORDER_TAG       204

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initBgView];
    [self initScrollView];
    [self initOrderView];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self refreshCount];
}


- (void)refreshCount
{
    OrderModel *theOrder1 = [[OrderModel alloc]init];
    theOrder1.type = @"await_pay";

    [[AppRequestManager sharedManager]operateOrderWithCartModel:theOrder1 operation:OrderOpsList andBlock:^(id responseObject, NSError *error) {
        if (responseObject != nil) {
            // 集中处理所有的数据
            NSUInteger count = [responseObject count];
            FAHoverButton *button = (FAHoverButton *)[self.orderView viewWithTag:AWAIT_PAY_TAG];
            [button setBubbleString:STR_INT(count)];
        }
    }];
    
    OrderModel *theOrder2 = [[OrderModel alloc]init];
    theOrder2.type = @"await_ship";
    
    [[AppRequestManager sharedManager]operateOrderWithCartModel:theOrder2 operation:OrderOpsList andBlock:^(id responseObject, NSError *error) {
        if (responseObject != nil) {
            // 集中处理所有的数据
            NSUInteger count = [responseObject count];
            FAHoverButton *button = (FAHoverButton *)[self.orderView viewWithTag:AWAIT_SHIPPING_TAG];
            [button setBubbleString:STR_INT(count)];
        }
    }];
    
    
    OrderModel *theOrder3 = [[OrderModel alloc]init];
    theOrder3.type = @"shipped";
    
    [[AppRequestManager sharedManager]operateOrderWithCartModel:theOrder3 operation:OrderOpsList andBlock:^(id responseObject, NSError *error) {
        if (responseObject != nil) {
            // 集中处理所有的数据
            NSUInteger count = [responseObject count];
            FAHoverButton *button = (FAHoverButton *)[self.orderView viewWithTag:SHIPPED_TAG];
            [button setBubbleString:STR_INT(count)];
        }
    }];

    
    
}


- (void)historyOrderAction:(UIButton *)sender
{
    OrderListViewController *VC = [[OrderListViewController alloc]initWithNibName:nil
                                                                           bundle:nil];
    [VC setUpDownButton:0];
    
    if (sender.tag == AWAIT_SHIPPING_TAG) {
        [VC setOrderType:@"await_ship"];
        VC.title = T(@"待发货订单");
    }else if(sender.tag == AWAIT_PAY_TAG){
        [VC setOrderType:@"await_pay"];
        VC.title = T(@"待付款订单");
    }else if(sender.tag == SHIPPED_TAG){
        [VC setOrderType:@"shipped"];
        VC.title = T(@"待收货订单");
    }else{
        [VC setOrderType:@""];
        VC.title = T(@"全部订单");
    }
    
    ColorNavigationController *nav = [[ColorNavigationController alloc]initWithRootViewController:VC];
    [self presentViewController:nav animated:YES completion:nil];
}

- (void)initBgView
{
    UIImageView *bgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, TOTAL_WIDTH, TOTAL_HEIGHT)];
    UIImage *cropImage = [[UIImage imageNamed:@"train_bg"] cropToSize:CGSizeMake(TOTAL_WIDTH, TOTAL_HEIGHT) usingMode:NYXCropModeCenter];
    
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

    UILabel *editIcon = [[UILabel alloc]initWithFrame:CGRectMake(H_70, 0, H_30, H_30)];
    editIcon.font = FONT_AWESOME_24;
    editIcon.text = [NSString fontAwesomeIconStringForEnum:FAPencil];
    editIcon.textColor = WHITECOLOR;

    
    // 头像
    self.avatarButton = [[RoundedAvatarButton alloc]initWithFrame:CGRectMake(self.avatarView.width/2-H_90/2, 0, H_90, H_90)];
    [self.avatarButton.avatarImageView setImage:[UIImage imageNamed:XAppDelegate.me.avatarURL]];
    
    [self.avatarButton addTarget:self action:@selector(avatarAction) forControlEvents:UIControlEventTouchUpInside];
//    [self.avatarButton addSubview:editIcon];
    [self.avatarView addSubview:self.avatarButton];

    // 左右按钮
    KKFlatButton *leftButton = [KKFlatButton buttonWithType:UIButtonTypeCustom];
    [leftButton setTitle:T(@"修改头像") forState:UIControlStateNormal];
    [leftButton setFrame:CGRectMake(0, H_90/2-H_24/2, H_56, H_24)];
    [leftButton addTarget:self action:@selector(avatarAction) forControlEvents:UIControlEventTouchUpInside];
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
    
    FAHoverButton *buttonA = [[FAHoverButton alloc]initWithFrame:CGRectMake(-LINE_W, H_50, TOTAL_WIDTH/3+LINE_W*2, H_60)];
    [buttonA setIconFont:FONT_16];
    [buttonA setIconString:T(@"待付款")];
//    [buttonA setBubbleString:@"3"];
    [buttonA setIconColor:DARKCOLOR];
    [buttonA setBorder];
    buttonA.tag = AWAIT_PAY_TAG;
    
    FAHoverButton *buttonB = [[FAHoverButton alloc]initWithFrame:CGRectMake(TOTAL_WIDTH/3, H_50, TOTAL_WIDTH/3, H_60)];
    [buttonB setIconFont:FONT_16];
    [buttonB setIconString:T(@"待发货")];
//    [buttonB setBubbleString:@"3"];
    [buttonB setIconColor:DARKCOLOR];
    [buttonB setBorder];
    buttonB.tag = AWAIT_SHIPPING_TAG;

    
    
    FAHoverButton *buttonC = [[FAHoverButton alloc]initWithFrame:CGRectMake(TOTAL_WIDTH/3*2-LINE_W, H_50, TOTAL_WIDTH/3+LINE_W*2, H_60)];
    [buttonC setIconFont:FONT_16];
    [buttonC setIconString:T(@"待收货")];
//    [buttonC setBubbleString:@"2"];
    [buttonC setIconColor:DARKCOLOR];
    [buttonC setBorder];
    buttonC.tag = SHIPPED_TAG;


    [self.orderView addSubview:orderLabel];
    [buttonA addTarget:self action:@selector(historyOrderAction:) forControlEvents:UIControlEventTouchUpInside];
    [buttonB addTarget:self action:@selector(historyOrderAction:) forControlEvents:UIControlEventTouchUpInside];
    [buttonC addTarget:self action:@selector(historyOrderAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.orderView addSubview:buttonA];
    [self.orderView addSubview:buttonB];
    [self.orderView addSubview:buttonC];
    
    
    KKFlatButton *buttonBigA = [KKFlatButton buttonWithType:UIButtonTypeCustom];
    [buttonBigA setTitle:T(@"全部订单") forState:UIControlStateNormal];
    [buttonBigA setFrame:CGRectMake(H_40, H_140, H_240, H_50)];
    [buttonBigA.titleLabel setFont:FONT_14];
    [buttonBigA setTitleColor:DARKCOLOR forState:UIControlStateNormal];
    [buttonBigA setBackgroundColor:GREENLIGHTCOLOR2];
    [buttonBigA addTarget:self action:@selector(historyOrderAction:) forControlEvents:UIControlEventTouchUpInside];
    buttonBigA.tag = ALL_ORDER_TAG;
    
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
//    [self.orderView addSubview:buttonBigC];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSLog(@"scrollView %.2f",scrollView.contentOffset.y);
    self.avatarView.y = AVATAR_Y_OFFSET + scrollView.contentOffset.y/2;
}

- (void)avatarAction
{
    NSArray *imgs = @[@"F001",@"F002",@"F003",@"F004",@"F005",@"F006",@"F007",@"F008",@"F009",
                      @"F010",@"F011",@"F012",@"M001",@"M002",@"M003",@"M004",@"M005",@"M006",
                      @"M007",@"M008",@"M009",@"M010",@"M011",@"M012",@"avatarIronMan"];
    
    NSMutableArray *images = [[NSMutableArray alloc]init];
    
    for (NSString *img in imgs) {
        [images addObject:[UIImage imageNamed:img]];
    }
    
    
    [SGActionView showGridMenuWithTitle:T(@"选择头像") itemTitles:imgs images:images selectedHandle:^(NSInteger index) {
        Me *theMe = [[ModelHelper sharedHelper]findOnlyMe];
        theMe.avatarURL =  imgs[index];
        MRSave();
        XAppDelegate.me = theMe;

        [self.avatarButton.avatarImageView setImage:[UIImage imageNamed:XAppDelegate.me.avatarURL]];
        [self.passDelegate passSignalValue:SIGNAL_AVATAR_UPLOAD_DONE andData:nil];
    }];
    
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
    NSString *urlString = CUSTOMER_SERVICE_URL;
    WebViewController *VC = [[WebViewController alloc]initWithNibName:nil bundle:nil];
    VC.titleString = T(@"帮助/客服");
    VC.urlString = urlString;
    [VC setUpDownButton:0];
    ColorNavigationController *nav = [[ColorNavigationController alloc]initWithRootViewController:VC];
    [self presentViewController:nav animated:YES completion:nil];
    
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
