//
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

#import <AlipaySDK/AlipaySDK.h>
#import "Order.h"
#import "DataSigner.h"


@interface OrderListViewController ()<UITableViewDataSource, UITableViewDelegate, PullListViewDelegate, PassValueDelegate>

@property(nonatomic, strong)NSMutableArray *dataArray;
@property(nonatomic, strong)UIView *footerView;
@property(nonatomic, strong)KKFlatButton *flowButton;
@property(nonatomic, strong)OrderModel *theOrder;

@end

@implementation OrderListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.commonListDelegate = self;
    self.dataSourceType = ListDataSourceOrder;
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableView.y = IOS7_CONTENT_OFFSET_Y;
    self.tableView.height = TOTAL_HEIGHT - IOS7_CONTENT_OFFSET_Y;
    
    self.dataArray = [[NSMutableArray alloc]init];
    
//    [self initDataSource];
    //    [self setUpImageDownButton:0];
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
    if([value isEqualToString:SIGNAL_ORDER_ACTION]){
        OrderModel *theOrder = data;
        NSMutableArray *titles = [[NSMutableArray alloc]init];
        if ([theOrder.paymentType isEqualToString:@"UNPAYED"]) {
            [titles addObject:@"支付宝付款.买买买!!!"];
        }else{
            [titles addObject:@"暂无操作"];
        }
        [SGActionView showSheetWithTitle:T(@"操作订单") itemTitles:titles selectedIndex:100 selectedHandle:^(NSInteger index) {
            if (index == 0) {
                // 调取支付宝接口
                [self doAlipayAction:theOrder];
            }
        }];
    }
}

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
    order.productName = theOrder.subject; //商品标题
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
    self.dataArray = [[NSMutableArray alloc]init];
    [[AppRequestManager sharedManager]operateOrderWithCartModel:self.theOrder operation:OrderOpsList andBlock:^(id responseObject, NSError *error) {
        
        if (responseObject != nil) {
            // 集中处理所有的数据
            
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
            }else{
                [DataTrans showWariningTitle:T(@"你还没有订单")
                               andCheatsheet:[NSString fontAwesomeIconStringForEnum:FAInfoCircle]
                                 andDuration:1.0f];
                [self showSetupDataSource:self.dataArray andError:nil];
            }
            
        }
        if (error != nil) {
            [DataTrans showWariningTitle:T(@"获取地址列表有误") andCheatsheet:ICON_TIMES andDuration:1.5f];
        }
        
    }];
}

- (void)recomendNewItems
{
    [self setupDataSource];
}

- (void)recomendOldItems
{
    //    [self setupDataSource];
}



#pragma mark -
#pragma mark UITableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return H_50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return CELL_HEIGHT +H_20;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    OrderTableViewCell *cellview = [[OrderTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    [cellview setFrame:CGRectMake(0, 0, TOTAL_WIDTH, H_40)];
    [cellview setNewData:self.dataArray[section]];
    cellview.passDelegate = self;
    return cellview;
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
