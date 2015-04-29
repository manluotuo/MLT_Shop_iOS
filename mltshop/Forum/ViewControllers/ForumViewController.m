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
#import "STAlertView.h"
#import <AFNetworking/AFNetworking.h>
#import "AppDelegate.h"
#import "ForumModel.h"
#import "PostViewController.h"
#import "ForumDetailController.h"
#import "ForumProfileController.h"
#import "NSString+TimeString.h"


@interface ForumViewController ()<UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate, PassValueDelegate, PullListViewDelegate, forumTableViewCellDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) CExpandHeader *header;
@property (nonatomic, strong) UIImageView *headImage;
@property (nonatomic, strong) STAlertView *stAlertView;
@property (nonatomic, copy) NSString *nickName;

@end

@implementation ForumViewController {
    NSInteger _contentOffsetY;
    NSInteger index;
    FAHoverButton *forumButton;
    NSInteger contentSet;
    
}


- (void)viewDidLoad {
    
    [super viewDidLoad];
    index = 1;
    self.dataArray = [[NSMutableArray alloc] init];
    [self.view setBackgroundColor:WHITECOLOR];
    /** 创建视图 */
    [self createUI];
    /** 创建导航栏 */
    [self customNavigationBar];
    /** 下拉刷新 */
    [self createRefresh];
    /** 上拉加载 */
    [self createGetMoreData];
//    [self setNewData];
    [self firstLogin];
    [self setNewData];
    self.commonListDelegate = self;
    self.passDelegate = self;
    
    //    self.automaticallyAdjustsScrollViewInsets = NO;
    //    self.tableView.y = IOS7_CONTENT_OFFSET_Y;
    //    self.tableView.height = TOTAL_HEIGHT - IOS7_CONTENT_OFFSET_Y;
    
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setUpNewData) name:SET_UP_HOME_DATA object:nil];
    
}

- (void)passSignalValue:(NSString *)value andData:(id)data {
    
    if ([value isEqualToString:SETUP_DATA]) {
        [self recomendNewItems];
    }
}

- (void)firstLogin {
    /** 获取用户信息 */
    NSString *httpUrl = @"http://sj.manluotuo.com/home/user/info";
    AFHTTPRequestOperationManager *rom=[AFHTTPRequestOperationManager manager];
    rom.responseSerializer.acceptableContentTypes=[NSSet setWithObjects:@"text/json",@"text/html", nil];
    NSDictionary *postDict = @{@"userid": [DataTrans
                                           noNullStringObj: XAppDelegate.me.userId]};
    [rom POST:httpUrl parameters:postDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([responseObject[@"SUCESS"] integerValue] == 1) {
            NSString *str = responseObject[@"data"][@"nickname"];
            if (str.length == 0) {
                [self setUserName];
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

- (void)setUserName {
    self.stAlertView = [[STAlertView alloc] initWithTitle:@"首次登陆，请设置昵称"
                                                  message:@"请设置漫社区昵称，设置后不可修改"
                                            textFieldHint:@"在此处输入昵称"
                                           textFieldValue:nil
                                        cancelButtonTitle:@"取消"
                                        otherButtonTitles:@"确认"
                                        cancelButtonBlock:^{
                                            [self dismissViewControllerAnimated:YES completion:nil];
                                        } otherButtonBlock:^(NSString *result){
                                            if (result.length > 10) {
                                                [DataTrans showWariningTitle:T(@"昵称应该在1-10个字符之间") andCheatsheet:nil andDuration:1.0f];
                                                [self setUserName];
                                                return;
                                            }
                                            
                                            if (result.length == 0) {
                                                [DataTrans showWariningTitle:T(@"昵称应该在1-10个字符之间") andCheatsheet:nil andDuration:1.0f];
                                                [self setUserName];
                                            } else {
                                                [self setNickName:result];
                                            }
                                            
                                        }];
}

- (void)setNewData {
    NSString *httpUrl=@"http://sj.manluotuo.com/home/post/home";
    AFHTTPRequestOperationManager *rom=[AFHTTPRequestOperationManager manager];
    rom.responseSerializer.acceptableContentTypes=[NSSet setWithObjects:@"text/json",@"text/html", nil];
    NSDictionary *postDict = @{@"page": [NSString stringWithFormat:@"%d", index],
                               @"pagecount": @"20"};
    [rom POST:httpUrl parameters:postDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([responseObject[@"SUCESS"] integerValue] == 1) {
            if (index == 1) {
                [self.dataArray removeAllObjects];
            }
            for (NSDictionary *dict in responseObject[@"data"][@"data"]) {
                ForumModel *model = [[ForumModel alloc] init];
                
                [model setValuesForKeysWithDictionary:dict];
                [self.dataArray addObject:model];
            }
            [self.tableView reloadData];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
    }];
}

/** 设置昵称 */
- (void)setNickName:(NSString *)nickName {
    NSString *httpUrl=@"http://sj.manluotuo.com/home/user/changeNickName";
    AFHTTPRequestOperationManager *rom=[AFHTTPRequestOperationManager manager];
    rom.responseSerializer.acceptableContentTypes=[NSSet setWithObjects:@"text/json",@"text/html", nil];
    NSDictionary *postDict = @{@"userid": XAppDelegate.me.userId,
                               @"nickname": nickName};
    [rom POST:httpUrl parameters:postDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"%@",error);
    }];
}


- (void)customNavigationBar {
    
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 64)];
    [self.view addSubview:headView];
    
    self.headImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 64)];
    [self.headImage setBackgroundColor:ORANGECOLOR];
    self.headImage.alpha = 0;
    [headView addSubview:self.headImage];
    
    CGFloat leftMargin = 10.0f;
    FAHoverButton *backButton = [[FAHoverButton alloc] initWithFrame:CGRectMake(15, 30, 12+leftMargin, 21)];
    [backButton setTitle:ICON_BACK forState:UIControlStateNormal];
    [backButton.titleLabel setFont:FONT_AWESOME_36];
    [backButton addTarget:self action:@selector(onLeftBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [backButton setImageEdgeInsets:UIEdgeInsetsMake(0, leftMargin, 0, 0)];
    [headView addSubview:backButton];
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton setFrame:CGRectMake(10, 25, 50, 30)];
    [leftButton addTarget:self action:@selector(onLeftBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [headView addSubview:leftButton];
    
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton setFrame:CGRectMake(WIDTH - 60, 20, 44, 44)];
    [rightButton addTarget:self action:@selector(onRightBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [rightButton setImage:[UIImage imageNamed:@"icon_send_frs_bar"] forState:UIControlStateNormal];
    [headView addSubview:rightButton];
    
    
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
        index++;
        [weakSelf getMoreData];
    }];
}

- (void)refreshTable {
    
    
    __weak ForumViewController *weakSelf = self;
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
    int64_t delayInSeconds = 1.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self.commonListDelegate recomendOldItems];
        [weakSelf.tableView.infiniteScrollingView stopAnimating];
    });
}

- (void)recomendNewItems {

    index = 1;
    [self setNewData];
}

- (void)recomendOldItems {
    [self setNewData];
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
    
    forumButton = [[FAHoverButton alloc] initWithFrame:CGRectMake(WIDTH-H_80, TOTAL_HEIGHT-H_80, H_50, H_50)];
//    [forumButton setImage:[UIImage imageNamed:T(@"ic_add_white_24dp")] forState:UIControlStateNormal];
    UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(12, 12, 23, 23)];
    image.image = [UIImage imageNamed:T(@"tb_cart_icon_empty")];
    [forumButton addSubview:image];
    [forumButton setBackgroundColor:ORANGECOLOR];
    [forumButton setRounded];
    [forumButton setIconFont:FONT_AWESOME_30];
    [forumButton addTarget:self action:@selector(onForumButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:forumButton];
    
}


- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {
    contentSet = scrollView.contentOffset.y;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if (contentSet < scrollView.contentOffset.y) {
        if (forumButton.y == TOTAL_HEIGHT-H_80) {
            [UIView animateWithDuration:0.3 animations:^{
                forumButton.y = TOTAL_HEIGHT + H_10;
            }];
        }
    } else {
        
        if (forumButton.y == TOTAL_HEIGHT + H_10) {
            [UIView animateWithDuration:0.3 animations:^{
                forumButton.y = TOTAL_HEIGHT - H_80;
            }];
        }
    }
    
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
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ForumTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellId"];
    if (!cell) {
        cell = [[ForumTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellId"];
    }
    cell.delegate = self;
    cell.passDelegate = self;
    ForumModel *model = self.dataArray[indexPath.row];
    
    [cell setData:model];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    ForumModel *model = self.dataArray[indexPath.row];
    CGSize titleSize = [(NSString *)model.text sizeWithWidth:WIDTH-H_40 andFont:FONT_14];
    if (model.image1.length != 0 || model.image2.length != 0 || model.image3.length != 0) {
    return H_60 + titleSize.height + (WIDTH-H_20)/3 + H_30;
    } else {
    return H_60 + titleSize.height + H_30;
    }

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ForumModel *model = self.dataArray[indexPath.row];
    model.time = [NSString stringTimeDescribeFromTimeString:model.time];
    ForumDetailController *datailVC = [[ForumDetailController alloc] init];
    datailVC.postid = model.postid;
    [self.navigationController pushViewController:datailVC animated:YES];
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

- (void)onRightBtnClick {
    PostViewController *postVC = [[PostViewController alloc] init];
    [self.navigationController pushViewController:postVC animated:YES];
}

- (void)onForumButtonClick {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

#pragma mark - forumTableViewCellDelegete
//点击头像事件
- (void)passSignalValue:(NSString *)value andString:(NSString *)string {
    
    if ([value isEqualToString:@"onIcon"]) {
        ForumProfileController *forumVC = [[ForumProfileController alloc] init];
        forumVC.userId = string;
        [self.navigationController pushViewController:forumVC animated:YES];
    }
    
}

- (void)setUpNewData {
    [self recomendNewItems];
}

@end
