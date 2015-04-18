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

@interface AnswerOneTableViewCell()

/** 头像 */
@property (nonatomic, strong) UIButton *userBtn;
/** 用户名 */
@property (nonatomic, strong) UILabel *userLable;
/** 楼层和时间 */
@property (nonatomic, strong) UILabel *numberFloor;
/** 内容 */
@property (nonatomic, strong) UILabel *contentLable;

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
    [self.userBtn sd_setImageWithURL:[NSURL URLWithString:nil] forState:UIControlStateNormal];
    [self.userBtn setFrame:CGRectMake(H_10, H_10, H_30, H_30)];
    [self.userBtn addTarget:self action:@selector(onUserBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.userBtn];
    
    self.userLable = [[UILabel alloc] initWithFrame:CGRectMake(self.userBtn.x+self.userBtn.width+H_10, H_10, H_100, H_10)];
    [self.userLable setTextColor:BlACKCOLOR];
    [self.userLable setFont:FONT_10];
    [self addSubview:self.userLable];
    
    self.numberFloor = [[UILabel alloc] initWithFrame:CGRectMake(self.userLable.x, self.userBtn.y+self.userBtn.height-H_10, H_200, H_10)];
    [self.numberFloor setTextColor:GRAYEXLIGHTCOLOR];
    [self.numberFloor setFont:FONT_10];
    [self addSubview:self.numberFloor];
    
    self.contentLable = [[UILabel alloc] initWithFrame:CGRectMake(self.numberFloor.x, self.numberFloor.y+self.numberFloor.height+H_10, WIDTH-H_10-self.numberFloor.x, H_10)];
    [self.contentLable setFont:FONT_10];
    [self addSubview:self.contentLable];
}

- (void)setNewData:(ContentModel *)data {
    
}

- (void)onUserBtnClick {
    
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
