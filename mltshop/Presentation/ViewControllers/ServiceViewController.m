//
//  ServiceViewController.m
//  mltshop
//
//  Created by 小新 on 15/3/24.
//  Copyright (c) 2015年 manluotuo. All rights reserved.
//
/** 客服中心 */

#import "ServiceViewController.h"

#import "FAHoverButton.h"

@interface ServiceViewController ()

@end

@implementation ServiceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = T(@"客服中心");
    [self.view setBackgroundColor:GRAYEXLIGHTCOLOR];
    [self customUI];
    [self setupleftButton];
}

- (void)customUI {
    UIView *rootView = [[UIView alloc] initWithFrame:CGRectMake(H_10, H_100, TOTAL_WIDTH-H_10*2, H_250)];
    [rootView setBackgroundColor:[UIColor whiteColor]];
    rootView.layer.cornerRadius = 5;
    rootView.clipsToBounds = YES;
    [self.view addSubview:rootView];
    
    UILabel *lableA = [[UILabel alloc] initWithFrame:CGRectMake(H_10, H_20, H_70, H_25)];
    lableA.text = [NSString stringWithFormat:@"商店民称："];
    lableA.textColor = [UIColor blackColor];
    [lableA setFont:FONT_14];
    [rootView addSubview:lableA];
    
    UILabel *lableB = [[UILabel alloc] initWithFrame:CGRectMake(lableA.x+lableA.width, lableA.y, rootView.width-H_90, H_40)];
    lableB.text = T(@"漫骆驼-中国最大的正品电影动漫周边商城");
    lableB.textColor = ORANGECOLOR;
    [lableB setFont:FONT_14];
    lableB.numberOfLines = 0;
    [rootView addSubview:lableB];
    
    UILabel *lableC = [[UILabel alloc] initWithFrame:CGRectMake(H_10, lableB.y+lableB.height+H_10, H_70, H_25)];
    lableC.text = [NSString stringWithFormat:@"客服 QQ："];
    lableC.textColor = [UIColor blackColor];
    [lableC setFont:FONT_14];
    [rootView addSubview:lableC];
    
    UILabel *lableD = [[UILabel alloc] initWithFrame:CGRectMake(lableC.x+lableC.width, lableC.y, rootView.width-H_90, H_25)];
    lableD.text = T(@"2842330513");
    lableD.textColor = ORANGECOLOR;
    [lableD setFont:FONT_14];
//    lableD.numberOfLines = 0;
    [rootView addSubview:lableD];
    
    UILabel *lableE = [[UILabel alloc] initWithFrame:CGRectMake(H_10, lableD.y+lableD.height+H_10, H_70, H_25)];
    lableE.text = [NSString stringWithFormat:@"客服邮箱："];
    lableE.textColor = [UIColor blackColor];
    [lableE setFont:FONT_14];
    [rootView addSubview:lableE];
    
    UILabel *lableF = [[UILabel alloc] initWithFrame:CGRectMake(lableE.x+lableE.width, lableE.y, rootView.width-H_90, H_25)];
    lableF.text = T(@"service@manluotuo.com");
    lableF.textColor = ORANGECOLOR;
    [lableF setFont:FONT_14];
    //    lableD.numberOfLines = 0;
    [rootView addSubview:lableF];
    
    UILabel *lableG = [[UILabel alloc] initWithFrame:CGRectMake(H_10, lableF.y+lableF.height+H_10, H_70, H_25)];
    lableG.text = [NSString stringWithFormat:@"客服电话："];
    lableG.textColor = [UIColor blackColor];
    [lableG setFont:FONT_14];
    [rootView addSubview:lableG];
    
    UILabel *lableH = [[UILabel alloc] initWithFrame:CGRectMake(lableG.x+lableG.width, lableG.y, rootView.width-H_90, H_25)];
    lableH.text = T(@"400-688-7035");
    lableH.textColor = ORANGECOLOR;
    [lableH setFont:FONT_14];
    //    lableD.numberOfLines = 0;
    [rootView addSubview:lableH];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:CGRectMake(H_15, lableH.y+lableH.height+H_15, rootView.width-H_30, H_40)];
    button.layer.cornerRadius = 5;
    button.clipsToBounds = YES;
    [button setTitle:T(@"呼叫客服") forState:UIControlStateNormal];
    [button addTarget:self action:@selector(onTelClick) forControlEvents:UIControlEventTouchUpInside];
    [button setBackgroundColor:ORANGECOLOR];
    [rootView addSubview:button];
    
//    UILabel *lableI = [[UILabel alloc] initWithFrame:CGRectMake(H_10, lableH.y+lableH.height+H_10, H_70, H_25)];
//    lableI.text = [NSString stringWithFormat:@"技术邮箱："];
//    lableI.textColor = [UIColor blackColor];
//    [lableI setFont:FONT_14];
//    [rootView addSubview:lableI];
//    
//    UILabel *lableJ = [[UILabel alloc] initWithFrame:CGRectMake(lableI.x+lableI.width, lableI.y, rootView.width-H_90, H_25)];
//    lableJ.text = T(@"duanxinrui@manluotuo.com");
//    lableJ.textColor = ORANGECOLOR;
//    [lableJ setFont:FONT_14];
//    //    lableD.numberOfLines = 0;
//    [rootView addSubview:lableJ];
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

- (void)onTelClick {
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",@"400-688-7035"];
    UIWebView * callWebview = [[UIWebView alloc] init];
    [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
    [self.view addSubview:callWebview];
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
