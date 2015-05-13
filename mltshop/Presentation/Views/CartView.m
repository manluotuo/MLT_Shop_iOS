//
//  CartView.m
//  
//
//  Created by Col on 15/5/11.
//
//

#import "CartView.h"
#import <SDWebImage/UIButton+WebCache.h>
#import "UIViewController+KNSemiModal.h"

@interface CartView()
@property (nonatomic, strong)UIView *headerView;
@property (nonatomic, strong)NSMutableArray *sizeBtnArray;
@property (nonatomic, strong)NSMutableArray *colorBtnArray;
@property (nonatomic, assign)CGFloat buyCount;
@property (nonatomic, weak)UILabel *buyCountLabel;
@property (nonatomic, weak)UIButton *decreaseBtn;
@property (nonatomic, weak)UILabel *priceLabel;
@property (nonatomic, weak)UIButton *goodsIcon;
@property (nonatomic, weak)UILabel *stockLabel;
@property (nonatomic, strong)GoodsModel *theGoods;
@property (nonatomic, weak) UIButton *increaseBtn;
@property (nonatomic, strong)CartModel *cartModel;
@property (nonatomic, copy)NSString *itemId;
@end

@implementation CartView

//-(instancetype)initWithFrame:(CGRect)frame{
//    self = [super initWithFrame:frame];
//    if (self) {
//        [self initView];
//    }
//    return self;
//}
//
//- (void)initView{
//    
//    
//}

- (void)setData:(GoodsModel *)model{
    [self setUpHeaderView];

    self.theGoods = model;
    
    NSURL *url = [NSURL URLWithString:self.theGoods.cover.original];
    [self.goodsIcon sd_setBackgroundImageWithURL:url forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"LLMainPageRecommDishDefault"]];
    
    self.priceLabel.text = [NSString stringWithFormat:@"￥%@.00",self.theGoods.shopPrice];
    self.stockLabel.text = [NSString stringWithFormat:@"库存%@件",self.theGoods.goodsInvertory];
    [self setUpContainView];
    
}

- (void) setUpContainView{
    UIView *containView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.headerView.frame), TOTAL_WIDTH, self.height - self.headerView.height)];
    containView.backgroundColor = [UIColor whiteColor];
    [self addSubview:containView];
    
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(10, containView.bounds.origin.y + 5, 50, 30)];
    label1.text = @"规格";
    label1.font = [UIFont systemFontOfSize:14];
    [containView addSubview:label1];
    
    NSMutableArray *arr = [NSMutableArray array];
    
    
    CGFloat btnW = 60;
    CGFloat btnH = 30;
    int count =4;

    CGFloat marginX = (self.bounds.size.width- count * btnW) / (count +1);
    CGFloat marginY = 15;
    for (int i = 0; i<self.theGoods.spec.values.count; i++) {
        
        SpecItemModel *model = self.theGoods.spec.values[i];
        
        CGSize btnSize = [model.label sizeWithFont:[UIFont systemFontOfSize:15]];
        if (btnSize.width > 60 && btnSize.width <65){
            btnW = btnSize.width;
            count = 3;
            marginX = 15;
            NSLog(@"%f",btnW);
        }else if (btnSize.width > 65){
            btnW = btnSize.width;
            marginX = 15;
            count = 2;
        }
        
        int row = i / count;
        int col = i % count;
        
        if (i<count) {
            marginY =30;
        }else{
            marginY = 20;
        }
        CGFloat x = marginX + (marginX + btnW) * col;
        CGFloat y = marginY + (marginY + btnH) * row;
        
        UIButton *sizeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        sizeButton.layer.cornerRadius = 5;
        sizeButton.layer.masksToBounds = YES;
        sizeButton.layer.borderColor = [UIColor colorWithRed:233/255.0 green:233/255.0 blue:233/255.0 alpha:1].CGColor;
        sizeButton.layer.borderWidth = 2;
        sizeButton.tag = i;
        [sizeButton addTarget:self action:@selector(sizeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        sizeButton.titleLabel.font = [UIFont systemFontOfSize:12];
        [sizeButton setTitle:model.label forState:UIControlStateNormal];
        [sizeButton setTitleColor:BLACKCOLOR forState:UIControlStateNormal];
        
        sizeButton.frame = CGRectMake(x, y, btnW, btnH);
        [containView addSubview:sizeButton];
        
        [arr addObject:sizeButton];
        
        [sizeButton addTarget:self action:@selector(sizeButtonCilck:) forControlEvents:UIControlEventTouchUpInside];
    }
    self.sizeBtnArray = arr;
    if (self.sizeBtnArray.count == 0) {
        UIButton *sizeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        sizeButton.layer.cornerRadius = 5;
        sizeButton.layer.masksToBounds = YES;
        sizeButton.layer.borderColor = [UIColor colorWithRed:233/255.0 green:233/255.0 blue:233/255.0 alpha:1].CGColor;
        sizeButton.layer.borderWidth = 2;
        sizeButton.frame = CGRectMake(marginX, 40, btnW, btnH);
        [self.sizeBtnArray addObject:sizeButton];
        sizeButton.selected = YES;
        sizeButton.layer.borderColor = [UIColor orangeColor].CGColor;
        sizeButton.titleLabel.font = [UIFont systemFontOfSize:12];
        [sizeButton setTitle:@"标准" forState:UIControlStateNormal];
        [sizeButton setTitleColor:BLACKCOLOR forState:UIControlStateNormal];
        [containView addSubview:sizeButton];
        
    }
    UIButton *btn = self.sizeBtnArray.lastObject;
    UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(5, CGRectGetMaxY(btn.frame) + 15, TOTAL_WIDTH - 10, 1)];
    line1.backgroundColor =[UIColor colorWithRed:233/255.0 green:233/255.0 blue:233/255.0 alpha:1];
    [containView addSubview:line1];
    
    
  /*
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(line1.frame) + 5, 50, 30)];
    label2.text = @"款式";
    label2.font = [UIFont systemFontOfSize:14];
    [containView addSubview:label2];
    
    NSMutableArray *ColorArr = [NSMutableArray array];
    for (int i = 0; i<4; i++) {
        UIButton *sizeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        sizeButton.layer.cornerRadius = 5;
        sizeButton.layer.masksToBounds = YES;
        sizeButton.layer.borderColor = [UIColor colorWithRed:233/255.0 green:233/255.0 blue:233/255.0 alpha:1].CGColor;
        sizeButton.layer.borderWidth = 2;
        CGFloat btnW = 55;
        CGFloat btnH = 30;
        CGFloat btnX = btnMargin + (btnW + btnMargin) * i;
        CGFloat btnY = CGRectGetMaxY(label2.frame);
        sizeButton.frame = CGRectMake(btnX, btnY, btnW, btnH);
        [containView addSubview:sizeButton];
        
        [ColorArr addObject:sizeButton];
        
        [sizeButton addTarget:self action:@selector(colorButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    self.colorBtnArray = ColorArr;
    UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(5, CGRectGetMaxY(label2.frame) + 45, TOTAL_WIDTH - 10, 1)];
    line2.backgroundColor =[UIColor colorWithRed:233/255.0 green:233/255.0 blue:233/255.0 alpha:1];
    [containView addSubview:line2];
    */
    
    UILabel *label3 = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(line1.frame) + 5, 70, 30)];
    label3.text = @"购买数量";
    label3.font = [UIFont systemFontOfSize:14];
    [containView addSubview:label3];
    
    UIButton *decrease = [UIButton buttonWithType:UIButtonTypeCustom];
    decrease.layer.borderColor =[UIColor colorWithRed:200/255.0 green:200/255.0 blue:200/255.0 alpha:1].CGColor;
    decrease.layer.borderWidth = 1;
    decrease.layer.cornerRadius = 2;
    decrease.layer.masksToBounds = YES;
    [decrease setImage:[UIImage imageNamed:@"skuview_decrease"] forState:UIControlStateNormal];
    [decrease setImage:[UIImage imageNamed:@"skuview_decrease2"] forState:UIControlStateDisabled];
    decrease.frame = CGRectMake(TOTAL_WIDTH - 120, CGRectGetMaxY(label3.frame), 35, 35);
    [decrease addTarget:self action:@selector(decreaseClick) forControlEvents:UIControlEventTouchUpInside];
    self.decreaseBtn = decrease;
    [containView addSubview:decrease];
    
    self.buyCount = 1;
    UILabel *numberLabel = [[UILabel alloc] initWithFrame:CGRectMake(TOTAL_WIDTH - 120 + decrease.width - 2, CGRectGetMaxY(label3.frame), 35, 35)];
    numberLabel.layer.borderColor =[UIColor colorWithRed:200/255.0 green:200/255.0 blue:200/255.0 alpha:1].CGColor;
    numberLabel.layer.borderWidth = 1;
    numberLabel.layer.cornerRadius = 2;
    numberLabel.layer.masksToBounds = YES;
    numberLabel.font = [UIFont systemFontOfSize:12];
    numberLabel.textAlignment = NSTextAlignmentCenter;
    numberLabel.text = [NSString stringWithFormat:@"%.0f",self.buyCount];
    if (self.buyCount == 1) {
        decrease.userInteractionEnabled = NO;
    }
    self.buyCountLabel = numberLabel;
    [containView addSubview:numberLabel];
    
    UIButton *increase = [UIButton buttonWithType:UIButtonTypeCustom];
    increase.layer.borderColor =[UIColor colorWithRed:200/255.0 green:200/255.0 blue:200/255.0 alpha:1].CGColor;
    increase.layer.borderWidth = 1;
    increase.layer.cornerRadius = 2;
    increase.layer.masksToBounds = YES;
    [increase setImage:[UIImage imageNamed:@"skuview_increase"] forState:UIControlStateNormal];
    [increase setImage:[UIImage imageNamed:@"skuview_increase2"] forState:UIControlStateHighlighted];
    increase.frame = CGRectMake(CGRectGetMaxX(numberLabel.frame)-2, CGRectGetMaxY(label3.frame), 35, 35);
    [increase addTarget:self action:@selector(increaseClick) forControlEvents:UIControlEventTouchUpInside];
    self.increaseBtn = increase;
    [containView addSubview:increase];
    
    
    
    UIView *line3 = [[UIView alloc] initWithFrame:CGRectMake(5, CGRectGetMaxY(label3.frame) + 45, TOTAL_WIDTH - 10, 1)];
    line3.backgroundColor =[UIColor colorWithRed:233/255.0 green:233/255.0 blue:233/255.0 alpha:1];
    [containView addSubview:line3];

    
    UIButton *doneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    doneBtn.backgroundColor =  ORANGECOLOR;
    [doneBtn setTitle:@"确定" forState: UIControlStateNormal];
    doneBtn.frame = CGRectMake(0, containView.height -90, TOTAL_WIDTH, 50);
    [doneBtn addTarget:self action:@selector(doneButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [containView addSubview:doneBtn];
    
}
/**
 *  点击确定按钮
 */
- (void)doneButtonClick{
    
    CartModel *model = [[CartModel alloc] init];
    model.goodsId = self.theGoods.goodsId;
    model.goodsCount = [NSNumber numberWithFloat:self.buyCount];
    if (self.theGoods.spec.values.count == 0) {
        model.goodsAttrId = @"";
        UIViewController * parent = [self containingViewController];
        if ([parent respondsToSelector:@selector(dismissSemiModalView)]) {
            [parent dismissSemiModalView];
        }
    }else{
        if (self.itemId == nil) {
            [DataTrans showWariningTitle:T(@"请选择规格") andCheatsheet:[NSString fontAwesomeIconStringForEnum:FAInfoCircle] andDuration:0.7f];
            return;
        }else{
            model.goodsAttrId = self.itemId;
            UIViewController * parent = [self containingViewController];
            if ([parent respondsToSelector:@selector(dismissSemiModalView)]) {
                [parent dismissSemiModalView];
            }
        }
    }
    NSLog(@"%@,%@,%@",model.goodsId,model.goodsCount,model.goodsAttrId);

    if ([_delegete respondsToSelector:@selector(donebtnClick:)]) {
        [_delegete donebtnClick:model];
    }
    
}

- (void)sizeButtonClick:(UIButton *)btn{
    
    SpecItemModel *model = self.theGoods.spec.values[btn.tag];
    self.itemId = model.itemId;
    if (model.thumb.length != 0) {
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",BASE_API, model.thumb] ];
        [self.goodsIcon sd_setBackgroundImageWithURL:url forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"LLMainPageRecommDishDefault"]];
    }
}


- (void)increaseClick{
    self.buyCount++;
    self.buyCountLabel.text = [NSString stringWithFormat:@"%.0f",self.buyCount];
    self.decreaseBtn.userInteractionEnabled = YES;
    if (self.buyCount == self.theGoods.goodsInvertory.intValue) {
        self.increaseBtn.userInteractionEnabled = NO;
    }
    
}

- (void)decreaseClick{
    self.buyCount--;
    self.increaseBtn.userInteractionEnabled = YES;
    self.buyCountLabel.text = [NSString stringWithFormat:@"%.0f",self.buyCount];
    if (self.buyCount == 1) {
        self.decreaseBtn.userInteractionEnabled = NO;
    }
}
/*
- (void) colorButtonClick:(UIButton *)btn{
    for (UIButton *button in self.colorBtnArray) {
        button.selected = NO;
        button.layer.borderColor = [UIColor colorWithRed:233/255.0 green:233/255.0 blue:233/255.0 alpha:1].CGColor;
    }
    btn.selected = YES;
    btn.layer.borderColor = [UIColor orangeColor].CGColor;
    
}
*/
- (void) sizeButtonCilck:(UIButton *)btn{
    for (UIButton *button in self.sizeBtnArray) {
        button.selected = NO;
        button.layer.borderColor = [UIColor colorWithRed:233/255.0 green:233/255.0 blue:233/255.0 alpha:1].CGColor;
    }
    btn.selected = YES;
    btn.layer.borderColor = [UIColor orangeColor].CGColor;
}

/**
 *  设置头部视图
 */
- (void) setUpHeaderView{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 40, self.width, 120)];
    self.headerView = headerView;
    [self addSubview:headerView];
    headerView.backgroundColor = [UIColor whiteColor];
    
    UIButton *iconBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.goodsIcon = iconBtn;
    iconBtn.frame = CGRectMake(20, 20, 125, 125);
    iconBtn.userInteractionEnabled = NO;
    iconBtn.layer.cornerRadius = 5;
    iconBtn.layer.masksToBounds = YES;
    iconBtn.layer.borderColor = [UIColor colorWithRed:241/255.0 green:241/255.0 blue:241/255.0 alpha:1].CGColor;
    iconBtn.layer.borderWidth = 3;
    iconBtn.userInteractionEnabled = NO;
    [self addSubview:iconBtn];
    
    UILabel *priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(iconBtn.frame) + 20, 30, 200, 10)];
    self.priceLabel = priceLabel;
    priceLabel.font = [UIFont systemFontOfSize:14];
    priceLabel.textColor = ORANGECOLOR;
    [headerView addSubview:priceLabel];
    
    UILabel *stockLabel = [[UILabel alloc] initWithFrame:CGRectMake(priceLabel.x, CGRectGetMaxY(priceLabel.frame) + 8, 200, 10)];
    self.stockLabel = stockLabel;
    stockLabel.textColor = [UIColor grayColor];
    stockLabel.font = [UIFont systemFontOfSize:12];
    [headerView addSubview:stockLabel];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(5, headerView.height -1, self.width - 10, 0.5)];
    lineView.backgroundColor = [UIColor colorWithRed:233/255.0 green:233/255.0 blue:233/255.0 alpha:1];
    [headerView addSubview:lineView];
}
@end
