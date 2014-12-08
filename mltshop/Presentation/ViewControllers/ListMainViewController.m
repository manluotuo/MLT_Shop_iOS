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

@interface ListMainViewController ()
@property(nonatomic, strong)YWDictionary *fixedData;
@property(nonatomic, strong)UIView *fixedView;

@end

#define SLIDE_FIX_HEIGHT H_160
#define BRAND_FIX_HEIGHT H_60 //1行3个品牌的高度
#define AREA_FIX_HEIGHT H_160 //1行一个布局
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
    CGFloat fixedHeight = 0.0f;
    self.fixedView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, TOTAL_WIDTH, H_100)];
    
    for (NSString *key in [self.fixedData allKeys]) {
        
        NSArray *listData = [self.fixedData objectForKey:key];
        
        if ([key isEqualToString:@"player"]) {
            CGRect rect = CGRectMake(0, fixedHeight, TOTAL_WIDTH, SLIDE_FIX_HEIGHT);
            GCPagedScrollView *pagedView = [[GCPagedScrollView alloc]initWithFrame:rect andPageControl:YES];

            // list data foreach add page
            [self.fixedView addSubview:pagedView];
            fixedHeight += SLIDE_FIX_HEIGHT;
        }else if([key isEqualToString:@"brand"]){
            NSInteger lines = floor(listData.count / 3);
            CGFloat brandHeight = BRAND_FIX_HEIGHT * lines;
            CGRect rect = CGRectMake(0, fixedHeight, TOTAL_WIDTH, brandHeight);
            ADBrandView *brandView = [[ADBrandView alloc]initWithFrame:rect];
            [brandView initWithData:listData];
            [self.fixedView addSubview:brandView];
            fixedHeight += brandHeight;
            
        }else if([key isEqualToString:@"area"]){
            for (NSDictionary *oneArea in listData) {
                CGRect rect = CGRectMake(0, fixedHeight, TOTAL_WIDTH, AREA_FIX_HEIGHT);
                ADAreaView *areaView = [[ADAreaView alloc]initWithFrame:rect];
                [areaView initWithData:oneArea];
                [self.fixedView addSubview:areaView];
                fixedHeight += AREA_FIX_HEIGHT;
            }
            
        }else{
            
        }
    }
    
    self.fixedView.height = fixedHeight;
    
    
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
