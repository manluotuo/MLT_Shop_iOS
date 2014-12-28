//
//  CartListViewController.m
//  mltshop
//
//  Created by mactive.meng on 28/12/14.
//  Copyright (c) 2014 manluotuo. All rights reserved.
//

#import "CartListViewController.h"
#import "AppRequestManager.h"
#import "UIViewController+ImageBackButton.h"

@interface CartListViewController ()<UITableViewDataSource, UITableViewDelegate, PullListViewDelegate, PassValueDelegate>

@property(nonatomic, strong)NSMutableArray *dataArray;
@property(nonatomic, strong)NSMutableDictionary *totalInfo;

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
            NSUInteger count = [goodsList count];
            self.totalInfo = responseObject[@"total"];
            if (ArrayHasValue(goodsList)) {
                for (int i = 0 ; i < count; i++) {
                    CartModel *oneCart = [[CartModel alloc]initWithDict:goodsList[i]];
                    NSLog(@"%@",goodsList[i]);
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
    if ([value isEqualToString:SIGNAL_ADDRESS_OPERATE_DONE]) {
        [self setupDataSource];
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
