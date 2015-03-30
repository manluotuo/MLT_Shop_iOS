//
//  CheckOrderViewController.m
//  mltshop
//
//  Created by mactive.meng on 1/1/15.
//  Copyright (c) 2015 manluotuo. All rights reserved.
//

#import "CheckOrderViewController.h"
#import "AddressTableViewCell.h"
#import "CartTableViewCell.h"
#import "PaymentTableViewCell.h"
#import "ShippingTableViewCell.h"
#import "BonusTableViewCell.h"
#import "AppRequestManager.h"
#import "SGActionView.h"
#import "AppDelegate.h"

#import <AlipaySDK/AlipaySDK.h>
#import "Order.h"
#import "DataSigner.h"
#import <HTProgressHUD/HTProgressHUD.h>
#import <HTProgressHUD/HTProgressHUDIndicatorView.h>


#define CART_TAG        0
#define CONSIGNEE_TAG   1
#define SHIPPING_TAG    2
#define PAYMENT_TAG     3
#define BONUS_TAG       4

@interface CheckOrderViewController ()<UITableViewDataSource, UITableViewDelegate, PassValueDelegate, UITextFieldDelegate>
{
    NSArray *sectionTitles;
    UILabel *goodsInfoLabel;
    UILabel *integralLabel;
    UILabel *summaryLabel;
    UILabel *bonusLabel;
    UITextField *integralText;
    KKFlatButton *doneButton;
    CGFloat payAmount;
    NSString *payType;
}

@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)FlowModel *dataSource;
@property (nonatomic, strong)FlowDoneModel *flowDoneData;
@property (nonatomic, strong)UIView *infoView;


@end

@implementation CheckOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillhide:) name:UIKeyboardWillHideNotification object:nil];
    
    self.title = T(@"结算页面");
    payType = @"支付宝付款";
    // Do any additional setup after loading the view.
    sectionTitles = @[@"商品列表",@"收货人", @"快递方式", @"支付方式",@"红包列表"];
    
    self.dataSource = [[FlowModel alloc]init];
    self.flowDoneData = [[FlowDoneModel alloc]init];
    self.view.backgroundColor = BGCOLOR;
    self.editing = NO;
    self.infoView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, TOTAL_WIDTH, H_240)];
    [self initInfoView];
    
    self.tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.backgroundColor = BGCOLOR;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.separatorColor = SEPCOLOR;
    
    self.tableView.delegate = self;
    self.tableView.dataSource  = self;
    
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
        
    }
    
    self.tableView.tableFooterView = self.infoView;
    [self.view addSubview:self.tableView];
    [self setupDataSource];
    
}

- (void)setupDataSource
{
    
    [[AppRequestManager sharedManager]flowCheckOrderWithBlock:^(id responseObject, NSError *error) {
        
        NSLog(@"!!!!!!!!!!!!!!!!%@", responseObject);
        if(responseObject != nil) {
            
            self.dataSource =  [[FlowModel alloc]initWithDict:responseObject];
            
            // 如果支付和快递  默认选第一个
            if ([self.dataSource.shippingList count] >= 1) {
                
                ShippingModel *item = [self.dataSource.shippingList firstObject];
                item.selected = YES;
                self.flowDoneData.shippingId = item.shippingId;
                
            }
            
            if ([self.dataSource.paymentList count] >=  1) {
                PayModel *item = [self.dataSource.paymentList firstObject];
                item.selected = YES;
                self.flowDoneData.payId = item.payId;
            }
            
            [self.tableView reloadData];
            
            [self refreshInfoView];
        }
        if (error != nil) {
            
            if ([error.userInfo[@"error_code"] isEqualToNumber:INT(10001)]) {
                [self.navigationController dismissViewControllerAnimated:YES completion:nil];
                
                [DataTrans showWariningTitle:T(@"请在\"个人中心->地址管理\"中 新增地址")
                               andCheatsheet:ICON_TIMES
                                 andDuration:3.0f];
                
            }
            
            
            
        }
    }];
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
    order.productName = [NSString stringWithFormat:@"%@i", theOrder.subject]; //商品标题
    order.productDescription = theOrder.desc; //商品描述
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
        
        [self dismissViewControllerAnimated:YES completion:nil];
        [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
            
            NSLog(@"reslut = %@",resultDic);
            if([resultDic[@"resultStatus"] isEqualToNumber:INT(9000)]){
                [self.navigationController popViewControllerAnimated:YES];
            }
        }];
        
        
        
    }
}

/** 微信支付 */
- (void)doWeiXinAction {
    NSLog(@"填写微信支付");
}

- (void)doneAction
{
    HTProgressHUD *HUD = [[HTProgressHUD alloc] init];
    HUD.indicatorView = [HTProgressHUDIndicatorView indicatorViewWithType:HTProgressHUDIndicatorTypeActivityIndicator];
    HUD.text = T(@"订单生成中...");
    [HUD showInView:self.view];
    
    [[AppRequestManager sharedManager]flowDoneWithFlowDoneModel:self.flowDoneData andBlock:^(id responseObject, NSError *error) {
        
        [HUD removeFromSuperview];
        if (responseObject != nil) {
            OrderModel *theOrder = [[OrderModel alloc]initWithDict:responseObject];
            [DataTrans showWariningTitle:T(@"订单已生成") andCheatsheet:ICON_CHECK];
            
            [SGActionView showSheetWithTitle:@"支付流程" itemTitles:@[payType, @"再逛逛"] selectedIndex:100 selectedHandle:^(NSInteger index) {
                if(index == 0) {
                    if ([payType isEqualToString:T(@"支付宝付款")]) {
                        [self doAlipayAction:theOrder];
                    } else {
                        NSLog(@"调用微信支付");
                        [self doWeiXinAction];
                    }
                } else {
                    [self dismissViewControllerAnimated:NO completion:^{
                        [[NSNotificationCenter defaultCenter] postNotificationName:SIGNAL_GO_TO object:nil userInfo:nil];
                    }];
                    [XAppDelegate showDrawerView];
                }
            }];
        }
        if (error != nil) {
            [DataTrans showWariningTitle:T(@"订单生成失败") andCheatsheet:ICON_TIMES];
        }
        
    }];
}

- (void)refreshInfoView
{
    payAmount = 0.0f;
    
    // 商品
    for (CartModel *cart in self.dataSource.goodsList) {
        payAmount += cart.subtotal.floatValue;
    }
    
    goodsInfoLabel.text = [NSString stringWithFormat:@"商品总计: %@元",STR_NUM2(payAmount)];
    
    // 快递费
    for (ShippingModel *ship in self.dataSource.shippingList) {
        if (ship.selected) {
            payAmount += ship.shippingFee.floatValue;
            break;
        }
    }
    
    // 红白
    for (BonusModel * bonus in self.dataSource.bonusList) {
        if (bonus.selected) {
            bonusLabel.text = [NSString stringWithFormat:@"%@, -%@ 元",
                               bonus.bonusName,
                               STR_NUM2([bonus.bonusMoney floatValue])];
            payAmount -= bonus.bonusMoney.floatValue;
            break;
        }
    }
    
    CGFloat canUseIntegral  = 0.0f;
    //    if (self.dataSource.yourIntegral < self.dataSource.orderMaxIntegral) {
    //        canUseIntegral = self.dataSource.yourIntegral.floatValue;
    //    }else{
    //        canUseIntegral = self.dataSource.orderMaxIntegral.floatValue;
    //    }
    
    self.flowDoneData.usedIntegral = FLOAT([integralText.text floatValue]);
    canUseIntegral = integralText.text.floatValue;
    
    NSString *integralString = [NSString stringWithFormat:@"我的积分: %@ , 最大可用积分:%@",
                                STR_INT([self.dataSource.yourIntegral integerValue]),
                                STR_INT([self.dataSource.orderMaxIntegral integerValue])];
    integralString = [NSString stringWithFormat:@"%@\n积分抵扣: -%.2f元",integralString,canUseIntegral/100];
    integralLabel.text = integralString;
    
    self.dataSource.payAmount = FLOAT(payAmount - canUseIntegral/100);
    summaryLabel.text = [NSString stringWithFormat:@"合计: %@",
                         STR_NUM2([self.dataSource.payAmount floatValue])];
    
    
}

- (void)initInfoView
{
    self.infoView.backgroundColor = WHITECOLOR;
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, TOTAL_WIDTH, H_30)];
    titleLabel.text = @"     汇总信息";
    titleLabel.font = FONT_13;
    titleLabel.textColor = GRAYCOLOR;
    titleLabel.backgroundColor = GRAYEXLIGHTCOLOR;
    
    [self.infoView addSubview:titleLabel];
    
    
    goodsInfoLabel = [[UILabel alloc]initWithFrame:CGRectMake(H_20, H_40, H_280, H_40)];
    goodsInfoLabel.font = FONT_13;
    goodsInfoLabel.textColor = GRAYCOLOR;
    
    integralLabel = [[UILabel alloc]initWithFrame:CGRectMake(H_20, H_40*2, H_280, H_40)];
    integralLabel.font = FONT_13;
    integralLabel.textColor = GRAYCOLOR;
    integralLabel.numberOfLines = 0;
    NSString *integralString = [NSString stringWithFormat:@"我的积分: %@ , 最大可用积分:%@",
                                STR_INT([self.dataSource.yourIntegral integerValue]),
                                STR_INT([self.dataSource.orderMaxIntegral integerValue])];
    integralLabel.text = integralString;
    
    /** 使用积分 */
    
    //    UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(H_20, H_40*3, H_100, H_20)];
    //    lable.text = T(@"使用积分");
    //    lable.font = FONT_13;
    //    [self.infoView addSubview:lable];
    
    integralText = [[UITextField alloc] initWithFrame:CGRectMake(H_20, H_40*3, H_100, H_20)];
    integralText.borderStyle = UITextBorderStyleBezel;
    integralText.placeholder = T(@"要使用的积分");
    integralText.delegate = self;
    integralText.font = FONT_13;
    
    [integralText addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [integralText setKeyboardType:UIKeyboardTypeNumberPad];
    
    
    
    bonusLabel = [[UILabel alloc]initWithFrame:CGRectMake(H_20, H_40*3+H_20, H_200, H_30)];
    bonusLabel.font = FONT_13;
    bonusLabel.textColor = GRAYCOLOR;
    
    
    summaryLabel = [[UILabel alloc]initWithFrame:CGRectMake(H_20, H_40*4, H_160, H_40)];
    summaryLabel.textColor = REDCOLOR;
    
    doneButton = [KKFlatButton buttonWithType:UIButtonTypeCustom];
    [doneButton setFrame:CGRectMake(H_180, H_40*4, H_100, H_40)];
    [doneButton setTitle:T(@"提交订单") forState:UIControlStateNormal];
    [doneButton addTarget:self action:@selector(doneAction) forControlEvents:UIControlEventTouchUpInside];
    
    
    [self.infoView addSubview:goodsInfoLabel];
    [self.infoView addSubview:integralLabel];
    [self.infoView addSubview:bonusLabel];
    [self.infoView addSubview:summaryLabel];
    [self.infoView addSubview:doneButton];
    [self.infoView addSubview:integralText];
}

#pragma mark -
#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger rows = [self.tableView numberOfRowsInSection:indexPath.section];
    NSMutableArray *indexPathsOfSection = [[NSMutableArray alloc]init];
    for (int i = 0; i<rows; i++) {
        [indexPathsOfSection addObject:
         [NSIndexPath indexPathForRow:i inSection:indexPath.section]];
    }
    
    
    if (indexPath.section == SHIPPING_TAG) {
        // refresh all
        for (ShippingModel *ship in self.dataSource.shippingList) {
            ship.selected = NO;
        }
        [self.tableView beginUpdates];
        [self.tableView reloadRowsAtIndexPaths:indexPathsOfSection
                              withRowAnimation:UITableViewRowAnimationNone];
        [self.tableView endUpdates];
        
        // 更新一条
        ShippingModel *theShip = self.dataSource.shippingList[indexPath.row];
        ShippingTableViewCell *cell = (ShippingTableViewCell*)[tableView cellForRowAtIndexPath:indexPath];
        theShip.selected = YES;
        [cell setNewData:theShip];
        self.flowDoneData.shippingId = theShip.shippingId;
        
    }
    
    if (indexPath.section == PAYMENT_TAG) {
        // refresh all
        for (PayModel *ship in self.dataSource.paymentList) {
            ship.selected = NO;
        }
        [self.tableView beginUpdates];
        [self.tableView reloadRowsAtIndexPaths:indexPathsOfSection
                              withRowAnimation:UITableViewRowAnimationNone];
        [self.tableView endUpdates];
        
        // 更新一条
        PayModel *theShip = self.dataSource.paymentList[indexPath.row];
        if (indexPath.row == 1) {
            payType = T(@"微信支付付款");
        }
        
        PaymentTableViewCell *cell = (PaymentTableViewCell*)[tableView cellForRowAtIndexPath:indexPath];
        theShip.selected = YES;
        [cell setNewData:theShip];
        self.flowDoneData.payId = theShip.payId;
        
    }
    
    if (indexPath.section == BONUS_TAG) {
        // refresh all
        for (BonusModel *ship in self.dataSource.bonusList) {
            ship.selected = NO;
        }
        [self.tableView beginUpdates];
        [self.tableView reloadRowsAtIndexPaths:indexPathsOfSection
                              withRowAnimation:UITableViewRowAnimationNone];
        [self.tableView endUpdates];
        
        // 更新一条
        BonusModel *theShip = self.dataSource.bonusList[indexPath.row];
        BonusTableViewCell *cell = (BonusTableViewCell*)[tableView cellForRowAtIndexPath:indexPath];
        theShip.selected = YES;
        [cell setNewData:theShip];
        self.flowDoneData.bounsId = theShip.bonusId;
        
    }
    
    [self refreshInfoView];
}


#pragma mark -
#pragma mark UITableViewDataSource


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [sectionTitles count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case CART_TAG:
            return [self.dataSource.goodsList count];
            break;
        case CONSIGNEE_TAG:
            return 1;
            break;
        case PAYMENT_TAG:
            return [self.dataSource.paymentList count];
            break;
        case SHIPPING_TAG:
            return [self.dataSource.shippingList count];
            break;
        case BONUS_TAG:
            NSLog(@"%@", self.dataSource.bonusList);
            return [self.dataSource.bonusList count];
            break;
        default:
            return 1;
            break;
    }
}

// 如何做选择某一个

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"FlowCell";
    
    if (indexPath.section == CART_TAG) {
        CartModel *cellData = self.dataSource.goodsList[indexPath.row];
        cellData.indexPath = indexPath;
        CartTableViewCell *cell = [[CartTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.passDelegate = self;
        [cell.imageRight setHidden:YES];
        [cell.changeCountBtn setHidden:YES];
        [cell setNewData:cellData];
        
        return cell;
    }else if (indexPath.section == CONSIGNEE_TAG){
        AddressModel *cellData = self.dataSource.consignee;
        cellData.indexPath = indexPath;
        AddressTableViewCell *cell = [[AddressTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.passDelegate = self;
        [cell setNewData:cellData];
        return cell;
    }else if (indexPath.section == PAYMENT_TAG){
        PayModel *cellData = self.dataSource.paymentList[indexPath.row];
        PaymentTableViewCell *cell = [[PaymentTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.passDelegate = self;
        [cell setNewData:cellData];
        return cell;
    }else if (indexPath.section == SHIPPING_TAG){
        ShippingModel *cellData = self.dataSource.shippingList[indexPath.row];
        ShippingTableViewCell *cell = [[ShippingTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.passDelegate = self;
        [cell setNewData:cellData];
        return cell;
    }else if (indexPath.section == BONUS_TAG){
        /** 红包 */
        BonusModel *cellData = self.dataSource.bonusList[indexPath.row];
        BonusTableViewCell *cell = [[BonusTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.passDelegate = self;
        [cell setNewData:cellData];
        return cell;
    }
    else{
        return nil;
    }
}

/////////////////////////////////////////////////////
#pragma mark - clear section line when cell is empty
/////////////////////////////////////////////////////

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, TOTAL_HEIGHT, H_30)];
    view.backgroundColor = GRAYEXLIGHTCOLOR;
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(H_20, 0, H_200, H_30)];
    label.text = sectionTitles[section];
    label.font = FONT_13;
    label.textColor = GRAYCOLOR;
    
    [view addSubview:label];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return H_30;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == CART_TAG || indexPath.section == SHIPPING_TAG) {
        return CELL_HEIGHT+H_20;
    }else{
        return CELL_HEIGHT;
    }
}


-(void) dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {
    [integralText resignFirstResponder];
}

#pragma mark - textField
//STR_INT([self.dataSource.yourIntegral integerValue]),
//STR_INT([self.dataSource.orderMaxIntegral integerValue])];

- (void)keyboardWillShow:(NSNotification *)notification {
    
    //获取键盘的高度
    NSDictionary *userInfo = [notification userInfo];
    
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    
    CGRect keyboardRect = [aValue CGRectValue];
    
    int height = keyboardRect.size.height;
    
    [UIView animateWithDuration:1 animations:^{
        self.tableView.y = self.tableView.y-height;
    }];
    
}

- (void)keyboardWillhide:(NSNotification *)notification {
    
    //获取键盘的高度
    
    NSDictionary *userInfo = [notification userInfo];
    
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    
    CGRect keyboardRect = [aValue CGRectValue];
    
    int height = keyboardRect.size.height;
    [UIView animateWithDuration:1 animations:^{
        self.tableView.y = self.tableView.y+height;
    }];
    
    NSString *integralString = [NSString stringWithFormat:@"我的积分: %@ , 最大可用积分:%@",
                                STR_INT([self.dataSource.yourIntegral integerValue]),
                                STR_INT([self.dataSource.orderMaxIntegral integerValue])];
    integralString = [NSString stringWithFormat:@"%@\n积分抵扣: -%.2f元",integralString,[integralText.text floatValue]/100];
    integralLabel.text = integralString;
    
    self.dataSource.payAmount = FLOAT(payAmount - [integralText.text floatValue]/100);
    summaryLabel.text = [NSString stringWithFormat:@"合计: %@",
                         STR_NUM2([self.dataSource.payAmount floatValue])];
    if (integralText.text.length == 0) {
    }
    
}


- (void)textFieldDidChange:(UITextField *) textField {
    
    if ([self.dataSource.yourIntegral integerValue] < [self.dataSource.orderMaxIntegral integerValue]) {
        if ([textField.text integerValue] > [self.dataSource.yourIntegral integerValue]) {
            integralText.text = STR_INT([self.dataSource.yourIntegral integerValue]);
        }
    } else {
        integralText.text = STR_INT([self.dataSource.orderMaxIntegral integerValue]);
        
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
