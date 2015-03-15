//
//  BonusViewController.m
//  mltshop
//
//  Created by 小新 on 15/3/12.
//  Copyright (c) 2015年 manluotuo. All rights reserved.
//

#import "BonusViewController.h"

#import "AppRequestManager.h"
#import "SGActionView.h"
#import "UIViewController+ImageBackButton.h"
#import "DataSigner.h"

#import <SDWebImage/UIImageView+WebCache.h>
#import "FAHoverButton.h"

#import "BonusListModel.h"

@interface BonusViewController ()<UITableViewDataSource, UITableViewDelegate>

@end

@implementation BonusViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = T(@"我的红包");
    [self setupleftButton];
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return nil;
}



#pragma mark - ButtonClick
- (void)onLeftBtnClick {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}


@end
