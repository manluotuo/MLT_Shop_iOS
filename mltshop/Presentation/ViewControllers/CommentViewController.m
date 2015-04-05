//
//  CommentViewController.m
//  mltshop
//
//  Created by 小新 on 15/4/4.
//  Copyright (c) 2015年 manluotuo. All rights reserved.
//

#import "CommentViewController.h"
#import "FAHoverButton.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "AppRequestManager.h"
#import "GoodsDetail.h"

@interface CommentViewController ()<UIScrollViewDelegate, UITextFieldDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
/** 缩略图 */
@property (nonatomic, strong) UIImageView *iconImage;
/** 名称 */
@property (nonatomic, strong) UILabel *goodsName;
/** 评论 */
@property (nonatomic, strong) UITextView *collectText;
/** 取消 */
@property (nonatomic, strong) UIButton *cancelBtn;
/** 确认 */
@property (nonatomic, strong) UIButton *certainBtn;
/** 星 */
@property (nonatomic, strong) UIButton *starButton;
/** 星级 */
@property (nonatomic, strong) NSString *star;
@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation CommentViewController {
        UILabel *placeLable;
    //    UIView *commentView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataArray = [[NSMutableArray alloc] init];
    self.star = @"5";
    [self createUI];
    [self setupleftButton];
}

- (void)createUI {
    
    [self.view setBackgroundColor:WHITECOLOR];
    self.scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    self.scrollView.delegate = self;
    [self.view addSubview:self.scrollView];
    
    for (NSInteger i = 0; i < self.model.goods_list.count; i++) {
        if ([self.model.goods_list[i][@"comments"] isEqualToString:@"0"]) {
            GoodsDetail *model = [[GoodsDetail alloc] init];
            model.goods_id = self.model.goods_list[i][@"goods_id"];
            model.name = self.model.goods_list[i][@"name"];
            model.small = self.model.goods_list[i][@"img"][@"small"];
            [self.dataArray addObject:model];
        }
    }
    
    for (NSInteger i = 0; i < self.dataArray.count; i++) {
        GoodsDetail *model = self.dataArray[i];
        UIView *commentView = [self createView:CGRectMake(H_0, H_10+i*H_200, WIDTH, H_180) tag:i andModel:model];
        commentView.tag = i + H_100;
        if (commentView.y > TOTAL_HEIGHT) {
            self.scrollView.contentSize = CGSizeMake(WIDTH, commentView.y+commentView.height+H_50);
        } else {
            self.scrollView.contentSize = CGSizeMake(WIDTH, TOTAL_HEIGHT-H_60);
        }
        [self.scrollView addSubview:commentView];

    }
}

- (UIView *)createView:(CGRect)frame tag:(NSInteger)tag andModel:(GoodsDetail *)model {
    
    UIView *commentView = [[UIView alloc] initWithFrame:frame];
    [commentView setBackgroundColor:GRAYEXLIGHTCOLOR];
    
    self.iconImage = [[UIImageView alloc] initWithFrame:CGRectMake(H_10, H_10, H_50, H_50)];
    
    self.goodsName = [[UILabel alloc] initWithFrame:CGRectMake(self.iconImage.x+self.iconImage.width+H_5, H_10, commentView.width-self.iconImage.width-H_20, H_20)];
    self.goodsName.font = FONT_14;
    
    for (NSInteger i = 0; i < 5; i++) {
        self.starButton = [FAHoverButton buttonWithType:UIButtonTypeCustom];
        [self.starButton setTitle:[NSString fontAwesomeIconStringForEnum:FAStar] forState:UIControlStateNormal];
        [self.starButton setFrame:CGRectMake(self.goodsName.x+32*i, self.goodsName.y+self.goodsName.height+5, 30, 30)];
        [self.starButton setTitleColor:[UIColor orangeColor] forState:UIControlStateSelected];
        [self.starButton addTarget:self action:@selector(onStarButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.starButton setSelected:YES];
        self.starButton.tag = i + tag*10+10;
        [commentView addSubview:self.starButton];
    }
    
    self.collectText = [[UITextView alloc] initWithFrame:CGRectMake(H_10, H_70, commentView.width-H_20, H_60)];
    //    [self.collectText becomeFirstResponder];
    self.collectText.layer.backgroundColor = [[UIColor clearColor] CGColor];
    self.collectText.layer.borderColor = [[UIColor grayColor] CGColor];
    self.collectText.layer.borderWidth = 1.0;
    self.collectText.layer.cornerRadius = 2.0f;
    self.collectText.tag = tag + 200;
    self.collectText.delegate = self;
    [self.collectText.layer setMasksToBounds:YES];
    [self.collectText setFont:FONT_16];
    
    placeLable = [[UILabel alloc] initWithFrame:CGRectMake(3, 3, 150, 30)];
    placeLable.enabled = NO;
    placeLable.tag = (tag+1)*10000;
    placeLable.text = @"请在此填写评价";
    placeLable.font = FONT_16;
    
    placeLable.textColor = [UIColor lightGrayColor];
    [self.collectText addSubview:placeLable];
    
    /** 给键盘增加完成按钮 */
    //    RFExampleToolbarButton *exampleButton = [RFExampleToolbarButton new];
    //    [RFKeyboardToolbar addToTextView:self.collectText withButtons:@[exampleButton]];
    
    
    self.cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.cancelBtn.frame = CGRectMake(H_10, self.collectText.y+self.collectText.height+H_6, H_120, H_30+H_5);
    //    [self.cancelBtn setTitle:T(@"取消") forState:UIControlStateNormal];
    //    [self.cancelBtn setBackgroundColor:[UIColor grayColor]];
    //    [self.cancelBtn addTarget:self action:@selector(onCancelBtnClick) forControlEvents:UIControlEventTouchUpInside];
    //    self.cancelBtn.clipsToBounds = YES;
    //    self.cancelBtn.layer.cornerRadius = 5;
    
    self.certainBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.certainBtn.frame = CGRectMake(commentView.width/2+H_10, self.cancelBtn.y, H_120, self.cancelBtn.height);
    [self.certainBtn setTitle:T(@"确定") forState:UIControlStateNormal];
    [self.certainBtn addTarget:self action:@selector(onCertainBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.certainBtn.tag = tag;
    [self.certainBtn setBackgroundColor:[UIColor orangeColor]];
    self.certainBtn.clipsToBounds = YES;
    self.certainBtn.layer.cornerRadius = 5;
    
    
    [commentView addSubview:self.iconImage];
    [commentView addSubview:self.goodsName];
    [commentView addSubview:self.collectText];
    //    [commentView addSubview:self.cancelBtn];
    [commentView addSubview:self.certainBtn];
    [self setCollectViewData:model];
    return commentView;
}

/** 设置评价窗口信息 */
- (void)setCollectViewData:(GoodsDetail *)model {
    [self.iconImage sd_setImageWithURL:[NSURL URLWithString:model.small] placeholderImage:nil];
    self.goodsName.text = model.name;
}

/** textView提示文字 */
- (void) textViewDidChange:(UITextView *)textView{
    
    placeLable = (UILabel *)[self.view viewWithTag:textView.tag-200+10000];
        if ([textView.text length] == 0) {
            [placeLable setHidden:NO];
        }else{
            [placeLable setHidden:YES];
        }

}

/** 确认按钮点击事件 */
- (void)onCertainBtnClick:(UIButton *)sender {
    
    HTProgressHUD *HUD = [[HTProgressHUD alloc] init];
    HUD.indicatorView = [HTProgressHUDIndicatorView indicatorViewWithType:HTProgressHUDIndicatorTypeActivityIndicator];
    HUD.text = T(@"请稍后\n正在提交评论");
    [HUD showInView:self.view];
    
    GoodsDetail *model = self.dataArray[sender.tag];
    self.collectText = (UITextView *)[self.scrollView viewWithTag:sender.tag + 200];
    NSDictionary *dict = @{@"goods_id": model.goods_id, @"comment_rank": self.star, @"content": self.collectText.text};
    NSLog(@"%@", dict);
    
    [[AppRequestManager sharedManager]getCommentAddWithDict:dict andBlock:^(id responseObject, NSError *error) {
        if ([responseObject isEqualToString:@"YES"]) {
            [HUD removeFromSuperview];
            UIView *view = (UIView *)[self.scrollView viewWithTag:sender.tag + 100];
            [UIView animateWithDuration:0.3 animations:^{
                view.x =  WIDTH * 3;
            }];
            for (UIView *view1 in self.scrollView.subviews) {
                [UIView animateWithDuration:0.8 animations:^{
                    if (view1.y != H_10) {
                        view1.y -= H_200;
                    }
                }];
            }
        }
    }];
}


/** 星数被点击 */
- (void)onStarButtonClick:(UIButton *)sender {
    
    NSInteger count = sender.tag/10*10;
    
    for (NSInteger j = count; j < count+5; j++) {
        UIButton *btn = (UIButton *)[self.view viewWithTag:j];
        [btn setSelected:NO];
    }
    for (NSInteger i = count; i <= sender.tag; i++) {
        UIButton *btn = (UIButton *)[self.view viewWithTag:i];
        [btn setSelected:YES];
    }
    self.star = [NSString stringWithFormat:@"%d", sender.tag%10+1];
    if (self.star.length == 0) {
        self.star = [NSString stringWithFormat:@"5"];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    for (NSInteger i = 200; i < 200+self.dataArray.count; i++) {
        UITextView *textView = (UITextView *)[self.scrollView viewWithTag:i];
        [textView resignFirstResponder];
    }
}

- (void)setupleftButton
{
    CGFloat leftMargin = 10.0f;
    FAHoverButton *backButton = [[FAHoverButton alloc] initWithFrame:CGRectMake(0, 0, 12+leftMargin, 21)];
    [backButton setTitle:ICON_BACK forState:UIControlStateNormal];
    [backButton.titleLabel setFont:FONT_AWESOME_36];
    [backButton setImageEdgeInsets:UIEdgeInsetsMake(0, leftMargin, 0, 0)];
    
    
    UIBarButtonItem *barBackButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    [backButton addTarget:self action:@selector(onLeftBtnClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = barBackButtonItem;
    self.navigationItem.hidesBackButton = YES;
}
- (void)onLeftBtnClick {
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


@end
