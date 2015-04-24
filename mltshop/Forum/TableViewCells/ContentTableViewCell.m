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
#import "ForumDetailModel.h"

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
    [self.userBtn setFrame:CGRectMake(H_10, H_10, H_40, H_40)];
    [self.userBtn addTarget:self action:@selector(onUserBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.userBtn];
    
    self.userLable = [[UILabel alloc] initWithFrame:CGRectMake(self.userBtn.x+self.userBtn.width+H_10, H_15, H_100, H_10)];
    [self.userLable setTextColor:BlACKCOLOR];
    [self.userLable setFont:FONT_12];
    [self addSubview:self.userLable];
    
    self.timeLable = [[UILabel alloc] initWithFrame:CGRectMake(self.userLable.x, self.userBtn.y+self.userBtn.height-H_15, H_100, H_10)];
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

- (void)setNewData:(ForumDetailModel *)data {
    [self.userBtn sd_setImageWithURL:[NSURL URLWithString:data.headerimg] forState:UIControlStateNormal];
    self.userLable.text = data.nickname;
    self.timeLable.text = data.time;
    self.titleLable.text = data.text;
    CGSize titleSize = [(NSString *)data.text sizeWithWidth:WIDTH-H_20 andFont:FONT_15];
    self.titleLable.height = titleSize.height;
    NSLog(@"Y = %f, H = %f", self.titleLable.y, self.titleLable.height);
    NSArray *array = [self setImageNumber:data];
    CGFloat imageX = 10;
    CGFloat imageY = self.titleLable.y+self.titleLable.height+10;
    CGFloat imageW = WIDTH - 20;
    CGFloat imageH = WIDTH - 20;
    for (NSInteger i = 1; i <= array.count; i++) {
        UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(imageX, imageY+((i-1)*imageH), imageW, imageH)];
        UITapGestureRecognizer *photoTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onPhotoTap:)];
        image.tag = i;
        image.userInteractionEnabled = YES;
        [image addGestureRecognizer:photoTap];
        [image sd_setImageWithURL:[NSURL URLWithString:array[i-1]] placeholderImage:[UIImage imageNamed:@"defPic"]];
        [self addSubview:image];
    }
    
    
}


- (void)onPhotoTap:(UITapGestureRecognizer *)sender {
    NSLog(@"%d", sender.view.tag);
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
