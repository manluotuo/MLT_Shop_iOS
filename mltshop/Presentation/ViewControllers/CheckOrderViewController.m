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
#import "AppRequestManager.h"

#define CART_TAG        0
#define CONSIGNEE_TAG   1
#define PAYMENT_TAG     2
#define SHIPPING_TAG    3
#define BONUS_TAG       4
#define DETAIL_TAG      5

@interface CheckOrderViewController ()<UITableViewDataSource, UITableViewDelegate, PassValueDelegate>
{
    NSArray *sectionTitles;
}

@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)FlowModel *dataSource;


@end

@implementation CheckOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = T(@"结算页面");
    // Do any additional setup after loading the view.
    sectionTitles = @[@"商品列表",@"收货人", @"快递方式", @"支付方式",@"红包列表",@"汇总信息"];
    
    self.dataSource = [[FlowModel alloc]init];
    self.view.backgroundColor = BGCOLOR;
    self.editing = NO;
    
    self.tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.backgroundColor = BGCOLOR;
    self.tableView.separatorStyle = UITableViewCellSelectionStyleGray;
    self.tableView.separatorColor = SEPCOLOR;
    
    self.tableView.delegate = self;
    self.tableView.dataSource  = self;
    
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }

    [self.view addSubview:self.tableView];

}

- (void)setupDataSource
{
    [[AppRequestManager sharedManager]flowCheckOrderWithBlock:^(id responseObject, NSError *error) {
        if(responseObject != nil){
            self.dataSource =  [[FlowModel alloc]initWithDict:responseObject];
            [self.tableView reloadData];
        }
    }];
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
        case DETAIL_TAG:
            return 1;
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
        AddressTableViewCell *cell = [[AddressTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.passDelegate = self;
        [cell setNewData:cellData];
        return cell;
    }
    else{
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        return cell;
    }
}

/////////////////////////////////////////////////////
#pragma mark - clear section line when cell is empty
/////////////////////////////////////////////////////

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return sectionTitles[section];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return H_30;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == CART_TAG) {
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
