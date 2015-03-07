//
//  SearchCategoryViewController.m
//  mltshop
//
//  Created by mactive.meng on 1/12/14.
//  Copyright (c) 2014 manluotuo. All rights reserved.
//

#import "SearchCategoryViewController.h"
#import "AppRequestManager.h"
#import "CategoryModel.h"
#import "GoodsModel.h"
#import "CategoryItemViewCell.h"
#import "ListViewController.h"
#import "GoodsDetailViewController.h"
#import <HTProgressHUD.h>
#import <HTProgressHUD/HTProgressHUDIndicatorView.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "SGActionView.h"
#import "GoodsOneTableViewCell.h"

typedef NS_ENUM(NSInteger,recommendListType) {
    recommendContactList = 1,
    recommendSearchResultList = 2
} ;

#define ITEM_PER_LINE 3
#define APP_ICON_TAG 100
#define APP_NAME_TAG 101

@interface SearchCategoryViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate,PassValueDelegate>
{
    NSInteger searchStart;
    NSInteger recommendType;
    HTProgressHUD *HUD;
    NSInteger pickedSection;
}

@property(nonatomic, strong) UISearchBar *searchBar;
@property(nonatomic, strong)UICollectionView *cateView;
@property (nonatomic, strong) UIView *coverView;
@property (nonatomic, strong) UITableView *tableView;

@property(nonatomic, strong)NSMutableArray *cateDataSource;
@property(nonatomic, strong)NSMutableArray *dataSource;

@end

@implementation SearchCategoryViewController
@synthesize searchBar;
@synthesize cateView;
@synthesize cateDataSource,dataSource;
@synthesize tableView;
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
    
    [self.cateView registerClass:[CategoryItemViewCell class] forCellWithReuseIdentifier:@"appCell"];
    
    
    UIEdgeInsets currentInset = self.cateView.contentInset;
    
    // Manully set contentInset.
    if (OSVersionIsAtLeastiOS7()) {
        currentInset.top = self.navigationController.navigationBar.bounds.size.height;
//        self.automaticallyAdjustsScrollViewInsets = YES;
        // On iOS7, you need plus the height of status bar.
        currentInset.top = H_40;
        self.cateView.height = self.cateView.height-TABBAR_HEIGHT;
        
        
    }else{
        NSLog(@"ios 6");
        currentInset.bottom += TABBAR_HEIGHT;
    }
    
    self.cateView.contentInset = currentInset;
    [self.view addSubview:self.cateView];
    
    self.cateDataSource = [[NSMutableArray alloc]init];
    
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, IOS7_CONTENT_OFFSET_Y, CGRectGetWidth(self.view.frame), H_40)];
    self.searchBar.placeholder = @"搜索（商品名称）";
    self.searchBar.barTintColor = GREENLIGHTCOLOR2;
    [self.searchBar setImage:[UIImage imageNamed:@"search_btn"] forSearchBarIcon:UISearchBarIconSearch state:UIControlStateNormal];
    self.searchBar.delegate = self;
    [self.view addSubview:self.searchBar];
    
    
    [self initSearchTableView];
}

- (void)initSearchTableView
{
    self.tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.backgroundColor = BGCOLOR;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.separatorColor = SEPCOLOR;
    
    self.tableView.y = IOS7_CONTENT_OFFSET_Y+H_40;
    self.tableView.height = self.tableView.frame.size.height - IOS7_CONTENT_OFFSET_Y-H_40;
    
    self.tableView.delegate = self;
    self.tableView.dataSource  = self;
    self.dataSource = [[NSMutableArray alloc]init];
    
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    [self.view addSubview:self.tableView];
    [self.tableView setHidden:YES];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self setupDataSource];
}

- (void)passSignalValue:(NSString *)value andData:(id)data
{
    if ([value isEqualToString:SIGNAL_SEARCH_CATEGORY_BUTTON_CLICKED]) {
        SearchModel *theSearch = data;
        ListViewController *VC = [[ListViewController alloc]initWithNibName:nil bundle:nil];
        VC.search = theSearch;
        [self.navigationController pushViewController:VC animated:YES];
    }
    
    if ([value isEqualToString:SIGNAL_TAP_VEHICLE]) {
        GoodsModel *theOne = data;
        NSLog(@"%@", theOne);
        
        GoodsDetailViewController *vc = [[GoodsDetailViewController alloc]initWithNibName:nil bundle:nil];
        vc.passDelegate = self;
        [vc setGoodsData:theOne];
        
        [self.navigationController presentViewController:vc animated:YES completion:nil];
    }
}

//////////////////////////////////////////////////
#pragma mark -- UISearchBar delegate
//////////////////////////////////////////////////

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    [self.searchBar setShowsCancelButton:YES animated:YES];
//    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [self.cateView setHidden:YES];
    [self controlAccessoryView:0.5];// 显示遮盖层。
    return YES;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [self.searchBar resignFirstResponder];
    [self.searchBar setShowsCancelButton:NO animated:YES];
//    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self.cateView setHidden:NO];
    [self.tableView setHidden:YES];
    [self controlAccessoryView:0];// 隐藏遮盖层。
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self.searchBar resignFirstResponder];
    [self.searchBar setShowsCancelButton:NO animated:YES];
    //  to do 搜索
    [self searchAndRefreshTableView];
//    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [self.cateView setHidden:YES];
    [self controlAccessoryView:0];// 隐藏遮盖层。
}


- (void)setupDataSource
{
    self.cateDataSource = [[NSMutableArray alloc]init];

    [[AppRequestManager sharedManager]getCategoryAllWithBlock:^(id responseObject, NSError *error) {
        if (responseObject != nil) {
            for (int i = 0 ; i < [responseObject count]; i++) {
                CategoryModel *model = [[CategoryModel alloc]initWithDict:responseObject[i]];
                [self.cateDataSource addObject:model];
            }

            [self.cateView reloadData];
        }
    }];
    
}


- (void)searchAndRefreshTableView{
    searchStart = 1;
    [[AppRequestManager sharedManager]searchWithKeywords:self.searchBar.text cateId:nil brandId:nil intro:nil page:searchStart size:100 andBlock:^(id responseObject, NSError *error) {
        if (responseObject != nil) {
            self.dataSource = [[NSMutableArray alloc]init];
            for (int i = 0 ; i < [responseObject count]; i++) {
                GoodsModel *model = [[GoodsModel alloc]initWithDict:responseObject[i]];
                [self.dataSource addObject:model];
            }
            [self.tableView setHidden:NO];
            [self.cateView setHidden:YES];
            [self.tableView reloadData];
        }

    }];
}


// 控制遮罩层的透明度
- (void)controlAccessoryView:(float)alphaValue{
    
    [UIView animateWithDuration:0.1 animations:^{
        //动画代码
        [self.coverView setAlpha:alphaValue];
    }completion:^(BOOL finished){
        
    }];
}

//////////////////////////////////////////////////
#pragma mark -- UITableView delegate
//////////////////////////////////////////////////
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataSource count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return GOODS_CELL_HEIGHT;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"SearchTableView";
    GoodsModel *cellData = [self.dataSource objectAtIndex:indexPath.row];
    
    GoodsOneTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil) {
        cell = [[GoodsOneTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.passDelegate = self;
    }
    [cell setNewData:cellData];
    

    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    GoodsModel *cellData = [self.dataSource objectAtIndex:indexPath.row];
    
    GoodsDetailViewController *vc = [[GoodsDetailViewController alloc]initWithNibName:nil bundle:nil];
    [vc setGoodsData:cellData];
    
    [self.navigationController presentViewController:vc animated:YES completion:nil];
}

///////////////////////////////////////////////
#pragma mark - collectionDataSource
///////////////////////////////////////////////
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    if (section == pickedSection) {
        return CGSizeMake(TOTAL_WIDTH, H_200);
    }else{
        return CGSizeMake(0, 0);
    }
}


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    NSUInteger _count = [self.cateDataSource count];
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
    
    CategoryModel *cellData = [[CategoryModel alloc]init];
    if (index < [self.cateDataSource count]) {
        cellData = [self.cateDataSource objectAtIndex:index];
        cellData.indexPath = indexPath;
    }
    
    CategoryItemViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier
                                                                  forIndexPath:indexPath];
    
    if (cell == nil) {
        //        cell = [[CategoryItemViewCell alloc]initWithFrame:CGRectMake(0, 0, CELL_WIDTH,CELL_HEIGHT)];
    }
    cell.passDelegate = self;
    [cell setRowData:cellData];
    
    return cell;
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    // select someone
    NSUInteger index = indexPath.section * ITEM_PER_LINE + indexPath.row;
    if ( index >= [self.cateDataSource count]) {
        return;
    }
    
    CategoryModel *cellData = self.cateDataSource[index];
    NSMutableArray *titles = [[NSMutableArray alloc]init];
    NSMutableArray *ids = [[NSMutableArray alloc]init];
    for (BrandModel *brand in cellData.subBrands) {
        [titles addObject:brand.brandName];
        [ids addObject:brand.brandId];
    }
    
    [SGActionView showGridMenuWithTitle:T(@"子品牌") itemTitles:titles images:nil selectedHandle:^(NSInteger index) {
        
        SearchModel *theSearch = [[SearchModel alloc]init];
        theSearch.brandId = ids[index];
        theSearch.catId = cellData.catId;
        ListViewController *VC = [[ListViewController alloc]initWithNibName:nil bundle:nil];
        VC.search = theSearch;
        [self.navigationController pushViewController:VC animated:YES];
        //
    }];
    
//
//    // open subcategory
//    for (int i = 0; i<[self.cateDataSource count]; i++) {
//        CategoryModel *cellData = self.cateDataSource[i];
//        if (i == index) {
//            cellData.isPicked = YES;
//        }else{
//            cellData.isPicked = NO;
//        }
//    }
//
//    
//    pickedSection = indexPath.section;
//
//    [self.cateView reloadData];
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
