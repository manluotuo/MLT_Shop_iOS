//
//  CartTableViewCell.m
//  mltshop
//
//  Created by mactive.meng on 21/12/14.
//  Copyright (c) 2014 manluotuo. All rights reserved.
//

#import "CartTableViewCell.h"

@interface CartTableViewCell(){
    UIImageView *coverImageView;
    UILabel *nameLabel;
    UILabel *detailLabel;
    UILabel *priceLabel;
    UILabel *numberLabel;
}

@property(nonatomic, strong)CartModel *data;
@end

@implementation CartTableViewCell

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

- (void)initCellView
{
    nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(H_20, TOP_PADDING, H_100, H_20)];
    nameLabel.font = FONT_14;
    nameLabel.textColor = GREENCOLOR;
    
    priceLabel = [[UILabel alloc]initWithFrame:CGRectMake(H_90, TOP_PADDING, H_200, H_20)];
    priceLabel.textColor = GRAYCOLOR;
    priceLabel.textAlignment = NSTextAlignmentRight;
    priceLabel.font = FONT_12;
    
    detailLabel = [[UILabel alloc]initWithFrame:CGRectMake(H_20, TOP_PADDING+H_24, H_280, H_30)];
    detailLabel.numberOfLines = 0;
    detailLabel.font = FONT_12;
    
    numberLabel = [[UILabel alloc]initWithFrame:CGRectMake(H_20, TOP_PADDING+H_24, H_280, H_30)];
    numberLabel.numberOfLines = 0;
    numberLabel.font = FONT_12;
    
    
    [self addSubview:nameLabel];
    [self addSubview:priceLabel];
    [self addSubview:detailLabel];
    [self addSubview:numberLabel];
}


- (void)setNewData:(CartModel *)_newData
{
    self.data = _newData;
    nameLabel.text = self.data.goodsName;
    priceLabel.text = STR_NUM0([self.data.shopPrice floatValue]);
    detailLabel.text = self.data.goodsBrief;
    numberLabel.text = STR_INT([self.data.goodsNumber integerValue]);
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
