//
//  CollectViewController.m
//  mltshop
//
//  Created by 小新 on 15/3/11.
//  Copyright (c) 2015年 manluotuo. All rights reserved.
//

#import "CollectViewController.h"

#import "AppRequestManager.h"
#import "SGActionView.h"
#import "UIViewController+ImageBackButton.h"
#import "ListViewController.h"
#import "GoodsDetailViewController.h"

#import "CollectModel.h"
#import "CollectTableViewCell.h"

#import "FAHoverButton.h"


@interface CollectViewController ()<UITableViewDataSource, UITableViewDelegate, PullListViewDelegate, PassValueDelegate>

@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation CollectViewController {
    CGFloat cellHeight;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = T(@"我的收藏");
    self.commonListDelegate = self;
    //    self.dataSourceType = CollectView;
    self.tableView.height = 400;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableView.y = IOS7_CONTENT_OFFSET_Y;
    self.tableView.height = TOTAL_HEIGHT - IOS7_CONTENT_OFFSET_Y;
    
    //    self.tableView.separatorStyle = UITableViewCellSelectionStyleGray;
    self.tableView.separatorStyle = UITableViewCellSelectionStyleBlue;
    self.dataArray = [[NSMutableArray alloc]init];
    
    [self initDataSource];
    [self setupleftButton];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gotoIndex) name:SIGNAL_GO_TO_INDEX object:nil];
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
    
    //    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 30)];
    //    [backButton setTitle:ICON_BACK forState:UIControlStateNormal];
    //    [backButton.titleLabel setFont:FONT_AWESOME_36];
    //    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    //    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
    //    [backButton addTarget:self action:@selector(onLeftBtnClick) forControlEvents:UIControlEventTouchUpInside];
}

- (void)onLeftBtnClick
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)gotoIndex {
    [self dismissViewControllerAnimated:NO completion:nil];
}

//- (void)setUpDownButton:(NSInteger)position
//{
//    [self setUpImageDownButton:0];
//}

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
    [[AppRequestManager sharedManager]getCollectListWithBlock:^(id responseObject, NSError *error) {
        if (responseObject != nil) {
            [self.dataArray removeAllObjects];
            for (NSDictionary *dict in responseObject[@"data"]) {
                CollectModel *model = [[CollectModel alloc] init];
                [model setValuesForKeysWithDictionary:dict];
                [self.dataArray addObject:model];
            }
            [self.tableView reloadData];
        }
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CollectTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellId"];
    if (!cell) {
        cell = [[CollectTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cellId"];
    }
    
    CollectModel *model = self.dataArray[indexPath.row];
    [cell setNewData:model];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    GoodsDetailViewController *VC = [[GoodsDetailViewController alloc]initWithNibName:nil bundle:nil];
    VC.passDelegate = self;
    CollectModel *model = self.dataArray[indexPath.row];
    GoodsModel *theGoods = [[GoodsModel alloc]init];
    theGoods.goodsId = model.goods_id;
    [VC setGoodsData:theGoods];
    
    [self presentViewController:VC animated:YES completion:nil];
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return UITableViewCellEditingStyleDelete;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.001;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
       CollectModel *model = self.dataArray[indexPath.row];
       [[AppRequestManager sharedManager]getDeleteCollectRecId:model.rec_id andBlcok:^(id responseObject, NSError *error) {
           if (responseObject != nil) {
               [self.dataArray removeObjectAtIndex:indexPath.row];
               [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
           }
           
       }];
        
    };
}

- (void)createRefresh {
}

- (void)createGetMoreData {
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


@end
