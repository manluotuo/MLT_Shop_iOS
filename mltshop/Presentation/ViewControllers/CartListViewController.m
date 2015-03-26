//
//  CartListViewController.m
//  mltshop
//
//  Created by mactive.meng on 28/12/14.
//  Copyright (c) 2014 manluotuo. All rights reserved.
//

#import "CartListViewController.h"
#import "AppRequestManager.h"
#import "SGActionView.h"
#import "UIViewController+ImageBackButton.h"
#import "KKFlatButton.h"
#import "CheckOrderViewController.h"
#import "AppDelegate.h"
#import "AddressInfoViewController.h"
#import "AddressListViewController.h"


@interface CartListViewController ()<UITableViewDataSource, UITableViewDelegate, PullListViewDelegate, PassValueDelegate>

@property(nonatomic, strong)NSMutableArray *addressArray;
@property(nonatomic, strong)NSMutableArray *dataArray;
@property(nonatomic, strong)NSMutableDictionary *totalInfo;
@property(nonatomic, strong)UIView *footerView;
@property(nonatomic, strong)KKFlatButton *flowButton;

@end

@implementation CartListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = T(@"购物车");
    self.commonListDelegate = self;
    self.dataSourceType = ListDataSourceCart;
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableView.y = IOS7_CONTENT_OFFSET_Y;
    self.tableView.height = TOTAL_HEIGHT - IOS7_CONTENT_OFFSET_Y;
    
    self.dataArray = [[NSMutableArray alloc]init];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gotoIndex) name:SIGNAL_GO_TO object:nil];
    
    [self initDataSource];
    [self setupAddressData];
//    [self setUpImageDownButton:0];
}

- (void)setupAddressData {
    
    self.addressArray = [[NSMutableArray alloc]init];
    [[AppRequestManager sharedManager]getAddressListWithBlock:^(id responseObject, NSError *error) {
        if (responseObject != nil) {
            // 集中处理所有的数据
            NSUInteger count = [responseObject count];
            for (int i = 0 ; i < count; i++) {
                AddressModel *oneAddress = [[AddressModel alloc]initWithDict:responseObject[i]];
                [self.addressArray addObject:oneAddress];
                NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
                if (self.addressArray.count == 0) {
                    [user setValue:@"NO" forKey:@"address"];
                } else {
                    [user setValue:@"YES" forKey:@"address"];
                }
                [user synchronize];
            }
        }
    }];
}


- (void)gotoIndex {
    [self dismissViewControllerAnimated:NO completion:^{
        [self gotoIndexAction];
    }];
}

- (void)setUpDownButton:(NSInteger)position
{
    [self setUpImageDownButton:0];
}

- (void)initDataSource
{
    [super initDataSource];
}

- (void)initFooterView:(NSDictionary *)total
{
    self.footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, TOTAL_WIDTH, H_150)];
    self.footerView.backgroundColor = WHITECOLOR;
    
    UIView *lineView1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, TOTAL_WIDTH, 1)];
    lineView1.backgroundColor = GRAYEXLIGHTCOLOR;

    UILabel *totalShopPrice = [[UILabel alloc]initWithFrame:CGRectMake(H_60, H_20, H_200, H_24)];
    totalShopPrice.textColor = REDCOLOR;
    UILabel *totalMarketPrice = [[UILabel alloc]initWithFrame:CGRectMake(H_60, H_20+H_22, H_200, H_50)];
    totalMarketPrice.textColor = GRAYLIGHTCOLOR;
    totalMarketPrice.numberOfLines = 0;
    
    
    totalShopPrice.font = CUSTOMFONT;
    totalMarketPrice.font = LITTLECUSTOMFONT;

    NSNumber *t1 = total[@"total_shop_price"];
    NSNumber *t2 = total[@"total_market_price"];
    NSNumber *t3 = total[@"saving"];
    totalShopPrice.text = [NSString stringWithFormat:@"总计: %.2f元", [t1 floatValue]];
    NSString *t2String = [NSString stringWithFormat:@"市场价: %.2f元\n", [t2 floatValue]];
    NSString *t3String = [NSString stringWithFormat:@"共节省: %.2f元 (%@)", [t3 floatValue], total[@"save_rate"]];
    
    totalMarketPrice.text = [t2String stringByAppendingString:t3String];
    
    self.flowButton = [KKFlatButton buttonWithType:UIButtonTypeCustom];
    [self.flowButton setFrame:CGRectMake(H_60, H_24+H_24*3, H_200, H_40)];
    [self.flowButton setTitle:T(@"去结算") forState:UIControlStateNormal];
    [self.flowButton setTitleColor:GREENCOLOR andStyle:KKFlatButtonStyleBordered];
    [self.flowButton addTarget:self action:@selector(checkOrderAction) forControlEvents:UIControlEventTouchUpInside];
    
    [self.footerView addSubview:totalShopPrice];
    [self.footerView addSubview:totalMarketPrice];
    [self.footerView addSubview:lineView1];
    [self.footerView addSubview:self.flowButton];
    
    self.tableView.tableFooterView = self.footerView;

}


- (void)checkOrderAction
{
    if ([self.dataArray count] > 0) {
        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
        
        if ([[user valueForKey:@"address"] isEqualToString:@"YES"]) {
        CheckOrderViewController *VC = [[CheckOrderViewController alloc]initWithNibName:nil bundle:nil];
        [VC setupDataSource];
            
            [self.navigationController pushViewController:VC animated:YES];
            
        } else {
            [DataTrans showWariningTitle:T(@"请您先填写地址") andCheatsheet:ICON_INFO andDuration:1.0f];
            AddressListViewController *address = [[AddressListViewController alloc] init];
            ColorNavigationController *nav = [[ColorNavigationController alloc] initWithRootViewController:address];
            NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
            [user setValue:@"NO" forKey:@"OK"];
            [user synchronize];
            [self presentViewController:nav animated:YES completion:nil];
        }
    }else{
        // 去首页逛逛
        // 发通知
        [self gotoIndexAction];
        
    }
}

-(void)gotoIndexAction
{
    [self dismissViewControllerAnimated:NO completion:^{
        [[NSNotificationCenter defaultCenter] postNotificationName:SIGNAL_GO_TO_INDEX_PAGE object:nil userInfo:nil];
    }];
    [XAppDelegate showDrawerView];
}



/**
 *  初始化文章 two goods one line
 */
- (void)setupDataSource {
    self.start = 0;
    self.dataArray = [[NSMutableArray alloc]init];
    self.totalInfo = [[NSMutableDictionary alloc]init];
    [[AppRequestManager sharedManager]operateCartWithCartModel:nil operation:CartOpsList andBlock:^(id responseObject, NSError *error) {
        if (responseObject != nil) {
            // 集中处理所有的数据
            NSArray *goodsList = responseObject[@"goods_list"];
            [self initFooterView:responseObject[@"total"]];
            
            NSUInteger count = [goodsList count];
            self.totalInfo = responseObject[@"total"];
            if (ArrayHasValue(goodsList)) {
                for (int i = 0 ; i < count; i++) {
                    CartModel *oneCart = [[CartModel alloc]initWithDict:goodsList[i]];
                    [self.dataArray addObject:oneCart];
                }
                NSLog(@"Online setupDataSource ======== ");
                [self showSetupDataSource:self.dataArray andError:nil];
                self.start = self.start + 1;
                NSLog(@"start %ld",(long)self.start);
                
                [self.flowButton setTitle:T(@"去结算") forState:UIControlStateNormal];

            }else{
                [DataTrans showWariningTitle:T(@"购物车空空如也")
                               andCheatsheet:[NSString fontAwesomeIconStringForEnum:FAInfoCircle]
                                 andDuration:1.0f];
                [self showSetupDataSource:self.dataArray andError:nil];
                [self.flowButton setTitle:T(@"去首页逛逛") forState:UIControlStateNormal];

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


- (void)passSignalValue:(NSString *)value andData:(id)data
{
    CartModel * theCart = data;
    if ([value isEqualToString:SIGNAL_CHANGE_CART_GOODS_COUNT]) {
        NSArray *titles = @[@"删除", @"1", @"2", @"3", @"4", @"5", @"6", @"7"];
        [SGActionView showGridMenuWithTitle:T(@"选择数量") itemTitles:titles images:nil selectedHandle:^(NSInteger index) {
            if (index ==0) {
                [[AppRequestManager sharedManager]operateCartWithCartModel:theCart operation:CartOpsDelete andBlock:^(id responseObject, NSError *error) {
                    [self setupDataSource];
                }];
            }else{
                theCart.goodsCount = INT(index);
                [[AppRequestManager sharedManager]operateCartWithCartModel:theCart operation:CartOpsUpdate andBlock:^(id responseObject, NSError *error) {
                    if (responseObject != nil) {
                        [self setupDataSource];
                    }
                }];
            }
        }];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    修改数量
//    sgaction
}

//- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
//    return UITableViewCellEditingStyleDelete;
//}
//
//- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if (editingStyle == UITableViewCellEditingStyleDelete) {
//        AddressModel *vehicleModel = self.dataArray[indexPath.row];
//        [[AppRequestManager sharedManager]operateAddressWithAddress:vehicleModel operation:AddressOpsDelete andBlock:^(id responseObject, NSError *error) {
//            if (responseObject != nil) {
//                [self.dataArray removeObjectAtIndex:indexPath.row];
//                [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
//            }
//            
//        }];
//    }
//}

- (void)createGetMoreData {
    
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
