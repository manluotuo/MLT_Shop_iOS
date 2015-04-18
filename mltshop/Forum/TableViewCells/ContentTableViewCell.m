//
//  ContentTableViewCell.m
//  mltshop
//
//  Created by 小新 on 15/4/18.
//  Copyright (c) 2015年 manluotuo. All rights reserved.
//

#import "ContentTableViewCell.h"
#import <SDWebImage/UIButton+WebCache.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "ContentModel.h"

@interface ContentTableViewCell()

/** 头像 */
@property (nonatomic, strong) UIButton *userBtn;
/** 用户名 */
@property (nonatomic, strong) UILabel *userLable;
/** 时间 */
@property (nonatomic, strong) UILabel *timeLable;
/** 标题 */
@property (nonatomic, strong) UILabel *titleLable;
/** 内容 */
@property (nonatomic, strong) UILabel *contentLable;

@end

@implementation ContentTableViewCell

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
    [self.userBtn setFrame:CGRectMake(H_10, H_10, H_40, H_40)];
    [self.userBtn addTarget:self action:@selector(onUserBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.userBtn];
    
    self.userLable = [[UILabel alloc] initWithFrame:CGRectMake(self.userBtn.x+self.userBtn.width+H_10, H_10, H_100, H_10)];
    [self.userLable setTextColor:BlACKCOLOR];
    [self.userLable setFont:FONT_12];
    [self addSubview:self.userLable];
    
    self.timeLable = [[UILabel alloc] initWithFrame:CGRectMake(self.userLable.x, self.userBtn.y+self.userBtn.height-H_10, H_100, H_10)];
    [self.timeLable setTextColor:GRAYEXLIGHTCOLOR];
    [self.timeLable setFont:FONT_12];
    [self addSubview:self.timeLable];
    
    self.titleLable = [[UILabel alloc] initWithFrame:CGRectMake(self.userBtn.x, self.userBtn.y+self.userBtn.height+H_15, WIDTH-self.userBtn.x*2, H_20)];
    [self.titleLable setFont:[UIFont boldSystemFontOfSize:H_15]];
    [self addSubview:self.titleLable];
    
    self.contentLable = [[UILabel alloc] initWithFrame:CGRectMake(self.userBtn.x, self.titleLable.y+self.titleLable.height+H_10, self.titleLable.width, H_10)];
    [self.contentLable setFont:FONT_13];
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
