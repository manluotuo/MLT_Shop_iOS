//
//  AddressTableViewCell.m
//  mltshop
//
//  Created by mactive.meng on 21/12/14.
//  Copyright (c) 2014 manluotuo. All rights reserved.
//

#import "AddressTableViewCell.h"

@interface AddressTableViewCell(){
    UILabel *consigneeLabel;
    UILabel *detailLabel;
    UILabel *phoneLabel;
}

@property(nonatomic, strong)AddressModel *data;
@end

@implementation AddressTableViewCell

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
    consigneeLabel = [[UILabel alloc]initWithFrame:CGRectMake(H_20, TOP_PADDING, H_100, H_20)];
    consigneeLabel.font = FONT_16;
    consigneeLabel.textColor = BLACKCOLOR;
    [self addSubview:consigneeLabel];

    phoneLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(consigneeLabel.frame) + H_10, consigneeLabel.y, H_200, H_20)];
    phoneLabel.font = CUSTOMFONT_16;
    phoneLabel.textColor = BLACKCOLOR;
    [self addSubview:phoneLabel];
    
    detailLabel = [[UILabel alloc]initWithFrame:CGRectMake(H_20, TOP_PADDING+H_20, H_280, H_30)];
    detailLabel.numberOfLines = 0;
    detailLabel.font = FONT_12;
    detailLabel.textColor = GRAYCOLOR;
    [self addSubview:detailLabel];

    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(H_5, CGRectGetMaxY(detailLabel.frame) + H_5, TOTAL_HEIGHT - H_5, 0.8)];
    line.backgroundColor = [UIColor colorWithRed:111.0f/255.0f green:111.0f/255.0f blue:111.0f/255.0f alpha:0.2];
    [self addSubview:line];
    
    
}


- (void)setNewData:(AddressModel *)_newData
{
    self.data = _newData;
    if ([self.data.defaultAddress boolValue]) {
        consigneeLabel.text = [NSString stringWithFormat:@"[默认] %@",self.data.consignee];
    }else{
        consigneeLabel.text = self.data.consignee;
    }
    
    phoneLabel.text = self.data.tel;
    
    detailLabel.text = [NSString stringWithFormat:@"%@ %@ %@",self.data.cityName,self.data.districtName,self.data.address];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
