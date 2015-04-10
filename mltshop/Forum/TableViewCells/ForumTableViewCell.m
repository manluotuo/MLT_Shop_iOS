//
//  ForumTableViewCell.m
//  mltshop
//
//  Created by 小新 on 15/3/30.
//  Copyright (c) 2015年 manluotuo. All rights reserved.
//

#import "ForumTableViewCell.h"

@interface ForumTableViewCell()

/** 容器View */
@property (nonatomic, strong) UIImageView *image;
/** 卡片式View背景颜色 */
@property (nonatomic, strong) UIView *backgroundView;
/** 头像与用户名容器 */
@property (nonatomic, strong) UIView *viewA;
/** 日期与点赞容器 */
@property (nonatomic, strong) UIView *viewB;

/** 头像 */
@property (nonatomic, strong) UIImageView *iconImage;
/** 用户名 */
@property (nonatomic, strong) UILabel *userName;
/** 标题 */
@property (nonatomic, strong) UILabel *titleLable;
/** 文本 */
@property (nonatomic, strong) UILabel *textLable;
/** 时间 */
@property (nonatomic, strong) UILabel *timeLable;
/** 图片 */
@property (nonatomic, strong) UIImageView *photoImage;
/** 赞 */
@property (nonatomic, strong) UIButton *zanBtn;
/** 回复数 */
@property (nonatomic, strong) UILabel *commentLable;

@end

@implementation ForumTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self initCellView];
    }
    return self;
}

- (void)initCellView {
    
    CGFloat spacing = 10;

    self.backgroundView = [[UIView alloc] initWithFrame:CGRectMake(H_10, H_10, WIDTH-H_20, H_200+H_10)];
    [self.backgroundView setBackgroundColor:GRAYEXLIGHTCOLOR];
    [self addSubview:self.backgroundView];

    self.image = [[UIImageView alloc] initWithFrame:CGRectMake(H_10, H_10, WIDTH-H_20, H_200+H_10)];
    [self.image setBackgroundColor:WHITECOLOR];
    [self.backgroundView addSubview:self.image];
    
    self.viewA = [[UIView alloc] initWithFrame:CGRectMake(H_10, H_10, self.backgroundView.width, H_50)];
    [self.viewA setBackgroundColor:[UIColor greenColor]];
    [self.backgroundView addSubview:self.viewA];
    /** 头像 */
    self.iconImage = [[UIImageView alloc] initWithFrame:CGRectMake(H_0, H_0, H_40, H_40)];
    UIPanGestureRecognizer *iconPan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(onIconImageClick)];
    [self.iconImage setBackgroundColor:BLACKCOLOR];
    [self.iconImage addGestureRecognizer:iconPan];
    [self.viewA addSubview:self.iconImage];
    
    /** 用户名 */
    self.userName = [[UILabel alloc] initWithFrame:CGRectMake(H_50, H_15, self.backgroundView.width-H_100, H_20)];
    [self.userName setBackgroundColor:[UIColor purpleColor]];
    [self.userName setFont:FONT_12];
    [self.viewA addSubview:self.userName];

    /** 标题 */
    self.titleLable = [[UILabel alloc] initWithFrame:CGRectMake(self.viewA.x, self.viewA.y+self.viewA.height+spacing, self.viewA.width, H_10)];
    [self.titleLable setNumberOfLines:0];
    [self.titleLable setFont:FONT_14];
    [self.backgroundView addSubview:self.titleLable];
    
    /** 图片 */
    
    /** 容器B */
    self.viewB = [[UIView alloc] initWithFrame:CGRectMake(H_10, self.titleLable.y+self.titleLable.height+spacing*2+H_90, self.viewA.width, H_30)];
    [self.backgroundView addSubview:self.viewB];
    [self.viewB setBackgroundColor:[UIColor grayColor]];
    /** 时间 */
    self.timeLable = [[UILabel alloc] initWithFrame:CGRectMake(H_10, H_5, H_100, H_20)];
    [self.timeLable setFont:FONT_12];
    [self.viewB addSubview:self.timeLable];
    /** 赞 */
    self.zanBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.zanBtn setFrame:CGRectMake(WIDTH-H_100, H_5, H_20, H_20)];
    [self.viewB addSubview:self.zanBtn];
    /** 回复数 */
    self.commentLable = [[UILabel alloc] initWithFrame:CGRectMake(self.zanBtn.x+H_60, H_5, H_20, H_20)];
    [self.commentLable setFont:FONT_12];
    [self.viewB addSubview:self.commentLable];


}

- (void)setData {
    self.titleLable.text = @"我是标题我是标题";
}

- (void)onIconImageClick {
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
