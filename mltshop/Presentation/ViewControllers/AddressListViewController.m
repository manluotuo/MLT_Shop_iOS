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

@interface AddressListViewController ()<UITableViewDataSource, UITableViewDelegate, PullListViewDelegate, PassValueDelegate>

@end

@implementation AddressListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.commonListDelegate = self;
    self.dataSourceType = ListDataSourceAddress;
    
    [self initDataSource];
    
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
    [[AppRequestManager sharedManager]getAddressListWithBlock:^(id responseObject, NSError *error) {
        if (responseObject != nil) {
            // 集中处理所有的数据
            NSMutableArray *goodsArray = [[NSMutableArray alloc]init];
            NSUInteger count = [responseObject count];
            for (int i = 0 ; i < count; i++) {
                AddressModel *oneAddress = [[AddressModel alloc]initWithDict:responseObject[i]];
                [goodsArray addObject:oneAddress];
            }
            NSLog(@"Online setupDataSource ======== ");
            [self showSetupDataSource:goodsArray andError:nil];
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
