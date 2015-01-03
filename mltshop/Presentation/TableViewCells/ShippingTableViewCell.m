//
//  ShippingTableViewCell.m
//  mltshop
//
//  Created by mactive.meng on 21/12/14.
//  Copyright (c) 2014 manluotuo. All rights reserved.
//

#import "ShippingTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "KKFlatButton.h"

@interface ShippingTableViewCell(){
    UILabel *nameLabel;
    UILabel *priceLabel;
    UILabel *statusLabel;
}

@property(nonatomic, strong)ShippingModel *data;

@end

@implementation ShippingTableViewCell

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
    statusLabel = [[UILabel alloc]initWithFrame:CGRectMake(H_20, H_20, H_20, H_20)];
    statusLabel.textColor = GRAYCOLOR;
    statusLabel.font = FONT_AWESOME_20;
    
    nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(H_60, H_10, H_220, H_40)];
    nameLabel.font = FONT_14;
    nameLabel.textColor = GRAYCOLOR;
    nameLabel.numberOfLines = 0;
    
    priceLabel = [[UILabel alloc]initWithFrame:CGRectMake(H_60, H_50, H_200, H_20)];
    priceLabel.font = FONT_14;
    priceLabel.textColor = GREENCOLOR;
    
    [self addSubview:statusLabel];
    [self addSubview:nameLabel];
    [self addSubview:priceLabel];
}


- (void)setNewData:(ShippingModel *)_newData
{
    self.data = _newData;
    
    if (self.data.selected) {
        statusLabel.textColor = GREENCOLOR;
        statusLabel.text = ICON_CHECK_O;
    }else{
        statusLabel.textColor = GRAYCOLOR;
        statusLabel.text = ICON_CIRCLE_O;
    }
    
    nameLabel.text = self.data.shippingName;
    priceLabel.text = [NSString stringWithFormat:@"快递费: %@元",STR_NUM2([self.data.shippingFee floatValue])];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
