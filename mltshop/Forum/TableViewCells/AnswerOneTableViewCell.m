//
//  AnswerTableViewCell.m
//  mltshop
//
//  Created by 小新 on 15/4/18.
//  Copyright (c) 2015年 manluotuo. All rights reserved.
//
/** 回复评论 */

#import "AnswerOneTableViewCell.h"
#import "ContentModel.h"
#import <SDWebImage/UIButton+WebCache.h>
#import "ContentContentModel.h"
#import "NSString+TimeString.h"


@interface AnswerOneTableViewCell()

/** 头像 */
@property (nonatomic, strong) UIButton *userBtn;
/** 用户名 */
@property (nonatomic, strong) UILabel *userLable;
/** 楼层和时间 */
@property (nonatomic, strong) UILabel *numberFloor;
/** 内容 */
@property (nonatomic, strong) UILabel *contentLable;
/** 回复1 */
@property (nonatomic, strong) UIView *view1;
@property (nonatomic, strong) UILabel *iconBtn1;
@property (nonatomic, strong) UILabel *lable1;
@property (nonatomic, strong) UIButton *moreBtn1;
/** 回复2 */
@property (nonatomic, strong) UIView *view2;
@property (nonatomic, strong) UILabel *iconBtn2;
@property (nonatomic, strong) UILabel *lable2;
@property (nonatomic, strong) UIButton *moreBtn2;

@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation AnswerOneTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self initCellView];
    }
    return self;
}

- (void)initCellView {
    self.userBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.userBtn setFrame:CGRectMake(H_10, H_10, H_30, H_30)];
    [self.userBtn addTarget:self action:@selector(onUserBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.userBtn];
    
    self.userLable = [[UILabel alloc] initWithFrame:CGRectMake(self.userBtn.x+self.userBtn.width+H_10, H_10, H_100, H_10)];
    [self.userLable setTextColor:BlACKCOLOR];
    [self.userLable setFont:FONT_14];
    [self addSubview:self.userLable];
    
    self.numberFloor = [[UILabel alloc] initWithFrame:CGRectMake(self.userLable.x, self.userBtn.y+self.userBtn.height-H_10, H_200, H_10)];
    [self.numberFloor setTextColor:GRAYLELIGHTCOLOR];
    [self.numberFloor setFont:FONT_13];
    [self addSubview:self.numberFloor];
    
    self.contentLable = [[UILabel alloc] initWithFrame:CGRectMake(self.numberFloor.x, self.numberFloor.y+self.numberFloor.height+H_10, WIDTH-H_10-self.numberFloor.x, H_10)];
    [self.contentLable setFont:FONT_14];
    [self.contentLable setNumberOfLines:0];
    [self addSubview:self.contentLable];
    
    /** 回复1 */
    self.view1 = [[UIView alloc] initWithFrame:CGRectMake(self.contentLable.x, 10, WIDTH-10-self.contentLable.x, 20)];
    UILabel *line1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view1.width, 0.1)];
//    [line1 setBackgroundColor:GRAYEXLIGHTCOLOR];
    [line1 setBackgroundColor:BLACKCOLOR];
    [self.view1 addSubview:line1];
//    self.iconBtn1 = [UIButton buttonWithType:UIButtonTypeCustom];
//    [self.iconBtn1 setFrame:CGRectMake(0, 10, 10, 10)];
    self.lable1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view1.width, 10)];
    [self.lable1 setFont:FONT_14];
    [self.view1 addSubview:self.lable1];
    [self addSubview:self.view1];
    [self.view1 setHidden:YES];
    self.iconBtn1 = [[UILabel alloc] init];
    [self.iconBtn1 setFrame:CGRectMake(0, 7, 100, 10)];
    [self.iconBtn1 setFont:FONT_14];
    self.iconBtn1.textColor = ORANGECOLOR;
//    [self.view1 addSubview:self.iconBtn1];
    
    
    /** 回复2 */
    self.view2 = [[UIView alloc] initWithFrame:CGRectMake(self.view1.x, 10, self.view1.width, 10)];
//    UILabel *line2 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view2.width, 0.1)];
////    [line2 setBackgroundColor:GRAYEXLIGHTCOLOR];
//    [line2 setBackgroundColor:BLACKCOLOR];
//    [self.view2 addSubview:line2];
    
    self.lable2 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view2.width, 10)];
    [self.lable2 setFont:FONT_14];
    [self.view2 addSubview:self.lable2];
    [self addSubview:self.view2];
    [self.view2 setHidden:YES];
    self.iconBtn2 = [[UILabel alloc] init];
    [self.iconBtn2 setFrame:CGRectMake(0, 7, 100, 10)];
    [self.iconBtn2 setFont:FONT_14];
    self.iconBtn2.textColor = ORANGECOLOR;
//    [self.view2 addSubview:self.iconBtn2];
    
}

- (void)setNewData:(ContentModel *)model {
    [self.userBtn sd_setImageWithURL:[NSURL URLWithString:model.headerimg] forState:UIControlStateNormal];
    self.contentLable.text = [model.text emojizedString];
    CGSize titleSize = [(NSString *)model.text sizeWithWidth:WIDTH-H_10-self.numberFloor.x-H_20 andFont:FONT_14];
    self.contentLable.height = titleSize.height;
    self.userLable.text = model.nickname;
    self.numberFloor.text = [NSString stringTimeDescribeFromTimeString:model.time];
    self.dataArray = [[NSMutableArray alloc] init];
    NSLog(@"%@", model.reply);
    for (NSDictionary *dict in model.reply) {
        ContentContentModel *model = [[ContentContentModel alloc] init];
        [model setValuesForKeysWithDictionary:dict];
        [self.dataArray addObject:model];
    }
    if (self.dataArray.count == 0) {
        [self.view1 setHidden:YES];
        [self.view2 setHidden:YES];
    }
    if (self.dataArray.count == 1) {
        [self.view1 setHidden:NO];
        [self.view2 setHidden:YES];
        ContentContentModel *model1 = self.dataArray[0];
        NSString *str = [[NSString stringWithFormat:@"%@: %@", model1.nickname, model1.context] emojizedString];
        NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:str];
        [string addAttribute:NSForegroundColorAttributeName value:ORANGECOLOR range:NSMakeRange(0,model1.nickname.length)];
        self.lable1.attributedText = string;
        CGSize titleSize = [str sizeWithWidth:WIDTH-10-self.contentLable.x andFont:FONT_14];
        self.lable1.height = titleSize.height;
        self.lable1.numberOfLines = 0;
        self.view1.y = self.contentLable.y+self.contentLable.height + 10;
        self.view1.height = self.lable1.y+self.lable1.height;
        [self.iconBtn1 setText:model1.nickname];
    }
    
    if (self.dataArray.count >= 2) {
        [self.view1 setHidden:NO];
        ContentContentModel *model1 = self.dataArray[0];
        NSString *str1 = [[NSString stringWithFormat:@"%@: %@", model1.nickname, model1.context] emojizedString];
        NSMutableAttributedString *string1 = [[NSMutableAttributedString alloc] initWithString:str1];
        [string1 addAttribute:NSForegroundColorAttributeName value:ORANGECOLOR range:NSMakeRange(0,model1.nickname.length)];
        self.lable1.attributedText = string1;
        CGSize titleSize1 = [str1 sizeWithWidth:WIDTH-10-self.contentLable.x andFont:FONT_14];
        self.lable1.height = titleSize1.height;
        [self.lable2 setNumberOfLines:0];
        self.view1.y = self.contentLable.y+self.contentLable.height + 5;
        self.view1.height = self.lable1.y+self.lable1.height;
        [self.iconBtn1 setText:model1.nickname];
        
        [self.view2 setHidden:NO];
        ContentContentModel *model2 = self.dataArray[1];
        NSString *str2 = [[NSString stringWithFormat:@"%@: %@", model2.nickname, model2.context] emojizedString];
        NSMutableAttributedString *string2 = [[NSMutableAttributedString alloc] initWithString:str2];
        [string2 addAttribute:NSForegroundColorAttributeName value:ORANGECOLOR range:NSMakeRange(0, model2.nickname.length)];
        self.lable2.attributedText = string2;
        CGSize titleSize2 = [str2 sizeWithWidth:WIDTH-10-self.contentLable.x andFont:FONT_14];
        self.lable2.height = titleSize2.height;
        [self.lable2 setNumberOfLines:0];
        self.view2.y = self.view1.y+self.view1.height;
        self.view2.height = self.lable2.y+self.lable2.height;
        [self.iconBtn2 setText:model2.nickname];
    }
}

- (void)onUserBtnClick {
    NSLog(@"头像被点击");
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
