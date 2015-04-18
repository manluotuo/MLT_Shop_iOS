//
//  ForumViewController.m
//  mltshop
//
//  Created by 小新 on 15/3/30.
//  Copyright (c) 2015年 manluotuo. All rights reserved.
//

#import "ForumViewController.h"
#import "FAHoverButton.h"
#import "ForumTableViewCell.h"
#import "SVPullToRefresh.h"
#import "CExpandHeader.h"

@interface ForumViewController ()<UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) CExpandHeader *header;
@property (nonatomic, strong) UIImageView *headImage;

@end

@implementation ForumViewController {
    NSInteger _contentOffsetY;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataArray = [[NSMutableArray alloc] init];
    [self.view setBackgroundColor:WHITECOLOR];
    self.navigationController.navigationBarHidden = YES;
    /** 创建视图 */
    [self createUI];
    /** 创建导航栏 */
    [self customNavigationBar];
    /** 下拉刷新 */
//    [self createRefresh];
    /** 上拉加载 */
    [self createGetMoreData];
    self.commonListDelegate = self;

//    self.automaticallyAdjustsScrollViewInsets = NO;
//    self.tableView.y = IOS7_CONTENT_OFFSET_Y;
//    self.tableView.height = TOTAL_HEIGHT - IOS7_CONTENT_OFFSET_Y;

}

- (void)customNavigationBar {
    
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 64)];
    [self.view addSubview:headView];
    
    self.headImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 64)];
    [self.headImage setBackgroundColor:ORANGECOLOR];
    self.headImage.alpha = 0;
    [headView addSubview:self.headImage];
    
    CGFloat leftMargin = 10.0f;
    FAHoverButton *backButton = [[FAHoverButton alloc] initWithFrame:CGRectMake(15, 25, 12+leftMargin, 21)];
    [backButton setTitle:ICON_BACK forState:UIControlStateNormal];
    [backButton.titleLabel setFont:FONT_AWESOME_36];
    [backButton addTarget:self action:@selector(onLeftBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [backButton setImageEdgeInsets:UIEdgeInsetsMake(0, leftMargin, 0, 0)];
    [headView addSubview:backButton];
    
//    FAHoverButton *postButton = [FAHoverButton allo] initWi
    
    UILabel *titleLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 25, WIDTH, 30)];
    titleLable.textAlignment = UIBaselineAdjustmentAlignCenters;
    titleLable.text = T(@"漫社区");
    titleLable.textColor = WHITECOLOR;
    [titleLable setFont:FONT_20];
    [self.headImage addSubview:titleLable];
    
}

- (void)createRefresh {
    
    __weak ForumViewController *weakSelf = self;
    [self.tableView addPullToRefreshWithActionHandler:^{
        [weakSelf refreshTable];
    }];
}

- (void)createGetMoreData {
    __weak ForumViewController *weakSelf = self;
    [self.tableView addInfiniteScrollingWithActionHandler:^{
        [weakSelf getMoreData];
    }];
}

- (void)refreshTable
{
    __weak ForumViewController *weakSelf = self;
    //    [weakSelf.tableView.pullToRefreshView setTitle:T(@">_< 努力加载中..") forState:SVPullToRefreshStateAll];
    int64_t delayInSeconds = 1.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self.commonListDelegate recomendNewItems];
        self.tableView.frame = self.view.bounds;
        [weakSelf.tableView.pullToRefreshView stopAnimating];
    });
}

- (void)getMoreData {
    
    __weak ForumViewController *weakSelf = self;
    
    // FIXME: 如果正在进行动画 那么不响应
    //    if (weakSelf.tableView.infiniteScrollingView.state == SVInfiniteScrollingStateStopped) {
    //
    //    }
    int64_t delayInSeconds = 1.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self.commonListDelegate recomendOldItems];
        [weakSelf.tableView.infiniteScrollingView stopAnimating];
    });
}

- (void)recomendNewItems {
    
}

- (void)recomendOldItems {
    
}

/** 创建View */
- (void)createUI {
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, -H_20, WIDTH, TOTAL_HEIGHT+H_20) style:UITableViewStyleGrouped];
        self.tableView.backgroundColor = REDCOLOR;
    UIImageView *image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pic_background"]];
    [image setFrame:self.tableView.bounds];
    self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    [self.tableView setBackgroundView:image];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    
    /** 商城入口按钮 */
    [self createForumButton];
}

/** 创建商城入口按钮 */
- (void)createForumButton {
    
    FAHoverButton *forumButton = [[FAHoverButton alloc] initWithFrame:CGRectMake(WIDTH-H_80, TOTAL_HEIGHT-H_80, H_50, H_50)];
    [forumButton setTitle:[NSString fontAwesomeIconStringForEnum:FAat] forState:UIControlStateNormal];
    [forumButton setTitleColor:GRAYCOLOR forState:UIControlStateNormal];
    [forumButton setRounded];
    [forumButton setIconFont:FONT_AWESOME_30];
    [forumButton addTarget:self action:@selector(onForumButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:forumButton];
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    NSLog(@"%f", scrollView.contentOffset.y);
    if (scrollView.contentOffset.y > 0 && _contentOffsetY < scrollView.contentOffset.y && self.headImage.alpha < 1) {
        self.headImage.alpha += 0.02;
    }
    else if (scrollView.contentOffset.y < 85 && _contentOffsetY > scrollView.contentOffset.y && self.headImage.alpha >= 0) {
        self.headImage.alpha -= 0.05;
    }
    if (scrollView.contentOffset.y > 100) {
        [UIView animateWithDuration:0.2 animations:^{
            self.headImage.alpha = 1;
        }];
    } else if (scrollView.contentOffset.y < 30) {
        [UIView animateWithDuration:0.2 animations:^{
            self.headImage.alpha = 0;
            return;
        }];
    }
    _contentOffsetY = scrollView.contentOffset.y;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ForumTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellId"];
    if (!cell) {
        cell = [[ForumTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellId"];
    }
    [cell setData];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 230;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 150;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 64)];
    image.image = [UIImage imageNamed:@"image"];
    return image;
}

- (void)onLeftBtnClick {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)onForumButtonClick {
    //    [self dismissViewControllerAnimated:YES completion:nil];
    ForumViewController *vc = [[ForumViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

@end
