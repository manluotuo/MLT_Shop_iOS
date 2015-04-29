//
//  DetailHeaderCell.m
//  mltshop
//
//  Created by 小新 on 15/4/27.
//  Copyright (c) 2015年 manluotuo. All rights reserved.
//

#import "DetailHeaderCell.h"
#import <SDWebImage/UIButton+WebCache.h>
#import "NSString+TimeString.h"


@interface DetailHeaderCell()

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

@implementation DetailHeaderCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setBackgroundColor:GRAYEXLIGHTCOLOR];
        [self initCellView];
    }
    return self;
}

- (void)initCellView {

    self.userBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.userBtn setFrame:CGRectMake(H_10, H_10, H_40, H_40)];
    [self.userBtn addTarget:self action:@selector(onUserBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.userBtn];
    self.userBtn.layer.cornerRadius = 20;
    self.userBtn.clipsToBounds = YES;
    
    self.userLable = [[UILabel alloc] initWithFrame:CGRectMake(self.userBtn.x+self.userBtn.width+H_10, H_15, H_100, H_10)];
    [self.userLable setTextColor:BlACKCOLOR];
    [self.userLable setFont:FONT_12];
    [self addSubview:self.userLable];
    
    self.timeLable = [[UILabel alloc] initWithFrame:CGRectMake(self.userLable.x, self.userBtn.y+self.userBtn.height-H_15, WIDTH, H_10)];
    [self.timeLable setTextColor:GRAYLIGHTCOLOR];
    [self.timeLable setFont:FONT_12];
    [self addSubview:self.timeLable];
    
    self.titleLable = [[UILabel alloc] initWithFrame:CGRectMake(self.userBtn.x, self.userBtn.y+self.userBtn.height+H_10, WIDTH-self.userBtn.x*2, H_20)];
    [self.titleLable setFont:[UIFont boldSystemFontOfSize:H_15]];
    [self.titleLable setNumberOfLines:0];
    [self addSubview:self.titleLable];
    
    self.contentLable = [[UILabel alloc] initWithFrame:CGRectMake(self.userBtn.x, self.titleLable.y+self.titleLable.height+H_10, self.titleLable.width, H_10)];
    [self.contentLable setFont:FONT_13];
    [self addSubview:self.contentLable];
}

- (void)setNewData:(ContentModel *)data {
    [self.userBtn sd_setBackgroundImageWithURL:[NSURL URLWithString:data.headerimg] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"logo_luotuo"]];
    self.userLable.text = data.nickname;
    self.timeLable.text = [NSString stringTimeDescribeFromTimeString:data.time];
    self.titleLable.text = [data.text emojizedString];
    CGSize titleSize = [(NSString *)data.text sizeWithWidth:WIDTH-H_20 andFont:FONT_15];
    self.titleLable.height = titleSize.height;
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
