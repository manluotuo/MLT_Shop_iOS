//
//  GoodsTwoTableViewCell.m
//  mltshop
//
//  Created by mactive.meng on 14/12/14.
//  Copyright (c) 2014 manluotuo. All rights reserved.
//

#import "GoodsTwoTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "NSString+Size.h"
@interface GoodsTwoTableViewCell(){
    GoodsHalfCell *leftCell;
    GoodsHalfCell *rightCell;
}

@property(nonatomic, strong)UITapGestureRecognizer *leftTap;
@property(nonatomic, strong)UITapGestureRecognizer *rightTap;
@property(nonatomic, strong)GoodsModel *leftData;
@property(nonatomic, strong)GoodsModel *rightData;


@end

@implementation GoodsTwoTableViewCell

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

#define  LEFT_TAG   0
#define  RIGHT_TAG  1
- (void)initCellView
{
    leftCell = [[GoodsHalfCell alloc]initWithFrame:CGRectMake(0, 0, TOTAL_WIDTH/2, GOODS_CELL_HEIGHT)];
    rightCell = [[GoodsHalfCell alloc]initWithFrame:CGRectMake(TOTAL_WIDTH/2, 0, TOTAL_WIDTH/2, GOODS_CELL_HEIGHT)];
    leftCell.tag = LEFT_TAG;
    rightCell.tag = RIGHT_TAG;
    
    
    self.leftTap = [[UITapGestureRecognizer alloc]
                      initWithTarget:self
                      action:@selector(tapSingleAction:)];
    self.leftTap.numberOfTapsRequired = 1;
    [leftCell addGestureRecognizer:self.leftTap];

    self.rightTap = [[UITapGestureRecognizer alloc]
                    initWithTarget:self
                    action:@selector(tapSingleAction:)];
    self.rightTap.numberOfTapsRequired = 1;
    [rightCell addGestureRecognizer:self.rightTap];
    
    [self addSubview:leftCell];
    [self addSubview:rightCell];

}

- (void)setNewData:(NSDictionary *)_newDataDict
{
    self.leftData = _newDataDict[@"left"];
    self.rightData = _newDataDict[@"right"];
    
    [leftCell setup:self.leftData];
    [rightCell setup:self.rightData];
    
}

-(void)tapSingleAction:(GoodsHalfCell *)sender
{
    if (sender.tag == LEFT_TAG) {
        [self.passDelegate passSignalValue:SIGNAL_TAP_VEHICLE andData:self.leftData];
    }
    
    if (sender.tag == RIGHT_TAG) {
        [self.passDelegate passSignalValue:SIGNAL_TAP_VEHICLE andData:self.rightData];
    }
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end


@interface GoodsHalfCell()
{
    UIImageView *goodsImg;
    UILabel *titleLabel;
    UILabel *priceLabel;
}

@end

@implementation GoodsHalfCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if(self){
        // right
        goodsImg = [[UIImageView alloc]initWithFrame:CGRectMake(H_30, H_10, H_100, H_100)];
        
        titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(H_20, H_110, H_130, H_20)];
        [titleLabel setFont:[UIFont boldSystemFontOfSize:12]];
        [titleLabel setTextColor:DARKCOLOR];
        [titleLabel setTextAlignment:NSTextAlignmentLeft];
        titleLabel.numberOfLines = 0;
        
        priceLabel = [[UILabel alloc]initWithFrame:CGRectMake(H_20, H_110, TOTAL_WIDTH/2, H_20)];
        [priceLabel setFont:LITTLECUSTOMFONT];
        [priceLabel setTextColor:REDCOLOR];
        [priceLabel setTextAlignment:NSTextAlignmentLeft];
        
        [self addSubview:goodsImg];
        [self addSubview:titleLabel];
        [self addSubview:priceLabel];
    }
    return self;
}

- (void)setup:(GoodsModel *)theGoods
{
    CGSize titleSize = [(NSString *)theGoods.goodsName sizeWithWidth:H_130 andFont:FONT_12];
    titleLabel.height = titleSize.height;
    priceLabel.y = titleLabel.y + titleSize.height;
    
    [goodsImg sd_setImageWithURL:[NSURL URLWithString:theGoods.cover.thumb] placeholderImage:PLACEHOLDERIMAGE];
    [titleLabel setText:theGoods.goodsName];
    [priceLabel setText:[[theGoods.shopPrice stringValue] stringByAppendingString:@"元"]];
    
}



@end

