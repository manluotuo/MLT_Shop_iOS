//
//  KKIconButton.m
//  merchant
//
//  Created by Raven on 14-10-11.
//  Copyright (c) 2014年 kkche. All rights reserved.
//

#import "KKIconButton.h"

@interface KKIconButton ()

@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *contentLabel;

@end

@implementation KKIconButton

@synthesize iconImageView;
@synthesize contentLabel;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self addAllViews];
    }
    return self;
}

- (void)addAllViews
{
    self.iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 2, 20, 20)];
    [self addSubview:self.iconImageView];
    
    self.contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 0, 35, 25)];
    self.contentLabel.font = FONT_12;
    self.contentLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.contentLabel];
}

- (void)setIconImageName:(NSString *)iconImageName
{
    self.iconImageView.image = [UIImage imageNamed:iconImageName];
}

- (void)setContentStr:(NSString *)contentStr
{
    self.contentLabel.text = contentStr;
}

- (void)setStrColor:(UIColor *)strColor
{
    self.contentLabel.textColor = strColor;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
