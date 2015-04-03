//
//  CollectTableViewCell.m
//  mltshop
//
//  Created by 小新 on 15/3/11.
//  Copyright (c) 2015年 manluotuo. All rights reserved.
//

#import "CollectTableViewCell.h"
#import "CollectModel.h"

#import <SDWebImage/UIImageView+WebCache.h>

@interface CollectTableViewCell() {
    UIImageView *image;
    UILabel *name;
    UILabel *price;
}

@end

@implementation CollectTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self initCellView];
    }
    return self;
}

- (void)awakeFromNib {

}

- (void)setNewData:(CollectModel *)model {
    
    [image sd_setImageWithURL:[NSURL URLWithString:model.img[@"goods"]] placeholderImage:PLACEHOLDERIMAGE];
    name.text = model.goods_name;
    CGSize contentSize = [model.goods_name sizeWithWidth:H_200 andFont:FONT_14];
    name.height = contentSize.height;
    NSLog(@"%f", name.height);
    price.y = name.y+name.height + 8;
    price.text = model.shop_price;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
}

- (CGFloat)setCellHeight {
    return 100;
}


- (void)initCellView {
    
    image = [[UIImageView alloc] initWithFrame:CGRectMake(H_5, H_5, H_80, H_80)];
    name = [[UILabel alloc] initWithFrame:CGRectMake(H_100, H_10, H_200, H_80)];
    name.numberOfLines = 0;
    name.font = FONT_14;
    
    price = [[UILabel alloc] initWithFrame:CGRectMake(H_100, name.y+name.height, H_200, H_10)];
    price.tintColor = [UIColor redColor];
    price.font = FONT_12;
    
//    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(H_20, price.y+price.height, WIDTH - H_20, 1)];
//    line.backgroundColor = GRAYEXLIGHTCOLOR;
    
//    [self addSubview:line];
    [self addSubview:image];
    [self addSubview:name];
    [self addSubview:price];
}

@end
