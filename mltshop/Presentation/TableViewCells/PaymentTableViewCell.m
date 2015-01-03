//
//  PaymentTableViewCell.m
//  mltshop
//
//  Created by mactive.meng on 21/12/14.
//  Copyright (c) 2014 manluotuo. All rights reserved.
//

#import "PaymentTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "KKFlatButton.h"

@interface PaymentTableViewCell(){
    UIImageView *iconView;
    UILabel *nameLabel;
    UILabel *priceLabel;
    UILabel *statusLabel;
}

@property(nonatomic, strong)PayModel *data;

@end

@implementation PaymentTableViewCell

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
    
    iconView = [[UIImageView alloc]initWithFrame:CGRectMake(H_60, H_15, H_90, H_30)];
    
    nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(H_160, H_20, H_60, H_20)];
    nameLabel.font = FONT_14;
    nameLabel.textColor = GRAYCOLOR;

    [self addSubview:statusLabel];
    [self addSubview:nameLabel];
    [self addSubview:iconView];
}


- (void)setNewData:(PayModel *)_newData
{
    self.data = _newData;
    
    if (self.data.selected) {
        statusLabel.textColor = GREENCOLOR;
        statusLabel.text = ICON_CHECK_O;
    }else{
        statusLabel.textColor = GRAYCOLOR;
        statusLabel.text = ICON_CIRCLE_O;
    }
    
    [iconView setImage:[UIImage imageNamed:self.data.payCode]];
    nameLabel.text = self.data.payName;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
