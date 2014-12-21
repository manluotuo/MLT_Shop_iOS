//
//  FAIconButton.m
//  bitmedia
//
//  Created by meng qian on 14-2-21.
//  Copyright (c) 2014年 thinktube. All rights reserved.
//

#import "FAIconButton.h"

@interface FAIconButton()


@end

@implementation FAIconButton


@synthesize titleColor;
@synthesize titleString;
@synthesize iconColor;
@synthesize iconString;
@synthesize iconLabel;
@synthesize isON;
@synthesize indexPath;

#define FONTAWESOME_OFFSET_Y -0.0f

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        self.backgroundColor = [UIColor clearColor];
        [self setTitleColor:WHITECOLOR forState:UIControlStateNormal];
        [self.titleLabel setFont:FONT_16];

        self.iconLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, FONTAWESOME_OFFSET_Y, frame.size.height, frame.size.height)];
        self.iconLabel.backgroundColor = [UIColor clearColor];
        self.iconLabel.font = FONT_AWESOME_14;
        self.iconLabel.textColor = WHITECOLOR;
        self.iconLabel.textAlignment = NSTextAlignmentCenter;
        self.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        
        if (frame.size.width > 120) {
            [self setContentEdgeInsets:UIEdgeInsetsMake(0, 25, 0, 10)];
            [self.iconLabel setFrame:CGRectMake(10, FONTAWESOME_OFFSET_Y, frame.size.height, frame.size.height)];
        }else{
            [self setContentEdgeInsets:UIEdgeInsetsMake(1, 22, 0, 3)];
            [self.iconLabel setFrame:CGRectMake(10, FONTAWESOME_OFFSET_Y, 20, frame.size.height)];
        }
        
        [[self layer] setBackgroundColor:GREENCOLOR.CGColor];
        [[self layer] setCornerRadius:H_5];
        [self addSubview:self.iconLabel];
        
        self.isON = NO;
//        UIImage *highlightBG = [FAIconButton imageWithColor:DARKGREENCOLOR size:frame.size];
//        [self setBackgroundImage:highlightBG forState:UIControlStateHighlighted];

    }
    return self;
}

- (void)setBorder:(BOOL)border
{
    if (border) {
        [[self layer] setBorderColor:GREENCOLOR.CGColor];
        [[self layer] setBorderWidth:0.5f];
        [self setBackgroundColor:WHITECOLOR];

    }else{
        [[self layer] setBorderWidth:0.0f];
    }
}


- (void)changeLightStyle
{
    [[self layer] setBackgroundColor:[UIColor clearColor].CGColor];
    [[self layer] setBorderWidth:0.0f];
    [[self layer] setCornerRadius:0.0f];
    if (self.frame.size.height < H_60) {
        self.iconLabel.font = FONT_AWESOME_14;
    }else{
        self.iconLabel.font = FONT_AWESOME_30;
    }
    
}

- (void)changeGreenLightStyle
{
    [[self layer] setBackgroundColor:GREENCOLOR.CGColor];
    [[self layer] setBorderColor:GRAYLIGHTCOLOR.CGColor];
    [[self layer] setBorderWidth:0.5f];
    [[self layer] setCornerRadius:0.0f];
    
}

- (void)changeRightIcon
{
    [self setContentEdgeInsets:UIEdgeInsetsMake(0, self.frame.size.width*0.2, 0, 40)];
    self.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [self.iconLabel setFrame:CGRectMake(self.frame.size.width - self.frame.size.height, FONTAWESOME_OFFSET_Y, self.frame.size.height, self.frame.size.height)];
}

- (void)changeCenterIcon
{
    [self.titleLabel setText:@""];
    [self setContentEdgeInsets:UIEdgeInsetsZero];
    [self.iconLabel setFrame:CGRectMake(0 , FONTAWESOME_OFFSET_Y, self.frame.size.width, self.frame.size.height)];
}

- (void)setTitleColor:(UIColor *)_titleColor
{
    [self setTitleColor:_titleColor forState:UIControlStateNormal];
//    [self.titleLabel setTextColor:_titleColor];
}

- (void)setTitleString:(NSString *)_titleString
{
    [self setTitle:_titleString forState:UIControlStateNormal];
}

- (void)setIconColor:(UIColor *)_iconColor
{
    [self.iconLabel setTextColor:_iconColor];
}

- (void)setIconString:(NSString *)_iconString
{
    if (StringHasValue(_iconString)) {
        [self.iconLabel setText:_iconString];
    }else{
        [self setContentEdgeInsets:UIEdgeInsetsZero];
    }
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
