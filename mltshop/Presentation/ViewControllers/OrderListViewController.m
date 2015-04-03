///
//  OrderListViewController.m
//  mltshop
//
//  Created by mactive.meng on 13/1/15.
//  Copyright (c) 2015 manluotuo. All rights reserved.
//

#import "OrderListViewController.h"
#import "AppRequestManager.h"
#import "SGActionView.h"
#import "UIViewController+ImageBackButton.h"
#import "KKFlatButton.h"
#import "CartTableViewCell.h"
#import "OrderTableViewCell.h"
#import "OrderFootTableViewCell.h"
#import "LogisticsViewController.h"

#import <AlipaySDK/AlipaySDK.h>
#import "Order.h"
#import "DataSigner.h"

#import "OrderDetailViewController.h"
#import "FAHoverButton.h"
#import "RFExampleToolbarButton.h"
#import <SDWebImage/UIImageView+WebCache.h>


@interface OrderListViewController ()<UITableViewDataSource, UITableViewDelegate, PullListViewDelegate, PassValueDelegate, UITextFieldDelegate>

@property(nonatomic, strong)NSMutableArray *dataArray;
@property(nonatomic, strong)UIView *footerView;
@property(nonatomic, strong)KKFlatButton *flowButton;
@property(nonatomic, strong)OrderModel *theOrder;

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

@implementation OrderListViewController {
    UIButton *button;
    NSInteger count;
    UILabel *placeLable;
    UILabel *pricrLable;
    UIButton *logisticsButton;
    NSInteger page;
    NSInteger pageNumber;
    CGSize size;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    page = 1;
    // Do any additional setup after loading the view.
    self.commonListDelegate = self;
    self.dataSourceType = ListDataSourceOrder;
    self.dataArray = [[NSMutableArray alloc]init];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableView.y = IOS7_CONTENT_OFFSET_Y;
    self.tableView.height = TOTAL_HEIGHT - IOS7_CONTENT_OFFSET_Y;
    
    self.dataArray = [[NSMutableArray alloc]init];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gotoIndexAction:) name:@"Page" object:nil];
    
    //    [self initDataSource];
    //    [self setUpImageDownButton:0];
}

- (void)gotoIndexAction:(NSObject *)page {
    
    
    pageNumber = [[(NSDictionary *)page valueForKey:@"object"] integerValue]/10;
    NSLog(@"%d",pageNumber);
}

- (void)setOrderType:(NSString *)type
{
    self.theOrder = [[OrderModel alloc]init];
    self.theOrder.type = [DataTrans noNullStringObj:type];
    [self setupDataSource];
}

- (void)setUpDownButton:(NSInteger)position
{
    [self setUpImageDownButton:0];
}

- (void)initDataSource
{
    [super initDataSource];
}


- (void)passSignalValue:(NSString *)value andData:(id)data
{
    OrderModel *theOrder = data;
    self.theOrder = theOrder;
    if([value isEqualToString:SIGNAL_ORDER_ACTION]){
        if ([theOrder.paymentType isEqualToString:@"UNPAYED"]) {
            [self doAlipayAction:theOrder];
        }
    }
    if ([value isEqualToString:CERTRAL_BTN_CLICK]) {
        NSLog(@"11111");
    }
    
    if ([value isEqualToString:LOGBTN_CLICK]) {
        LogisticsViewController *logVC = [[LogisticsViewController alloc] init];
        logVC.invoice_no = theOrder.invoice_no;
        [self.navigationController pushViewController:logVC animated:YES];
    }
    
    
    if ([value isEqualToString:@"Comment"]) {
        [self initCollectView:theOrder];
        [self setCollectViewData:theOrder];
    }
}

/** 初始化评价窗口 */
- (void)initCollectView:(OrderModel *)model {
    
    size = self.tableView.contentSize;
    NSLog(@"%f", size.height);
    self.tableView.contentOffset = CGPointMake(0, H_90);
    self.tableView.contentSize = CGSizeMake(WIDTH, TOTAL_HEIGHT);
    self.collectView = [[UIView alloc] initWithFrame:CGRectMake(H_20, H_90, TOTAL_WIDTH-H_40, H_180)];
    //    self.collectView = [[UIView alloc] initWithFrame:CGRectMake(TOTAL_WIDTH/2, TOTAL_HEIGHT/2, 0, 0)];
    self.collectView.backgroundColor = GRAYEXLIGHTCOLOR;
    self.collectView.alpha = 0;
    self.collectView.clipsToBounds = YES;
    self.collectView.layer.cornerRadius = 10;
    
    self.iconImage = [[UIImageView alloc] initWithFrame:CGRectMake(H_10, H_10, H_50, H_50)];
    
    self.goodsName = [[UILabel alloc] initWithFrame:CGRectMake(self.iconImage.x+self.iconImage.width+H_5, H_10, self.tableView.width-self.iconImage.width-H_20, H_20)];
    self.goodsName.font = FONT_14;
    
    for (NSInteger i = 0; i < 5; i++) {
        self.starButton = [FAHoverButton buttonWithType:UIButtonTypeCustom];
        [self.starButton setTitle:[NSString fontAwesomeIconStringForEnum:FAStar] forState:UIControlStateNormal];
        [self.starButton setFrame:CGRectMake(self.goodsName.x+32*i, self.goodsName.y+self.goodsName.height+5, 30, 30)];
        [self.starButton setTitleColor:[UIColor orangeColor] forState:UIControlStateSelected];
        [self.starButton addTarget:self action:@selector(onStarButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.starButton setSelected:YES];
        self.starButton.tag = i+H_10;
        [self.collectView addSubview:self.starButton];
    }
    
    self.collectText = [[UITextView alloc] initWithFrame:CGRectMake(H_10, H_70, self.collectView.width-H_20, H_60)];
    [self.collectText becomeFirstResponder];
    self.collectText.layer.backgroundColor = [[UIColor clearColor] CGColor];
    self.collectText.layer.borderColor = [[UIColor grayColor] CGColor];
    self.collectText.layer.borderWidth = 1.0;
    self.collectText.layer.cornerRadius = 8.0f;
    [self.collectText.layer setMasksToBounds:YES];
    [self.collectText setFont:FONT_16];
    [self.collectText setDelegate:self];
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
    
    
    
    [self.tableView addSubview:self.collectView];
    [self.collectView addSubview:self.iconImage];
    [self.collectView addSubview:self.goodsName];
    [self.collectView addSubview:self.collectText];
    [self.collectView addSubview:self.cancelBtn];
    [self.collectView addSubview:self.certainBtn];
    
    [UIView animateWithDuration:0.5 animations:^{
        self.collectView.alpha = 1;
    }];
    
}

/** textView提示文字 */
- (void) textViewDidChange:(UITextView *)textView{
    if ([textView.text length] == 0) {
        [placeLable setHidden:NO];
    }else{
        [placeLable setHidden:YES];
    }
}

/** 设置评价窗口信息 */
- (void)setCollectViewData:(OrderModel *)model {
    [self.iconImage sd_setImageWithURL:[NSURL URLWithString:model.goods_list[count][@"img"][@"small"]] placeholderImage:nil];
    self.goodsName.text = model.goods_list[count][@"goods_name"];
}

/** 取消按钮点击事件 */
- (void)onCancelBtnClick {
    self.tableView.contentSize = size;
    [self.collectView removeFromSuperview];
}

/** 确认按钮点击事件 */
- (void)onCertainBtnClick {
    
    [self.collectText resignFirstResponder];
    HTProgressHUD *HUD = [[HTProgressHUD alloc] init];
    HUD.indicatorView = [HTProgressHUDIndicatorView indicatorViewWithType:HTProgressHUDIndicatorTypeActivityIndicator];
    HUD.text = T(@"请稍后\n正在提交评论");
    [HUD showInView:self.view];
    
    NSDictionary *dict = @{@"goods_id": self.theOrder.goods_list[count][@"goods_id"], @"comment_rank": @"5", @"content": self.collectText.text};
    
    [[AppRequestManager sharedManager]getCommentAddWithDict:dict andBlock:^(id responseObject, NSError *error) {
        if ([responseObject isEqualToString:@"YES"]) {
            [HUD removeFromSuperview];
            count++;
            [self.collectView removeFromSuperview];
            if (count < self.theOrder.goods_list.count) {
                [self initCollectView:self.theOrder];
                [self setCollectViewData:self.theOrder];
            } else {
                self.tableView.contentSize = size;
                // TODO：改变评价订单显示的文字
            }
        }
    }];
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

/** 支付宝付款 */
- (void)doAlipayAction:(OrderModel *)theOrder
{
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
    Order *order = [[Order alloc] init];
    order.partner = partner;
    order.seller = seller;
    order.tradeNO = theOrder.orderSn; //订单ID（由商家自行制定）
    order.productName = [NSString stringWithFormat:@"%@i",theOrder.subject]; //商品标题
    order.productDescription = theOrder.desc; //商品描述
    //    NSLog(@"!!!%@", theOrder.orderSn);
    //    NSLog(@"$$$%@", theOrder.subject);
    //    NSLog(@"^^^%@", theOrder.desc);
    //    NSLog(@"***%.2f", theOrder.orderAmount.floatValue);
    order.amount = [NSString stringWithFormat:@"%.2f",theOrder.orderAmount.floatValue]; //商品价格
    //    order.amount = [NSString stringWithFormat:@"%.2f", (arc4random() % 100)/10.0f]; //商品价格 9.9-0.1
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

/**
 *  初始化文章 two goods one line
 */
- (void)setupDataSource {
    
    self.start = 0;
    [[AppRequestManager sharedManager]operateOrderWithOrderModel:self.theOrder operation:OrderOpsList andPage:page andBlock:^(id responseObject, NSError *error) {
        if (responseObject != nil) {
            // 集中处理所有的数据
            if (page == 1) {
                [self.dataArray removeAllObjects];
            }
            NSUInteger count = [responseObject count];
            if (ArrayHasValue(responseObject)) {
                for (int i = 0 ; i < count; i++) {
                    OrderModel *oneOrder = [[OrderModel alloc]initWithDict:responseObject[i]];
                    [self.dataArray addObject:oneOrder];
                }
                NSLog(@"Online setupDataSource ======== ");
                [self showSetupDataSource:self.dataArray andError:nil];
                self.start = self.start + 1;
                NSLog(@"start %ld",(long)self.start);
            } else {
                [DataTrans showWariningTitle:T(@"您还没有订单")
                               andCheatsheet:[NSString fontAwesomeIconStringForEnum:FAInfoCircle]
                                 andDuration:1.0f];
                [self showSetupDataSource:self.dataArray andError:nil];
                UILabel *lable =[[UILabel alloc] initWithFrame:CGRectMake(30, TOTAL_HEIGHT/2-50, WIDTH-60, 50)];
                lable.text = T(@"抱歉~您还没有订单");
                lable.textAlignment = UIBaselineAdjustmentAlignCenters;
                [self.view addSubview:lable];
            }
            
        }
        if (error != nil) {
            [DataTrans showWariningTitle:T(@"获取地址列表有误") andCheatsheet:ICON_TIMES andDuration:1.5f];
        }
        
    }];
}

- (void)recomendNewItems
{
    page = 1;
    [self setupDataSource];
}

- (void)recomendOldItems
{
    if (page == pageNumber+1) {
        return;
    }
    
    if (self.tableView.contentSize.height < size.height) {
        return;
    }
    
    page++;
    [self setupDataSource];
}



#pragma mark -
#pragma mark UITableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return H_50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return CELL_HEIGHT + H_20;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    OrderTableViewCell *cellview = [[OrderTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    [cellview setFrame:CGRectMake(0, 0, WIDTH, H_40)];
    if(self.dataArray.count > 0) {
        [cellview setNewData:self.dataArray[section]];
    }
    cellview.passDelegate = self;
    return cellview;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
//    OrderModel *model = self.dataArray[section];
//    if ([model.order_status integerValue] == 2 || [model.order_status integerValue] == 4) {
//        return 20;
//    } else if ([model.shipping_status integerValue] == 0 && [model.paymentType isEqualToString:@"PAYED"]) {
//        return 20;
//    } else {
        return 65;
//    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    OrderFootTableViewCell *cellView = [[OrderFootTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    [cellView setFrame:CGRectMake(0, -40, WIDTH, 40)];
    
    if (self.dataArray.count > 0) {
        [cellView setNewData:self.dataArray[section]];
    }
    cellView.passDelegate = self;
    return cellView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.dataArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    OrderModel *theOrder = self.dataArray[section];
    NSLog(@"count %@",theOrder.cartList);
    return [theOrder.cartList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"ListCell";
    
    OrderModel *theOrder = self.dataArray[indexPath.section];
    CartModel *cellData = [theOrder.cartList objectAtIndex:indexPath.row];
    cellData.indexPath = indexPath;
    
    CartTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[CartTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        [cell.changeCountBtn setHidden:YES];
        cell.passDelegate = self;
    }
    
    [cell setNewData:cellData];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    OrderDetailViewController *orderVC = [[OrderDetailViewController alloc] init];
    OrderModel *theOrder = self.dataArray[indexPath.section];
    orderVC.order_id = theOrder.orderId;
    orderVC.goods_list = theOrder.goods_list;
    ColorNavigationController *nav = [[ColorNavigationController alloc] initWithRootViewController:orderVC];
    [self presentViewController:nav animated:YES completion:nil];
}



- (void)viewWillAppear:(BOOL)animated {
    [self setupDataSource];
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
