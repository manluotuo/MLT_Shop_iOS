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

@interface ListMainViewController ()<UIScrollViewDelegate>
@property(nonatomic, strong)YWDictionary *fixedData;
@property(nonatomic, strong)UIScrollView *fixedView;

@end

@implementation ListMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupDataSource];
}

- (void)setupDataSource
{
    [[AppRequestManager sharedManager]getHomeDataWithBlock:^(id responseObject, NSError *error) {
        if (responseObject != nil) {
            self.fixedData = [[YWDictionary alloc]init];
            
            // 对首页数据进行排序
            NSArray *keys = [responseObject allKeys];
            
            if ([keys containsObject:@"player"]) {
                [self.fixedData setObject:responseObject[@"player"] forKey:@"player"];
            }
            
            if ([keys containsObject:@"brand"]) {
                [self.fixedData setObject:responseObject[@"brand"] forKey:@"brand"];
            }
            
            if ([keys containsObject:@"area"]) {
                [self.fixedData setObject:responseObject[@"area"] forKey:@"area"];
            }
            
            
            [self buildFixedView];
        }
    }];
}

- (void)buildFixedView
{
    /**
     *  fixedHeight  = 各区域高度+ 区域间隔(SEP_HEIGHT)
     */
    CGFloat fixedHeight = 0.0f;
    self.fixedView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, TOTAL_WIDTH, self.view.frame.size.height)];
    
    for (NSString *key in [self.fixedData allKeys]) {
        
        NSArray *listData = [self.fixedData objectForKey:key];
        
        // 滚动广告屏
        if ([key isEqualToString:@"player"]) {
            CGFloat playerY = fixedHeight;
            CGRect rect = CGRectMake(0, playerY, TOTAL_WIDTH, SLIDE_FIX_HEIGHT);
            GCPagedScrollView *pagedScrollView = [[GCPagedScrollView alloc]initWithFrame:rect andPageControl:YES];
            
            pagedScrollView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
            pagedScrollView.backgroundColor = GRAYEXLIGHTCOLOR;
            pagedScrollView.minimumZoomScale = 1; //最小到0.3倍
            pagedScrollView.maximumZoomScale = 3.0; //最大到3倍
            pagedScrollView.clipsToBounds = YES;
            pagedScrollView.scrollEnabled = YES;
            pagedScrollView.pagingEnabled = YES;
            pagedScrollView.delegate = self;
            [pagedScrollView removeAllContentSubviews];
            
            CGRect scrollFrame = CGRectMake(0, 0, TOTAL_WIDTH, SLIDE_FIX_HEIGHT);
            for (int i = 0 ; i < [listData count]; i++) {
                // last one
                UIImageView *page = [[UIImageView alloc]
                                     initWithFrame:scrollFrame];
                [page setContentMode:UIViewContentModeScaleAspectFill];
                
                [page sd_setImageWithURL:[NSURL URLWithString:listData[i][@"photo"][@"thumb"]]];
                [pagedScrollView addContentSubview:page];
            }
            

            // list data foreach add page
            [self.fixedView addSubview:pagedScrollView];
            fixedHeight += SLIDE_FIX_HEIGHT;
        }
        //品牌分类
        else if([key isEqualToString:@"brand"]){
            NSInteger lines = floor(listData.count / 3);
            CGFloat brandHeight = BRAND_FIX_HEIGHT * lines;
            CGRect rect = CGRectMake(0, fixedHeight+SEP_HEIGHT, TOTAL_WIDTH, brandHeight);
            ADBrandView *brandView = [[ADBrandView alloc]initWithFrame:rect];
            [brandView initWithData:listData];
            [self.fixedView addSubview:brandView];
            fixedHeight += brandHeight;
            
        }
        //区域信息
        else if([key isEqualToString:@"area"]){
            for (NSDictionary *oneArea in listData) {
                CGRect rect = CGRectMake(0, fixedHeight+SEP_HEIGHT*2, TOTAL_WIDTH, AREA_FIX_HEIGHT);
                ADAreaView *areaView = [[ADAreaView alloc]initWithFrame:rect];
                [areaView initWithData:oneArea];
                [self.fixedView addSubview:areaView];
                /**
                 *  高度-1 为了 获得一个像素的感觉
                 */
                fixedHeight += AREA_FIX_HEIGHT-1;
            }
            
        }else{
            
        }
    }
    
    [self.fixedView setContentSize:CGSizeMake(TOTAL_WIDTH, fixedHeight)];
    [self.view addSubview:self.fixedView];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
