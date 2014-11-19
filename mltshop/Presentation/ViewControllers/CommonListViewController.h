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
    ListDataSourceTwoInLine    = 0,    // 一行两辆车
    ListDataSourceOneInLine    = 1,    // 一行一辆车
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

@end


