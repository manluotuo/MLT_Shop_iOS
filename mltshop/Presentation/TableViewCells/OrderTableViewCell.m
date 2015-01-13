//
//  OrderTableViewCell.m
//  mltshop
//
//  Created by mactive.meng on 13/1/15.
//  Copyright (c) 2015 manluotuo. All rights reserved.
//

#import "OrderTableViewCell.h"

@interface OrderTableViewCell()
{
    UILabel *timeLabel;
    UILabel *idLabel;
    UILabel *amountLabel;
}
@property(nonatomic, strong)OrderModel *data;
@end

@implementation OrderTableViewCell
@synthesize actionBtn;

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
    timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(H_100, H_14, H_200, H_20)];
    timeLabel.font = FONT_14;
    timeLabel.textColor = GREENCOLOR;
    
    idLabel = [[UILabel alloc]initWithFrame:CGRectMake(H_100, H_14+H_20, H_280, H_20)];
    idLabel.numberOfLines = 0;
    idLabel.font = FONT_12;
    
    amountLabel = [[UILabel alloc]initWithFrame:CGRectMake(H_100, H_14+H_20+H_20, H_120, H_20)];
    amountLabel.textColor = GRAYCOLOR;
    amountLabel.font = LITTLECUSTOMFONT;
    
    actionBtn = [KKFlatButton buttonWithType:UIButtonTypeCustom];
    actionBtn.titleLabel.font = FONT_12;
    [actionBtn setTitle:T(@"修改数量") forState:UIControlStateNormal];
    [actionBtn setFrame:CGRectMake(H_220, H_40, H_80, H_40)];
    [actionBtn addTarget:self action:@selector(opsAction) forControlEvents:UIControlEventTouchUpInside];
    [actionBtn setTitleColor:ORANGE_DARK_COLOR andStyle:KKFlatButtonStyleLight];
    
    [self addSubview:timeLabel];
    [self addSubview:idLabel];
    [self addSubview:amountLabel];
    [self addSubview:actionBtn];
}

- (void)setNewData:(OrderModel *)_newData
{
    self.data = _newData;
    
    timeLabel.text = [DataTrans dateStringFromDate:self.data.orderTime];
    idLabel.text = self.data.orderId;
    amountLabel.text = STR_NUM2(self.data.orderAmount);
}

- (void)opsAction
{
    [self.passDelegate passSignalValue:SIGNAL_ORDER_ACTION andData:self.data];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
