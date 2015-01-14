//
//  CartTableViewCell.m
//  mltshop
//
//  Created by mactive.meng on 21/12/14.
//  Copyright (c) 2014 manluotuo. All rights reserved.
//

#import "CartTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "KKFlatButton.h"

@interface CartTableViewCell(){
    UIImageView *coverImageView;
    UILabel *nameLabel;
    UILabel *attrLabel;
    UILabel *priceLabel;
    UILabel *numberLabel;
}

@property(nonatomic, strong)CartModel *data;
@end

@implementation CartTableViewCell
@synthesize changeCountBtn;

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
    
    coverImageView = [[UIImageView alloc]initWithFrame:CGRectMake(H_15, H_14, H_60, H_60)];
    
    nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(H_100, H_14, H_200, H_20)];
    nameLabel.font = FONT_14;
    nameLabel.textColor = GREENCOLOR;
    
    attrLabel = [[UILabel alloc]initWithFrame:CGRectMake(H_100, H_14+H_20, H_280, H_20)];
    attrLabel.numberOfLines = 0;
    attrLabel.font = FONT_12;
    
    priceLabel = [[UILabel alloc]initWithFrame:CGRectMake(H_100, H_14+H_20+H_20, H_120, H_20)];
    priceLabel.textColor = GRAYCOLOR;
    priceLabel.font = LITTLECUSTOMFONT;
    
    changeCountBtn = [KKFlatButton buttonWithType:UIButtonTypeCustom];
    changeCountBtn.titleLabel.font = FONT_12;
    [changeCountBtn setTitle:T(@"修改数量") forState:UIControlStateNormal];
    [changeCountBtn setFrame:CGRectMake(H_220, H_40, H_80, H_40)];
    [changeCountBtn addTarget:self action:@selector(changeCountAction) forControlEvents:UIControlEventTouchUpInside];
    [changeCountBtn setTitleColor:ORANGE_DARK_COLOR andStyle:KKFlatButtonStyleLight];
    
    [self addSubview:coverImageView];
    [self addSubview:nameLabel];
    [self addSubview:priceLabel];
    [self addSubview:attrLabel];
    [self addSubview:changeCountBtn];
}


- (void)setNewData:(CartModel *)_newData
{
    self.data = _newData;
    
    NSLog(@"%@",self.data.cover.thumb);
    [coverImageView sd_setImageWithURL:[NSURL URLWithString:self.data.cover.thumb] placeholderImage:PLACEHOLDERIMAGE];
    
    nameLabel.text = self.data.goodsName;
    if (StringHasValue(self.data.goodsAttr)) {
        attrLabel.text = self.data.goodsAttr;
        priceLabel.y = H_14+H_20+H_20;
    }else{
        attrLabel.text = @"";
        priceLabel.y = H_14+H_24;
    }
    
    NSString *priceString = STR_NUM2([self.data.shopPrice floatValue]);
    NSString *numberString = STR_INT([self.data.goodsCount integerValue]);
    
    priceLabel.text = [NSString stringWithFormat:@"%@ x %@", priceString, numberString];
    
}

- (void)changeCountAction
{
    [self.passDelegate passSignalValue:SIGNAL_CHANGE_CART_GOODS_COUNT andData:self.data];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
