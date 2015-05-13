//
//  OrderFootTableViewCell.m
//  mltshop
//
//  Created by 小新 on 15/3/31.
//  Copyright (c) 2015年 manluotuo. All rights reserved.
//

#import "OrderFootTableViewCell.h"
#import "AppRequestManager.h"

#define OS_UNCONFIRMED            0 // 未确认

#define OS_CONFIRMED              1 // 已确认

#define OS_CANCELED               2 // 已取消

#define OS_INVALID                3 // 无效

#define OS_RETURNED               4 // 退货

#define OS_SPLITED                5 // 已分单

#define OS_SPLITING_PART          6 // 部分分单

/* 配送状态 */

#define SS_UNSHIPPED              0 // 未发货

#define SS_SHIPPED                1 // 已发货

#define SS_RECEIVED               2 // 已收货

#define SS_PREPARING              3 // 备货中

#define SS_SHIPPED_PART           4 // 已发货(部分商品)

#define SS_SHIPPED_ING            5 // 发货中(处理分单)

#define OS_SHIPPED_PART           6 // 已发货(部分商品)

@interface OrderFootTableViewCell()<UIAlertViewDelegate>

@property(nonatomic, strong)OrderModel *data;

/** 立即付款与确认收货按钮 */
@property (nonatomic, strong) UIButton *payBtn;
/** 查看物流按钮 */
@property (nonatomic, strong) UIButton *logBtn;
/** 评论按钮 */
@property (nonatomic, strong) UIButton *commentBtn;
/** 已取消 */
@property (nonatomic, strong) UILabel *lable;
@end

@implementation OrderFootTableViewCell {
    UIView *backgrounkView;
    UIView *line;
    NSInteger count;
}

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
    backgrounkView = [[UIView alloc] initWithFrame:CGRectMake(0, H_45, WIDTH, H_20)];
    [backgrounkView setBackgroundColor:BGCOLOR];
    [self addSubview:backgrounkView];
    
    self.payBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.payBtn setFrame:CGRectMake(WIDTH-H_90, H_8, H_70, H_28)];
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
    [self.logBtn setFrame:CGRectMake(WIDTH-self.payBtn.width-H_20 - H_80, self.payBtn.y, H_70, self.payBtn.height)];
    [self.logBtn setTitle:T(@"查看物流") forState:UIControlStateNormal];
    [self.logBtn setTitleColor:GRAYCOLOR forState:UIControlStateNormal];
    [self.logBtn.layer setBorderColor:GRAYCOLOR.CGColor];
    [self.logBtn.layer setBorderWidth:1.0f];
    [self.logBtn.layer setCornerRadius:5.0f];
    [self.logBtn addTarget:self action:@selector(onLogBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    [self.logBtn.titleLabel setFont:FONT_14];
    
    self.commentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.commentBtn setFrame:CGRectMake(WIDTH-H_90, self.payBtn.y, H_70, self.payBtn.height)];
    
    [self.commentBtn setTitle:T(@"评价订单") forState:UIControlStateNormal];
    [self.commentBtn.titleLabel setFont:FONT_14];
    [self.commentBtn setTitleColor:GRAYCOLOR forState:UIControlStateNormal];
    [self.commentBtn.layer setBorderColor:GRAYCOLOR.CGColor];
    [self.commentBtn.layer setBorderWidth:1.0f];
    [self.commentBtn.layer setCornerRadius:5.0f];
    [self.commentBtn addTarget:self action:@selector(onCommentBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    self.lable = [[UILabel alloc] initWithFrame:CGRectMake(self.commentBtn.x, self.commentBtn.y, self.commentBtn.width, self.commentBtn.height)];
    [self.lable setFont:FONT_14];
    [self.lable setTextColor:REDCOLOR];
    self.lable.textAlignment = UIBaselineAdjustmentAlignCenters;
    //    [self.lable.layer setBorderColor:GRAYCOLOR.CGColor];
    //    [self.lable.layer setBorderWidth:1.0f];
    //    [self.lable.layer setCornerRadius:5.0f];
    [self addSubview:self.lable];
    
    line = [[UIView alloc] initWithFrame:CGRectMake(0, 45, WIDTH, 0.6)];
    [line setBackgroundColor:GRAYLELIGHTCOLOR];
    [self addSubview:line];
    
    [self addSubview:self.payBtn];
    [self addSubview:self.logBtn];
    [self addSubview:self.commentBtn];
    
}

#warning - 需要在这里判断支付方式
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
        [[AppRequestManager sharedManager]operateOrderWithOrderModel:self.data operation:OrderOpsAffirmReceived andPage:0 andBlock:^(id responseObject, NSError *error) {
            [DataTrans showWariningTitle:T(@"成功收货") andCheatsheet:ICON_INFO andDuration:1.0f];
            if (count < self.data.goods_list.count) {
                [self.passDelegate passSignalValue:@"Comment" andData:self.data];
            }
            [self.payBtn setHidden:NO];
            [self.commentBtn setHidden:YES];
        }];
    }
}

/** 物流按钮点击 */
- (void)onLogBtnClick {
    [self.passDelegate passSignalValue:LOGBTN_CLICK andData:self.data];
}

/** 评论按钮点击 */
- (void)onCommentBtnClick {
    [self.passDelegate passSignalValue:@"Comment" andData:self.data];
}

- (void)setButtonState {
    
    /** 已取消 都不显示 */
    if ([self.data.order_status integerValue] == OS_CANCELED || [self.data.order_status integerValue] == OS_RETURNED || [self.data.order_status integerValue] == OS_INVALID) {
        self.lable.text = @"无效订单";
        [self.payBtn setHidden:YES];
        [self.commentBtn setHidden:YES];
        [self.logBtn setHidden:YES];
        [line setHidden:YES];
        //        backgrounkView.y = H_0;
        
    }
    
    
    if ([self.data.shipping_status integerValue] == SS_UNSHIPPED && [self.data.paymentType isEqualToString:@"PAYED"]) {
        [self.logBtn setHidden:YES];
        [self.payBtn setHidden:NO];
        [self.payBtn setSelected:YES];
        [self.commentBtn setHidden:YES];
        //        backgrounkView.y = H_0;
    }
    
    /** 未确认 未付款 显示立即付款 */
    if ([self.data.order_status intValue] == OS_UNCONFIRMED && [self.data.paymentType isEqualToString:T(@"UNPAYED")]) {
        [self.payBtn setHidden:NO];
        [self.payBtn setSelected:NO];
        [self.commentBtn setHidden:YES];
        [self.logBtn setHidden:YES];
    }
    
    
    /** 已发货 已付款 显示查看物流 */
    if ([self.data.shipping_status integerValue] == SS_SHIPPED && [self.data.paymentType isEqualToString:T(@"PAYED")]) {
        [self.payBtn setSelected:YES];
        [self.logBtn setHidden:NO];
        [self.commentBtn setHidden:YES];
    }
    
    /** 已收货 已付款 显示评论 */
    if ([self.data.shipping_status integerValue] == SS_RECEIVED && [self.data.paymentType isEqualToString:T(@"PAYED")]) {
        [self.payBtn setHidden:YES];
        [self.commentBtn setHidden:NO];
        for (NSInteger i = 0; i < self.data.goods_list.count; i++) {
            if ([self.data.goods_list[i][@"comments"] isEqualToString:@"0"]) {
                [self.lable setHidden:YES];
                [self.commentBtn setHidden:NO];
                return;
            } else {
                [self.commentBtn setHidden:YES];
                self.lable.text = @"交易成功";
                [self.lable setHidden:NO];
            }
        }
    }
}

- (void)setNewData:(OrderModel *)_newData {
    
    self.data = _newData;
    NSLog(@"%@", self.data);
    [self setButtonState];
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
