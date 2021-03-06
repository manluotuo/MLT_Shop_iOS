//
//  CommonListViewController.h
//  bitmedia
//
//  Created by meng qian on 14-1-22.
//  Copyright (c) 2014年 thinktube. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "MMViewController.h"
#import "PullListViewDelegate.h"
#import "PassValueDelegate.h"



typedef NS_ENUM(NSInteger,ListDataSourceType)
{
    ListDataSourceMixInLine     = 0,    // 一行两辆车
    ListDataSourceTwoInLine     = 1,    // 一行两辆车
    ListDataSourceOneInLine     = 2,    // 一行一辆车
    ListDataSourceAddress       = 3,    // 一行一辆车
    ListDataSourceCart          = 4,    // 一行一辆车
    ListDataSourceOrder         = 5,    // 一行一辆车
    ListDataSourceBrand         = 6,    // 一行一辆车
    CollectView                 = 7,
};


@interface CommonListViewController : MMViewController

@property(nonatomic, assign)NSObject<PullListViewDelegate> *commonListDelegate;
@property(nonatomic, assign)NSObject<PassValueDelegate> *delegateForHostView;

@property (nonatomic, assign)NSString *maxID;
@property (nonatomic, assign)NSString *minID;
@property (nonatomic, assign)NSInteger start;
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)NSMutableArray *dataSource;
@property (nonatomic, assign)NSInteger dataSourceType;

- (void)disableRefreshTable:(BOOL)disable;
- (void)resetInfiniteScrollingViewTitles;
- (void)initDataSource;
- (void)showSetupDataSource:(id)responseObject andError:(NSError *)error;
- (void)showRecomendNewItems:(id)responseObject andError:(NSError *)error;
- (void)showRecomendOldItems:(id)responseObject andError:(NSError *)error;

- (void)initQuickAddTableViewBgView;
- (void)initNoDataTableViewBgViewWithTitle:(NSString *)title subTitle:(NSString *)subTitle;

/** 刷新 */
- (void)createRefresh;
/** 加载 */
- (void)createGetMoreData;

@end


