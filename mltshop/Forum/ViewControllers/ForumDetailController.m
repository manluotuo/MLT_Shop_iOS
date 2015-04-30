//
//  ForumDetailController.m
//  mltshop
//
//  Created by 小新 on 15/4/24.
//  Copyright (c) 2015年 manluotuo. All rights reserved.
//

#import "ForumDetailController.h"
#import <AFNetworking/AFNetworking.h>
#import "ForumDetailModel.h"
#import "ContentModel.h"
#import "ContentContentModel.h"
#import "ContentViewController.h"
#import "AnswerOneTableViewCell.h"
#import "AnswerTwoTableViewCell.h"
#import "ContentTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "FaceIconView.h"
#import "NSString+TimeString.h"
#import "DetailViewController.h"
#import "ForumProfileController.h"
#import "AppDelegate.h"

@interface ForumDetailController ()<PassValueDelegate, UITableViewDataSource, UITableViewDelegate, FaceIconDelegate, UITextViewDelegate,contentTableViewCellDelegate>

/** 详情数据 */
@property (nonatomic, strong) NSMutableArray *detailArray;
/** 回复数据 */
@property (nonatomic, strong) NSMutableArray *contentArray;
/** 回复的回复数据 */
@property (nonatomic, strong) NSMutableArray *conconArray;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *textView;
@property (nonatomic, strong) UITextView *text;
@property (nonatomic, strong) NSMutableArray *dataArray;


@end

@implementation ForumDetailController {
    CGFloat imagePhotoH;
    CGFloat headerHeight;
    FaceIconView *view;
    UIButton *faceBtn;
}

- (void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewDidLoad {

    [self.view setBackgroundColor:WHITECOLOR];
    [super viewDidLoad];
    self.detailArray = [[NSMutableArray alloc] init];
    self.contentArray = [[NSMutableArray alloc] init];
    self.conconArray = [[NSMutableArray alloc] init];

    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.tableView setDelegate:self];
    [self.tableView setDataSource:self];
    [self.view addSubview:self.tableView];
    self.tableView.y = IOS7_CONTENT_OFFSET_Y;
    self.tableView.height = TOTAL_HEIGHT - IOS7_CONTENT_OFFSET_Y-40;
    self.textView = [[UIView alloc] initWithFrame:CGRectMake(0, TOTAL_HEIGHT-H_40, WIDTH, 40)];
    UIImageView *image = [[UIImageView alloc] initWithFrame:self.view.bounds];
    [image setImage:[UIImage imageNamed:@"pic_talk_background"]];
//    [self.textView addSubview:image];
    [self.view addSubview:self.textView];
    [self createTextView];
    [self setNewDataSource];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setUpNewData) name:SET_UP_DATA object:nil];
    
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
    
    self.title = @"帖子详情";
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
    
    self.text.layer.cornerRadius = 5;
    self.text.clipsToBounds = YES;
    self.text.layer.borderWidth = 1.0;
    self.text.layer.cornerRadius = 5.0f;
    self.text.layer.borderColor = [GRAYLIGHTCOLOR CGColor];
    
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

- (void)setNewDataSource {
    NSString *httpUrl = @"http://sj.manluotuo.com/home/post/PostInfo";
    AFHTTPRequestOperationManager *rom=[AFHTTPRequestOperationManager manager];
    rom.responseSerializer.acceptableContentTypes=[NSSet setWithObjects:@"text/json",@"text/html", nil];
    NSDictionary *postDict = @{@"postid": self.postid};
    [rom POST:httpUrl parameters:postDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@", responseObject);
        if ([responseObject[@"SUCESS"] integerValue] == 1) {
            [self.detailArray removeAllObjects];
            [self.contentArray removeAllObjects];
            ForumDetailModel *model = [[ForumDetailModel alloc] init];
            [model setValuesForKeysWithDictionary:responseObject[@"data"][@"post"]];
            [self.detailArray addObject:model];
            for (NSDictionary *dict in responseObject[@"data"][@"repost"]) {
                ContentModel *model = [[ContentModel alloc] init];
                [model setValuesForKeysWithDictionary:dict];
                NSLog(@"%@", model.postid);
                [self.contentArray addObject:model];
            }
            [self.tableView reloadData];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSLog(@"每个分区有多少行 %d", self.contentArray.count);
    return self.contentArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    AnswerOneTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"oneCellId"];
    if (!cell) {
        cell = [[AnswerOneTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"onCellId"];
    }
    ContentModel *model = self.contentArray[indexPath.row];
    [cell setNewData:model];
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    self.dataArray = [[NSMutableArray alloc] init];
    ContentModel *model = self.contentArray[indexPath.row];
    CGSize titleSize = [(NSString *)model.text sizeWithWidth:WIDTH-H_20 andFont:FONT_15];
    CGFloat cellHeight = 60+titleSize.height+10;
    for (NSDictionary *dict in model.reply) {
        ContentContentModel *model = [[ContentContentModel alloc] init];
        [model setValuesForKeysWithDictionary:dict];
        [self.dataArray addObject:model];
    }
    if (model.reply.count == 1) {
        ContentContentModel *model1 = self.dataArray[0];
        NSString *str = [NSString stringWithFormat:@"%@:%@", model1.nickname, model1.context];
        CGSize titleSize = [str sizeWithWidth:WIDTH-60 andFont:FONT_14];
        cellHeight += titleSize.height;
    }
    if (model.reply.count >= 2) {
        ContentContentModel *model1 = self.dataArray[0];
        NSString *str1 = [NSString stringWithFormat:@"%@:%@", model1.nickname, model1.context];
        CGSize titleSize1 = [str1 sizeWithWidth:WIDTH-60 andFont:FONT_14];
        ContentContentModel *model2 = self.dataArray[1];
        NSString *str2 = [NSString stringWithFormat:@"%@:%@", model2.nickname, model2.context];
        CGSize titleSize2 = [str2 sizeWithWidth:WIDTH-60 andFont:FONT_14];
        cellHeight += titleSize1.height + titleSize2.height;
    }
    return cellHeight;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    ContentTableViewCell *cellview = [[ContentTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    [cellview setFrame:CGRectMake(0, 0, WIDTH, H_40)];
    if(self.detailArray.count > 0) {
        [cellview setNewData:self.detailArray[section]];
    }
    cellview.passDelegate = self;
    cellview.delegate = self;
    return cellview;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        if (self.detailArray.count != 0) {
            headerHeight = 65;
            ForumDetailModel *model = self.detailArray[section];
            CGSize titleSize = [(NSString *)model.text sizeWithWidth:WIDTH-H_20 andFont:FONT_15];
            headerHeight += titleSize.height;
            NSArray *array = [self setImageNumber:model];
            for (NSInteger i = 1; i <= array.count; i++) {
                UIImageView *imagePhoto = [[UIImageView alloc] init];
                [imagePhoto sd_setImageWithURL:[NSURL URLWithString:array[i-1]] placeholderImage:[UIImage imageNamed:@"defPic"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                    if (image.size.width > image.size.height) {
                        if (image.size.width > WIDTH - 10) {
                            imagePhotoH = image.size.height*((WIDTH-20)/image.size.width);
                            if (imagePhotoH < 0) {
                                imagePhotoH = imagePhotoH*(-1);
                            }
                        } else {
                            imagePhotoH = image.size.height;
                        }
                    } else {
                        if (image.size.width > WIDTH - 10) {
                            imagePhotoH = image.size.height*((WIDTH-20)/image.size.width);
                            if (imagePhotoH < 0) {
                                imagePhotoH = imagePhotoH*(-1);
                            }
                        } else {
                            imagePhotoH = image.size.height;
                        }
                    }
                    headerHeight += imagePhotoH + 10;
                }];
            }
            return headerHeight;
        }
        return 0.001;
    } else {
        return 0.001;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    DetailViewController *detailVC = [[DetailViewController alloc] init];

    ContentModel *model = self.contentArray[indexPath.row];
    model.time = [NSString stringTimeDescribeFromTimeString:model.time];
    detailVC.model = model;
    [self.navigationController pushViewController:detailVC animated:YES];
}

- (NSArray *)setImageNumber:(NSObject *)data {
    NSMutableArray *array = [[NSMutableArray alloc] init];
    ForumDetailModel *model = (ForumDetailModel *)data;
    NSLog(@"%@", model.image1);
    if ([DataTrans noNullString:model.image1]) {
        [array addObject:model.image1];
    }
    if ([DataTrans noNullString:model.image2]) {
        [array addObject:model.image2];
    }
    if ([DataTrans noNullString:model.image3]) {
        [array addObject:model.image3];
    }
    if ([DataTrans noNullString:model.image4]) {
        [array addObject:model.image4];
    }
    if ([DataTrans noNullString:model.image5]) {
        [array addObject:model.image5];
    }
    if ([DataTrans noNullString:model.image6]) {
        [array addObject:model.image6];
    }
    if ([DataTrans noNullString:model.image7]) {
        [array addObject:model.image7];
    }
    if ([DataTrans noNullString:model.image8]) {
        [array addObject:model.image8];
    }
    if ([DataTrans noNullString:model.image9]) {
        [array addObject:model.image9];
    }
    return [NSArray arrayWithArray:array];
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
    NSString *httpUrl = @"http://sj.manluotuo.com/home/post/repost";
    AFHTTPRequestOperationManager *rom=[AFHTTPRequestOperationManager manager];
    rom.responseSerializer.acceptableContentTypes=[NSSet setWithObjects:@"text/json",@"text/html", nil];
    NSDictionary *postDict = @{@"userid": [[NSUserDefaults standardUserDefaults] valueForKey:@"userid"],
                               @"postid": self.postid,
                               @"context": self.text.text};
    [rom POST:httpUrl parameters:postDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([responseObject[@"SUCESS"] integerValue] == 1) {
            NSLog(@"成功");
            [self setNewDataSource];
            [DataTrans showWariningTitle:@"回复成功" andCheatsheet:nil andDuration:1.0f];
            self.text.text = @"";
            [self.text resignFirstResponder];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

- (void)textViewDidChange:(UITextView *)textView {
//    NSString *desContent = textView.text;//获取文本内容
//    
//    CGRect orgRect=self.text.frame;//获取原始UITextView的frame
//    CGSize size = [desContent sizeWithWidth:WIDTH-H_120 andFont:FONT_14];
//    
//    orgRect.size.height = size.height+10;//获取自适应文本内容高度
//    
//    self.text.frame = orgRect;//重设UITextView的frame
//    self.textView.height += size.height+10;
//    self.text.text = desContent;
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


- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if (view != nil) {
        [view removeFromSuperview];
        [UIView animateWithDuration:0.3f animations:^{
            self.textView.y = TOTAL_HEIGHT-H_40;
        }];
        faceBtn.selected = NO;
        faceBtn.userInteractionEnabled = YES;
        view = nil;
    }
    [self.text resignFirstResponder];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    
}

#pragma mark - 点击 ContentTableViewCell 头像时调用
-(void)contentTableViewCellIconDidClick:(ContentTableViewCell *)cell{
    ForumProfileController *forumVC = [[ForumProfileController alloc] init];
    forumVC.userId = cell.userId;
    [self.navigationController pushViewController:forumVC animated:YES];
}

- (void)setUpNewData {
   [self setNewDataSource];
}

@end
