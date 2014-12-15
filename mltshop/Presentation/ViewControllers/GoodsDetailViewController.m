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

#import "NSString+FontAwesome.h"
#import <SDWebImage/UIImageView+WebCache.h>


@interface GoodsDetailViewController ()<UIScrollViewDelegate>
{
    CGFloat fixedHeight;
}
// view
@property(nonatomic, strong)GoodsModel *theGoods;
@property(nonatomic, strong)GCPagedScrollView *galleryView;
// infoview
@property(nonatomic, strong)UIView *infoView;
@property(nonatomic, strong)UILabel *titleLabel;
@property(nonatomic, strong)UILabel *briefLabel;
@property(nonatomic, strong)UILabel *priceLabel;
@property(nonatomic, strong)UILabel *marketPriceLabel;
@property(nonatomic, strong)UILabel *inventoryLabel;
@property(nonatomic, strong)UIButton *brandButton;
@property(nonatomic, strong)FAIconButton *specificationButton;


@property(nonatomic, strong)UIView *htmlView;

@property(nonatomic, strong)UIScrollView *fixedView;

// 3个按钮
@property(nonatomic, strong)KKFlatButton *backButton;
@property(nonatomic, strong)KKFlatButton *shareButton;
@property(nonatomic, strong)KKFlatButton *favButton;




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
}

/**
 *  init views
 */
- (void)buildFixedView
{
    fixedHeight = 0.0f;
    self.fixedView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, TOTAL_WIDTH, self.view.frame.size.height)];
    
    [self initGalleryView];
    [self initInfoView];
    [self initHtmlView];
    [self initButtons];
    [self.view addSubview:self.fixedView];
}

-(void)initButtons
{
    
}

-(void)initInfoView
{
    CGRect rect = CGRectMake(0, fixedHeight, TOTAL_WIDTH, H_90 + H_150);
    self.infoView = [[UIView alloc]initWithFrame:rect];

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
    
    UILabel *priceTitle = [[UILabel alloc]initWithFrame:CGRectMake(H_18, H_90+H_15, H_60, H_24)];
    priceTitle.text = T(@"本店价");
    priceTitle.font = FONT_14;
    
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

    UILabel *inventoryTitle = [[UILabel alloc]initWithFrame:CGRectMake(H_200, H_90+H_15, H_50, H_24)];
    inventoryTitle.text = T(@"库存");
    inventoryTitle.font = FONT_14;

    self.inventoryLabel = [[UILabel alloc]initWithFrame:CGRectMake(H_200+H_50, H_90+H_15, H_70, H_24)];
    [self.inventoryLabel setFont:FONT_14];
    [self.inventoryLabel setTextColor:GRAYCOLOR];
    [self.priceLabel setTextAlignment:NSTextAlignmentCenter];
    
    
    UILabel *brandTitle = [[UILabel alloc]initWithFrame:CGRectMake(H_18, H_140+H_15, H_50, H_24)];
    brandTitle.text = T(@"品牌");
    brandTitle.font = FONT_14;
    
    self.brandButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.brandButton setFrame:CGRectMake(H_100, H_140, H_100, H_40)];
    [self.brandButton setTitleColor:GRAYCOLOR forState:UIControlStateNormal];
    
    self.specificationButton = [[FAIconButton alloc]initWithFrame:CGRectMake(H_20, H_90+H_100, H_280, H_50)];
    [self.specificationButton setIconString:[NSString fontAwesomeIconStringForEnum:FAAngleRight]];
    [self.specificationButton setTitle:T(@"选择尺码/颜色分类") forState:UIControlStateNormal];
    [self.specificationButton changeRightIcon];
    [self.specificationButton setTitleColor:GREENCOLOR];
    [self.specificationButton setIconColor:GREENCOLOR];
    [self.specificationButton changeLightStyle];
    [self.specificationButton addTarget:self action:@selector(getTheNewestLevelId) forControlEvents:UIControlEventTouchUpInside];

    [self.infoView addSubview:self.titleLabel];
    [self.infoView addSubview:self.briefLabel];
    [self.infoView addSubview:priceTitle];
    [self.infoView addSubview:self.priceLabel];
    [self.infoView addSubview:self.marketPriceLabel];
    [self.infoView addSubview:inventoryTitle];
    [self.infoView addSubview:self.inventoryLabel];
    [self.infoView addSubview:brandTitle];
    [self.infoView addSubview:self.brandButton];
    [self.infoView addSubview:self.specificationButton];
    
    [self.fixedView addSubview:self.infoView];
}

-(void)initHtmlView
{
    
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
    
    // refresh galleryView
    CGRect scrollFrame = CGRectMake(0, 0, TOTAL_WIDTH, TOTAL_WIDTH);
    for (int i = 0 ; i < [self.theGoods.gallery count]; i++) {
        // last one
        UIImageView *page = [[UIImageView alloc]
                             initWithFrame:scrollFrame];
        
        [page setContentMode:UIViewContentModeScaleAspectFill];
        
        [page sd_setImageWithURL:[NSURL URLWithString:self.theGoods.gallery[i][@"thumb"]]];
        [self.galleryView addContentSubview:page];
    }
    
    self.titleLabel.text = self.theGoods.goodsName;
    self.briefLabel.text = self.theGoods.goodsBrief;

    
    NSAttributedString * marketPriceString =
    [[NSAttributedString alloc] initWithString:@"$198"
                                    attributes:@{NSStrikethroughStyleAttributeName:@(NSUnderlineStyleSingle)}];

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
