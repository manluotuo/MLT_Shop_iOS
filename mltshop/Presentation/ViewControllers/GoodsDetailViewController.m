//
//  GoodsDetailViewController.m
//  mltshop
//
//  Created by mactive.meng on 14/12/14.
//  Copyright (c) 2014 manluotuo. All rights reserved.
//

#import "GoodsDetailViewController.h"
#import "NSString+Size.h"
#import "GCPagedScrollView.h"
#import "FAHoverButton.h"
#import "FAIconButton.h"
#import "KKFlatButton.h"
#import "AppRequestManager.h"
#import "SGActionView.h"
#import "NSString+FontAwesome.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "WebViewController.h"
#import "CartListViewController.h"
#import "ShareHelper.h"

#import "CommentTableViewCell.h"

#define SERVICE_TAB_TAG     101
#define ADD_CART_TAB_TAG    102
#define CART_TAB_TAG        103

@interface GoodsDetailViewController ()<UIScrollViewDelegate,UIWebViewDelegate,UITableViewDataSource,UITableViewDelegate>
{
    CGFloat fixedHeight;
    CGFloat htmlHeight;
    CGFloat commentHeight;
    CGFloat cellHeight;
    CGSize fixedSize;
}
// view
@property(nonatomic, strong)GoodsModel *theGoods;
@property(nonatomic, strong)GCPagedScrollView *galleryView;
// infoview
@property(nonatomic, strong)UIView *infoView;
@property(nonatomic, strong)UILabel *titleLabel;
@property(nonatomic, strong)UILabel *briefLabel;
@property(nonatomic, strong)UILabel *priceLabel;
@property(nonatomic, strong)UILabel *priceTitle;
@property(nonatomic, strong)UILabel *marketPriceLabel;
@property(nonatomic, strong)UILabel *inventoryLabel;
@property(nonatomic, strong)FAIconButton *specificationButton;
@property(nonatomic, strong)UIButton *brandButton;
@property(nonatomic, strong)UIButton *htmlBtn; /** 商品详情 */
@property(nonatomic, strong)UIButton *commentBtn; /** 用户评价 */
@property(nonatomic, strong)UIButton *collectBtn; /** 收藏 */

@property(nonatomic, strong)UIWebView *htmlView;
@property(nonatomic, strong)UITableView *commentView;

@property(nonatomic, strong)UIScrollView *fixedView;
@property(nonatomic, strong)UIView *topNavView;
@property(nonatomic, strong)UIView *lableView;

// 底部tabbar
@property(nonatomic, strong)UIView *tabbarView;
@property(nonatomic, strong)FAIconButton *serviceTabButton;
@property(nonatomic, strong)FAIconButton *cartTabButton;
@property(nonatomic, strong)FAIconButton *buyTabButton;
@property(nonatomic, strong)UILabel *cartCountLabel;


// 3个按钮
@property(nonatomic, strong)FAHoverButton *backButton;
@property(nonatomic, strong)FAHoverButton *shareButton;
@property(nonatomic, strong)FAHoverButton *favButton;


@property(nonatomic, strong)NSMutableArray *commentData;

@end

@implementation GoodsDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.view.backgroundColor = BGCOLOR;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self buildFixedView];
    self.commentData = [[NSMutableArray alloc] init];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gotoIndexAction) name:SIGNAL_GO_TO_INDEX_PAGE object:nil];
    
}

- (void)gotoIndexAction
{
    [self dismissViewControllerAnimated:YES completion:^{
        [[NSNotificationCenter defaultCenter] postNotificationName:SIGNAL_GO_TO_INDEX object:nil userInfo:nil];
    }];
}

- (void)viewWillAppear: (BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void)tabbarAction:(UIButton *)sender
{
    if (sender.tag == ADD_CART_TAB_TAG) {
        
        NSMutableArray *titleArray = [[NSMutableArray alloc]init];
        
        /**
         *  如果只有一个 那么默认选第一个
         */
        if ([self.theGoods.spec.values count] == 1) {
            SpecItemModel *item = [self.theGoods.spec.values firstObject];
            CartModel *newCartItem = [[CartModel alloc]init];
            newCartItem.goodsId = self.theGoods.goodsId;
            newCartItem.goodsCount = INT(1);
            newCartItem.goodsAttrId = item.itemId;
            
            [self addToCart:newCartItem];
        }else if ([self.theGoods.spec.values count] > 1){
            
            
            for (SpecItemModel *item in self.theGoods.spec.values) {
                [titleArray addObject:item.label];
            }
            
            [SGActionView showSheetWithTitle:T(@"选择尺码/颜色分类")  itemTitles:titleArray selectedIndex:100 selectedHandle:^(NSInteger index) {
                
                SpecItemModel *specItem = [self.theGoods.spec.values objectAtIndex:index];
                CartModel *newCartItem = [[CartModel alloc]init];
                newCartItem.goodsId = self.theGoods.goodsId;
                newCartItem.goodsCount = INT(1);
                newCartItem.goodsAttrId = specItem.itemId;
                
                
                [self addToCart:newCartItem];
                
            }];
        }else{
            // 没有spec 的
            CartModel *newCartItem = [[CartModel alloc]init];
            newCartItem.goodsId = self.theGoods.goodsId;
            newCartItem.goodsCount = INT(1);
            newCartItem.goodsAttrId = @"";
            
            [self addToCart:newCartItem];
        }
        
    }else if (sender.tag == SERVICE_TAB_TAG){
        NSString *urlString = CUSTOMER_SERVICE_URL;
        WebViewController *VC = [[WebViewController alloc]initWithNibName:nil bundle:nil];
        VC.titleString = T(@"帮助/客服");
        VC.urlString = urlString;
        [VC setUpDownButton:0];
        ColorNavigationController *nav = [[ColorNavigationController alloc]initWithRootViewController:VC];
        [self presentViewController:nav animated:YES completion:nil];
    }else if (sender.tag == CART_TAB_TAG){
        CartListViewController *VC = [[CartListViewController alloc]init];
        [VC setUpDownButton:0];
        ColorNavigationController *nav = [[ColorNavigationController alloc]initWithRootViewController:VC];
        [self presentViewController:nav animated:YES completion:nil];
    }
}

- (void)addToCart:(CartModel *)cartModel
{
    [SGActionView resetSGActionViewInstance:nil];
    NSArray *titles = @[@"1", @"2", @"3", @"4", @"5", @"6", @"7"];
    [SGActionView showGridMenuWithTitle:T(@"选择数量") itemTitles:titles images:nil selectedHandle:^(NSInteger index) {
        cartModel.goodsCount = INT(index+1);
        [[AppRequestManager sharedManager]operateCartWithCartModel:cartModel operation:CartOpsCreate andBlock:^(id responseObject, NSError *error) {
            if (responseObject != nil) {
                [DataTrans showWariningTitle:T(@"成功加入购物车") andCheatsheet:ICON_CHECK];
                [self refreshCartCount];
            }
        }];
    }];
    
}

/**
 *  init views
 */
- (void)buildFixedView
{
    fixedHeight = 0.0f;
    self.fixedView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, TOTAL_WIDTH, self.view.frame.size.height)];
    self.fixedView.delegate = self;
    
    [self initGalleryView];
    [self initInfoView];
    [self initHtmlView];
    
    [self.fixedView setContentSize:CGSizeMake(TOTAL_WIDTH, fixedHeight)];
    [self.view addSubview:self.fixedView];
    
    [self initTabbarButton];
    
    [self initButtons];
    
    // 左滑退出
    UISwipeGestureRecognizer *gestureRec = [[UISwipeGestureRecognizer alloc] initWithTarget:self
                                                                                     action:@selector(backAction)];
    [gestureRec setDirection:UISwipeGestureRecognizerDirectionRight];
    [self.fixedView addGestureRecognizer:gestureRec];
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if ([scrollView isEqual:self.galleryView]) {
        if (self.galleryView.contentOffset.x < -H_80) {
            [self backAction];
        }
    }
    
    if ([scrollView isEqual:self.fixedView]) {
        
        if (self.fixedView.contentOffset.y < -H_80) {
            [self backAction];
        }
    }
}

- (void)initTabbarButton
{
    self.tabbarView = [[UIView alloc]initWithFrame:CGRectMake(0, TOTAL_HEIGHT-H_50, TOTAL_WIDTH, H_50)];
    self.tabbarView.backgroundColor = [UIColor colorWithRed:245 green:245 blue:245 alpha:0.8];
    
    self.serviceTabButton = [[FAIconButton alloc]initWithFrame:CGRectMake(0, 0, TOTAL_WIDTH/3, H_50)];
    [self.serviceTabButton setIconString:[NSString fontAwesomeIconStringForEnum:FACommentsO]];
    [self.serviceTabButton setTitle:T(@"联系客服") forState:UIControlStateNormal];
    [self.serviceTabButton setTitleColor:DARKCOLOR];
    [self.serviceTabButton setIconColor:ORANGECOLOR];
    [self.serviceTabButton changeLightStyle];
    self.serviceTabButton.tag = SERVICE_TAB_TAG;
    self.serviceTabButton.titleLabel.font = FONT_14;
    [self.serviceTabButton addTarget:self action:@selector(tabbarAction:) forControlEvents:UIControlEventTouchUpInside];
    
    self.cartTabButton = [[FAIconButton alloc]initWithFrame:CGRectMake(TOTAL_WIDTH/3, 0, TOTAL_WIDTH/3, H_50)];
    [self.cartTabButton setIconString:[NSString fontAwesomeIconStringForEnum:FAPlusCircle]];
    [self.cartTabButton setTitle:T(@"加购物车") forState:UIControlStateNormal];
    [self.cartTabButton setTitleColor:DARKCOLOR];
    [self.cartTabButton setIconColor:ORANGECOLOR];
    [self.cartTabButton changeLightStyle];
    self.cartTabButton.tag = ADD_CART_TAB_TAG;
    self.cartTabButton.titleLabel.font = FONT_14;
    [self.cartTabButton addTarget:self action:@selector(tabbarAction:) forControlEvents:UIControlEventTouchUpInside];
    
    
    self.buyTabButton = [[FAIconButton alloc]initWithFrame:CGRectMake(TOTAL_WIDTH/3*2, 0, TOTAL_WIDTH/3, H_50)];
    [self.buyTabButton setIconString:[NSString fontAwesomeIconStringForEnum:FAShoppingCart]];
    [self.buyTabButton setTitle:T(@"购物车") forState:UIControlStateNormal];
    [self.buyTabButton setTitleColor:DARKCOLOR];
    [self.buyTabButton setIconColor:ORANGECOLOR];
    [self.buyTabButton changeLightStyle];
    self.buyTabButton.tag = CART_TAB_TAG;
    self.buyTabButton.titleLabel.font = FONT_14;
    [self.buyTabButton addTarget:self action:@selector(tabbarAction:) forControlEvents:UIControlEventTouchUpInside];
    
    self.cartCountLabel = [[UILabel alloc]initWithFrame:CGRectMake(H_80, H_10, H_16, H_16)];
    [self.cartCountLabel.layer setCornerRadius:H_8];
    [self.cartCountLabel.layer setMasksToBounds:YES];
    self.cartCountLabel.textAlignment = NSTextAlignmentCenter;
    self.cartCountLabel.backgroundColor = REDCOLOR;
    self.cartCountLabel.font = CUSTOMFONT_12;
    self.cartCountLabel.textColor = WHITECOLOR;
    [self.buyTabButton addSubview:self.cartCountLabel];
    
    [self.tabbarView addSubview:self.serviceTabButton];
    [self.tabbarView addSubview:self.cartTabButton];
    [self.tabbarView addSubview:self.buyTabButton];
    
    [self.view addSubview:self.tabbarView];
    
}



-(void)initButtons
{
    self.topNavView = [[UIView alloc]initWithFrame:CGRectMake(0, H_20, TOTAL_WIDTH, H_40)];
    
    self.backButton = [[FAHoverButton alloc]initWithFrame:CGRectMake(H_20, 0, H_40, H_40)];
    [self.backButton setIconString:[NSString fontAwesomeIconStringForEnum:FAChevronLeft]];
    [self.backButton setBackgroundColor:BlACKALPHACOLOR];
    [self.backButton setRounded];
    [self.backButton setIconFont:FONT_AWESOME_20];
    [self.backButton addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    [self.topNavView addSubview:self.backButton];
    
    
    self.shareButton = [[FAHoverButton alloc]initWithFrame:CGRectMake(TOTAL_WIDTH-H_60, 0, H_40, H_40)];
    [self.shareButton setIconString:[NSString fontAwesomeIconStringForEnum:FAshareAlt]];
    [self.shareButton setBackgroundColor:BlACKALPHACOLOR];
    [self.shareButton setRounded];
    [self.shareButton setIconFont:FONT_AWESOME_20];
    [self.shareButton addTarget:self action:@selector(shareAction) forControlEvents:UIControlEventTouchUpInside];
    [self.topNavView addSubview:self.shareButton];
    
    [self.view addSubview:self.topNavView];
    
    
}

-(void)backAction
{
    [self dismissViewControllerAnimated:YES completion:^{
        //
    }];
}

-(void)shareAction
{
    [ShareHelper sharedHelper].baseViewController = self.navigationController;
    [[ShareHelper sharedHelper]showShareView:self.theGoods];
    
}


-(void)initInfoView
{
    CGRect rect = CGRectMake(0, fixedHeight, TOTAL_WIDTH, H_90 + H_100 + H_40);
    self.infoView = [[UIView alloc]initWithFrame:rect];
    self.infoView.backgroundColor = WHITECOLOR;
    self.infoView.userInteractionEnabled = YES;
    
    self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(H_18, H_15, H_260, H_20)];
    [self.titleLabel setFont:[UIFont boldSystemFontOfSize:14]];
    [self.titleLabel setTextColor:DARKCOLOR];
    [self.titleLabel setTextAlignment:NSTextAlignmentLeft];
    self.titleLabel.numberOfLines = 0;
    
    self.briefLabel = [[UILabel alloc]initWithFrame:CGRectMake(H_18, H_45, H_260, H_40)];
    [self.briefLabel setFont:FONT_12];
    [self.briefLabel setTextColor:GRAYCOLOR];
    [self.briefLabel setTextAlignment:NSTextAlignmentLeft];
    self.briefLabel.numberOfLines = 0;
    
    self.priceTitle = [[UILabel alloc]initWithFrame:CGRectMake(H_18, H_90+H_15, H_60, H_24)];
    self.priceTitle.text = T(@"本店价");
    self.priceTitle.font = FONT_14;
    
    self.priceLabel = [[UILabel alloc]initWithFrame:CGRectMake(H_18+H_60, H_90+H_15, H_60, H_24)];
    [self.priceLabel setFont:FONT_14];
    [self.priceLabel setTextColor:WHITECOLOR];
    [self.priceLabel setBackgroundColor:ORANGECOLOR];
    [self.priceLabel.layer setCornerRadius:H_5];
    [self.priceLabel.layer setMasksToBounds:YES];
    [self.priceLabel setTextAlignment:NSTextAlignmentCenter];
    
    self.marketPriceLabel = [[UILabel alloc]initWithFrame:CGRectMake(H_18+H_60*2, H_90+H_15, H_60, H_24)];
    [self.marketPriceLabel setFont:FONT_12];
    [self.marketPriceLabel setTextColor:GRAYCOLOR];
    [self.marketPriceLabel setTextAlignment:NSTextAlignmentCenter];
    
    UILabel *inventoryTitle = [[UILabel alloc]initWithFrame:CGRectMake(H_220, H_90+H_15, H_50, H_24)];
    inventoryTitle.text = T(@"库存");
    inventoryTitle.font = FONT_14;
    
    self.inventoryLabel = [[UILabel alloc]initWithFrame:CGRectMake(H_220+H_50, H_90+H_15, H_70, H_24)];
    [self.inventoryLabel setFont:FONT_14];
    [self.inventoryLabel setTextColor:GRAYCOLOR];
    [self.priceLabel setTextAlignment:NSTextAlignmentCenter];
    
    
    UILabel *brandTitle = [[UILabel alloc]initWithFrame:CGRectMake(H_18, H_140+H_15, H_50, H_24)];
    brandTitle.text = T(@"品牌");
    brandTitle.font = FONT_14;
    
    self.collectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.collectBtn setFrame:CGRectMake(H_200, H_140+H_15, H_80, H_24)];
    [self.collectBtn setTitle:T(@"收藏") forState:UIControlStateNormal];
    [self.collectBtn setTitleColor:BLACKCOLOR forState:UIControlStateNormal];
    [self.collectBtn setTitle:T(@"已收藏") forState:UIControlStateSelected];
    [self.collectBtn.titleLabel setFont:FONT_14];
    [self.collectBtn setBackgroundColor:[UIColor grayColor]];
    [self.collectBtn setSelected:NO];
    [self.collectBtn addTarget:self action:@selector(onCollectBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    
    self.brandButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.brandButton setFrame:CGRectMake(H_80, H_140+H_8, H_220, H_40)];
    [self.brandButton setTitleColor:GRAYCOLOR forState:UIControlStateNormal];
    self.brandButton.titleLabel.font = FONT_14;
    self.brandButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    //    [self.brandButton addTarget:self action:@selector(buttonAction) forControlEvents:UIControlEventTouchUpInside];
    
    
    /** 去除选择尺码/颜色分类 */
    //    self.specificationButton = [[FAIconButton alloc]initWithFrame:CGRectMake(H_20, H_90+H_100, H_280, H_50)];
    //    [self.specificationButton setIconString:[NSString fontAwesomeIconStringForEnum:FAAngleRight]];
    //    [self.specificationButton setTitle:T(@"选择尺码/颜色分类") forState:UIControlStateNormal];
    //    [self.specificationButton changeRightIcon];
    //    [self.specificationButton setTitleColor:GREENLIGHTCOLOR];
    //    [self.specificationButton setIconColor:GREENCOLOR];
    //    [self.specificationButton changeLightStyle];
    //    [self.specificationButton.iconLabel setFont:FONT_AWESOME_30];
    //    [self.specificationButton addTarget:self action:@selector(chooseSpecAction) forControlEvents:UIControlEventTouchUpInside];
    
    /** 图文详情与用户评价 */
    self.lableView = [[UIView alloc] initWithFrame:CGRectMake(0, H_90+H_100, TOTAL_WIDTH, H_40)];
    //    self.lableView.backgroundColor = [UIColor redColor];
    
    
    self.htmlBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.htmlBtn.titleLabel.font = FONT_14;
    [self.htmlBtn setTitle:T(@"图文详情") forState:UIControlStateNormal];
    [self.htmlBtn setFrame:CGRectMake(0, 0, TOTAL_WIDTH/2, H_40)];
    [self.htmlBtn setTitleColor:BlACKCOLOR forState:UIControlStateNormal];
    [self.htmlBtn setTitleColor:ORANGECOLOR forState:UIControlStateSelected];
    [self.htmlBtn setBackgroundColor:GRAYEXLIGHTCOLOR];
    [self.htmlBtn setSelected:YES];
    [self.htmlBtn addTarget:self action:@selector(onHtmlBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.lableView addSubview:self.htmlBtn];
    
    self.commentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.commentBtn.titleLabel.font = FONT_14;
    [self.commentBtn setFrame:CGRectMake(TOTAL_WIDTH/2, 0, TOTAL_WIDTH/2, H_40)];
    [self.commentBtn setTitle:T(@"用户评论") forState:UIControlStateNormal];
    [self.commentBtn setTitleColor:BlACKCOLOR forState:UIControlStateNormal];
    [self.commentBtn setTitleColor:ORANGECOLOR forState:UIControlStateSelected];
    [self.commentBtn setBackgroundColor:GRAYEXLIGHTCOLOR];
    [self.commentBtn setSelected:NO];
    [self.commentBtn addTarget:self action:@selector(onCommentBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.lableView addSubview:self.commentBtn];
    
    //    UILabel *htmlTitle = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, TOTAL_WIDTH/2, H_40)];
    //    htmlTitle.text = T(@"图文详情");
    //    htmlTitle.font = FONT_12;
    //    htmlTitle.textAlignment = NSTextAlignmentCenter;
    //    htmlTitle.backgroundColor = GRAYEXLIGHTCOLOR;
    //    [self.lableView addSubview:htmlTitle];
    
    
    //    [self.infoView addSubview:self.titleLabel];
    //    [self.infoView addSubview:self.briefLabel];
    //    [self.infoView addSubview:self.priceTitle];
    //    [self.infoView addSubview:self.priceLabel];
    //    [self.infoView addSubview:self.marketPriceLabel];
    //    [self.infoView addSubview:inventoryTitle];
    //    [self.infoView addSubview:self.inventoryLabel];
    //    [self.infoView addSubview:brandTitle];
    //    [self.infoView addSubview:self.brandButton];
    //    [self.infoView addSubview:self.specificationButton];
    //    [self.infoView addSubview:htmlTitle];
    
    
    //    UILabel *commentTitle = [[UILabel alloc]initWithFrame:CGRectMake(TOTAL_WIDTH/2, 0, TOTAL_WIDTH/2, H_40)];
    //    commentTitle.text = T(@"用户评论");
    //    commentTitle.font = FONT_12;
    //    commentTitle.textAlignment = NSTextAlignmentCenter;
    //    commentTitle.backgroundColor = GRAYEXLIGHTCOLOR;
    //    [self.lableView addSubview:commentTitle];
    
    [self.infoView addSubview:self.titleLabel];
    [self.infoView addSubview:self.briefLabel];
    [self.infoView addSubview:self.priceTitle];
    [self.infoView addSubview:self.priceLabel];
    [self.infoView addSubview:self.marketPriceLabel];
    [self.infoView addSubview:inventoryTitle];
    [self.infoView addSubview:self.inventoryLabel];
    [self.infoView addSubview:brandTitle];
    [self.infoView addSubview:self.brandButton];
    //    [self.infoView addSubview:self.specificationButton];
    //    [self.infoView addSubview:htmlTitle];
    [self.infoView addSubview:self.lableView];
    [self.infoView addSubview:self.collectBtn];
    
    
    
    
    UIView *lineView1 = [[UIView alloc]initWithFrame:CGRectMake(0, H_90, TOTAL_WIDTH, 1)];
    lineView1.backgroundColor = GRAYEXLIGHTCOLOR;
    UIView *lineView2 = [[UIView alloc]initWithFrame:CGRectMake(0, H_90+H_50, TOTAL_WIDTH, 1)];
    lineView2.backgroundColor = GRAYEXLIGHTCOLOR;
    UIView *lineView3 = [[UIView alloc]initWithFrame:CGRectMake(0, H_90+H_50*2, TOTAL_WIDTH, 1)];
    lineView3.backgroundColor = GRAYEXLIGHTCOLOR;
    UIView *lineView4 = [[UIView alloc]initWithFrame:CGRectMake(H_200, H_90, 1, H_50)];
    lineView4.backgroundColor = GRAYEXLIGHTCOLOR;
    UIView *lineView5 = [[UIView alloc] initWithFrame:CGRectMake(TOTAL_WIDTH/2, 0, 1, 40)];
    lineView5.backgroundColor = [UIColor whiteColor];
    
    [self.lableView addSubview:lineView5];
    [self.infoView addSubview:lineView1];
    [self.infoView addSubview:lineView2];
    [self.infoView addSubview:lineView3];
    [self.infoView addSubview:lineView4];
    
    
    
    [self.fixedView addSubview:self.infoView];
    
    fixedHeight += rect.size.height;
}

-(void)initHtmlView
{
    htmlHeight = TOTAL_HEIGHT;
    self.htmlView = [[UIWebView alloc]initWithFrame:CGRectMake(0, fixedHeight, TOTAL_WIDTH, htmlHeight)];
    [self.fixedView addSubview:self.htmlView];
    self.htmlView.delegate = self;
}

- (void)initCommentView {
    
    commentHeight = 0.1;
    self.commentView = [[UITableView alloc] initWithFrame:CGRectMake(0, fixedHeight, TOTAL_WIDTH, commentHeight)];
    self.commentView.delegate = self;
    self.commentView.dataSource = self;
    [self.fixedView addSubview:self.commentView];
    //    self.fixedView.contentOffset = CGPointMake(0, 0);
}


- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    if (navigationType == UIWebViewNavigationTypeLinkClicked) {
        return NO;
    }else{
        return YES;
    }
}

-(void)initGalleryView
{
    // gallery view
    CGFloat playerY = fixedHeight;
    CGRect rect = CGRectMake(0, playerY, TOTAL_WIDTH, TOTAL_WIDTH);
    self.galleryView = [[GCPagedScrollView alloc]initWithFrame:rect andPageControl:YES];
    
    self.galleryView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
    self.galleryView.backgroundColor = GRAYEXLIGHTCOLOR;
    self.galleryView.minimumZoomScale = 1; //最小到0.3倍
    self.galleryView.maximumZoomScale = 1.0; //最大到3倍
    self.galleryView.clipsToBounds = YES;
    self.galleryView.scrollEnabled = YES;
    self.galleryView.pagingEnabled = YES;
    self.galleryView.delegate = self;
    [self.galleryView removeAllContentSubviews];
    // list data foreach add page
    [self.fixedView addSubview:self.galleryView];
    
    fixedHeight += TOTAL_WIDTH;
    
}

- (void)setGoodsData:(GoodsModel *)_goods
{
    self.theGoods = _goods;
    
    [[AppRequestManager sharedManager]getGoodsDetailWithGoodsId:_goods.goodsId andBlcok:^(id responseObject, NSError *error) {
        if (responseObject != nil) {
            self.theGoods = [[GoodsModel alloc]initWithDict:responseObject];
            [self refreshViewWithData];
        }
    }];
    
    [self refreshCartCount];
}


- (void)refreshCartCount
{
    [[AppRequestManager sharedManager]operateCartWithCartModel:nil operation:CartOpsList andBlock:^(id responseObject, NSError *error) {
        if (responseObject != nil) {
            NSArray *goodsList = responseObject[@"goods_list"];
            [UIView animateWithDuration:0.3
                                  delay:0
                                options:UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionAllowUserInteraction
                             animations:^{
                                 //Move frame or transform view
                                 self.cartCountLabel.y = H_15;
                                 self.cartCountLabel.text = STR_INT([goodsList count]);
                             } completion:^(BOOL finished) {
                                 [UIView animateWithDuration:0.3 animations:^{
                                     self.cartCountLabel.y = H_10;
                                     
                                 }];
                             }];
        }
    }];
}

- (void)refreshViewWithData
{
    // refresh galleryView
    CGRect scrollFrame = CGRectMake(0, 0, TOTAL_WIDTH, TOTAL_WIDTH);
    for (int i = 0 ; i < [self.theGoods.gallery count]; i++) {
        // last one
        UIImageView *page = [[UIImageView alloc]
                             initWithFrame:scrollFrame];
        
        [page setContentMode:UIViewContentModeScaleAspectFill];
        
        PhotoModel *onePhoto = self.theGoods.gallery[i];
        [page sd_setImageWithURL:[NSURL URLWithString:onePhoto.thumb]];
        [self.galleryView addContentSubview:page];
    }
    
    self.titleLabel.text = self.theGoods.goodsName;
    self.briefLabel.text = self.theGoods.goodsBrief;
    
    // 售价
    if (self.theGoods.promotePrice.integerValue > 0) {
        self.priceTitle.text = @"促销价";
        self.priceLabel.text = STR_NUM2([self.theGoods.promotePrice floatValue]);
    }else{
        self.priceTitle.text = @"本店价";
        self.priceLabel.text = STR_NUM2([self.theGoods.shopPrice floatValue]);
    }
    // 市场价
    NSAttributedString * marketPriceString =
    [[NSAttributedString alloc] initWithString: STR_NUM2([self.theGoods.marketPrice floatValue])
                                    attributes:@{NSStrikethroughStyleAttributeName:@(NSUnderlineStyleSingle)}];
    
    self.marketPriceLabel.attributedText = marketPriceString;
    
    self.inventoryLabel.text = STR_INT([self.theGoods.goodsInvertory integerValue]);
    [self.brandButton setTitle:self.theGoods.brandName forState:UIControlStateNormal];
    
    [self.htmlView loadHTMLString:self.theGoods.goodsDesc baseURL:nil];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    if ([webView isEqual:self.htmlView]) {
        htmlHeight = self.htmlView.scrollView.contentSize.height;
        self.htmlView.height = htmlHeight;
        fixedHeight += htmlHeight;
        [self.fixedView setContentSize:CGSizeMake(TOTAL_WIDTH, fixedHeight)];
    }
}



- (void)chooseSpecAction
{
    NSMutableArray *titleArray = [[NSMutableArray alloc]init];
    for (SpecItemModel *item in self.theGoods.spec.values) {
        [titleArray addObject:item.label];
    }
    [SGActionView showSheetWithTitle:T(@"选择尺码/颜色分类")  itemTitles:titleArray selectedIndex:100 selectedHandle:^(NSInteger index) {
        //
    }];
}


#pragma mark - UITableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSLog(@"%ld", self.commentData.count);
    return self.commentData.count;
}


// 这有个BUG
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CommentId"];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"CommentTableViewCell" owner:self options:nil] lastObject];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    CommentModel *model = self.commentData[indexPath.row];
    [cell setCellData:model];
    cellHeight = [cell setCellHeight];
    

    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    self.commentView.height += cellHeight;
    NSLog(@"%f", self.commentView.height);
    self.fixedView.contentSize = CGSizeMake(WIDTH, H_550+H_100 + self.commentView.height);
    fixedSize = self.fixedView.contentSize;
    
    NSLog(@"!!!!!!!%f", cellHeight);
    return cellHeight;
}

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleDefault;
}

#endif

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - ButtonClick
/** 商品详情点击事件 */
- (void)onHtmlBtnClick {
    
    self.fixedView.contentOffset = CGPointMake(0, 0);
    if (self.htmlBtn.selected == YES) {
        return;
    }
    fixedHeight = H_550;
    if (self.commentView != nil) {
        [self.commentView setHidden:YES];
    }
    [self initHtmlView];
    [self.htmlView loadHTMLString:self.theGoods.goodsDesc baseURL:nil];
    self.htmlBtn.selected = YES;
    self.commentBtn.selected = NO;
    NSLog(@"onHtmlBtnClick");
}

/** 用户评论点击事件 */
- (void)onCommentBtnClick {
    
    self.fixedView.contentOffset = CGPointMake(0, 0);
    if (self.commentBtn.selected == YES) {
        return;
    }
    fixedHeight = H_550;
    if (self.htmlView != nil) {
        [self.htmlView removeFromSuperview];
        self.htmlView = nil;
    }
    if (self.commentData.count < 1) {
        [[AppRequestManager sharedManager] getCommentWithGoodsId:self.theGoods.goodsId andBlock:^(id responseObject, NSError *error) {
            for (NSDictionary *dict in responseObject[@"data"]) {
                CommentModel *model = [[CommentModel alloc] init];
                [model setValuesForKeysWithDictionary:dict];
                
                [self.commentData addObject:model];
            }
            
            [self.commentView reloadData];
        }];
    }
    
    if (self.commentView == nil) {
        [self initCommentView];
        
    } else {
        [self.commentView setHidden:NO];
        self.fixedView.contentSize = fixedSize;
    }
    
    self.htmlBtn.selected = NO;
    self.commentBtn.selected = YES;
    NSLog(@"onCommentClick");
    
}

/** 收藏按钮点击事件 */
- (void)onCollectBtnClick {
    
    if (self.collectBtn.selected == NO) {
        [[AppRequestManager sharedManager]getCollectAddWithGoodsId:self.theGoods.goodsId andBlock:^(id responseObject, NSError *error) {
            NSLog(@"%@", responseObject[@"status"][@"succeed"]);
            if (responseObject != nil) {
                [DataTrans showWariningTitle:T(@"已成功收藏") andCheatsheet:@"" andDuration:1.0f];
            }
            /*if (error != nil) */ else {
                NSDictionary *userDict = [error userInfo];
                if ([userDict[@"succeed"] isEqualToNumber:INT(0)]) {
                    [DataTrans showWariningTitle:userDict[@"error_desc"] andCheatsheet:ICON_TIMES andDuration:1.0f];
                }
            }
        }];
    } else {
        NSLog(@"已取消收藏");
    }
    
    self.collectBtn.selected = !self.collectBtn.selected;
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
