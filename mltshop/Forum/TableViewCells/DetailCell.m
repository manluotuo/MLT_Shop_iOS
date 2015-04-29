//
//  DetailCell.m
//  mltshop
//
//  Created by 小新 on 15/4/27.
//  Copyright (c) 2015年 manluotuo. All rights reserved.
//

#import "DetailCell.h"
#import "emojis.h"

@interface DetailCell()

@property (nonatomic, strong) UILabel *lable;

@end

@implementation DetailCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
//        [self setBackgroundColor:GRAYEXLIGHTCOLOR];
        [self initCellView];
    }
    return self;
}

- (void)initCellView {
    
    self.lable = [[UILabel alloc] initWithFrame:CGRectMake(H_50, 0, WIDTH-H_60, 10)];
    [self.lable setFont:FONT_14];
    [self.lable setNumberOfLines:0];
    [self addSubview:self.lable];
}

- (void)setNewData:(ContentContentModel *)model {
    
    NSString *str = [[NSString stringWithFormat:@"%@: %@", model.nickname, model.context] emojizedString];
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:str];
    [string addAttribute:NSForegroundColorAttributeName value:ORANGECOLOR range:NSMakeRange(0, model.nickname.length)];
    CGSize titleSize = [str sizeWithWidth:WIDTH-H_60 andFont:FONT_14];
    self.lable.height = titleSize.height;
    self.lable.attributedText = string;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
