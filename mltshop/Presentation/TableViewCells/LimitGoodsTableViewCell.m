//
//  LimitGoodsTableViewCell.m
//  mltshop
//
//  Created by 小新 on 15/3/21.
//  Copyright (c) 2015年 manluotuo. All rights reserved.
//

#import "LimitGoodsTableViewCell.h"

#import <SDWebImage/UIImageView+WebCache.h>
#import "LimitModel.h"

@interface LimitGoodsTableViewCell()

/** 图片 */
@property (nonatomic, strong) UIImageView *iconImage;
/** 价格 */
@property (nonatomic, strong) UILabel *goodsPrice;
/** 商品名称 */
@property (nonatomic, strong) UILabel *goodsName;


@end
@implementation LimitGoodsTableViewCell

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
    
    CGFloat X = 0;
    CGFloat Y = 0;
    CGFloat W = TOTAL_WIDTH;
    CGFloat H = W;
    self.iconImage = [[UIImageView alloc] initWithFrame:CGRectMake(X, Y, W, H)];
    self.goodsPrice = [[UILabel alloc] initWithFrame:CGRectMake(0, self.iconImage.height+H_20, W, H_20)];
    self.goodsPrice.textColor = REDCOLOR;
    [self.goodsPrice setFont:[UIFont boldSystemFontOfSize:14.0f]];
    self.goodsPrice.textAlignment = UITextAlignmentCenter;
    self.goodsName = [[UILabel alloc] initWithFrame:CGRectMake(0, self.goodsPrice.y+self.goodsPrice.height, W, H_20)];
    [self.goodsName setFont:FONT_14];
    self.goodsName.textAlignment = UITextAlignmentCenter;
    
    [self addSubview:self.iconImage];
    [self addSubview:self.goodsPrice];
    [self addSubview:self.goodsName];
    
}

- (void)setCellData:(LimitModel *)model {
    
    [self.iconImage sd_setImageWithURL:[NSURL URLWithString:model.img[@"goods"]] placeholderImage:[UIImage imageNamed:nil]];
    self.goodsPrice.text = [NSString stringWithFormat:@"￥%@元", model.promote_price];
    
    self.goodsName.text = model.goods_name;
    
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
