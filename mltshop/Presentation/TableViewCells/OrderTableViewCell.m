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
@property (nonatomic, strong)OrderModel *data;
@property (nonatomic, strong) UIImageView *imageRight;
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
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 0.6)];
    [line setBackgroundColor:GRAYLELIGHTCOLOR];
    [self addSubview:line];
    
    idLabel = [[UILabel alloc]initWithFrame:CGRectMake(H_10, H_5, H_240, H_20)];
    idLabel.numberOfLines = 0;
    idLabel.textColor = GRAYCOLOR;
    idLabel.font = FONT_12;
    
    amountLabel = [[UILabel alloc]initWithFrame:CGRectMake(H_110, H_25, H_100, H_20)];
    amountLabel.font = FONT_12;
    
    timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(H_10, H_25, H_150, H_20)];
    timeLabel.font = FONT_12;
    timeLabel.textColor = GREENCOLOR;
    
    actionBtn = [KKFlatButton buttonWithType:UIButtonTypeCustom];
    actionBtn.titleLabel.font = FONT_12;
    [actionBtn setTitle:T(@"立即付款") forState:UIControlStateNormal];
    [actionBtn setFrame:CGRectMake(H_220, H_10, H_70, H_30)];
    [actionBtn addTarget:self action:@selector(opsAction) forControlEvents:UIControlEventTouchUpInside];
    [actionBtn setTitleColor:WHITECOLOR andStyle:KKFlatButtonStyleLight];
    [actionBtn setBackgroundColor:[UIColor orangeColor]];
    
    self.imageRight = RIGHT_FRAME;
    [self.imageRight setImage:RIGHT_IMAGE];
    [self addSubview:self.imageRight];
    
//    self.backgroundColor = BGCOLOR;
    self.backgroundColor = WHITECOLOR;
    
    [self addSubview:timeLabel];
    [self addSubview:idLabel];
    [self addSubview:amountLabel];
//    [self addSubview:actionBtn];
}

- (void)setNewData:(OrderModel *)_newData
{
    self.data = _newData;
    

    
    idLabel.text = [NSString stringWithFormat:@"编号: %@",self.data.orderSn];
    amountLabel.text = [NSString stringWithFormat:@"总计: %@元",
                        STR_NUM2([self.data.orderAmount floatValue])];
    
    timeLabel.text = [DataTrans dateStringFromDate:self.data.orderTime];
    if ([self.data.paymentType isEqualToString:@"UNPAYED"]) {
        [actionBtn setHidden:NO];
        
    } else {
        
        [actionBtn setHidden:YES];
    }

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
