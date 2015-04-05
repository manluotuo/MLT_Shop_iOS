//
//  LimitViewController.m
//  mltshop
//
//  Created by 小新 on 15/3/21.
//  Copyright (c) 2015年 manluotuo. All rights reserved.
//

#import "LimitViewController.h"
#import "AppRequestManager.h"
#import "SGActionView.h"
#import "UIViewController+ImageBackButton.h"
#import "KKFlatButton.h"
#import "CheckOrderViewController.h"
#import "AppDelegate.h"
#import "LimitModel.h"
#import "LimitGoodsTableViewCell.h"
#import "GoodsDetailViewController.h"
#import "FAHoverButton.h"
/** 限时特价 */

@interface LimitViewController ()<UITableViewDataSource, UITableViewDelegate, PassValueDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) UILabel *lable;
@property(nonatomic, strong)FAHoverButton *leftDrawerAvatarButton;
@end

@implementation LimitViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setData];
    [self customUI];
    [self setupLeftMenuButton];
    self.dataArray = [[NSMutableArray alloc] init];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableView.y = IOS7_CONTENT_OFFSET_Y;
    self.tableView.height = TOTAL_HEIGHT - IOS7_CONTENT_OFFSET_Y;
}

- (void)setupLeftMenuButton {
    
    self.leftDrawerAvatarButton = [FAHoverButton buttonWithType:UIButtonTypeCustom];
    [self.leftDrawerAvatarButton setTitle:ICON_BARS forState:UIControlStateNormal];
    [self.leftDrawerAvatarButton setFrame:CGRectMake(0, 0, ROUNDED_BUTTON_HEIGHT, ROUNDED_BUTTON_HEIGHT)];
    [self.leftDrawerAvatarButton addTarget:self action:@selector(leftDrawerButtonPress:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem * leftDrawerButton = [[UIBarButtonItem alloc]initWithCustomView:self.leftDrawerAvatarButton];
    
    [self.navigationItem setLeftBarButtonItem:leftDrawerButton animated:YES];
}

- (void)customUI {
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    
}

- (void)setData {
    
    [[AppRequestManager sharedManager]setLimitDataBlock:^(id responseObject, NSError *error) {
        if (responseObject != nil) {
            for (NSDictionary *dict in responseObject[@"data"]) {
            LimitModel *model = [[LimitModel alloc] init];
            [model setValuesForKeysWithDictionary:dict];
            [self.dataArray addObject:model];
            }
            [self.tableView reloadData];
        }
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    LimitGoodsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellId"];
    if (!cell) {
        cell = [[LimitGoodsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellId"];
    }
    
    LimitModel *model = self.dataArray[indexPath.section];
    [cell setCellData:model];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
//    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 20)];
//    [view setBackgroundColor:BGCOLOR];
    
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return WIDTH+H_90;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    GoodsDetailViewController *VC = [[GoodsDetailViewController alloc]initWithNibName:nil bundle:nil];
    VC.passDelegate = self;
    LimitModel *model = self.dataArray[indexPath.row];
    GoodsModel *theGoods = [[GoodsModel alloc]init];
    theGoods.goodsId = model.goods_id;
    [VC setGoodsData:theGoods];
    [self presentViewController:VC animated:YES completion:nil];

}

-(void)leftDrawerButtonPress:(id)sender{
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

@end
