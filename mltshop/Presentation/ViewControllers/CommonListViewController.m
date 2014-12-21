 //
//  CommonListViewController.m
//  bitmedia
//
//  Created by meng qian on 13-12-24.
//  Copyright (c) 2013年 thinktube. All rights reserved.
//

#import "CommonListViewController.h"
#import "GoodsOneTableViewCell.h"
#import "GoodsTwoTableViewCell.h"
#import "AddressTableViewCell.h"
#import "SVPullToRefresh.h"
#import "AppRequestManager.h"
#import <MMDrawerController/MMDrawerBarButtonItem.h>
#import <MMDrawerController/UIViewController+MMDrawerController.h>
#import <TSMessages/TSMessage.h>
#import "FAHoverButton.h"
#import "NoDataView.h"
#import "NSString+Size.h"
#import "PassValueDelegate.h"


@interface CommonListViewController ()<UITableViewDataSource, UITableViewDelegate, PassValueDelegate>
@property (nonatomic, strong)NoDataView *noDataView;

@end

@implementation CommonListViewController
@synthesize tableView;
@synthesize dataSource;
@synthesize maxID, minID;
@synthesize noDataView;
@synthesize start;
@synthesize dataSourceType;
@synthesize delegateForHostView;
@synthesize commonListDelegate;
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
    
    self.view.backgroundColor = BGCOLOR;
    self.editing = NO;
    
    self.tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.backgroundColor = BGCOLOR;
    self.tableView.separatorStyle = UITableViewCellSelectionStyleGray;
    self.tableView.separatorColor = SEPCOLOR;
    
    self.tableView.delegate = self;
    self.tableView.dataSource  = self;
    
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    UIEdgeInsets currentInset = self.tableView.contentInset;
    
    // Manully set contentInset.
    if (OSVersionIsAtLeastiOS7()) {
        currentInset.top = self.navigationController.navigationBar.bounds.size.height;
        self.automaticallyAdjustsScrollViewInsets = NO;
        // On iOS7, you need plus the height of status bar.
        currentInset.top = 0;
//        currentInset.bottom += IOS7_CONTENT_OFFSET_Y ;
        self.tableView.height = self.tableView.height-IOS7_CONTENT_OFFSET_Y-TABS_VIEW_HEIGHT;


    }else{
        NSLog(@"ios 6");
        currentInset.bottom += TABBAR_HEIGHT+TABS_VIEW_HEIGHT;
    }
    self.tableView.contentInset = currentInset;
    
    
    
    [self.view addSubview:self.tableView];

    
    self.maxID = @"";
    self.minID = @"";

    __weak CommonListViewController *weakSelf = self;
    
    //    self.tableView
    // setup pull-to-refresh
    [self.tableView addPullToRefreshWithActionHandler:^{
        [weakSelf refreshTable];
    }];
    
//    //setup infinite scrolling
//    [self.tableView addInfiniteScrollingWithActionHandler:^{
//        [weakSelf getMoreData];
//    }];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleNextStep:)
                                                 name:NOTIFICATION_VEHICLE_EDIT_DONE object:nil];
    // if no network set enable
}

-(void)handleNextStep:(NSNotification *)notification
{
//    NSDictionary *theData = [notification userInfo];
//    NSLog(@"theData %@",theData);
    [self initDataSource];
}

- (void)initDataSource
{
    [self.commonListDelegate setupDataSource];
}

- (void)disableRefreshTable:(BOOL)disable
{
    if (disable) {
        __weak CommonListViewController *weakSelf = self;
        [self.tableView setShowsPullToRefresh:NO];
    }
}

- (void)resetInfiniteScrolling
{
    [self.tableView resetInfiniteScrollingViewTitles:[NSMutableArray arrayWithObjects:
                                                      NSLocalizedString(@"",),
                                                      NSLocalizedString(@"加载更多...",),
                                                      NSLocalizedString(@"加载更多...",),
                                                      nil]];
}

- (void)initQuickAddTableViewBgView
{
    self.noDataView = [[NoDataView alloc] initWithFrame:
                              CGRectMake((TOTAL_WIDTH-NO_DATA_WIDTH)/2, (TOTAL_HEIGHT*0.8-NO_DATA_HEIGHT)/2, NO_DATA_WIDTH, NO_DATA_HEIGHT)];
    [self.noDataView setTitleString:T(@"暂无商品")];
    [self.noDataView addTarget:self.commonListDelegate action:@selector(triggerCreateVehicle:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.noDataView];
}

- (void)initNoDataTableViewBgViewWithTitle:(NSString *)title subTitle:(NSString *)subTitle
{
    self.noDataView = [[NoDataView alloc] initWithFrame:
                       CGRectMake((TOTAL_WIDTH-NO_DATA_WIDTH)/2, (TOTAL_HEIGHT*0.8-NO_DATA_HEIGHT)/2, NO_DATA_WIDTH, NO_DATA_HEIGHT)];
    [self.noDataView setBackgroundColor:GRAYCOLOR];
    [self.noDataView setTitleString:title];
    if (StringHasValue(subTitle)) {
        [self.noDataView setSubTitleString:subTitle];
    }
    [self.view addSubview:self.noDataView];
}

- (void)triggerCreateVehicle:(id)sender
{
//    host triggerCreateVehicle
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_QUICK_ADD_STEP
                                                        object:self
                                                      userInfo:nil];

//    [self.delegateForHostView passSignalValue:SIGNAL_CREATE_VEHICLE andData:sender];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    //    [self.tableView triggerPullToRefresh];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

////////////////////////////////////////////////////////////
#pragma mark - getFirstOrLastArticleID Actions
////////////////////////////////////////////////////////////


- (void)showSetupDataSource:(id)responseObject andError:(NSError *)error
{

    self.dataSource = [[NSMutableArray alloc] init];
//    self.dataSource = [DataTrans getDataArrayWithExtendData:responseObject];
    self.dataSource = responseObject;
    
    // TODO: 多于10条的时候才有加载更多的动画
    if ([self.dataSource count] > 10) {
        //setup infinite scrolling
        __weak CommonListViewController *weakSelf = self;
        [self.tableView addInfiniteScrollingWithActionHandler:^{
            [weakSelf getMoreData];
        }];
        
        [self resetInfiniteScrolling];
    }

    
    
    if ([self.dataSource count] == 0) {
        __weak CommonListViewController *weakSelf = self;
        [weakSelf.tableView.infiniteScrollingView setEnabled:NO];
        [self.noDataView setHidden:NO];
        [self.tableView reloadData];
    }else{
        [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
        self.tableView.backgroundView = nil;
        [self.tableView reloadData];
        [self.noDataView setHidden:YES];

//        [self makeMaxAndMinID];
        NSLog(@"setupDataSource %d 条", [self.dataSource count]);
    }
    
    if (error != nil) {
//        [self.noDataView setHidden:NO];
//        [self.noDataView setSubTitleString:T(@"点击屏幕 重新加载")];
    }
}


- (void)showRecomendNewItems:(id)responseObject andError:(NSError *)error
{
    if (error != nil) {
        NSLog(@"showRecomendNewItems error: %@",error);
        return ;
    }
    __weak CommonListViewController *weakSelf = self;

    NSMutableArray *data = [DataTrans getDataArrayWithExtendData:responseObject];

    NSLog(@"new data : %d",[data count]);
    // 大于20条清空列表
//    if ([data count] >= 20) {
//        self.dataSource = [[NSMutableArray alloc]init];
//    }

    if ([data count] <= 0) {
        NSLog(@"no data");
        [TSMessage setDefaultViewController:self];
        [TSMessage showNotificationWithTitle:T(@"暂无更新，休息一会儿") type:TSMessageNotificationTypeSuccess];
        return;
    }else{
        /**
         *  insert new article
         */
        [weakSelf.tableView beginUpdates];
        NSMutableArray *indexPaths = [[NSMutableArray alloc]init];
        NSInteger _count =  [data count]-1;

        for (int idx = _count; idx >= 0; idx--) { //[data count]

            NSDictionary *object = [data objectAtIndex:idx];

            [weakSelf.dataSource insertObject:object atIndex:0];

            [indexPaths addObject:[NSIndexPath indexPathForRow:idx inSection:0]];

        }

        [weakSelf.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
        [weakSelf.tableView endUpdates];


        NSString *message = [NSString stringWithFormat:T(@"为您推荐了%d辆车"),[data count]];
        [TSMessage setDefaultViewController:self];
        [TSMessage showNotificationWithTitle:message type:TSMessageNotificationTypeSuccess];
        
//        [self makeMaxAndMinID];

    }

}

- (void)showRecomendOldItems:(id)responseObject andError:(NSError *)error
{
    __weak CommonListViewController *weakSelf = self;

    NSLog(@"old data : %d",[responseObject count]);
    if ([responseObject count] > 0) {

        [weakSelf.tableView beginUpdates];

        // TODO: little ugly because can't addObject
        weakSelf.dataSource = [[NSMutableArray alloc]initWithArray:weakSelf.dataSource];
        for (NSDictionary *object in responseObject) {
            NSLog(@"%@",object);
            [weakSelf.dataSource addObject:object];
            [weakSelf.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:weakSelf.dataSource.count-1 inSection:0]] withRowAnimation:UITableViewRowAnimationTop];
        }

        [weakSelf.tableView endUpdates];
        
//        [self makeMaxAndMinID];


    }else{
        if ([self.dataSource count] > 0 ) {
            [weakSelf.tableView.infiniteScrollingView setTitle:T(@"全部加载完成") forState:SVInfiniteScrollingStateStopped];
            [weakSelf.tableView.infiniteScrollingView setEnabled:NO];
        }
    }
}



////////////////////////////////////////////////////////////
#pragma mark - tableview and datasource action
////////////////////////////////////////////////////////////

- (void)refreshTable
{
    __weak CommonListViewController *weakSelf = self;
//    [weakSelf.tableView.pullToRefreshView setTitle:T(@">_< 努力加载中..") forState:SVPullToRefreshStateAll];
    
    int64_t delayInSeconds = 1.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self.commonListDelegate recomendNewItems];
        
        [weakSelf.tableView.pullToRefreshView stopAnimating];
    });
}

- (void)getMoreData {
    __weak CommonListViewController *weakSelf = self;
    
    int64_t delayInSeconds = 1.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self.commonListDelegate recomendOldItems];
        
        [weakSelf.tableView.infiniteScrollingView stopAnimating];
    });
}

#pragma mark -
#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.dataSourceType == ListDataSourceTwoInLine){
        return GOODS_CELL_HEIGHT + H_30;
    }else{
        return GOODS_CELL_HEIGHT;
    }
}

#pragma mark -
#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataSource count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"ListCell";

    if (self.dataSourceType == ListDataSourceTwoInLine) {
        NSDictionary *cellData = [self.dataSource objectAtIndex:indexPath.row];
        GoodsTwoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        
        if (cell == nil) {
            cell = [[GoodsTwoTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            cell.passDelegate = self;
        }
        [cell setNewData:cellData];
        
        return cell;
    }
    else if(self.dataSourceType == ListDataSourceOneInLine){
        GoodsModel *cellData = [self.dataSource objectAtIndex:indexPath.row];
        cellData.indexPath = INT(indexPath.row);
        GoodsOneTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        
        if (cell == nil) {
            cell = [[GoodsOneTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            cell.passDelegate = self;
        }
        [cell setNewData:cellData];
        
        return cell;
    }else if(self.dataSourceType == ListDataSourceAddress){
        AddressModel *cellData = [self.dataSource objectAtIndex:indexPath.row];
        cellData.indexPath = INT(indexPath.row);
        AddressTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        
        if (cell == nil) {
            cell = [[AddressTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            cell.passDelegate = self;
        }
        [cell setNewData:cellData];
        
        return cell;
    }
    
    else{
        GoodsModel *cellData = [self.dataSource objectAtIndex:indexPath.row];
        cellData.indexPath = INT(indexPath.row);
        GoodsOneTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        
        if (cell == nil) {
            cell = [[GoodsOneTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            cell.passDelegate = self;
        }
        [cell setNewData:cellData];
        
        return cell;
    }
}

//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    [DataTrans showWariningTitle:T(@"TODO") andCheatsheet:ICON_FLAG];
//}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleNone;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

////////////////////////////////////////////////////////////
#pragma UIScrollViewDelegate Methods
////////////////////////////////////////////////////////////

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    // TODO: TLSwipeForOptionsCellEnclosingTableViewDidBeginScrollingNotification  in articleViewCell
//    [[NSNotificationCenter defaultCenter] postNotificationName:TLSwipeForOptionsCellEnclosingTableViewDidBeginScrollingNotification object:scrollView];
}


/////////////////////////////////////////////////////
#pragma mark - clear section line when cell is empty
/////////////////////////////////////////////////////
- (float)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01f;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [UIView new];
}


-(void) dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


@end
