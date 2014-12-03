//
//  SearchCategoryViewController.m
//  mltshop
//
//  Created by mactive.meng on 1/12/14.
//  Copyright (c) 2014 manluotuo. All rights reserved.
//

#import "SearchCategoryViewController.h"
#import "AppViewCell.h"
#import <HTProgressHUD.h>
#import <HTProgressHUD/HTProgressHUDIndicatorView.h>

typedef NS_ENUM(NSInteger,recommendListType) {
    recommendContactList = 1,
    recommendSearchResultList = 2
} ;

#define ITEM_PER_LINE 3
#define APP_ICON_TAG 100
#define APP_NAME_TAG 101

@interface SearchCategoryViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UISearchBarDelegate>
{
    NSInteger searchStart;
    NSInteger recommendType;
    HTProgressHUD *HUD;
    NSInteger pickedSection;
}

@property(nonatomic, strong) UISearchBar *searchBar;
@property(nonatomic, strong)UICollectionView *cateView;
@property (nonatomic, strong) UIView *coverView;
@property (nonatomic, strong) UITableView *searchTableView;

@property(nonatomic, strong)NSMutableArray *dataSource;

@end

@implementation SearchCategoryViewController
@synthesize searchBar;
@synthesize cateView;
@synthesize dataSource;
@synthesize searchTableView;
@synthesize coverView;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = T(@"分类搜索");
    
    pickedSection = 100;
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setItemSize:CGSizeMake(CELL_WIDTH , CELL_HEIGHT)];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    [flowLayout setMinimumInteritemSpacing:0];
    
    self.cateView = [[UICollectionView alloc]initWithFrame:self.view.bounds collectionViewLayout:flowLayout];
    self.cateView.delegate = self;
    self.cateView.dataSource = self;
    [self.cateView setBackgroundColor:BGCOLOR];
    
    [self.cateView registerClass:[AppViewCell class] forCellWithReuseIdentifier:@"appCell"];
    
    
    UIEdgeInsets currentInset = self.cateView.contentInset;
    
    // Manully set contentInset.
    if (OSVersionIsAtLeastiOS7()) {
        currentInset.top = self.navigationController.navigationBar.bounds.size.height;
        self.automaticallyAdjustsScrollViewInsets = NO;
        // On iOS7, you need plus the height of status bar.
        currentInset.top = IOS7_CONTENT_OFFSET_Y;
        self.cateView.height = self.cateView.height-TABBAR_HEIGHT;
        
        
    }else{
        NSLog(@"ios 6");
        currentInset.bottom += TABBAR_HEIGHT;
    }
    self.cateView.contentInset = currentInset;
    
    [self.view addSubview:self.cateView];
    
    self.dataSource = [[NSMutableArray alloc]init];
    
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 40)];
    self.searchBar.placeholder = @"搜索（按姓名或电话）";
    self.searchBar.barTintColor = UIColorFromRGB(0xdcf2e3);
    [self.searchBar setImage:[UIImage imageNamed:@"search_btn"] forSearchBarIcon:UISearchBarIconSearch state:UIControlStateNormal];
    self.searchBar.delegate = self;

}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self setupDataSource];
}

#pragma mark -- UISearchBar delegate

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    self.cateView.y = 20;
    [self.searchBar setShowsCancelButton:YES animated:YES];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [self controlAccessoryView:0.5];// 显示遮盖层。
    return YES;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    self.cateView.y = IOS7_CONTENT_OFFSET_Y;
    [self.searchBar resignFirstResponder];
    [self.searchBar setShowsCancelButton:NO animated:YES];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self controlAccessoryView:0];// 隐藏遮盖层。
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self.searchBar resignFirstResponder];
    [self.searchBar setShowsCancelButton:NO animated:YES];
    //  to do 搜索
    [self searchAndRefreshTableView];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [self controlAccessoryView:0];// 隐藏遮盖层。
}


- (void)setupDataSource
{
    self.dataSource = @[
                        @{@"name":@"name1",@"id":@"1"},
                        @{@"name":@"name2",@"id":@"2"},
                        @{@"name":@"name3",@"id":@"3"},
                        @{@"name":@"name4",@"id":@"4"},
                        @{@"name":@"name5",@"id":@"5"},
                        @{@"name":@"name6",@"id":@"6"},
                        @{@"name":@"name7",@"id":@"7"},
                        @{@"name":@"name8",@"id":@"8"},
                        @{@"name":@"name9",@"id":@"9"},
                        @{@"name":@"name10",@"id":@"10"},
                        ];
    [self.cateView reloadData];
}


- (void)searchAndRefreshTableView{
    searchStart = 0;
//    [[AppRequestManager sharedManager] searchContactWithUserId:XAppDelegate.me.userId searchString:self.searchBar.text andPage:searchStart andSize:DEFAULT_PAGE_SIZE andBlock:^(id responseObject, NSError *error) {
//        if (ArrayHasValue(responseObject[@"items"])) {
//            
//            NSArray *items = responseObject[@"items"];
//            NSMutableArray *contactArray = [[NSMutableArray alloc]init];
//            
//            for (NSDictionary *dict in items) {
//                CustomerModel *model = [[CustomerModel alloc]initWithDict:dict];
//                [contactArray addObject:model];
//            }
//            
//            searchStart += 1;
//            
//            [self showSetupDataSource:contactArray andError:nil];
//        }
//    }];
    recommendType = recommendSearchResultList;
}


// 控制遮罩层的透明度
- (void)controlAccessoryView:(float)alphaValue{
    
    [UIView animateWithDuration:0.1 animations:^{
        //动画代码
        [self.coverView setAlpha:alphaValue];
    }completion:^(BOOL finished){
        
    }];
}


///////////////////////////////////////////////
#pragma mark - collectionDataSource
///////////////////////////////////////////////
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    if (section == pickedSection) {
        return CGSizeMake(200, 100);
    }else{
        return CGSizeMake(0, 0);
    }
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    NSUInteger _count = [self.dataSource count];
    if ( (_count % ITEM_PER_LINE) == 0) {
        return _count / ITEM_PER_LINE;
    }else{
        return _count / ITEM_PER_LINE + 1;
    }
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return ITEM_PER_LINE;
}


///////////////////////////////////////////////
#pragma mark - collectionDelegate
///////////////////////////////////////////////

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"appCell";
    
    
    NSUInteger index = indexPath.section * ITEM_PER_LINE + indexPath.row;
    
    NSDictionary *cellData = [[NSDictionary alloc]init];
    if (index < [self.dataSource count]) {
        cellData = [self.dataSource objectAtIndex:index];
    }
    
    NSLog(@"index %i",index);
    
    AppViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier
                                                                  forIndexPath:indexPath];
    
    if (cell == nil) {
        //        cell = [[AppViewCell alloc]initWithFrame:CGRectMake(0, 0, CELL_WIDTH,CELL_HEIGHT)];
    }
    
    [cell setRowData:cellData];
    
    return cell;
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    // select someone
    NSUInteger index = indexPath.section * ITEM_PER_LINE + indexPath.row;
    if ( index >= [self.dataSource count]) {
        return;
    }
    
    NSDictionary *cellData = [self.dataSource objectAtIndex:index];
    // open subcategory
    pickedSection = indexPath.section;
    [self.cateView reloadData];
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
