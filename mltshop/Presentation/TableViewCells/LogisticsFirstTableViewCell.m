//
//  LogisticsFirstTableViewCell.m
//  mltshop
//
//  Created by 小新 on 15/3/28.
//  Copyright (c) 2015年 manluotuo. All rights reserved.
//

#import "LogisticsFirstTableViewCell.h"
#import "LogisticsModel.h"

@interface LogisticsFirstTableViewCell()

@property (nonatomic, strong) UILabel *titleLable;
@property (nonatomic, strong) UILabel *timeLable;
@property (nonatomic, strong) UIView  *lineView;
@property (nonatomic, strong) UIImageView  *spotView;
@property (nonatomic, strong) LogisticsModel *model;

@end

@implementation LogisticsFirstTableViewCell

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
    
    self.spotView = [[UIImageView alloc] initWithFrame:CGRectMake(13, H_15, H_15, H_15)];
    self.spotView.backgroundColor = GRAYCOLOR;
    [self.spotView.layer setCornerRadius:self.spotView.frame.size.height/2];
    [self.spotView setClipsToBounds:YES];
    
    self.lineView = [[UIView alloc] initWithFrame:CGRectMake(H_20, H_0, 1, H_60)];
    [self.lineView setBackgroundColor:GRAYLELIGHTCOLOR];
    
    self.titleLable = [[UILabel alloc] initWithFrame:CGRectMake(H_40, H_10, WIDTH-H_30*2, 35)];
    self.titleLable.numberOfLines = H_0;
    self.timeLable = [[UILabel alloc] initWithFrame:CGRectMake(H_40, self.titleLable.y+self.titleLable.height+5, self.titleLable.width, H_15)];
    
    [self.titleLable setFont:FONT_14];
    [self.timeLable setFont:FONT_14];
    [self.titleLable setTextColor:ORANGE_DARK_COLOR];
    [self.timeLable setTextColor:ORANGE_DARK_COLOR];
    
    [self addSubview:self.lineView];
    [self addSubview:self.spotView];
    [self addSubview:self.titleLable];
    [self addSubview:self.timeLable];
}

- (void)setNewData:(LogisticsModel *)_newData andType:(BOOL)type {
    self.model = _newData;
    
    CGSize titleHeight = [self.model.context sizeWithWidth:self.titleLable.width andFont:FONT_14];
    self.titleLable.height = titleHeight.height;
    self.timeLable.y = self.titleLable.y+self.titleLable.height+5;
    
    self.titleLable.text = self.model.context;
    self.timeLable.text = self.model.time;
    self.lineView.height = self.timeLable.y+self.timeLable.height+5;
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(H_50, self.timeLable.y+self.timeLable.height+H_15, WIDTH-H_60, 1)];
    [view setBackgroundColor:GRAYLELIGHTCOLOR];
    [self addSubview:view];
    if (type) {
        [self.spotView setBackgroundColor:ORANGE_DARK_COLOR];
        self.lineView.y = self.spotView.y;
        self.height -= self.spotView.y;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
