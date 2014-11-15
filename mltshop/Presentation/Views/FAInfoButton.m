//
//  FAInfoButton.m
//  bitmedia
//
//  Created by meng qian on 14-3-3.
//  Copyright (c) 2014年 thinktube. All rights reserved.
//

#import "FAInfoButton.h"

@interface FAInfoButton()

@property(nonatomic, strong)UILabel *theTitleLabel;
@property(nonatomic, strong)UILabel *theSubTitleLabel;

@end

@implementation FAInfoButton

@synthesize iconColor;
@synthesize iconString;
@synthesize theTitleLabel;
@synthesize titleColor;
@synthesize titleString;
@synthesize subTitleString;
#define BUBBLE_H 15.0f
#define BUBBLE_W 20.0f


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        self.backgroundColor = [UIColor clearColor];
        [self.titleLabel setFont:FONT_AWESOME_20];
        self.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        [self setContentEdgeInsets:UIEdgeInsetsMake(0, 0, frame.size.height*0.4, 0)];
        
        [self setTitleColor:GRAYLIGHTCOLOR forState:UIControlStateNormal];
        [self setTitleColor:GRAYLIGHTCOLOR forState:UIControlStateHighlighted];
        
        self.theTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0 , frame.size.height*0.5, frame.size.width, frame.size.height*0.2)];
        [self.theTitleLabel setBackgroundColor:[UIColor clearColor]];
        [self.theTitleLabel setTextColor:GRAYLIGHTCOLOR];
        [self.theTitleLabel setFont:FONT_12];
        [self.theTitleLabel setTextAlignment:NSTextAlignmentCenter];
        self.theTitleLabel.backgroundColor = [UIColor clearColor];

        self.theSubTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0 , frame.size.height*0.75, frame.size.width, frame.size.height*0.2)];
        [self.theSubTitleLabel setBackgroundColor:[UIColor clearColor]];
        [self.theSubTitleLabel setTextColor:GRAYCOLOR];
        [self.theSubTitleLabel setFont:FONT_12];
        [self.theSubTitleLabel setTextAlignment:NSTextAlignmentCenter];
        self.theSubTitleLabel.backgroundColor = [UIColor clearColor];

        [self addSubview:self.theTitleLabel];
        [self addSubview:self.theSubTitleLabel];
        [self setTitleColor:GRAYCOLOR forState:UIControlStateNormal];
        
//        UIImage *highlightBG = [FAInfoButton imageWithColor:GRAYEXLIGHTCOLOR size:frame.size];
//        [self setBackgroundImage:highlightBG forState:UIControlStateHighlighted];
    }
    return self;
}

- (void)setIcon:(NSString *)icon andTitle:(NSString *)title andSubTitle:(NSString *)subTitle
{
    [self setTitle:icon forState:UIControlStateNormal];
    self.theTitleLabel.text = title;
    self.theSubTitleLabel.text = subTitle;
}

- (void)setIconColor:(UIColor *)_iconColor
{
    [self.titleLabel setTextColor:_iconColor];
}

- (void)setIconString:(NSString *)_iconString
{
    [self.titleLabel setText:_iconString];
}

- (void)setTitleString:(NSString *)_titleString
{
    self.theTitleLabel.text = _titleString;
}

- (void)setSubTitleString:(NSString *)_subTitleString
{
    self.theSubTitleLabel.text = _subTitleString;
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
