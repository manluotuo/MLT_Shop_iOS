//
//  ForumViewController.m
//  mltshop
//
//  Created by 小新 on 15/3/30.
//  Copyright (c) 2015年 manluotuo. All rights reserved.
//

#import "ForumViewController.h"
#import "FAHoverButton.h"


@interface ForumViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation ForumViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"漫骆驼";
    [self createUI];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableView.y = IOS7_CONTENT_OFFSET_Y;
    self.tableView.height = TOTAL_HEIGHT - IOS7_CONTENT_OFFSET_Y;
}

/** 创建View */
- (void)createUI {
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    self.tableView.backgroundColor = REDCOLOR;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    /** 商城入口按钮 */
    [self createForumButton];
    [self setupleftButton];
    
}

/** 创建论坛入口按钮 */
- (void)createForumButton {
    
    FAHoverButton *forumButton = [[FAHoverButton alloc] initWithFrame:CGRectMake(WIDTH-H_80, TOTAL_HEIGHT-H_80, H_50, H_50)];
    [forumButton setTitle:[NSString fontAwesomeIconStringForEnum:FAat] forState:UIControlStateNormal];
    [forumButton setTitleColor:GRAYCOLOR forState:UIControlStateNormal];
    [forumButton setRounded];
    [forumButton setIconFont:FONT_AWESOME_30];
    [forumButton addTarget:self action:@selector(onForumButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:forumButton];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return nil;
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
    
}

- (void)onForumButtonClick {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

@end
