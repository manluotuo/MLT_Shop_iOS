//
//  OrderDetailViewController.m
//  mltshop
//
//  Created by 小新 on 15/3/14.
//  Copyright (c) 2015年 manluotuo. All rights reserved.
//

#import "OrderDetailViewController.h"

#import "AppRequestManager.h"
#import "SGActionView.h"
#import "UIViewController+ImageBackButton.h"
#import "KKFlatButton.h"
#import <AlipaySDK/AlipaySDK.h>
#import "DataSigner.h"

#import <SDWebImage/UIImageView+WebCache.h>
#import "OrderDetailModel.h"
#import "FAHoverButton.h"
#import "Order.h"

#import "RFExampleToolbarButton.h"
#import "SIAlertView.h"
#import "FAHoverButton.h"

@interface OrderDetailViewController ()<UITextViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSString *orderStatus; // 订单状态
@property (nonatomic, strong) NSString *shippingStatus; // 发货状态
@property (nonatomic, strong) NSString *payStatus; // 支付状态

/** 评论窗口 */
@property (nonatomic, strong) UIView *collectView;
/** 缩略图 */
@property (nonatomic, strong) UIImageView *iconImage;
/** 名称 */
@property (nonatomic, strong) UILabel *goodsName;
/** 评论 */
@property (nonatomic, strong) UITextView *collectText;
/** 取消 */
@property (nonatomic, strong) UIButton *cancelBtn;
/** 确认 */
@property (nonatomic, strong) UIButton *certainBtn;
/** 星 */
@property (nonatomic, strong) UIButton *starButton;
/** 星级 */
@property (nonatomic, strong) NSString *star;
@end

@implementation OrderDetailViewController {
    UIButton *button;
    NSInteger count;
    UILabel *placeLable;
    UILabel *pricrLable;
}

//[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gotoIndex) name:SIGNAL_GO_TO_INDEX object:nil];

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    count = 0;
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(H_0, H_0, WIDTH, TOTAL_HEIGHT-10)];
    self.scrollView.contentSize = CGSizeMake(WIDTH, 1000);
    [self.scrollView setBackgroundColor:WHITECOLOR];
    [self.view addSubview:self.scrollView];
    
    [self setupleftButton];
    self.title = T(@"订单详情");
    
    self.scrollView.y = IOS7_CONTENT_OFFSET_Y;
    self.scrollView.height = TOTAL_HEIGHT - IOS7_CONTENT_OFFSET_Y;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeBtnClick) name:@"tongzhi" object:nil];
    self.dataArray = [[NSMutableArray alloc]init];
    
    [self setData];
}

- (void)setData {
    
    self.dataArray = [[NSMutableArray alloc]init];
    [[AppRequestManager sharedManager]getOrderDetailOrderId:self.order_id andBlock:^(id responseObject,
                                                                                     NSError *error) {
        
        if (responseObject != nil) {
            // 集中处理所有的数据
            OrderDetailModel *model = [[OrderDetailModel alloc]init];
            
            [model setValuesForKeysWithDictionary:responseObject[@"data"]];
            [self.dataArray addObject:model];
            [self initView];
        }
        if (error != nil) {
            [DataTrans showWariningTitle:T(@"获取订单详情有误") andCheatsheet:ICON_TIMES andDuration:1.5f];
        }
        
    }];
}

- (UILabel *)createLable:(NSString *)title frame:(CGRect)frame color:(UIColor *)color font:(UIFont *)font {
    
    UILabel *lable = [[UILabel alloc] initWithFrame:frame];
    lable.numberOfLines = 2;
    [lable setFont:font];
    if (font == nil) {
        [lable setFont:FONT_16];
    }
    lable.textColor = color;
    if (color == nil) {
        lable.textColor =  BLACKCOLOR;
    }
    [lable setText:title];
    return lable;
}

- (UIView *)createLine:(CGRect)frame {
    UIView *line = [[UIView alloc] initWithFrame:frame];
    line.backgroundColor = [UIColor grayColor];
    line.alpha = 0.3;
    return line;
}

/** 订单详情---初始化页面 */
- (void)initView {
    if (self.dataArray.count > 0) {
        OrderDetailModel *model = [self.dataArray lastObject];
        //    CGRectMake(<#CGFloat x#>, <#CGFloat y#>, <#CGFloat width#>, <#CGFloat height#>)
        UILabel *lableAA = [self createLable:@"收货信息" frame:CGRectMake(H_15, H_5, WIDTH-H_15*2, H_50) color:[UIColor grayColor] font:FONT_14];
        [self.scrollView addSubview:lableAA];
        
        UIView *lineA = [self createLine:CGRectMake(H_14, lableAA.y+lableAA.height, WIDTH-H_14*2, 1)];
        [self.scrollView addSubview:lineA];
        
        UILabel *lableB = [self createLable:[NSString stringWithFormat:@"收货人名：%@", model.consignee] frame:CGRectMake(H_20, lableAA.y+lableAA.height+7.5, lableAA.width, H_20) color:nil font:nil];
        [self.scrollView addSubview:lableB];
        
        UILabel *lableC = [self createLable:[NSString stringWithFormat:@"收货地址：%@", model.address] frame:CGRectMake(H_20, lableB.y+lableB.height+H_10, lableAA.width, H_20) color:nil font:nil];
        [self.scrollView addSubview:lableC];
        
        
        UILabel *lableD = [self createLable:[NSString stringWithFormat:@"联系电话：%@", model.tel] frame:CGRectMake(H_20, lableC.y+lableC.height+H_10, lableAA.width, H_20) color:nil font:nil];
        [self.scrollView addSubview:lableD];
        
        UILabel *lableAB = [self createLable:@"支付及配送" frame:CGRectMake(H_15, lableD.y+lableD.height+H_8, WIDTH-H_15*2, H_50) color:[UIColor grayColor] font:FONT_14];
        [self.scrollView addSubview:lableAB];
        
        UIView *lineB = [self createLine:CGRectMake(H_14, lableAB.y+lableAB.height, lineA.width, 1)];
        [self.scrollView addSubview:lineB];
        
        UILabel *lableE = [self createLable:[NSString stringWithFormat:@"支付方式：%@", model.pay_name] frame:CGRectMake(H_20, lableAB.y+lableAB.height+H_8, lableAA.width, H_20) color:nil font:nil];
        [self.scrollView addSubview:lableE];
        
        UILabel *lableF = [self createLable:[NSString stringWithFormat:@"配送方式：%@", model.shipping_name] frame:CGRectMake(H_20, lableE.y+lableE.height+H_10, lableAA.width, H_20) color:nil font:nil];
        CGSize contentSize = [model.shipping_name sizeWithWidth:lableAA.width - H_80 andFont:FONT_12];
        lableF.height = contentSize.height;
        lableF.numberOfLines = 0;
        [self.scrollView addSubview:lableF];
        
        UILabel *lableAC = [self createLable:@"订单信息" frame:CGRectMake(H_15, lableF.y+lableF.height+H_8, WIDTH-H_15*2, H_50) color:[UIColor grayColor] font:FONT_14];
        [self.scrollView addSubview:lableAC];
        
        UIView *lineC = [self createLine:CGRectMake(lineB.x, lableAC.y+lableAC.height, lineA.width, 1)];
        [self.scrollView addSubview:lineC];
        
        UILabel *lableG = [self createLable:[NSString stringWithFormat:@"下单日期：%@", model.formated_add_time] frame:CGRectMake(H_20, lableAC.y+lableAC.height+H_8, WIDTH-H_15*2, H_20) color:nil font:nil];
        [self.scrollView addSubview:lableG];
        
        UILabel *lableH = [self createLable:[NSString stringWithFormat:@"订单编号：%@", model.order_sn] frame:CGRectMake(H_20, lableG.y+lableG.height+H_10, WIDTH-H_15*2, H_20) color:nil font:nil];
        [self.scrollView addSubview:lableH];
        
        
        switch ([model.order_status integerValue]) {
            case 0:
                self.orderStatus = T(@"未确认");
                break;
            case 1:
                self.orderStatus = T(@"已确认");
                break;
            case 2:
                self.orderStatus = T(@"已取消");
                break;
            case 3:
                self.orderStatus = T(@"无效");
                break;
            case 4:
                self.orderStatus = T(@"退货");
                break;
            case 5:
                self.orderStatus = T(@"已确认");
                break;
            case 6:
                self.orderStatus = T(@"已确认");
                break;
            default:
                break;
                
        }
        
        switch ([model.shipping_status integerValue]) {
            case 0:
                self.shippingStatus = T(@"未发货");
                break;
            case 1:
                self.shippingStatus = T(@"已发货");
                break;
            case 2:
                self.shippingStatus = T(@"已收货");
                break;
            case 3:
                self.shippingStatus = T(@"备货中");
                break;
            case 4:
                self.shippingStatus = T(@"已发货(部分商品)");
                break;
            case 5:
                self.shippingStatus = T(@"发货中(处理分单)");
                break;
            case 6:
                self.shippingStatus = T(@"已发货(部分商品)");
                break;
            default:
                break;
        }
        
        switch ([model.pay_status integerValue]) {
            case 0:
                self.payStatus = T(@"未付款");
                break;
            case 1:
                self.payStatus = T(@"付款中");
                break;
            case 2:
                self.payStatus = T(@"已付款");
                break;
            default:
                break;
        }
        
        UILabel *lableI = [self createLable:[NSString stringWithFormat:@"订单状态：%@, %@, %@", self.orderStatus, self.shippingStatus, self.payStatus] frame:CGRectMake(H_20, lableH.y+lableH.height+H_10, WIDTH-H_15*2, H_20) color:nil font:nil];
        [self.scrollView addSubview:lableI];
        
        UILabel *lableJ = [self createLable:[NSString stringWithFormat:@"订单金额：%@(包含邮费%@)", model.formated_order_amount, model.formated_shipping_fee] frame:CGRectMake(H_20, lableI.y+lableI.height+H_10, WIDTH-H_15*2, H_20) color:nil font:nil];
        [self.scrollView addSubview:lableJ];
        
        UILabel *lableAD = [self createLable:@"商品列表" frame:CGRectMake(H_15, lableJ.y+lableJ.height+H_8, WIDTH-H_15*2, H_50) color:[UIColor grayColor] font:FONT_14];
        [self.scrollView addSubview:lableAD];
        
        UIView *lineD = [self createLine:CGRectMake(lineA.x, lableAD.y+lableAD.height, lineA.width, 1)];
        [self.scrollView addSubview:lineD];
        
        for (int i = 0; i < self.goods_list.count; i++) {
            UIImageView *image = [[UIImageView alloc] initWithFrame: CGRectMake(H_10, lableAD.y+lableAD.height+H_4 + H_100*i, H_80, H_80)];
            [image sd_setImageWithURL:[NSURL URLWithString:self.goods_list[i][@"img"][@"small"]] placeholderImage:[UIImage imageNamed:@" "]];
            [self.scrollView addSubview:image];
            
            UILabel *lableK = [self createLable:[NSString stringWithFormat:@"%@", self.goods_list[i][@"goods_name"]] frame:CGRectMake(image.width+H_20, lableAD.y+lableAD.height+H_12 + H_100*i, WIDTH-H_15*2-image.width-H_20, H_20) color:GREENCOLOR font:FONT_16];
            CGSize contentSize = [self.goods_list[i][@"goods_name"] sizeWithWidth:WIDTH-H_15*2-image.width-H_20 andFont:FONT_16];
            lableK.height = contentSize.height;
            [self.scrollView addSubview:lableK];
            
            UILabel *lableL = [self createLable:[NSString stringWithFormat:@"%@ x %@", self.goods_list[i][@"subtotal"], self.goods_list[i][@"goods_number"]] frame:CGRectMake(image.width+H_20, lableK.y+lableK.height+H_5, WIDTH-H_15*2-image.width-H_20, H_20) color:ORANGE_DARK_COLOR font:FONT_16];
            [self.scrollView addSubview:lableL];
            
            UIView *lineE = [self createLine:CGRectMake(lineA.x, image.y+image.height+2, lineA.width, 1)];
            [self.scrollView addSubview:lineE];
            
            self.scrollView.contentSize = CGSizeMake(WIDTH, lableL.y+lableL.height+H_15+H_80);
        }
        
        UIView *btnView = [[UIView alloc] initWithFrame:CGRectMake(H_0, TOTAL_HEIGHT-H_80, WIDTH, H_80)];
        UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(H_0, H_0, WIDTH, H_80)];
        image.image = [UIImage imageNamed:@"1"];
        [btnView addSubview:image];
        pricrLable = [self createLable:[NSString stringWithFormat:@"应付总额：%@", model.order_amount] frame:CGRectMake(H_15, H_20, WIDTH, H_40) color:ORANGECOLOR font:FONT_16];
        [btnView addSubview:pricrLable];
        if ([model.pay_status integerValue] == 2) {
            pricrLable.hidden = YES;
        }
        
        button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setFrame:CGRectMake(WIDTH/2+H_20, H_20, WIDTH/2-H_20*2, H_40)];
        [button setTitle:@"立即付款" forState:UIControlStateNormal];
        [button setTitle:T(@"确认收货") forState:UIControlStateSelected];
        button.selected = NO;
        [button setTintColor:WHITECOLOR];
        [button setBackgroundColor:ORANGECOLOR];
        [button.titleLabel setFont:FONT_16];
        button.layer.cornerRadius = 5;
        button.clipsToBounds = YES;
        [button addTarget:self action:@selector(onBtnCLick) forControlEvents:UIControlEventTouchUpInside];
        [btnView addSubview:button];
        [self setButtonSelect];
        [self.view addSubview:btnView];
        
    }
}

/** 按钮显示的状态 */
- (void)setButtonSelect {
    
    if (self.dataArray.count > 0) {
        OrderDetailModel *model = [self.dataArray lastObject];
        if ([model.order_status integerValue] == 2 || [model.order_status integerValue] == 3 || [model.order_status integerValue] == 4 || [model.shipping_status integerValue] == 2) {
            button.hidden = YES;
        } else {
            if ([model.pay_status integerValue] == 0) {
                button.selected = NO;
            } else if ([model.pay_status integerValue] == 2){
                button.selected = YES;
            }
        }
        
    }
    
}

/** 设置导航栏按钮 */
- (void)setupleftButton
{
    CGFloat leftMargin = 10.0f;
    FAHoverButton *backButton = [[FAHoverButton alloc] initWithFrame:CGRectMake(0, 0, 12+leftMargin, 21)];
    [backButton setTitle:ICON_BACK forState:UIControlStateNormal];
    [backButton.titleLabel setFont:FONT_AWESOME_36];
    [backButton setImageEdgeInsets:UIEdgeInsetsMake(0, leftMargin, 0, 0)];
    
    
    UIBarButtonItem *barBackButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    [backButton addTarget:self action:@selector(onLeftBtnClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = barBackButtonItem;
    self.navigationItem.hidesBackButton = YES;
}
/** 导航栏按钮点击事件 */
- (void)onLeftBtnClick {
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

/** 确认收货/立即付款按钮点击事件 */
- (void)onBtnCLick {
    
    //TODO:记着切换
    if (button.selected == NO) {
        if (self.dataArray.count > 0) {
            OrderDetailModel *model = [self.dataArray lastObject];
            [self doAlipayAction:model];
        }
    } else {
        SIAlertView *alertView = [[SIAlertView alloc] initWithTitle:nil andMessage:@"确认收货"];
        [alertView addButtonWithTitle:@"取消"
                                 type:SIAlertViewButtonTypeCancel
                              handler:^(SIAlertView *alertView) {
                                  
                              }];
        [alertView addButtonWithTitle:@"确认"
                                 type:SIAlertViewButtonTypeDefault
                              handler:^(SIAlertView *alertView) {
                                  OrderModel *model = [[OrderModel alloc] init];
                                  model.orderId = self.order_id;
                                  [[AppRequestManager sharedManager]operateOrderWithOrderModel:model operation:OrderOpsAffirmReceived andBlock:^(id responseObject, NSError *error) {
                                      [DataTrans showWariningTitle:T(@"成功收货") andCheatsheet:ICON_INFO andDuration:1.0f];
                                      button.enabled = NO;
                                      [button setBackgroundColor:[UIColor grayColor]];
                                      if (count < self.goods_list.count) {
                                          [self initCollectView];
                                          [self setCollectViewData];
                                      }
                                  }];
                              }];
        alertView.titleColor = [UIColor blueColor];
        alertView.cornerRadius = 10;
        alertView.buttonFont = [UIFont boldSystemFontOfSize:15];
        alertView.transitionStyle = SIAlertViewTransitionStyleBounce;
        [alertView show];
        
    }
}

/** 初始化评价窗口 */
- (void)initCollectView {
    
    self.scrollView.contentOffset = CGPointMake(0, H_90);
    self.collectView = [[UIView alloc] initWithFrame:CGRectMake(H_20, H_90, TOTAL_WIDTH-H_40, H_180)];
    //    self.collectView = [[UIView alloc] initWithFrame:CGRectMake(TOTAL_WIDTH/2, TOTAL_HEIGHT/2, 0, 0)];
    self.collectView.backgroundColor = GRAYEXLIGHTCOLOR;
    self.collectView.alpha = 0;
    self.collectView.clipsToBounds = YES;
    self.collectView.layer.cornerRadius = 10;
    
    self.iconImage = [[UIImageView alloc] initWithFrame:CGRectMake(H_10, H_10, H_50, H_50)];
    
    self.goodsName = [[UILabel alloc] initWithFrame:CGRectMake(self.iconImage.x+self.iconImage.width+H_5, H_10, self.scrollView.width-self.iconImage.width-H_20, H_20)];
    self.goodsName.font = FONT_14;
    
    for (NSInteger i = 0; i < 5; i++) {
        self.starButton = [FAHoverButton buttonWithType:UIButtonTypeCustom];
        [self.starButton setTitle:[NSString fontAwesomeIconStringForEnum:FAStar] forState:UIControlStateNormal];
        [self.starButton setFrame:CGRectMake(self.goodsName.x+32*i, self.goodsName.y+self.goodsName.height+5, 30, 30)];
        [self.starButton setTitleColor:[UIColor orangeColor] forState:UIControlStateSelected];
        [self.starButton addTarget:self action:@selector(onStarButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.starButton setSelected:NO];
        self.starButton.tag = i+H_10;
        [self.collectView addSubview:self.starButton];
    }
    
    self.collectText = [[UITextView alloc] initWithFrame:CGRectMake(H_10, H_70, self.collectView.width-H_20, H_60)];
    [self.collectText becomeFirstResponder];
    self.collectText.layer.backgroundColor = [[UIColor clearColor] CGColor];
    self.collectText.layer.borderColor = [[UIColor grayColor] CGColor];
    self.collectText.layer.borderWidth = 1.0;
    self.collectText.layer.cornerRadius = 8.0f;
    self.collectText.delegate = self;
    [self.collectText.layer setMasksToBounds:YES];
    [self.collectText setFont:FONT_16];
    placeLable = [[UILabel alloc] initWithFrame:CGRectMake(3, 3, 150, 30)];
    placeLable.enabled = NO;
    placeLable.text = @"请在此填写评价";
    placeLable.font = FONT_16;
    placeLable.textColor = [UIColor lightGrayColor];
    [self.collectText addSubview:placeLable];
    
    /** 给键盘增加完成按钮 */
    RFExampleToolbarButton *exampleButton = [RFExampleToolbarButton new];
    [RFKeyboardToolbar addToTextView:self.collectText withButtons:@[exampleButton]];
    
    
    self.cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.cancelBtn.frame = CGRectMake(H_10, self.collectText.y+self.collectText.height+H_6, H_120, H_30+H_5);
    [self.cancelBtn setTitle:T(@"取消") forState:UIControlStateNormal];
    [self.cancelBtn setBackgroundColor:[UIColor grayColor]];
    [self.cancelBtn addTarget:self action:@selector(onCancelBtnClick) forControlEvents:UIControlEventTouchUpInside];
    self.cancelBtn.clipsToBounds = YES;
    self.cancelBtn.layer.cornerRadius = 5;
    
    self.certainBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.certainBtn.frame = CGRectMake(self.collectView.width/2+H_10, self.cancelBtn.y, H_120, self.cancelBtn.height);
    [self.certainBtn setTitle:T(@"确定") forState:UIControlStateNormal];
    [self.certainBtn addTarget:self action:@selector(onCertainBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.certainBtn setBackgroundColor:[UIColor orangeColor]];
    self.certainBtn.clipsToBounds = YES;
    self.certainBtn.layer.cornerRadius = 5;
    
    
    
    [self.scrollView addSubview:self.collectView];
    [self.collectView addSubview:self.iconImage];
    [self.collectView addSubview:self.goodsName];
    [self.collectView addSubview:self.collectText];
    [self.collectView addSubview:self.cancelBtn];
    [self.collectView addSubview:self.certainBtn];
    
    [UIView animateWithDuration:0.5 animations:^{
        self.collectView.alpha = 1;
    }];
    
}

/** 设置评价窗口信息 */
- (void)setCollectViewData {
    [self.iconImage sd_setImageWithURL:[NSURL URLWithString:self.goods_list[count][@"img"][@"small"]] placeholderImage:nil];
    self.goodsName.text = self.goods_list[count][@"goods_name"];
}

/** 支付 */
- (void)doAlipayAction:(OrderDetailModel *)theOrder {
    
    /*
     *商户的唯一的parnter和seller。
     *签约后，支付宝会为每个商户分配一个唯一的 parnter 和 seller。
     */
    
    /*============================================================================*/
    /*=======================需要填写商户app申请的===================================*/
    /*============================================================================*/
    NSString *partner = @"2088211543184953";
    NSString *seller = @"manluotuodianzi@sina.com";
    NSString *privateKey = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"pkcs8" ofType:@"txt"]];
    NSLog(@"privateKey %@",privateKey);
    /*============================================================================*/
    /*============================================================================*/
    /*============================================================================*/
    
    //partner和seller获取失败,提示
    if ([partner length] == 0 || [seller length] == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"缺少partner或者seller。"
                                                       delegate:self
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    /*
     *生成订单信息及签名
     */
    //将商品信息赋予AlixPayOrder的成员变量
    NSInteger i = 0;
    Order *order = [[Order alloc] init];
    order.partner = partner;
    order.seller = seller;
    order.tradeNO = theOrder.order_sn; //订单ID（由商家自行制定）
    for (NSDictionary *dict in self.goods_list) {
        
        i++;
    }
    if (self.goods_list.count > 0) {
        order.productName = [NSString stringWithFormat:@"%@等%ld种商品i", self.goods_list[0][@"goods_name"], (long)i]; //商品标题
        order.productDescription = [NSString stringWithFormat:@"%@等%ld种商品", self.goods_list[0][@"goods_name"], (long)i]; //商品描述
        order.amount = [NSString stringWithFormat:@"%.2f",theOrder.order_amount.floatValue]; //商品价格
        //    order.amount = [NSString stringWithFormat:@"%.2f", (arc4random() % 100)/10.0f]; //商品价格 9.9-0.1
    }
    order.notifyURL = [NSString stringWithFormat:@"%@%@",BASE_API,@"/ws_pay/notify_url.php"]; //回调URL
    order.service = @"mobile.securitypay.pay";
    order.paymentType = @"1";
    order.inputCharset = @"utf-8";
    order.itBPay = @"30m";
    order.showUrl = @"m.alipay.com";
    
    //应用注册scheme,在AlixPayDemo-Info.plist定义URL types
    NSString *appScheme = @"mltshop";
    
    //将商品信息拼接成字符串
    NSString *orderSpec = [order description];
    NSLog(@"orderSpec = %@",orderSpec);
    
    //获取私钥并将商户信息签名,外部商户可以根据情况存放私钥和签名,只需要遵循RSA签名规范,并将签名字符串base64编码和UrlEncode
    id<DataSigner> signer = CreateRSADataSigner(privateKey);
    NSString *signedString = [signer signString:orderSpec];
    
    //将签名成功字符串格式化为订单字符串,请严格按照该格式
    NSString *orderString = nil;
    if (signedString != nil) {
        orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
                       orderSpec, signedString, @"RSA"];
        
        [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
            NSLog(@"reslut = %@",resultDic);
            if([resultDic[@"resultStatus"] isEqualToNumber:INT(9000)]){
                [self.navigationController popViewControllerAnimated:YES]; 
            }
            
        }];
        
    }
}

/** 改变付款/收货按钮状态 */
- (void)changeBtnClick {
    button.enabled = NO;
    button.backgroundColor = [UIColor grayColor];
}

/** 取消按钮点击事件 */
- (void)onCancelBtnClick {
    [self.collectView removeFromSuperview];
}

/** 确认按钮点击事件 */
- (void)onCertainBtnClick {
    
    [self.collectText resignFirstResponder];
    HTProgressHUD *HUD = [[HTProgressHUD alloc] init];
    HUD.indicatorView = [HTProgressHUDIndicatorView indicatorViewWithType:HTProgressHUDIndicatorTypeActivityIndicator];
    HUD.text = T(@"请稍后\n正在提交评论");
    [HUD showInView:self.view];
    
    NSLog(@"%@", self.goods_list[count][@"goods_id"]);
    NSDictionary *dict = @{@"goods_id": self.goods_list[count][@"goods_id"], @"comment_rank": @"5", @"content": self.collectText.text};
    
    [[AppRequestManager sharedManager]getCommentAddWithDict:dict andBlock:^(id responseObject, NSError *error) {
        if ([responseObject isEqualToString:@"YES"]) {
            [HUD removeFromSuperview];
            count++;
            [self.collectView removeFromSuperview];
            if (count < self.goods_list.count) {
                [self initCollectView];
                [self setCollectViewData];
            }
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/** textView提示文字 */
- (void) textViewDidChange:(UITextView *)textView{
    if ([textView.text length] == 0) {
        [placeLable setHidden:NO];
    }else{
        [placeLable setHidden:YES];
    }
}

/** 星数被点击 */
- (void)onStarButtonClick:(UIButton *)sender {
    
    
    for (NSInteger j = 10; j < 15; j++) {
        UIButton *btn = (UIButton *)[self.view viewWithTag:j];
        [btn setSelected:NO];
    }
    for (NSInteger i = 10; i <= sender.tag; i++) {
        UIButton *btn = (UIButton *)[self.view viewWithTag:i];
        [btn setSelected:YES];
    }
    self.star = [NSString stringWithFormat:@"%d", sender.tag];
    if (self.star.length == 0) {
        self.star = [NSString stringWithFormat:@"5"];
    }
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
