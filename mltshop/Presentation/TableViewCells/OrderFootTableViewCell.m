//
//  OrderFootTableViewCell.m
//  mltshop
//
//  Created by 小新 on 15/3/31.
//  Copyright (c) 2015年 manluotuo. All rights reserved.
//

#import "OrderFootTableViewCell.h"
#import "AppRequestManager.h"

@interface OrderFootTableViewCell()<UIAlertViewDelegate>

@property(nonatomic, strong)OrderModel *data;

/** 立即付款与确认收货按钮 */
@property (nonatomic, strong) UIButton *payBtn;
/** 查看物流按钮 */
@property (nonatomic, strong) UIButton *logBtn;
/** 评论按钮 */
@property (nonatomic, strong) UIButton *commentBtn;

@end

@implementation OrderFootTableViewCell

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

- (void)initCellView {
    self.backgroundColor = WHITECOLOR;
    UIView *backgrounkView = [[UIView alloc] initWithFrame:CGRectMake(0, H_45, WIDTH, H_20)];
    [backgrounkView setBackgroundColor:BGCOLOR];
    [self addSubview:backgrounkView];
    
    self.payBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.payBtn setFrame:CGRectMake(WIDTH-H_90, H_5+1, H_70, H_32)];
    [self.payBtn setTitle:T(@"立即付款") forState:UIControlStateNormal];
    [self.payBtn setTitle:T(@"确认收货") forState:UIControlStateSelected];
    [self.payBtn addTarget:self action:@selector(onPayBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.payBtn.titleLabel setFont:FONT_14];
    [self.payBtn setTitleColor:ORANGECOLOR forState:UIControlStateNormal];
    [self.payBtn setTitleColor:ORANGECOLOR forState:UIControlStateSelected];
    [self.payBtn.layer setBorderColor:ORANGECOLOR.CGColor];
    [self.payBtn.layer setBorderWidth:1.0f];
    [self.payBtn.layer setCornerRadius:5.0f];
    [self.payBtn setSelected:NO];
    
    
    self.logBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.logBtn setFrame:CGRectMake(WIDTH-self.payBtn.width-H_20 - H_80, H_5+1, H_70, H_32)];
    [self.logBtn setTitle:T(@"查看物流") forState:UIControlStateNormal];
    [self.logBtn setTitleColor:GRAYCOLOR forState:UIControlStateNormal];
    [self.logBtn.layer setBorderColor:GRAYCOLOR.CGColor];
    [self.logBtn.layer setBorderWidth:1.0f];
    [self.logBtn.layer setCornerRadius:5.0f];
    [self.logBtn addTarget:self action:@selector(onLogBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    [self.logBtn.titleLabel setFont:FONT_14];
    
    self.commentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.commentBtn setFrame:CGRectMake(WIDTH-H_90, H_5+1, H_70, H_32)];

    [self.commentBtn setTitle:T(@"评价订单") forState:UIControlStateNormal];
    [self.commentBtn.titleLabel setFont:FONT_14];
    [self.commentBtn setTitleColor:GRAYCOLOR forState:UIControlStateNormal];
    [self.commentBtn.layer setBorderColor:GRAYCOLOR.CGColor];
    [self.commentBtn.layer setBorderWidth:1.0f];
    [self.commentBtn.layer setCornerRadius:5.0f];
    [self.commentBtn addTarget:self action:@selector(onCommentBtnClick) forControlEvents:UIControlEventTouchUpInside];
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 45, WIDTH, 0.6)];
    [line setBackgroundColor:GRAYLELIGHTCOLOR];
    [self addSubview:line];
    
    [self addSubview:self.payBtn];
    [self addSubview:self.logBtn];
//    [self addSubview:self.commentBtn];
    
}

- (void)onPayBtnClick {
    if (self.payBtn.selected == NO) {
    [self.passDelegate passSignalValue:SIGNAL_ORDER_ACTION andData:self.data];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:T(@"确定收货") delegate:self cancelButtonTitle:T(@"取消") otherButtonTitles:T(@"确认"), nil];
        alert.delegate = self;
        [alert show];
    }
}

/** 付款与确认收货按钮点击 */
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {

        [[AppRequestManager sharedManager]operateOrderWithOrderModel:self.data operation:OrderOpsAffirmReceived andBlock:^(id responseObject, NSError *error) {
            NSLog(@"%@", responseObject);
            [DataTrans showWariningTitle:T(@"成功收货") andCheatsheet:ICON_INFO andDuration:1.0f];
            
        }];
        
    }
}

/** 物流按钮点击 */
- (void)onLogBtnClick {
//    [self.passDelegate passSignalValue:<#(NSString *)#> andData:<#(id)#>];
}

/** 评论按钮点击 */
- (void)onCommentBtnClick {
//    [self.passDelegate passSignalValue:<#(NSString *)#> andData:<#(id)#>];
}

- (void)setButtonState:(OrderModel *)model {
    
}

- (void)setNewData:(OrderModel *)_newData {
    
    self.data = _newData;
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
