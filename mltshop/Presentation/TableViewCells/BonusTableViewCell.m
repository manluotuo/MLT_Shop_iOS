//
//  BonusTableViewCell.m
//  mltshop
//
//  Created by mactive.meng on 21/12/14.
//  Copyright (c) 2014 manluotuo. All rights reserved.
//

#import "BonusTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "KKFlatButton.h"

@interface BonusTableViewCell(){
    UIImageView *iconView;
    UILabel *nameLabel;
    UILabel *priceLabel;
    UILabel *statusLabel;
}

@property(nonatomic, strong)BonusModel *data;

@end

@implementation BonusTableViewCell

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
    
    
    nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(H_60, H_20, H_200, H_20)];
    nameLabel.font = FONT_14;
    nameLabel.textColor = GREENCOLOR;
    
    [self addSubview:statusLabel];
    [self addSubview:nameLabel];
}


- (void)setNewData:(BonusModel *)_newData
{
    self.data = _newData;
    
    if (self.data.selected) {
        statusLabel.textColor = GREENCOLOR;
        statusLabel.text = ICON_CHECK_O;
    }else{
        statusLabel.textColor = GRAYCOLOR;
        statusLabel.text = ICON_CIRCLE_O;
    }
    
    nameLabel.text = [NSString stringWithFormat:@"%@ (%@ 元)",
                      self.data.bonusName,
                      STR_NUM2([self.data.bonusMoney floatValue])];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
