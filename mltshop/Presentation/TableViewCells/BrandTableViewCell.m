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
    UIView *backgroundView;
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
    iconView = [[UIImageView alloc]initWithFrame:CGRectMake((WIDTH-150)/2, H_14, H_150, H_100)];
    [iconView setContentMode:UIViewContentModeScaleAspectFill];
    
//    nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(H_110, H_10, H_200, H_20)];
//    nameLabel.font = FONT_14;
//    nameLabel.textColor = DARKCOLOR;
    
    statusLabel = [[UILabel alloc]initWithFrame:CGRectMake(H_20, H_120, WIDTH-H_40, H_40)];
    statusLabel.font = FONT_12;
    statusLabel.textColor = GRAYCOLOR;
    statusLabel.numberOfLines = 0;
    
    backgroundView = [[UIView alloc] initWithFrame:CGRectMake(H_15, H_5, WIDTH-H_30, 10)];
    [backgroundView setBackgroundColor:GRAYEXLIGHTCOLOR];

    
//    [self addSubview:backgroundView];
    [self addSubview:iconView];
    [self addSubview:statusLabel];
//    [self addSubview:nameLabel];
}


- (void)setNewData:(BrandModel *)_newData
{
    self.data = _newData;
    [iconView sd_setImageWithURL:[NSURL URLWithString:self.data.brandLogo] placeholderImage:PLACEHOLDERIMAGE];
    
    CGSize descSize = [self.data.brandDesc sizeWithWidth:WIDTH-H_40 andFont:FONT_12];
    statusLabel.height = descSize.height;
//    nameLabel.text = self.data.brandName;
    statusLabel.text = self.data.brandDesc;
    backgroundView.height = H_150+descSize.height;
    
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
