//
//  AnswerTwoTableViewCell.m
//  mltshop
//
//  Created by 小新 on 15/4/18.
//  Copyright (c) 2015年 manluotuo. All rights reserved.
//

#import "AnswerTwoTableViewCell.h"

@interface AnswerTwoTableViewCell()
/** 用户名 */
@property (nonatomic, strong) UIButton *userBtn;
/** 回复 */
@property (nonatomic, strong) UILabel *answerLable;

@end
@implementation AnswerTwoTableViewCell

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
    
    self.answerLable = [[UILabel alloc] initWithFrame:CGRectMake(self.userBtn.x, self.userBtn.y, WIDTH-H_60, H_10)];
    [self.answerLable setTextColor:GRAYCOLOR];
    [self addSubview:self.answerLable];
    
    self.userBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.userBtn setFrame:CGRectMake(H_50, H_10, WIDTH-H_60, H_10)];
    [self.userBtn setTitleColor:BLUECOLOR forState:UIControlStateNormal];
    [self.userBtn addTarget:self action:@selector(onUserBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.userBtn];
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
