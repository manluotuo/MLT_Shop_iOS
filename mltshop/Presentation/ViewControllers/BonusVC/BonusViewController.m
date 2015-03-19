//
//  BonusViewController.m
//  mltshop
//
//  Created by 小新 on 15/3/12.
//  Copyright (c) 2015年 manluotuo. All rights reserved.
//

#import "BonusViewController.h"

#import "AppRequestManager.h"
#import "SGActionView.h"
#import "UIViewController+ImageBackButton.h"
#import "DataSigner.h"

#import <SDWebImage/UIImageView+WebCache.h>
#import "FAHoverButton.h"

#import "BonusListModel.h"
#import "BonusListTableViewCell.h"

@interface BonusViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation BonusViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = T(@"我的红包");
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableView.y = IOS7_CONTENT_OFFSET_Y;
    self.tableView.height = TOTAL_HEIGHT - IOS7_CONTENT_OFFSET_Y;
    self.tableView.separatorStyle = UITableViewCellSelectionStyleBlue;
    [self setupDataSource];
    [self setupleftButton];
}

- (void)setupDataSource {
    self.dataSource = [[NSMutableArray alloc]init];
    self.dataArray = [[NSMutableArray alloc] init];
    [[AppRequestManager sharedManager]getBonusListWithBlock:^(id responseObject, NSError *error) {
        {
            if (responseObject != nil) {
                // 集中处理所有的数据
                for (NSDictionary *dict in responseObject[@"data"]) {
                    BonusListModel *model = [[BonusListModel alloc] init];
                    [model setValuesForKeysWithDictionary:dict];
                    [self.dataSource addObject:model];
                    BonusInfoModel *modelInfo = [[BonusInfoModel alloc] init];
                    [modelInfo setValuesForKeysWithDictionary:model.info];
                    [self.dataArray addObject:modelInfo];
                }
                [self.tableView reloadData];
            }
            if (error != nil) {
                [DataTrans showWariningTitle:T(@"获取地址列表有误") andCheatsheet:ICON_TIMES andDuration:1.5f];
            }
        }
    }];
}

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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSLog(@"%d", self.dataSource.count);
    return self.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 95;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    BonusListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellId"];
    if (!cell) {
        cell = [[BonusListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellId"];
    }
    
    BonusInfoModel *model = self.dataArray[indexPath.row];
    BonusListModel *listModel = self.dataSource[indexPath.row];
    model.bonus_date = listModel.bonus_date;
    [cell setNewData:model];
    return cell;
}

/** 刷新 */
- (void)createRefresh {
    
}
/** 加载 */
- (void)createGetMoreData {
    
}

#pragma mark - ButtonClick
- (void)onLeftBtnClick {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


@end
