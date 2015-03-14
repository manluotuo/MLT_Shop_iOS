//
//  CommentTableViewCell.m
//  mltshop
//
//  Created by 小新 on 15/3/10.
//  Copyright (c) 2015年 manluotuo. All rights reserved.
//

#import "CommentTableViewCell.h"

@interface CommentTableViewCell()

@property (weak, nonatomic) IBOutlet UIImageView *iconImage;

@property (weak, nonatomic) IBOutlet UILabel *author;

@property (weak, nonatomic) IBOutlet UILabel *create;
@property (nonatomic, strong) UILabel *content;

@end

@implementation CommentTableViewCell

- (void)awakeFromNib {
    // Initialization code
}


- (void)setCellData:(CommentModel *)model {
    
    if (model.create != nil) {
        NSRange range = [model.create rangeOfString:@"+"];
        NSString *timeStr = [model.create substringToIndex:range.location];
        self.create.text = timeStr;
        
    }
    self.author.text = model.author;
    self.content = [[UILabel alloc] initWithFrame:CGRectMake(H_30, self.create.y+self.create.height+H_10, H_260, H_30)];
    
    CGSize contentSize = [model.content sizeWithWidth:H_260 andFont:FONT_12];
    self.content.height = contentSize.height;
    self.content.text = model.content;
    self.content.numberOfLines = 0;
    [self.content setFont:FONT_12];
    [self addSubview:self.content];
}

- (CGFloat)setCellHeight {
    
    return self.content.y + self.content.height + 10;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
