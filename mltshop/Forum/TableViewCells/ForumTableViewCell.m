//
//  ForumTableViewCell.m
//  mltshop
//
//  Created by 小新 on 15/3/30.
//  Copyright (c) 2015年 manluotuo. All rights reserved.
//

#import "ForumTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <UIButton+WebCache.h>
#import "NSString+TimeString.h"
#import "emojis.h"

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

@property (nonatomic, strong) UIImageView *image1;
@property (nonatomic, strong) UIImageView *image2;
@property (nonatomic, strong) UIImageView *image3;

@end

@implementation ForumTableViewCell {
    CGFloat spacing;
}

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
    /** 间隙 */
    
    spacing = H_10;
    self.backgroundView = [[UIView alloc] initWithFrame:CGRectMake(H_10, H_10, WIDTH-H_20, H_200+H_30)];
    [self.backgroundView setBackgroundColor:GRAYEXLIGHTCOLOR];
    [self addSubview:self.backgroundView];
    
    self.image = [[UIImageView alloc] initWithFrame:CGRectMake(H_10, H_10, self.backgroundView.width, self.backgroundView.height)];
    [self.image setBackgroundColor:WHITECOLOR];
    [self.backgroundView addSubview:self.image];
    
    self.viewA = [[UIView alloc] initWithFrame:CGRectMake(H_20, H_20, self.backgroundView.width-H_20, H_40)];
    [self.backgroundView addSubview:self.viewA];
    
    /** 头像 */
    self.iconImage = [[UIImageView alloc] initWithFrame:CGRectMake(H_0, H_0, H_40, H_40)];
    UITapGestureRecognizer *iconPan = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onIconImageClick)];
    [self.iconImage addGestureRecognizer:iconPan];
    self.iconImage.layer.cornerRadius = 20;
    self.iconImage.clipsToBounds = YES;
    [self.iconImage setBackgroundColor:REDCOLOR];
    [self.viewA addSubview:self.iconImage];
    
    /** 用户名 */
    self.userName = [[UILabel alloc] initWithFrame:CGRectMake(H_50, H_10, self.backgroundView.width-H_100, H_20)];
    //    [self.userName setBackgroundColor:[UIColor purpleColor]];
    [self.userName setFont:FONT_12];
    [self.viewA addSubview:self.userName];
    
    /** 内容 */
    self.titleLable = [[UILabel alloc] initWithFrame:CGRectMake(self.viewA.x, self.viewA.y+self.viewA.height, self.viewA.width, H_10)];
    [self.titleLable setNumberOfLines:0];
    [self.titleLable setFont:FONT_14];
    [self.backgroundView addSubview:self.titleLable];
    
    /** 图片 */
    CGFloat imageX = self.titleLable.x;
    CGFloat imageY = self.titleLable.y+self.titleLable.height+2*spacing;
    CGFloat imageW = (self.viewA.width-spacing)/3;
    self.image1 = [[UIImageView alloc] initWithFrame:CGRectMake(imageX, imageY, imageW, imageW)];
    [self.backgroundView addSubview:self.image1];
    self.image2 = [[UIImageView alloc] initWithFrame:CGRectMake(imageX+imageW+spacing/2, imageY, imageW, imageW)];
    [self.backgroundView addSubview:self.image2];
    self.image3 = [[UIImageView alloc] initWithFrame:CGRectMake(imageX+2*imageW+spacing, imageY, imageW, imageW)];
    [self.backgroundView addSubview:self.image3];
    
    
    /** 容器B */
    self.viewB = [[UIView alloc] initWithFrame:CGRectMake(H_20, self.titleLable.y+self.titleLable.height+spacing*2+(self.viewA.width-spacing)/3, self.viewA.width, H_30)];
    [self.backgroundView addSubview:self.viewB];
    
    /** 时间 */
    self.timeLable = [[UILabel alloc] initWithFrame:CGRectMake(H_0, H_0, H_100, H_30)];
    [self.timeLable setFont:FONT_12];
    [self.viewB addSubview:self.timeLable];
    /** 赞 */
    self.zanBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.zanBtn setFrame:CGRectMake(WIDTH-H_100, H_0, H_20, H_20)];
    [self.viewB addSubview:self.zanBtn];
    /** 回复数 */
    self.commentLable = [[UILabel alloc] initWithFrame:CGRectMake(self.zanBtn.x+H_60, H_0, H_20, H_20)];
    [self.commentLable setFont:FONT_12];
    [self.viewB addSubview:self.commentLable];
    
    self.backgroundView.userInteractionEnabled = YES;
    self.image.userInteractionEnabled = YES;
    self.iconImage.userInteractionEnabled = YES;
    self.viewA.userInteractionEnabled = YES;
    self.viewB.userInteractionEnabled = YES;
}

- (void)setData:(ForumModel *)model {
    self.titleLable.text = [model.text emojizedString];
    CGSize titleSize = [(NSString *)model.text sizeWithWidth:self.viewA.width andFont:FONT_14];
    self.titleLable.height = titleSize.height;
    self.userName.text = model.nickname;
    [self.iconImage sd_setImageWithURL:[NSURL URLWithString:model.headerimg] placeholderImage:[UIImage imageNamed:@"logo_luotuo"]];
    self.viewB.y = self.titleLable.y+self.titleLable.height;
    
    if (model.image1.length != 0) {
        [self.image1 setHidden:NO];
        [self.image1 sd_setImageWithURL:[NSURL URLWithString:model.image1] placeholderImage:[UIImage imageNamed:@"defPic"]];
        self.viewB.y = self.image1.y+self.image1.width+5;
    } else {
        [self.image1 setHidden:YES];
        self.viewB.y = self.titleLable.y+self.titleLable.height;
    }
    
    if (model.image2.length != 0) {
        [self.image2 setHidden:NO];
        [self.image2 sd_setImageWithURL:[NSURL URLWithString:model.image2] placeholderImage:[UIImage imageNamed:@"defPic"]];
        [self.backgroundView addSubview:self.image2];
        self.viewB.y = self.image1.y+self.image1.width+5;
    } else {
        [self.image2 setHidden:YES];
    }
    
    if (model.image3.length != 0) {
        [self.image3 setHidden:NO];
        [self.image3 sd_setImageWithURL:[NSURL URLWithString:model.image3] placeholderImage:[UIImage imageNamed:@"defPic"]];
        [self.backgroundView addSubview:self.image3];
        self.viewB.y = self.image1.y+self.image1.width+5;
    } else {
        [self.image3 setHidden:YES];
    }
    
    self.timeLable.text = [NSString stringTimeDescribeFromTimeString:model.time];
    self.backgroundView.height = self.viewB.y+self.viewB.height-H_10;
    self.image.height = self.backgroundView.height;
}

- (void)onIconImageClick {
    
    NSLog(@"头像被点击");
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
