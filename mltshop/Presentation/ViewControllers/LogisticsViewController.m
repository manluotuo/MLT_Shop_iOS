//
//  LogisticsViewController.m
//  mltshop
//
//  Created by 小新 on 15/3/27.
//  Copyright (c) 2015年 manluotuo. All rights reserved.
//

#import "LogisticsViewController.h"
#import "FAHoverButton.h"
#import "JHAPISDK.h"
#import "JHOpenidSupplier.h"
#import "LogisticsModel.h"
#import "LogisticsTableViewCell.h"
#import "LogisticsFirstTableViewCell.h"

@interface LogisticsViewController()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;


@end

@implementation LogisticsViewController {
    HTProgressHUD *HUD;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.title = @"物流信息";
    [self.view setBackgroundColor:WHITEALPHACOLOR];
    self.dataArray = [[NSMutableArray alloc] init];
    [[JHOpenidSupplier shareSupplier] registerJuheAPIByOpenId:JUHE_OPENID];
    [self doTestAction];
    [self customUI];
    [self setupleftButton];
    self.tableView.y = IOS7_CONTENT_OFFSET_Y;
    self.tableView.height = TOTAL_HEIGHT - IOS7_CONTENT_OFFSET_Y;
    
}

- (void)customUI {
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    self.tableView.delegate   = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    
    HUD = [[HTProgressHUD alloc] init];
    HUD.indicatorView = [HTProgressHUDIndicatorView indicatorViewWithType:HTProgressHUDIndicatorTypeActivityIndicator];
    HUD.text = T(@"正在载入物流信息...");
    [HUD showInView:self.view];
}

/** 设置导航栏按钮 */
- (void)setupleftButton
{
    CGFloat leftMargin = 10.0f;
    FAHoverButton *backButton = [[FAHoverButton alloc] initWithFrame:CGRectMake(0, 0, 12+leftMargin, 21)];
    [backButton setTitle:ICON_BACK forState:UIControlStateNormal];
    [backButton.titleLabel setFont:FONT_AWESOME_36];
    [backButton setImageEdgeInsets:UIEdgeInsetsMake(0, leftMargin, 0, 0)];
    
    
    UIBarButtonItem *barBackButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    [backButton addTarget:self action:@selector(onLeftBtnClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = barBackButtonItem;
    self.navigationItem.hidesBackButton = YES;
}

- (void)doTestAction
{
    //    ***************** LIFE ***************
    //    /*IP*/
    NSString *path = @"http://v.juhe.cn/exp/index";
    NSString *api_id = @"43";
    NSString *method = @"GET";
    NSDictionary *param = @{@"com":@"zto", @"no":self.invoice_no};
    JHAPISDK *juheapi = [JHAPISDK shareJHAPISDK];
    
    [juheapi executeWorkWithAPI:path
                          APIID:api_id
                     Parameters:param
                         Method:method
                        Success:^(id responseObject){
                            [HUD removeFromSuperview];
                            if ([[param objectForKey:@"dtype"] isEqualToString:@"xml"]) {
                                NSLog(@"***xml*** \n %@", responseObject);
                            }else{
                                int error_code = [[responseObject objectForKey:@"error_code"] intValue];
                                if (!error_code) {
                                    for (NSDictionary *dict in responseObject[@"result"][@"list"]) {
                                        LogisticsModel *model = [[LogisticsModel alloc] init];
                                        [model setValuesForKeysWithDictionary:dict];
                                        [self.dataArray addObject:model];
                                    }
                                    [self.tableView reloadData];
                                }else{
                                    UILabel *lable =[[UILabel alloc] initWithFrame:CGRectMake(30, TOTAL_HEIGHT/2-50, WIDTH-60, 50)];
                                    lable.text = T(@"该商品暂无物流信息");
                                    lable.textAlignment = UIBaselineAdjustmentAlignCenters;
                                    [self.view addSubview:lable];
                                }
                            }
                        } Failure:^(NSError *error) {
                            [HUD removeFromSuperview];
                            NSLog(@"error:   %@",error.description);
                        }];
    
}


/** 导航栏按钮点击事件 */
- (void)onLeftBtnClick {
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSLog(@"%d", self.dataArray.count);
    return [self.dataArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        LogisticsFirstTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        if (!cell) {
            cell = [[LogisticsFirstTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        }
        LogisticsModel *model = self.dataArray[self.dataArray.count - indexPath.row - 1];
        [cell setNewData:model andType:YES];
        return cell;
    } else {
        LogisticsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellId"];
        if (!cell) {
            cell = [[LogisticsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellId"];
            tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        }
        LogisticsModel *model = self.dataArray[self.dataArray.count - indexPath.row - 1];
        [cell setNewData:model andType:NO];
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    LogisticsModel *model = self.dataArray[self.dataArray.count - indexPath.row - 1];
    CGSize size = [model.remark sizeWithWidth:WIDTH-H_60 andFont:FONT_14];
    
    return H_10+size.height+H_15+H_25;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.0001;
}

@end
