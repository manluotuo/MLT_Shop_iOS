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
#import "CExpandHeader.h"

#import "CollectViewController.h"
#import "BonusVC/BonusViewController.h"
#import "ServiceViewController.h"

/** 选择图片 */
#import "FSMediaPicker.h"

/** 个人中心 */

@interface ProfileViewController ()<UIScrollViewDelegate, FSMediaPickerDelegate>

@property(nonatomic, strong)UIView *avatarView;
@property(nonatomic, strong)UIScrollView *scrollView;
@property(nonatomic, strong)UIView *orderView;
@property(nonatomic, strong)RoundedAvatarButton *avatarButton;
@property(nonatomic, strong)CExpandHeader *header;
@property(nonatomic, strong)UIView *customView;

@end

#define AVATAR_Y_OFFSET -20.0f
#define LINE_W          0.5f

#define AWAIT_PAY_TAG       201
#define AWAIT_SHIPPING_TAG  202
#define SHIPPED_TAG         203
#define ALL_ORDER_TAG       204

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initScrollView];
    
    [self initBgView];
    
    [self initOrderView];
    
    [self initLineView];
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
    
    [[AppRequestManager sharedManager]operateOrderWithOrderModel:theOrder1 operation:OrderOpsList andPage:0 andBlock:^(id responseObject, NSError *error) {
        if (responseObject != nil) {
            // 集中处理所有的数据
            NSUInteger count = [responseObject count];
            FAHoverButton *button = (FAHoverButton *)[self.orderView viewWithTag:AWAIT_PAY_TAG];
            [button setBubbleString:STR_INT(count)];
        }
    }];
    
    OrderModel *theOrder2 = [[OrderModel alloc]init];
    theOrder2.type = @"await_ship";
    
    [[AppRequestManager sharedManager]operateOrderWithOrderModel:theOrder2 operation:OrderOpsList andPage:0 andBlock:^(id responseObject, NSError *error) {
        if (responseObject != nil) {
            // 集中处理所有的数据
            NSUInteger count = [responseObject count];
            FAHoverButton *button = (FAHoverButton *)[self.orderView viewWithTag:AWAIT_SHIPPING_TAG];
            [button setBubbleString:STR_INT(count)];
        }
    }];
    
    
    OrderModel *theOrder3 = [[OrderModel alloc]init];
    theOrder3.type = @"shipped";
    
    [[AppRequestManager sharedManager]operateOrderWithOrderModel:theOrder3 operation:OrderOpsList andPage:0 andBlock:^(id responseObject, NSError *error) {
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
    self.customView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, TOTAL_WIDTH, VIEW_HEIGHT)];
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, TOTAL_WIDTH, VIEW_HEIGHT)];
    [imageView setImage:[UIImage imageNamed:@"image"]];
    
    imageView.autoresizingMask = UIViewAutoresizingFlexibleHeight| UIViewAutoresizingFlexibleWidth;
    imageView.clipsToBounds = YES;
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.customView addSubview:imageView];
    [self initOtherView];
    self.header = [CExpandHeader expandWithScrollView:self.scrollView expandView:self.customView];
    /*
     UIImageView *bgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, TOTAL_WIDTH, TOTAL_HEIGHT)];
     UIImage *cropImage = [[UIImage imageNamed:@"train_bg"] cropToSize:CGSizeMake(TOTAL_WIDTH, TOTAL_HEIGHT) usingMode:NYXCropModeCenter];
     
     [bgView setImageToBlur:cropImage blurRadius:5.0f completionBlock:^{
     }];
     
     [self.view addSubview:bgView];*/
}


- (void)initOtherView {
    // 头像
    self.avatarButton = [[RoundedAvatarButton alloc]initWithFrame:CGRectMake(self.avatarView.width/2-H_90/2, 0, H_90, H_90)];
    [self.avatarButton.avatarImageView setImage:[UIImage imageNamed:XAppDelegate.me.avatarURL]];
    [self.avatarButton.avatarImageView sd_setImageWithURL:[NSURL URLWithString:XAppDelegate.me.avatarURL]
                                       placeholderImage:[UIImage imageNamed:@"logo_luotuo"]];
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
    
}

- (void)initScrollView
{
    self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, TOTAL_HEIGHT)];
    [self.scrollView setContentSize:CGSizeMake(TOTAL_WIDTH, self.scrollView.frame.size.height-VIEW_HEIGHT+H_200+H_30)];
    [self.view addSubview:self.scrollView];
    
    
    self.avatarView = [[UIView alloc]initWithFrame:CGRectMake(H_30, AVATAR_Y_OFFSET, H_260, H_90)];
    
    UILabel *editIcon = [[UILabel alloc]initWithFrame:CGRectMake(H_70, 0, H_30, H_30)];
    editIcon.font = FONT_AWESOME_24;
    editIcon.text = [NSString fontAwesomeIconStringForEnum:FAPencil];
    editIcon.textColor = WHITECOLOR;
    
    /*
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
     [self.avatarView addSubview:rightButton];*/
    
    
    [self.scrollView addSubview:self.avatarView];
    self.scrollView.delegate = self;
}

- (void)initOrderView
{
    self.orderView  = [[UIView alloc]initWithFrame:CGRectMake(0, H_160_180, TOTAL_WIDTH, TOTAL_HEIGHT)];
    [self.orderView setBackgroundColor:WHITECOLOR];
    self.orderView.backgroundColor = GRAYEXLIGHTCOLOR;
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
    [buttonA setBackgroundColor:WHITECOLOR];
    buttonA.tag = AWAIT_PAY_TAG;
    
    FAHoverButton *buttonB = [[FAHoverButton alloc]initWithFrame:CGRectMake(TOTAL_WIDTH/3, H_50, TOTAL_WIDTH/3, H_60)];
    [buttonB setIconFont:FONT_16];
    [buttonB setIconString:T(@"待发货")];
    //    [buttonB setBubbleString:@"3"];
    [buttonB setIconColor:DARKCOLOR];
    [buttonB setBorder];
    [buttonB setBackgroundColor:WHITECOLOR];
    buttonB.tag = AWAIT_SHIPPING_TAG;
    
    
    
    FAHoverButton *buttonC = [[FAHoverButton alloc]initWithFrame:CGRectMake(TOTAL_WIDTH/3*2-LINE_W, H_50, TOTAL_WIDTH/3+LINE_W*2, H_60)];
    [buttonC setIconFont:FONT_16];
    [buttonC setIconString:T(@"待收货")];
    [buttonC setBackgroundColor:WHITECOLOR];
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
    [buttonBigA setFrame:CGRectMake(H_5, H_120, WIDTH-H_5*2, H_60)];
    [buttonBigA setBackgroundColor:WHITECOLOR];

    UIImageView *imageA = RIGHT_IMAGE_FRAME;
    [imageA setImage:RIGHT_IMAGE];
    [buttonBigA addSubview:imageA];
    
    UILabel *lableA = TITLE_LABLE;
    [lableA setText:T(@"全部订单")];
    [lableA setFont:FONT_14];
    [lableA setTextColor:DARKCOLOR];
    [buttonBigA addSubview:lableA];
    
    [buttonBigA addTarget:self action:@selector(historyOrderAction:) forControlEvents:UIControlEventTouchUpInside];
    buttonBigA.tag = ALL_ORDER_TAG;
    
    KKFlatButton *buttonBigB = [KKFlatButton buttonWithType:UIButtonTypeCustom];
    [buttonBigB setFrame:CGRectMake(H_5, H_120+H_60, WIDTH-H_5*2, H_60)];
    [buttonBigB.titleLabel setFont:FONT_14];
//    [buttonBigB setBackgroundImage:[UIImage imageNamed:@"text"] forState:UIControlStateNormal];
    [buttonBigB setTitleColor:DARKCOLOR forState:UIControlStateNormal];
    [buttonBigB setBackgroundColor:WHITECOLOR];
    [buttonBigB addTarget:self action:@selector(addressAction) forControlEvents:UIControlEventTouchUpInside];
    UIImageView *imageB = RIGHT_IMAGE_FRAME;
    [imageB setImage:RIGHT_IMAGE];
    [buttonBigB addSubview:imageB];
    
    UILabel *lableB = TITLE_LABLE;
    [lableB setText:T(@"地址管理")];
    [lableB setFont:FONT_14];
    [lableB setTextColor:DARKCOLOR];
    [buttonBigB addSubview:lableB];
    
    
    KKFlatButton *buttonBigC = [KKFlatButton buttonWithType:UIButtonTypeCustom];
    [buttonBigC setFrame:CGRectMake(H_5, H_120+H_60*2+H_20, WIDTH-H_5*2, H_60)];
    [buttonBigC.titleLabel setFont:FONT_14];
    [buttonBigC setTitleColor:DARKCOLOR forState:UIControlStateNormal];
    [buttonBigC setBackgroundColor:WHITECOLOR];
    [buttonBigC addTarget:self action:@selector(collectionAction) forControlEvents:UIControlEventTouchUpInside];
    UIImageView *imageC = RIGHT_IMAGE_FRAME;
    [imageC setImage:RIGHT_IMAGE];
    [buttonBigC addSubview:imageC];
    
    UILabel *lableC = TITLE_LABLE;
    [lableC setText:T(@"我的收藏")];
    [lableC setFont:FONT_14];
    [lableC setTextColor:DARKCOLOR];
    [buttonBigC addSubview:lableC];
    
    KKFlatButton *buttonBigD = [KKFlatButton buttonWithType:UIButtonTypeCustom];
    [buttonBigD setFrame:CGRectMake(H_5, H_120+H_60*3+H_21, WIDTH-H_5*2, H_60)];
    [buttonBigD.titleLabel setFont:FONT_14];
    [buttonBigD setTitleColor:DARKCOLOR forState:UIControlStateNormal];
    [buttonBigD setBackgroundColor:WHITECOLOR];
    [buttonBigD addTarget:self action:@selector(onBonusClick) forControlEvents:UIControlEventTouchUpInside];
    UIImageView *imageD = RIGHT_IMAGE_FRAME;
    [imageD setImage:RIGHT_IMAGE];
    [buttonBigD addSubview:imageD];
    
    UILabel *lableD = TITLE_LABLE;
    [lableD setText:T(@"我的红包")];
    [lableD setFont:FONT_14];
    [lableD setTextColor:DARKCOLOR];
    [buttonBigD addSubview:lableD];
    
    KKFlatButton *buttonBigE = [KKFlatButton buttonWithType:UIButtonTypeCustom];
    [buttonBigE setFrame:CGRectMake(H_5, H_120+H_60*4+H_22, WIDTH-H_5*2, H_60)];
    [buttonBigE.titleLabel setFont:FONT_14];
    [buttonBigE setTitleColor:DARKCOLOR forState:UIControlStateNormal];
    [buttonBigE setBackgroundColor:WHITECOLOR];
    [buttonBigE addTarget:self action:@selector(onServiceClick) forControlEvents:UIControlEventTouchUpInside];
    UIImageView *imageE = RIGHT_IMAGE_FRAME;
    [imageE setImage:RIGHT_IMAGE];
    [buttonBigE addSubview:imageE];
    
    UILabel *lableE = TITLE_LABLE;
    [lableE setText:T(@"客服中心")];
    [lableE setFont:FONT_14];
    [lableE setTextColor:DARKCOLOR];
    [buttonBigE addSubview:lableE];
    
    [self.orderView addSubview:buttonBigA];
    [self.orderView addSubview:buttonBigB];
    [self.orderView addSubview:buttonBigC];
    [self.orderView addSubview:buttonBigD];
    [self.orderView addSubview:buttonBigE];
}

- (void)initLineView {
    UIView *lineView1 = [[UIView alloc]initWithFrame:CGRectMake(0, H_180, TOTAL_WIDTH, 1)];
    lineView1.backgroundColor = GRAYEXLIGHTCOLOR;
    
    [self.orderView addSubview:lineView1];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //    NSLog(@"scrollView %.2f",scrollView.contentOffset.y);
    self.avatarView.y = AVATAR_Y_OFFSET + scrollView.contentOffset.y/2;
}


/** 选择头型上传 */
- (void)avatarAction
{
    FSMediaPicker *mediaPicker = [[FSMediaPicker alloc] init];
    mediaPicker.mediaType = FSMediaTypePhoto;
    mediaPicker.editMode = FSEditModeCircular;
    mediaPicker.delegate = self;
    [mediaPicker showFromView:self.avatarButton];
    return;
   
    /**
     
    已改为上传从本地上传头像
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
        NSLog(@"%@", XAppDelegate.me.avatarURL);
        [self.avatarButton.avatarImageView setImage:[UIImage imageNamed:XAppDelegate.me.avatarURL]];
        [self.passDelegate passSignalValue:SIGNAL_AVATAR_UPLOAD_DONE andData:nil];
    }]; 
     */
}

/** 敏！！！！！！ */
- (void)mediaPicker:(FSMediaPicker *)mediaPicker didFinishWithMediaInfo:(NSDictionary *)mediaInfo
{
    HTProgressHUD *HUD = [[HTProgressHUD alloc] init];
    HUD.indicatorView = [HTProgressHUDIndicatorView indicatorViewWithType:HTProgressHUDIndicatorTypeActivityIndicator];
    HUD.text = T(@"正在上传头像");
    [HUD showInView:self.view];
    
    NSString *postUrl = @"http://192.168.1.199:8080/home/user/changeHeaderPicture";
    NSDictionary *postDict = @{@"userid": @"2032"};
    NSData *imageData = UIImageJPEGRepresentation(mediaInfo.circularEditedImage, 0.0);
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:postUrl parameters:postDict constructingBodyWithBlock:^(id formData) {
        [formData appendPartWithFileData:imageData name:@"file" fileName:@"file.jpg" mimeType:@"image/jpeg"];
    }];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        /** 获取用户信息 */
        NSString *httpUrl = @"http://192.168.1.199:8080/home/user/info";
        AFHTTPRequestOperationManager *rom=[AFHTTPRequestOperationManager manager];
        rom.responseSerializer.acceptableContentTypes=[NSSet setWithObjects:@"text/json",@"text/html", nil];
        NSDictionary *postDict = @{@"userid": [DataTrans
                                               noNullStringObj: XAppDelegate.me.userId]};
        [rom POST:httpUrl parameters:postDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"%@", responseObject);
            [HUD removeFromSuperview];
            if ([responseObject[@"SUCESS"] integerValue] == 1) {
            Me *theMe = [[ModelHelper sharedHelper]findOnlyMe];
            theMe.avatarURL =  responseObject[@"data"][@"headerimg"];
            MRSave();
            XAppDelegate.me = theMe;
            [self.avatarButton.avatarImageView setImage:mediaInfo.circularEditedImage];
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

- (void)mediaPickerDidCancel:(FSMediaPicker *)mediaPicker
{
    NSLog(@"%s",__FUNCTION__);
}


#pragma mark - 点击事件
/** 地址管理 */
- (void)addressAction
{
    AddressListViewController *VC = [[AddressListViewController alloc]init];
    ColorNavigationController *nav = [[ColorNavigationController alloc]initWithRootViewController:VC];
    [self presentViewController:nav animated:YES completion:nil];
}

/** 我的收藏 */
- (void)collectionAction
{
    CollectViewController *vc = [[CollectViewController alloc] init];
    ColorNavigationController *nav = [[ColorNavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:nav animated:YES completion:nil];
}

/** 客服 */
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

/** 我的红包 */
- (void)onBonusClick {
    
    BonusViewController *bonusVC = [[BonusViewController alloc] init];
    ColorNavigationController *nav = [[ColorNavigationController alloc] initWithRootViewController:bonusVC];
    [self presentViewController:nav animated:YES completion:nil];
    
}

/** 客服中心 */
- (void)onServiceClick {
    ServiceViewController *vc = [[ServiceViewController alloc] init];
    ColorNavigationController *nav = [[ColorNavigationController alloc] initWithRootViewController:vc];
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
