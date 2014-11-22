//
//  ListOnlineViewController.m
//  merchant
//
//  Created by mactive.meng on 13/6/14.
//  Copyright (c) 2014 kkche. All rights reserved.
//

#import "ListOnlineViewController.h"
#import "AppRequestManager.h"
#import "SGActionView.h"
#import "ColorNavigationController.h"

@interface ListOnlineViewController ()<UITableViewDataSource, UITableViewDelegate, PullListViewDelegate, PassValueDelegate>

@end

@implementation ListOnlineViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.commonListDelegate = self;

//    [self initDataSource];
    
}

- (void)initDataSource
{
    [super initDataSource];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

////////////////////////////////////////////////////////////
#pragma mark - Network Actions
////////////////////////////////////////////////////////////

/**
 *  初始化文章
 */
- (void)setupDataSource {
    
    self.start = 0;
    [[AppRequestManager sharedManager] listVehicleWithMerchantId:@""
                                                     substituted:YES
                                                         andPage:self.start
                                                         andSize:20
                                                       andStatus:[self.categoryId stringValue]
                                                        andBlock:^(id responseObject, NSError *error) {
        if (responseObject != nil) {
            // 集中处理所有的数据
            NSMutableArray *vehicleArray = [[NSMutableArray alloc]init];
            for (id jsonData in responseObject) {
//                Vehicle * cellData = [DataTrans vehilceFromDict:jsonData];
//                NSLog(@"Online setupDataSource %@ %@ %.2f",cellData.brand, cellData.series, [cellData.quotedPrice floatValue]);
//                [vehicleArray addObject:cellData];
            }
            NSLog(@"Online setupDataSource ======== ");
            [self showSetupDataSource:vehicleArray andError:nil];
            self.start = self.start + 1;
            NSLog(@"start %d",self.start);
        }
        if (error != nil) {
            [DataTrans showWariningTitle:T(@"获取车辆列表有误") andCheatsheet:ICON_TIMES andDuration:1.5f];
        }
    }];
}

/**
 *  推荐新的文章
 */
- (void)recomendNewItems
{
    [self setupDataSource];
}


/**
 *  推荐旧的文章
 */
- (void)recomendOldItems
{
    NSLog(@"start %d",self.start);
    
    [[AppRequestManager sharedManager] listVehicleWithMerchantId:@""
                                                     substituted:YES
                                                         andPage:self.start
                                                         andSize:20
                                                       andStatus:[self.categoryId stringValue]
                                                        andBlock:^(id responseObject, NSError *error) {
        if (responseObject != nil) {
            //
            NSMutableArray *vehicleArray = [[NSMutableArray alloc]init];
            for (id jsonData in responseObject) {
//                Vehicle * cellData = [DataTrans vehilceFromDict:jsonData];
//                [vehicleArray addObject:cellData];
            }
            [self showRecomendOldItems:vehicleArray andError:error];
            self.start = self.start + 1;
        }
        if (error != nil) {
            [DataTrans showWariningTitle:T(@"获取车辆列表有误") andCheatsheet:ICON_TIMES andDuration:1.5f];
        }
                                                            
    }];

}


@end
