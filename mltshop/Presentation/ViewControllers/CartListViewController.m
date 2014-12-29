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

@interface CartListViewController ()<UITableViewDataSource, UITableViewDelegate, PullListViewDelegate, PassValueDelegate>

@property(nonatomic, strong)NSMutableArray *dataArray;
@property(nonatomic, strong)NSMutableDictionary *totalInfo;
@property(nonatomic, strong)UIView *footerView;

@end

@implementation CartListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = T(@"地址管理");
    self.commonListDelegate = self;
    self.dataSourceType = ListDataSourceCart;
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableView.y = IOS7_CONTENT_OFFSET_Y;
    self.tableView.height = TOTAL_HEIGHT - IOS7_CONTENT_OFFSET_Y;
    
    self.dataArray = [[NSMutableArray alloc]init];
    
    [self initDataSource];
//    [self setUpImageDownButton:0];
}

- (void)initDataSource
{
    [super initDataSource];
}

- (void)initFooterView:(NSDictionary *)total
{
    self.footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, TOTAL_WIDTH, H_100)];
    self.footerView.backgroundColor = WHITECOLOR;
    
    UIView *lineView1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, TOTAL_WIDTH, 1)];
    lineView1.backgroundColor = GRAYEXLIGHTCOLOR;

    UILabel *totalShopPrice = [[UILabel alloc]initWithFrame:CGRectMake(H_40, H_20, H_200, H_20)];
    totalShopPrice.textColor = REDCOLOR;
    UILabel *totalMarketPrice = [[UILabel alloc]initWithFrame:CGRectMake(H_40, H_40, H_200, H_20)];
    totalMarketPrice.textColor = GRAYLIGHTCOLOR;
    UILabel *savingPrice = [[UILabel alloc]initWithFrame:CGRectMake(H_40, H_60, H_200, H_20)];
    savingPrice.textColor = GREENCOLOR;
    
    totalShopPrice.font = CUSTOMFONT;
    totalMarketPrice.font = LITTLECUSTOMFONT;
    savingPrice.font = LITTLECUSTOMFONT;

    NSNumber *t1 = total[@"total_shop_price"];
    NSNumber *t2 = total[@"total_market_price"];
    NSNumber *t3 = total[@"saving"];
    totalShopPrice.text = [NSString stringWithFormat:@"总计: %.2f元", [t1 floatValue]];
    totalMarketPrice.text = [NSString stringWithFormat:@"市场总价: %.2f", [t2 floatValue]];
    savingPrice.text = [NSString stringWithFormat:@"共节省: %.2f元 %@", [t3 floatValue], total[@"save_rate"]];
    
    [self.footerView addSubview:totalShopPrice];
    [self.footerView addSubview:totalMarketPrice];
    [self.footerView addSubview:savingPrice];
    [self.footerView addSubview:lineView1];
    
    self.tableView.tableFooterView = self.footerView;

}



/**
 *  初始化文章 two goods one line
 */
- (void)setupDataSource {
    self.start = 0;
    self.dataArray = [[NSMutableArray alloc]init];
    self.totalInfo = [[NSMutableDictionary alloc]init];
    [[AppRequestManager sharedManager]operateCartWithAddress:nil operation:CartOpsList andBlock:^(id responseObject, NSError *error) {
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
            }else{
                [DataTrans showWariningTitle:T(@"购物车空空如也")
                               andCheatsheet:[NSString fontAwesomeIconStringForEnum:FAInfoCircle]
                                 andDuration:1.0f];
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
                [[AppRequestManager sharedManager]operateCartWithAddress:theCart operation:CartOpsDelete andBlock:^(id responseObject, NSError *error) {
                    [self setupDataSource];
                }];
            }else{
                theCart.goodsCount = INT(index);
                [[AppRequestManager sharedManager]operateCartWithAddress:theCart operation:CartOpsUpdate andBlock:^(id responseObject, NSError *error) {
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

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        AddressModel *vehicleModel = self.dataArray[indexPath.row];
        [[AppRequestManager sharedManager]operateAddressWithAddress:vehicleModel operation:AddressOpsDelete andBlock:^(id responseObject, NSError *error) {
            if (responseObject != nil) {
                [self.dataArray removeObjectAtIndex:indexPath.row];
                [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            }
            
        }];
    }
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
