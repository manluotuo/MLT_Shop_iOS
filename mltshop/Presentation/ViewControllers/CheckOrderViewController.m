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

#define CART_TAG        0
#define CONSIGNEE_TAG   1
#define SHIPPING_TAG    2
#define PAYMENT_TAG     3
#define BONUS_TAG       4

@interface CheckOrderViewController ()<UITableViewDataSource, UITableViewDelegate, PassValueDelegate>
{
    NSArray *sectionTitles;
    UILabel *integralLabel;
    UILabel *summaryLabel;
    UILabel *bonusLabel;
    KKFlatButton *doneButton;
}

@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)FlowModel *dataSource;
@property (nonatomic, strong)UIView *infoView;


@end

@implementation CheckOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = T(@"结算页面");
    // Do any additional setup after loading the view.
    sectionTitles = @[@"商品列表",@"收货人", @"快递方式", @"支付方式",@"红包列表"];
    
    self.dataSource = [[FlowModel alloc]init];
    self.view.backgroundColor = BGCOLOR;
    self.editing = NO;
    self.infoView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, TOTAL_WIDTH, H_200)];
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

}

- (void)setupDataSource
{
    [[AppRequestManager sharedManager]flowCheckOrderWithBlock:^(id responseObject, NSError *error) {
        if(responseObject != nil){
            self.dataSource =  [[FlowModel alloc]initWithDict:responseObject];
            
            [self.tableView reloadData];
            [self refreshInfoView];
        }
    }];
}


- (void)refreshInfoView
{
    CGFloat payAmount = 0.0f;

    // 商品
    for (CartModel *cart in self.dataSource.goodsList) {
        payAmount += cart.subtotal.floatValue;
    }
    
    // 快递费
    for (ShippingModel *ship in self.dataSource.shippingList) {
        if (ship.selected) {
            payAmount += ship.shippingFee.floatValue;
            break;
        }
    }
    
    // 红白
    for (BonusModel * bonus in self.dataSource.shippingList) {
        if (bonus.selected) {
            bonusLabel.text = bonus.bonusName;
            payAmount -= bonus.bonusMoney.floatValue;
            break;
        }
    }
    
    self.dataSource.payAmount = FLOAT(payAmount);
    summaryLabel.text = [NSString stringWithFormat:@"合计: %@",
                         STR_NUM2([self.dataSource.payAmount floatValue])];
    
}

- (void)initInfoView
{
    self.infoView.backgroundColor = GRAYEXLIGHTCOLOR;
    integralLabel = [[UILabel alloc]initWithFrame:CGRectMake(H_20, TOP_PADDING, H_280, H_20)];
    integralLabel.font = FONT_12;
    NSString *integralString = [NSString stringWithFormat:@"我的积分: %@ , 最大可用积分:%@",
                                STR_INT([self.dataSource.yourIntegral integerValue]),
                                STR_INT([self.dataSource.orderMaxIntegral integerValue])];
    integralLabel.text = integralString;
    
    bonusLabel = [[UILabel alloc]initWithFrame:CGRectMake(H_20, TOP_PADDING+H_30, H_200, H_30)];
    
    summaryLabel = [[UILabel alloc]initWithFrame:CGRectMake(H_20, TOP_PADDING+H_30*2, H_100, H_40)];
    summaryLabel.textColor = REDCOLOR;
    
    doneButton = [KKFlatButton buttonWithType:UIButtonTypeCustom];
    [doneButton setFrame:CGRectMake(H_160, TOP_PADDING+H_30*2, H_100, H_40)];
    [doneButton setTitle:T(@"确认") forState:UIControlStateNormal];
    

    [self.infoView addSubview:integralLabel];
    [self.infoView addSubview:bonusLabel];
    [self.infoView addSubview:summaryLabel];
    [self.infoView addSubview:doneButton];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
