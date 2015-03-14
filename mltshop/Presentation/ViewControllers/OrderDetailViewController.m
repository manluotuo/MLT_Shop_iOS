//
//  OrderDetailViewController.m
//  mltshop
//
//  Created by 小新 on 15/3/14.
//  Copyright (c) 2015年 manluotuo. All rights reserved.
//

#import "OrderDetailViewController.h"

#import "AppRequestManager.h"
#import "SGActionView.h"
#import "UIViewController+ImageBackButton.h"
#import "KKFlatButton.h"
#import <AlipaySDK/AlipaySDK.h>
#import "DataSigner.h"

#import <SDWebImage/UIImageView+WebCache.h>
#import "OrderDetailModel.h"
#import "FAHoverButton.h"

@interface OrderDetailViewController ()

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation OrderDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(H_0, H_0, WIDTH, TOTAL_HEIGHT-10)];
    self.scrollView.contentSize = CGSizeMake(WIDTH, 1000);
    [self.scrollView setBackgroundColor:WHITECOLOR];
    [self.view addSubview:self.scrollView];
    
    [self setupleftButton];
    self.title = T(@"订单详情");
    
    self.scrollView.y = IOS7_CONTENT_OFFSET_Y;
    self.scrollView.height = TOTAL_HEIGHT - IOS7_CONTENT_OFFSET_Y;
    
    
    self.dataArray = [[NSMutableArray alloc]init];
    
    [self setData];
}

- (void)setData {
    
    self.dataArray = [[NSMutableArray alloc]init];
    [[AppRequestManager sharedManager]getOrderDetailOrderId:self.order_id andBlock:^(id responseObject,
                                                                                     NSError *error) {
        
        if (responseObject != nil) {
            // 集中处理所有的数据
            OrderDetailModel *model = [[OrderDetailModel alloc]init];
            
            [model setValuesForKeysWithDictionary:responseObject[@"data"]];
            [self.dataArray addObject:model];
            NSLog(@"%@", model.consignee);
            [self initView];
        }
        if (error != nil) {
            [DataTrans showWariningTitle:T(@"获取订单详情有误") andCheatsheet:ICON_TIMES andDuration:1.5f];
        }
        
    }];
}

- (UILabel *)createLable:(NSString *)title frame:(CGRect)frame color:(UIColor *)color font:(UIFont *)font {
    
    UILabel *lable = [[UILabel alloc] initWithFrame:frame];
    lable.numberOfLines = 2;
    [lable setFont:font];
    if (font == nil) {
        [lable setFont:FONT_12];
    }
    lable.textColor = color;
    if (color == nil) {
        lable.textColor =  BLACKCOLOR;
    }
    [lable setText:title];
    return lable;
}

- (UIView *)createLine:(CGRect)frame {
    UIView *line = [[UIView alloc] initWithFrame:frame];
    line.backgroundColor = [UIColor grayColor];
    line.alpha = 0.3;
    return line;
}

- (void)initView {
    
    if (self.dataArray.count > 0) {
        OrderDetailModel *model = [self.dataArray lastObject];
        //    CGRectMake(<#CGFloat x#>, <#CGFloat y#>, <#CGFloat width#>, <#CGFloat height#>)
        UILabel *lableAA = [self createLable:@"收货信息" frame:CGRectMake(H_15, H_5, WIDTH-H_15*2, H_50) color:[UIColor grayColor] font:FONT_20];
        [self.scrollView addSubview:lableAA];
        
        UIView *lineA = [self createLine:CGRectMake(H_14, lableAA.y+lableAA.height, WIDTH-H_14*2, 1)];
        [self.scrollView addSubview:lineA];
        
        UILabel *lableB = [self createLable:[NSString stringWithFormat:@"收货人名：%@", model.consignee] frame:CGRectMake(H_20, lableAA.y+lableAA.height+7.5, lableAA.width, H_20) color:nil font:nil];
        [self.scrollView addSubview:lableB];
        
        UILabel *lableC = [self createLable:[NSString stringWithFormat:@"收货地址：%@", model.address] frame:CGRectMake(H_20, lableB.y+lableB.height+H_10, lableAA.width, H_20) color:nil font:nil];
        [self.scrollView addSubview:lableC];
        
        
        UILabel *lableD = [self createLable:[NSString stringWithFormat:@"联系电话：%@", model.tel] frame:CGRectMake(H_20, lableC.y+lableC.height+H_10, lableAA.width, H_20) color:nil font:nil];
        [self.scrollView addSubview:lableD];
        
        UILabel *lableAB = [self createLable:@"支付及配送" frame:CGRectMake(H_15, lableD.y+lableD.height+H_8, WIDTH-H_15*2, H_50) color:[UIColor grayColor] font:FONT_20];
        [self.scrollView addSubview:lableAB];
        
        UIView *lineB = [self createLine:CGRectMake(H_14, lableAB.y+lableAB.height, lineA.width, 1)];
        [self.scrollView addSubview:lineB];
        
        UILabel *lableE = [self createLable:[NSString stringWithFormat:@"支付方式：%@", model.pay_name] frame:CGRectMake(H_20, lableAB.y+lableAB.height+H_8, lableAA.width, H_20) color:nil font:nil];
        [self.scrollView addSubview:lableE];
        
        UILabel *lableF = [self createLable:[NSString stringWithFormat:@"配送方式：%@", model.shipping_name] frame:CGRectMake(H_20, lableE.y+lableE.height+H_10, lableAA.width, H_20) color:nil font:nil];
        CGSize contentSize = [model.shipping_name sizeWithWidth:lableAA.width - H_80 andFont:FONT_12];
        lableF.height = contentSize.height;
        lableF.numberOfLines = 0;
        [self.scrollView addSubview:lableF];
        
        UILabel *lableAC = [self createLable:@"订单信息" frame:CGRectMake(H_15, lableF.y+lableF.height+H_8, WIDTH-H_15*2, H_50) color:[UIColor grayColor] font:FONT_20];
        [self.scrollView addSubview:lableAC];
        
        UIView *lineC = [self createLine:CGRectMake(lineB.x, lableAC.y+lableAC.height, lineA.width, 1)];
        [self.scrollView addSubview:lineC];
        
        UILabel *lableG = [self createLable:[NSString stringWithFormat:@"下单日期：%@", model.formated_add_time] frame:CGRectMake(H_20, lableAC.y+lableAC.height+H_8, WIDTH-H_15*2, H_20) color:nil font:nil];
        [self.scrollView addSubview:lableG];
        
        UILabel *lableH = [self createLable:[NSString stringWithFormat:@"订单编号：%@", model.order_sn] frame:CGRectMake(H_20, lableG.y+lableG.height+H_10, WIDTH-H_15*2, H_20) color:nil font:nil];
        [self.scrollView addSubview:lableH];
        
        UILabel *lableI = [self createLable:[NSString stringWithFormat:@"订单状态：%@, %@, %@", model.order_status, model.shipping_status, model.pay_status] frame:CGRectMake(H_20, lableH.y+lableH.height+H_10, WIDTH-H_15*2, H_20) color:nil font:nil];
        [self.scrollView addSubview:lableI];
        
        UILabel *lableJ = [self createLable:[NSString stringWithFormat:@"订单金额：%@(包含邮费%@)", model.formated_order_amount, model.formated_shipping_fee] frame:CGRectMake(H_20, lableI.y+lableI.height+H_10, WIDTH-H_15*2, H_20) color:nil font:nil];
        [self.scrollView addSubview:lableJ];
        
        UILabel *lableAD = [self createLable:@"商品列表" frame:CGRectMake(H_15, lableJ.y+lableJ.height+H_8, WIDTH-H_15*2, H_50) color:[UIColor grayColor] font:FONT_20];
        [self.scrollView addSubview:lableAD];
        
        UIView *lineD = [self createLine:CGRectMake(lineA.x, lableAD.y+lableAD.height, lineA.width, 1)];
        [self.scrollView addSubview:lineD];
        
        for (int i = 0; i < self.goods_list.count; i++) {
            UIImageView *image = [[UIImageView alloc] initWithFrame: CGRectMake(H_10, lableAD.y+lableAD.height+H_4 + H_100*i, H_80, H_80)];
            [image sd_setImageWithURL:[NSURL URLWithString:self.goods_list[i][@"img"][@"small"]] placeholderImage:[UIImage imageNamed:@" "]];
            [self.scrollView addSubview:image];
            
            UILabel *lableK = [self createLable:[NSString stringWithFormat:@"%@", self.goods_list[i][@"goods_name"]] frame:CGRectMake(image.width+H_20, lableAD.y+lableAD.height+H_12 + H_100*i, WIDTH-H_15*2-image.width-H_20, H_20) color:GREENCOLOR font:FONT_16];
            CGSize contentSize = [self.goods_list[i][@"goods_name"] sizeWithWidth:WIDTH-H_15*2-image.width-H_20 andFont:FONT_16];
            lableK.height = contentSize.height;
            [self.scrollView addSubview:lableK];
            
            UILabel *lableL = [self createLable:[NSString stringWithFormat:@"%@ x %@", self.goods_list[i][@"subtotal"], self.goods_list[i][@"goods_number"]] frame:CGRectMake(image.width+H_20, lableK.y+lableK.height+H_5, WIDTH-H_15*2-image.width-H_20, H_20) color:ORANGE_DARK_COLOR font:FONT_16];
            [self.scrollView addSubview:lableL];
            
            UIView *lineE = [self createLine:CGRectMake(lineA.x, image.y+image.height+2, lineA.width, 1)];
            [self.scrollView addSubview:lineE];
            
            self.scrollView.contentSize = CGSizeMake(WIDTH, lableL.y+lableL.height+H_15+H_80);
        }
        
        UIView *btnView = [[UIView alloc] initWithFrame:CGRectMake(H_0, TOTAL_HEIGHT-H_80, WIDTH, H_80)];
        UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(H_0, H_0, WIDTH, H_80)];
        image.image = [UIImage imageNamed:@"1"];
        [btnView addSubview:image];
        UILabel *pricrLable = [self createLable:[NSString stringWithFormat:@"应付总额：%@", model.order_amount] frame:CGRectMake(H_15, H_20, WIDTH, H_40) color:ORANGECOLOR font:FONT_16];
        [btnView addSubview:pricrLable];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setFrame:CGRectMake(WIDTH/2+H_20, H_15, WIDTH/2-H_20*2, H_50)];
        [button setTitle:@"立即付款" forState:UIControlStateNormal];
        [button setTintColor:WHITECOLOR];
        [button setBackgroundColor:ORANGECOLOR];
        [button.titleLabel setFont:FONT_16];
        button.layer.cornerRadius = 20;
        button.clipsToBounds = YES;
        [btnView addSubview:button];
        [self.view addSubview:btnView];

    }
}

- (void)setupleftButton
{
    CGFloat leftMargin = 10.0f;
    FAHoverButton *backButton = [[FAHoverButton alloc] initWithFrame:CGRectMake(0, 0, 12+leftMargin, 21)];
    [backButton setTitle:ICON_BACK forState:UIControlStateNormal];
    [backButton.titleLabel setFont:FONT_AWESOME_36];
    [backButton setImageEdgeInsets:UIEdgeInsetsMake(0, leftMargin, 0, 0)];
    
    
    UIBarButtonItem *barBackButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    [backButton addTarget:self action:@selector(onLeftBtnClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = barBackButtonItem;
    self.navigationItem.hidesBackButton = YES;
}

- (void)onLeftBtnClick {
    [self dismissViewControllerAnimated:YES completion:nil];
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
