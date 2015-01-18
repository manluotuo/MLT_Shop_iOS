//
//  BrandTableViewCell.m
//  mltshop
//
//  Created by mactive.meng on 18/1/15.
//  Copyright (c) 2015 manluotuo. All rights reserved.
//

#import "BrandTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface BrandTableViewCell(){
    UIImageView *iconView;
    UILabel *nameLabel;
    UILabel *statusLabel;
}

@property(nonatomic, strong)BrandModel *data;

@end
@implementation BrandTableViewCell

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
    iconView = [[UIImageView alloc]initWithFrame:CGRectMake(H_10, H_14, H_80, H_60)];
    [iconView setContentMode:UIViewContentModeScaleAspectFill];
    
    nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(H_110, H_10, H_200, H_20)];
    nameLabel.font = FONT_14;
    nameLabel.textColor = DARKCOLOR;
    
    statusLabel = [[UILabel alloc]initWithFrame:CGRectMake(H_110, H_36, H_200, H_40)];
    statusLabel.font = FONT_12;
    statusLabel.textColor = GRAYCOLOR;
    statusLabel.numberOfLines = 0;
    
    [self addSubview:iconView];
    [self addSubview:statusLabel];
    [self addSubview:nameLabel];
}


- (void)setNewData:(BrandModel *)_newData
{
    self.data = _newData;
    [iconView sd_setImageWithURL:[NSURL URLWithString:self.data.brandLogo] placeholderImage:PLACEHOLDERIMAGE];
    
    CGSize descSize = [self.data.brandDesc sizeWithWidth:H_200 andFont:FONT_12];
    statusLabel.height = descSize.height;
    nameLabel.text = self.data.brandName;
    statusLabel.text = self.data.brandDesc;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                      initWithTarget:self
                      action:@selector(tapSingleAction)];
    tap.numberOfTapsRequired = 1;
    [self addGestureRecognizer:tap];
}
- (void)tapSingleAction
{
    [self.passDelegate passSignalValue:SIGNAL_TAP_CELL andData:self.data];
}

@end
