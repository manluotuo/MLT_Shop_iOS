//
//  ListMainViewController.m
//  mltshop
//
//  Created by mactive.meng on 19/11/14.
//  Copyright (c) 2014 manluotuo. All rights reserved.
//

#import "ListMainViewController.h"
#import "AppRequestManager.h"
#import "GCPagedScrollView.h"
#import "ADAreaView.h"
#import "ADBrandView.h"
#import "YWDictionary.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "ListViewController.h"
#import "WebViewController.h"
#import "GoodsDetailViewController.h"
#import "CycleScrollView.h"
#import "SVPullToRefresh.h"
#import "FAHoverButton.h"
#import "ForumRootViewController.h"
#import "XXYNavigationController.h"

#import "Appdelegate.h"
static const NSInteger kTotalPageCount = 5;
@interface ListMainViewController ()<UIScrollViewDelegate,PassValueDelegate, PullListViewDelegate>
@property(nonatomic, strong)YWDictionary *fixedData;
@property(nonatomic, strong)UIScrollView *fixedView;
@property (nonatomic, strong) GCPagedScrollView *pagedScrollView;
@property (nonatomic , strong) CycleScrollView *mainScorllView;
@property (nonatomic, strong) UISwipeGestureRecognizer *rightSwipeGestureRecognizer;

@end

@implementation ListMainViewController {
    CGFloat conuntSet;
    BOOL select;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    select = YES;
    [self setupDataSource];
    [self createRefresh];
}

- (void)onForumButtonClick {
    
    ForumRootViewController *forumView = [[ForumRootViewController alloc] init];
    XXYNavigationController *nav = [[XXYNavigationController alloc] initWithRootViewController:forumView];
    
    [nav setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
    [self presentViewController:nav animated:NO completion:^{
        [MobClick event:UM_FORUM];
    }];
    
}
-(void)passSignalValue:(NSString *)value andData:(id)data
{
    if([value isEqualToString:SIGNAL_MAIN_PAGE_TAPPED] && data != nil){
        id parsed = [DataTrans parseDataFromURL:data];
        if ([parsed isKindOfClass:[SearchModel class]]) {
            if ([[(SearchModel*)parsed brandId] isEqualToString:@"all"]) {
                // FIXME: goto 品牌街
            }else{
                ListViewController *VC = [[ListViewController alloc]initWithNibName:nil bundle:nil];
                VC.search = parsed;
                VC.title = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"];
                [VC setUpDownButton:0];
                ColorNavigationController *nav = [[ColorNavigationController alloc]initWithRootViewController:VC];
                [self.navigationController presentViewController:nav animated:YES completion:nil];
            }
        }else{
            if (DictionaryHasValue(parsed)) {
                if ([parsed[@"type"] isEqualToString:@"url"]) {
                    NSString *urlString = parsed[@"id"];
                    WebViewController *VC = [[WebViewController alloc]initWithNibName:nil bundle:nil];
                    VC.titleString = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"];
                    VC.urlString = urlString;
                    [VC setUpDownButton:0];
                    ColorNavigationController *nav = [[ColorNavigationController alloc]initWithRootViewController:VC];
                    [self.navigationController presentViewController:nav animated:YES completion:nil];
                }else if ([parsed[@"type"] isEqualToString:@"goods"]){
                    GoodsDetailViewController *VC = [[GoodsDetailViewController alloc]initWithNibName:nil bundle:nil];
                    VC.passDelegate = self;
                    GoodsModel *theGoods = [[GoodsModel alloc]init];
                    theGoods.goodsId = parsed[@"id"];

                    [VC setGoodsData:theGoods];
                    
                    [self.navigationController presentViewController:VC animated:YES completion:nil];
                }
            }
        }
    }
    
}

- (void)createRefresh {
    __weak ListMainViewController *weakSelf = self;
    [weakSelf.fixedView addPullToRefreshWithActionHandler:^{
        //        [weakSelf refreshTable];
    }];
}

- (void)setupDataSource
{
    [[AppRequestManager sharedManager]getHomeDataWithBlock:^(id responseObject, NSError *error) {
        if (responseObject != nil) {
            self.fixedData = [[YWDictionary alloc]init];
            
            // 对首页数据进行排序
            NSArray *keys = [responseObject allKeys];
            NSLog(@"%@",[keys lastObject]);
            if ([keys containsObject:@"player"]) {
                [self.fixedData setObject:responseObject[@"player"] forKey:@"player"];
            }
            
            if ([keys containsObject:@"brand"]) {
                [self.fixedData setObject:responseObject[@"brand"] forKey:@"brand"];
            }
            
            if ([keys containsObject:@"area"]) {
                [self.fixedData setObject:responseObject[@"area"] forKey:@"area"];
            }
            
            if ([keys containsObject:@"promote_goods"]) {
                [self.fixedData setObject:responseObject[@"promote_goods"] forKey:@"promote_goods"];
            }
            
            [self buildFixedView];
        }
    }];
}


// TODO:滚动试图
- (void)buildFixedView
{
    /**
     *  fixedHeight  = 各区域高度+ 区域间隔(SEP_HEIGHT)
     */
    CGFloat fixedHeight = 0.0f;
    self.fixedView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, TOTAL_WIDTH, self.view.frame.size.height)];
    self.fixedView.delegate = self;
    self.rightSwipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipes:)];
    self.rightSwipeGestureRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
    [self.fixedView addGestureRecognizer:self.rightSwipeGestureRecognizer];
    
    [self.fixedView setBackgroundColor:WHITECOLOR];
    NSMutableArray *viewsArray = [@[] mutableCopy];
    for (NSString *key in [self.fixedData allKeys]) {
        
        NSArray *listData = [self.fixedData objectForKey:key];

        // 滚动广告屏
        if ([key isEqualToString:@"player"]) {
            CGFloat playerY = fixedHeight;
            CGRect rect = CGRectMake(0, playerY, TOTAL_WIDTH, SLIDE_FIX_HEIGHT);
            /*
             替换滚动试图
             self.pagedScrollView = [[GCPagedScrollView alloc]initWithFrame:rect andPageControl:YES];
             self.pagedScrollView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
             self.pagedScrollView.backgroundColor = GRAYEXLIGHTCOLOR;
             self.pagedScrollView.minimumZoomScale = 1; //最小到0.3倍
             self.pagedScrollView.maximumZoomScale = 3.0; //最大到3倍
             self.pagedScrollView.clipsToBounds = YES;
             self.pagedScrollView.scrollEnabled = YES;
             self.pagedScrollView.pagingEnabled = YES;
             self.pagedScrollView.delegate = self;
             [self.pagedScrollView removeAllContentSubviews];
             
             */
            CGRect scrollFrame = CGRectMake(0, 0, TOTAL_WIDTH, SLIDE_FIX_HEIGHT);
            for (int i = 0 ; i < [listData count]; i++) {
                
                UIImageView *page = [[UIImageView alloc]
                                     initWithFrame:scrollFrame];
                [page setContentMode:UIViewContentModeScaleAspectFill];
                [page sd_setImageWithURL:[NSURL URLWithString:listData[i][@"photo"][@"thumb"]]];
                [viewsArray addObject:page];
                /*
                 替换滚动试图
                 // 点击事件
                 UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleImageTap:)];
                 tap.cancelsTouchesInView = YES;
                 tap.numberOfTapsRequired = 1;
                 page.userInteractionEnabled = YES;
                 page.tag = i;
                 [page addGestureRecognizer:tap];
                 
                 NSLog(@"%@", listData[i][@"photo"][@"thumb"]);
                 [page sd_setImageWithURL:[NSURL URLWithString:listData[i][@"photo"][@"thumb"]]];
                 [viewsArray addObject:page];
                 [self.pagedScrollView addContentSubview:page];
                 */
            }
            
            self.mainScorllView = [[CycleScrollView alloc] initWithFrame:rect animationDuration:3];
            self.mainScorllView.backgroundColor = [[UIColor purpleColor] colorWithAlphaComponent:0.1];
            self.mainScorllView.totalPagesCount = ^NSInteger(void){
                return viewsArray.count;
            };
            self.mainScorllView.fetchContentViewAtIndex = ^UIView *(NSInteger pageIndex){
                return viewsArray[pageIndex];
            };
            self.mainScorllView.TapActionBlock = ^(NSInteger pageIndex){
                
                NSArray *items = [self.fixedData objectForKey:@"player"];
                NSDictionary *item = items[pageIndex];
                // TODO: 敏！
//                 [self passSignalValue:SIGNAL_MAIN_PAGE_TAPPED andData:@"http://www.manluotuo.com/zhuanti/150424/150424.html"];
                [self passSignalValue:SIGNAL_MAIN_PAGE_TAPPED andData:item[@"url"]];
            };
            
            [self.fixedView addSubview:self.mainScorllView];
            
            fixedHeight += SLIDE_FIX_HEIGHT;
        }
        //品牌分类
        else if([key isEqualToString:@"brand"]){
            NSInteger lines = floor(listData.count / 3);
            CGFloat brandHeight = BRAND_FIX_HEIGHT * lines;
            CGRect rect = CGRectMake(0, fixedHeight+SEP_HEIGHT, TOTAL_WIDTH, brandHeight);
            ADBrandView *brandView = [[ADBrandView alloc]initWithFrame:rect];
            [brandView setBackgroundColor:WHITECOLOR];
            [brandView initWithData:listData];
            [self.fixedView addSubview:brandView];
            
            brandView.passDelegate = self;
            
            fixedHeight += brandHeight;
            
        }
        //区域信息
        else if([key isEqualToString:@"area"]){
            for (NSDictionary *oneArea in listData) {
                
                CGFloat height = AREA_FIX_HEIGHT;
                if (StringHasValue(oneArea[@"title"])) {
                    height += H_30;
                }
                
                CGRect rect = CGRectMake(0, fixedHeight+SEP_HEIGHT*2, TOTAL_WIDTH, height);
                ADAreaView *areaView = [[ADAreaView alloc]initWithFrame:rect];
                
                [areaView initWithData:oneArea];
                [self.fixedView addSubview:areaView];
               
                areaView.passDelegate = self;
                /**
                 *  高度-1 为了 获得一个像素的感觉
                 */
                fixedHeight += height;
            }
        }
        
        //设置品牌街下面的image
//        if ([key isEqualToString:@"promote_goods"]) {
//            CGFloat height =SLIDE_FIX_HEIGHT;
//            UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.mainScorllView.frame)*2-H_5, TOTAL_WIDTH, height)];
//            image.layer.borderWidth = 1.0;
//            image.layer.borderColor = GRAYEXLIGHTCOLOR.CGColor;
//            NSURL *url = [NSURL URLWithString:@"http://www.manluotuo.com/data/afficheimg/20150430roeiye.jpg"];
//            [image sd_setImageWithURL:url];
//            [self.fixedView addSubview:image];
//            fixedHeight += height;
//        }
    }
    [self.fixedView setContentSize:CGSizeMake(TOTAL_WIDTH, fixedHeight)];
    [self.view addSubview:self.fixedView];
    
    self.view.backgroundColor = [UIColor colorWithRed:251/255.0 green:247/255.0 blue:237/255.0 alpha:1];

}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    conuntSet = scrollView.contentOffset.y;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
        if (conuntSet < scrollView.contentOffset.y) {
            [self.passDelegate passSignalValue:@"40000" andData:nil];
        } else {
            
            [self.passDelegate passSignalValue:@"40001" andData:nil];
        }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    select = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)handleSwipes:(UISwipeGestureRecognizer *)sender {
    
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
    
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
