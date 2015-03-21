//
//  AddressListViewController.m
//  mltshop
//
//  Created by mactive.meng on 21/12/14.
//  Copyright (c) 2014 manluotuo. All rights reserved.
//

#import "AddressListViewController.h"
#import "AppRequestManager.h"
#import "AddressInfoViewController.h"
#import "UIViewController+ImageBackButton.h"

@interface AddressListViewController ()<UITableViewDataSource, UITableViewDelegate, PullListViewDelegate, PassValueDelegate>

@property(nonatomic, strong)NSMutableArray *dataArray;
@end

@implementation AddressListViewController

- (void)viewDidLoad {

    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = T(@"地址管理");
    self.commonListDelegate = self;
    self.dataSourceType = ListDataSourceAddress;
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableView.y = IOS7_CONTENT_OFFSET_Y;
    self.tableView.height = TOTAL_HEIGHT - IOS7_CONTENT_OFFSET_Y;

    self.dataArray = [[NSMutableArray alloc]init];
    
    [self initDataSource];
    [self setUpImageDownButton:0];
    [self setupRightAddButton];
}

- (void)setupRightAddButton
{
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 30)];
    [backButton setTitle:T(@"新增") forState:UIControlStateNormal];
    
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.rightBarButtonItem = leftBarButtonItem;
    [backButton addTarget:self action:@selector(addAction) forControlEvents:UIControlEventTouchUpInside];
}

- (void)addAction
{
    AddressInfoViewController *vc = [[AddressInfoViewController alloc]init];
    [vc setNewData:[[AddressModel alloc]initWithDict:nil]];
    vc.passDelegate = self;
    
    [self.navigationController pushViewController:vc animated:YES];
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
    [[AppRequestManager sharedManager]getAddressListWithBlock:^(id responseObject, NSError *error) {
        if (responseObject != nil) {
            // 集中处理所有的数据
            NSUInteger count = [responseObject count];
            for (int i = 0 ; i < count; i++) {
                AddressModel *oneAddress = [[AddressModel alloc]initWithDict:responseObject[i]];
                [self.dataArray addObject:oneAddress];
            }
            NSLog(@"Online setupDataSource ======== ");
            [self showSetupDataSource:self.dataArray andError:nil];
            self.start = self.start + 1;
            NSLog(@"start %ld",(long)self.start);
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    if (self.dataSource.count == 0) {
        [user setValue:@"NO" forKey:@"address"];
        [user setValue:@"NO" forKey:@"OK"];
        [user synchronize];
    } else {
        [user setValue:@"YES" forKey:@"OK"];
        [user setValue:@"YES" forKey:@"address"];
        [user synchronize];
    }
    return [self.dataSource count];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    AddressInfoViewController *vc = [[AddressInfoViewController alloc]initWithNibName:nil bundle:nil];
    [vc setNewData:[self.dataSource objectAtIndex:indexPath.row]];
    vc.passDelegate =self;
    [self.navigationController pushViewController:vc animated:YES];

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
                if (self.dataArray.count == 0) {
                    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
                    [user setValue:@"NO" forKey:@"address"];
                    [user synchronize];
                }
            }

        }];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)createGetMoreData {
    
}

- (void)viewDidAppear:(BOOL)animated {
    if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"OK"] isEqualToString:@"NO"]) {
        [self addAction];
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
