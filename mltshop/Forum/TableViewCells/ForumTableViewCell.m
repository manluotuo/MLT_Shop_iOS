//
//  ForumTableViewCell.m
//  mltshop
//
//  Created by 小新 on 15/3/30.
//  Copyright (c) 2015年 manluotuo. All rights reserved.
//

#import "ForumTableViewCell.h"

@interface ForumTableViewCell()

/** 图片 */
@property (nonatomic, strong) UIImageView *iconImage;
/** 文字 */
@property (nonatomic, strong) UILabel *titleLable;
/** 时间 */
@property (nonatomic, strong) UILabel *timeLable;

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
    
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
