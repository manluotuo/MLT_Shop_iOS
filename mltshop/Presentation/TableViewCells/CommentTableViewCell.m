//
//  CommentTableViewCell.m
//  mltshop
//
//  Created by 小新 on 15/3/10.
//  Copyright (c) 2015年 manluotuo. All rights reserved.
//

#import "CommentTableViewCell.h"

@interface CommentTableViewCell()



/** 头像 */
@property (nonatomic, strong) UIImageView *iconImage;
/** 用户名 */
@property (nonatomic, strong) UILabel *author;
/** 评论 */
@property (nonatomic, strong) UILabel *content;
/** 时间 */
@property (nonatomic, strong) UILabel *create;
@end

@implementation CommentTableViewCell

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

- (void)awakeFromNib {
    // Initialization code
}

- (void)initCellView {
    
    self.iconImage = [[UIImageView alloc] initWithFrame:CGRectMake(H_8, H_8, H_50, H_50)];
    self.author = [[UILabel alloc] initWithFrame:CGRectMake(H_10, H_12, H_70, H_18)];
    [self.author setFont:FONT_14];
    self.author.textColor = [UIColor redColor];
    self.create = [[UILabel alloc] initWithFrame:CGRectMake(self.author.x+self.author.width+H_5, H_12, H_150, H_18)];
    [self.create setFont:FONT_14];
    
    self.content = [[UILabel alloc] initWithFrame:CGRectMake(H_50+2, self.create.y+self.create.height+H_5, WIDTH-H_60, H_30)];
    self.content.textColor = [UIColor grayColor];
    UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(H_10, self.content.y-2, H_50, H_30)];
    lable.text = @"评论：";
    [lable setFont:FONT_14];
    lable.textColor = [UIColor redColor];
    
    [self addSubview:lable];
//    [self addSubview:self.iconImage];
    [self addSubview:self.author];
    [self addSubview:self.create];
    [self addSubview:self.content];
}

- (void)setCellData:(CommentModel *)model {
    
    [self.iconImage setImage:[UIImage imageNamed:@"logo_luotuo"]];
    if (model.create != nil) {
        NSRange range = [model.create rangeOfString:@"+"];
        NSString *timeStr = [model.create substringToIndex:range.location];
        self.create.text = timeStr;
        
    }
    self.author.text = model.author;
    
    CGSize contentSize = [model.content sizeWithWidth:WIDTH-H_60 andFont:FONT_14];
    self.content.height = contentSize.height;
    self.content.text = model.content;
    self.content.numberOfLines = 0;
    [self.content setFont:FONT_14];
}

- (CGFloat)setCellHeight {
    
    return self.content.y + self.content.height + 10;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
