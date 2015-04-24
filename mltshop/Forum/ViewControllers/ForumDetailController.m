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

@interface ForumDetailController ()<PassValueDelegate>

/** 详情数据 */
@property (nonatomic, strong) NSMutableArray *detailArray;
/** 回复数据 */
@property (nonatomic, strong) NSMutableArray *contentArray;
/** 回复的回复数据 */
@property (nonatomic, strong) NSMutableArray *conconArray;

@end

@implementation ForumDetailController

- (void)viewDidLoad {

    [super viewDidLoad];
    self.navigationController.navigationBarHidden = NO;
    self.detailArray = [[NSMutableArray alloc] init];
    self.contentArray = [[NSMutableArray alloc] init];
    self.conconArray = [[NSMutableArray alloc] init];
    
    [self setNewDataSource];
//     self.clearsSelectionOnViewWillAppear = NO;
}

- (void)setNewDataSource {
    NSString *httpUrl = @"http://192.168.1.199:8080/home/post/PostInfo";
    AFHTTPRequestOperationManager *rom=[AFHTTPRequestOperationManager manager];
    rom.responseSerializer.acceptableContentTypes=[NSSet setWithObjects:@"text/json",@"text/html", nil];
    NSDictionary *postDict = @{@"postid": self.postid};
    [rom POST:httpUrl parameters:postDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([responseObject[@"SUCESS"] integerValue] == 1) {
            ForumDetailModel *model = [[ForumDetailModel alloc] init];
            [model setValuesForKeysWithDictionary:responseObject[@"data"][@"post"]];
            [self.detailArray addObject:model];
            for (NSDictionary *dict in responseObject[@"data"][@"repost"]) {
                ContentModel *model = [[ContentModel alloc] init];
                [model setValuesForKeysWithDictionary:dict];
                NSLog(@"%@", model.postid);
                [self.contentArray addObject:model];
                for (NSDictionary *dict in model.reply) {
                    ContentContentModel *model = [[ContentContentModel alloc] init];
                    [model setValuesForKeysWithDictionary:dict];
                    [self.conconArray addObject:model];
                }
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
    NSLog(@"!!!%d", self.contentArray.count+1);
    return self.contentArray.count+1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSLog(@"%d", self.conconArray.count);
    return self.conconArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellId" forIndexPath:indexPath];
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    ContentTableViewCell *cellview = [[ContentTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    [cellview setFrame:CGRectMake(0, 0, WIDTH, H_40)];
    if(self.detailArray.count > 0) {
        [cellview setNewData:self.detailArray[section]];
    }
    cellview.passDelegate = self;
    return cellview;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        if (self.detailArray.count != 0) {
        CGFloat headerHeight = 65;
        ForumDetailModel *model = self.detailArray[section];
        CGSize titleSize = [(NSString *)model.text sizeWithWidth:WIDTH-H_20 andFont:FONT_15];
        headerHeight += titleSize.height;
        NSArray *array = [self setImageNumber:model];
        headerHeight += 20+array.count*WIDTH-20;
            return headerHeight;
        }
        return 0.001;
    } else {
        return 0.001;
    }
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


@end
