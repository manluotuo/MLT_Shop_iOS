//
//  DetailViewController.m
//  mltshop
//
//  Created by 小新 on 15/4/27.
//  Copyright (c) 2015年 manluotuo. All rights reserved.
//

#import "DetailViewController.h"
#import "FaceIconView.h"
#import <AFNetworking/AFNetworking.h>
#import "ForumDetailModel.h"
#import "ContentModel.h"
#import "ContentContentModel.h"
#import "ContentViewController.h"
#import "AnswerOneTableViewCell.h"
#import "AnswerTwoTableViewCell.h"
#import "ContentTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "NSString+TimeString.h"
#import "DetailViewController.h"
#import "DetailHeaderCell.h"
#import "DetailCell.h"

@interface DetailViewController ()<UITableViewDataSource, UITableViewDelegate, FaceIconDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) UIView *textView;
@property (nonatomic, strong) UITextView *text;
@end

@implementation DetailViewController{
    CGFloat imagePhotoH;
    CGFloat headerHeight;
    FaceIconView *view;
    UIButton *faceBtn;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataSource = [[NSMutableArray alloc] init];
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableView.y = IOS7_CONTENT_OFFSET_Y;
    self.tableView.height = TOTAL_HEIGHT - IOS7_CONTENT_OFFSET_Y-40;
    self.textView = [[UIView alloc] initWithFrame:CGRectMake(0, TOTAL_HEIGHT-H_40, WIDTH, 40)];
    self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    [self.view addSubview:self.textView];
    
    for (NSDictionary *dict in self.model.reply) {
        ContentContentModel *model = [[ContentContentModel alloc] init];
        [model setValuesForKeysWithDictionary:dict];
        NSLog(@"%@", model.replypostid);
        [self.dataSource addObject:model];
    }
    //增加监听，当键盘出现或改变时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    //增加监听，当键退出时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    [self createTextView];
}

- (void)createTextView {
    [self.textView setBackgroundColor:GRAYEXLIGHTCOLOR];
    faceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [faceBtn setFrame:CGRectMake(10, 5, 30, 30)];
    [faceBtn setImage:[UIImage imageNamed:@"expression_n"] forState:UIControlStateNormal];
    [faceBtn setImage:[UIImage imageNamed:@"expression_s"] forState:UIControlStateSelected];
    [faceBtn setSelected:NO];
    faceBtn.tag = 0;
    [faceBtn addTarget:self action:@selector(onFaceIconClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.textView addSubview:faceBtn];
    
    self.text = [[UITextView alloc] initWithFrame:CGRectMake(H_50, 5, WIDTH-H_120, H_30)];
    [self.text setFont:FONT_14];
    //    [self.text setDelegate:self];
    [self.textView addSubview:self.text];
    
    UIButton *postButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [postButton setTitle:T(@"发送") forState:UIControlStateNormal];
    [postButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [postButton setBackgroundColor:[UIColor blueColor]];
    postButton.layer.cornerRadius = 5;
    postButton.clipsToBounds = YES;
    postButton.titleLabel.font = FONT_16;
    [postButton setFrame:CGRectMake(WIDTH-H_60, 5, H_50, H_30)];
    [postButton addTarget:self action:@selector(onPostButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.textView addSubview:postButton];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.model.reply count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    DetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellId"];
    if (!cell) {
        cell = [[DetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellId"];
    }
    ContentContentModel *model = self.dataSource[indexPath.row];
    [cell setNewData:model];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    CGSize titleSize = [(NSString *)self.model.text sizeWithWidth:WIDTH-H_20 andFont:FONT_15];
    return 60+titleSize.height;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    DetailHeaderCell *cell = [[DetailHeaderCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    [cell setFrame:CGRectMake(0, 0, WIDTH, H_40)];
    [cell setNewData:self.model];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    ContentContentModel *model = self.dataSource[indexPath.row];
    NSString *str = [[NSString stringWithFormat:@"%@: %@", model.nickname, model.context] emojizedString];
    CGSize titleSize = [str sizeWithWidth:WIDTH-H_60 andFont:FONT_14];
    return titleSize.height;
}

#pragma mark - button 点击事件
- (void)onFaceIconClick:(UIButton *)sender {
    faceBtn.userInteractionEnabled = NO;
    faceBtn.selected = !faceBtn.selected;
    [self.text resignFirstResponder];
    if (view == nil) {
        view = [[FaceIconView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-H_160, self.view.frame.size.width, H_160)];
    }
    view.alpha = 0;
    view.delegate = self;
    [view initView];
    [self.view addSubview:view];
    [UIView animateWithDuration:0.3 animations:^{
        view.alpha = 1;
        self.textView.y = TOTAL_HEIGHT-H_40 - 160;
    }];
}

#pragma mark facialView delegate 点击表情键盘上的文字
-(void)selectedFacialView:(NSString*)str {
    if ([str isEqualToString:@"delete"]) {
        if (self.text.text.length>0) {
            NSRange range = NSMakeRange(self.text.text.length-1, 1);
            NSString *str = [self.text.text substringWithRange:range];
            if ([str isEqualToString:@"]"]) {
                self.text.text = [self.text.text substringToIndex:self.text.text.length-4];
            } else {
                self.text.text = [self.text.text substringToIndex:self.text.text.length-1];
            }
        }
    } else {
        faceBtn.userInteractionEnabled = YES;
        self.text.text = [NSString stringWithFormat:@"%@%@", self.text.text, str];
    }
}


- (void)onPostButtonClick {
    NSString *httpUrl = @"http://sj.manluotuo.com/home/post/replypost";
    AFHTTPRequestOperationManager *rom=[AFHTTPRequestOperationManager manager];
    rom.responseSerializer.acceptableContentTypes=[NSSet setWithObjects:@"text/json",@"text/html", nil];
    NSDictionary *postDict = @{@"sendid": [[NSUserDefaults standardUserDefaults] valueForKey:@"userid"],
                               @"repostid": self.model.repostid,
                               @"context": self.text.text,
                               @"postid": self.model.postid,
                               @"replyuserid": self.model.userid};
    [rom POST:httpUrl parameters:postDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@", responseObject);
        if ([responseObject[@"SUCESS"] integerValue] == 1) {
            NSLog(@"成功");
            [DataTrans showWariningTitle:@"回复成功" andCheatsheet:nil andDuration:1.0f];
            self.text.text = @"";
            [self.text resignFirstResponder];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

//当键盘出现或改变时调用
- (void)keyboardWillShow:(NSNotification *)aNotification {
    //获取键盘的高度
    if (view != nil) {
        [view removeFromSuperview];
        view = nil;
    }
    faceBtn.selected = NO;
    faceBtn.userInteractionEnabled = YES;
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    self.textView.y = TOTAL_HEIGHT-H_40 - keyboardRect.size.height;
}

//当键退出时调用
- (void)keyboardWillHide:(NSNotification *)aNotification {
    self.textView.y = TOTAL_HEIGHT-H_40;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

@end
