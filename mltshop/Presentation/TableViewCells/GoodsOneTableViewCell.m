//
//  GoodsOneTableViewCell.m
//  mltshop
//
//  Created by mactive.meng on 14/12/14.
//  Copyright (c) 2014 manluotuo. All rights reserved.
//

#import "GoodsOneTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "NSString+Size.h"
@interface GoodsOneTableViewCell(){
    UIImageView *goodsImg;
    UILabel *titleLabel;
    UILabel *briefLabel;
    UILabel *priceLabel;
}

@property(nonatomic, strong)UITapGestureRecognizer *singleTap;
@property(nonatomic, strong)GoodsModel *data;


@end

@implementation GoodsOneTableViewCell

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
    goodsImg = [[UIImageView alloc]initWithFrame:CGRectMake(H_10, H_10, H_120, H_120)];
    
    titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(H_150, H_25, H_150, H_20)];
    [titleLabel setFont:[UIFont boldSystemFontOfSize:14]];
    [titleLabel setTextColor:DARKCOLOR];
    [titleLabel setTextAlignment:NSTextAlignmentLeft];
    titleLabel.numberOfLines = 0;
    
    briefLabel = [[UILabel alloc]initWithFrame:CGRectMake(H_150, H_60, H_150, H_20)];
    [briefLabel setFont:FONT_12];
    [briefLabel setTextColor:GRAYCOLOR];
    [briefLabel setTextAlignment:NSTextAlignmentLeft];
    briefLabel.numberOfLines = 0;
    

    priceLabel = [[UILabel alloc]initWithFrame:CGRectMake(H_150, H_80, TOTAL_WIDTH/2, H_20)];
    [priceLabel setFont:LITTLECUSTOMFONT];
    [priceLabel setTextColor:REDCOLOR];
    [priceLabel setTextAlignment:NSTextAlignmentLeft];
    
    
    
    [self addSubview:goodsImg];
    [self addSubview:titleLabel];
    [self addSubview:briefLabel];
    [self addSubview:priceLabel];
    
    
    
    //    self.subView = [[ArticleTableViewCellSubView alloc]initWithFrame:CGRectMake(0, 0, TOTAL_WIDTH, VEHICLE_CELL_HEIGHT)];
    self.singleTap = [[UITapGestureRecognizer alloc]
                      initWithTarget:self
                      action:@selector(tapSingleAction:)];
    self.singleTap.numberOfTapsRequired = 1;
    [self addGestureRecognizer:self.singleTap];
}

- (void)setNewData:(GoodsModel *)_newData
{
    self.data = _newData;
    [self setup:_newData];
}

- (void)setup:(GoodsModel *)theGoods
{
    CGSize titleSize = [(NSString *)theGoods.goodsName sizeWithWidth:H_150 andFont:FONT_14];
    CGSize briefSize = [(NSString *)theGoods.goodsBrief sizeWithWidth:H_150 andFont:FONT_12];
    titleLabel.height = titleSize.height;
    briefLabel.height = briefSize.height;
    briefLabel.y = H_25 + titleSize.height;
    priceLabel.y = H_25 + titleSize.height + briefSize.height;
    
    [goodsImg sd_setImageWithURL:[NSURL URLWithString:theGoods.cover.thumb] placeholderImage:PLACEHOLDERIMAGE];
    [titleLabel setText:theGoods.goodsName];
    [briefLabel setText:theGoods.goodsBrief];
    
    if (theGoods.promotePrice.integerValue > 0) {
        [priceLabel setText:[[theGoods.promotePrice stringValue] stringByAppendingString:@"元"]];
    }else{
        [priceLabel setText:[[theGoods.shopPrice stringValue] stringByAppendingString:@"元"]];
    }
    
}


-(void)tapSingleAction:(id)sender
{
    [self.passDelegate passSignalValue:SIGNAL_TAP_VEHICLE andData:self.data];
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
