//
//  BrandListViewController.m
//  mltshop
//
//  Created by mactive.meng on 18/1/15.
//  Copyright (c) 2015 manluotuo. All rights reserved.
//

#import "BrandListViewController.h"
#import "AppRequestManager.h"
#import "SGActionView.h"
#import "UIViewController+ImageBackButton.h"
#import "ListViewController.h"

@interface BrandListViewController ()<UITableViewDataSource, UITableViewDelegate, PullListViewDelegate, PassValueDelegate>

@property(nonatomic, strong)NSMutableArray *dataArray;

@end

@implementation BrandListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = T(@"品牌街");
    self.commonListDelegate = self;
    self.dataSourceType = ListDataSourceBrand;
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableView.y = IOS7_CONTENT_OFFSET_Y;
    self.tableView.height = TOTAL_HEIGHT - IOS7_CONTENT_OFFSET_Y;
    
    self.dataArray = [[NSMutableArray alloc]init];
    
    [self initDataSource];
    //    [self setUpImageDownButton:0];
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
    if ([value isEqualToString:SIGNAL_TAP_CELL]) {
        BrandModel *theBrand = data;
        ListViewController *VC = [[ListViewController alloc]initWithNibName:nil bundle:nil];
        VC.search = [[SearchModel alloc]init];
        VC.search.brandId= theBrand.brandId;
        VC.title = theBrand.brandName;
        [VC setUpDownButton:0];
        ColorNavigationController *nav = [[ColorNavigationController alloc]initWithRootViewController:VC];
        [self.navigationController presentViewController:nav animated:nil completion:nil];
    }
}
/**
 *  初始化文章 two goods one line
 */
- (void)setupDataSource {
    self.start = 0;
    self.dataArray = [[NSMutableArray alloc]init];
    [[AppRequestManager sharedManager]getBrandAllWithBlock:^(id responseObject, NSError *error) {
        if (responseObject != nil) {
            // 集中处理所有的数据
            NSUInteger count = [responseObject count];
            if (ArrayHasValue(responseObject)) {
                for (int i = 0 ; i < count; i++) {
                    BrandModel *oneOrder = [[BrandModel alloc]initWithDict:responseObject[i]];
                    [self.dataArray addObject:oneOrder];
                }
                NSLog(@"Online setupDataSource ======== ");
                [self showSetupDataSource:self.dataArray andError:nil];
                self.start = self.start + 1;
                NSLog(@"start %ld",(long)self.start);
            }
        }
    }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.001;
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



@end
