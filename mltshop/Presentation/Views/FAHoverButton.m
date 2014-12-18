//
//  FAHoverButton.m
//  bitmedia
//
//  Created by meng qian on 14-3-3.
//  Copyright (c) 2014年 thinktube. All rights reserved.
//

#import "FAHoverButton.h"

@interface FAHoverButton()

@property(nonatomic, strong)UILabel *bubbleLabel;

@end

@implementation FAHoverButton

@synthesize iconColor;
@synthesize iconString;
@synthesize bubbleString;
@synthesize bubbleLabel;
@synthesize iconFont;
@synthesize signal;
@synthesize indexPath;
#define BUBBLE_H 16.0f
#define BUBBLE_W 16.0f


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        self.backgroundColor = [UIColor clearColor];
        [self.titleLabel setFont:FONT_AWESOME_24];
        self.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        
        [self setTitleColor:WHITECOLOR forState:UIControlStateNormal];
        [self setTitleColor:WHITECOLOR forState:UIControlStateHighlighted];
        
        self.bubbleLabel = [[UILabel alloc]initWithFrame:CGRectMake(40 , frame.size.height/2-BUBBLE_H/2, BUBBLE_W, BUBBLE_H)];
        [self.bubbleLabel setBackgroundColor:GREENLIGHTCOLOR];
        [self.bubbleLabel setTextColor:WHITECOLOR];
        [self.bubbleLabel setFont:LITTLECUSTOMFONT];
        [self.bubbleLabel setTextAlignment:NSTextAlignmentCenter];
        [self.bubbleLabel.layer setCornerRadius:BUBBLE_H/2];
        [self.bubbleLabel.layer setMasksToBounds:YES];
        [self.bubbleLabel setHidden:YES];

        [self addSubview:self.bubbleLabel];

//        UIImage *highlightBG = [FAHoverButton imageWithColor:DARKGREENCOLOR size:frame.size];
//        [self setBackgroundImage:highlightBG forState:UIControlStateHighlighted];
    }
    return self;
}

- (void)setBubbleString:(NSString *)_bubbleString
{
    if (StringHasValue(_bubbleString)) {
        [self.bubbleLabel setHidden:NO];
        self.bubbleLabel.text = _bubbleString;
        self.bubbleLabel.frame = CGRectMake(self.frame.size.width - BUBBLE_W*2 , self.frame.size.height/2-BUBBLE_H/2, BUBBLE_W, BUBBLE_H);
        [self setTitleEdgeInsets:UIEdgeInsetsMake(0, -20, 0, 0)];

    }
}

- (void)setIconImage:(UIImage *)iconImage
{
    [self setImage:iconImage forState:UIControlStateNormal];
    [self setImage:iconImage forState:UIControlStateHighlighted];
//    [self setImageEdgeInsets:UIEdgeInsetsMake(0, 30, 0, 20)];
}

- (void)setIconColor:(UIColor *)_iconColor
{
    [self setTitleColor:_iconColor forState:UIControlStateNormal];
    [self setTitleColor:_iconColor forState:UIControlStateHighlighted];

}

- (void)setIconString:(NSString *)_iconString
{
    [self setTitle:_iconString forState:UIControlStateNormal];
    [self setTitle:_iconString forState:UIControlStateHighlighted];
}

- (void)setIconFont:(UIFont *)_iconFont
{
    [self.titleLabel setFont:_iconFont];
}

- (void)setBorder
{
    [self.layer setBorderColor:GRAYLIGHTCOLOR.CGColor];
    [self.layer setBorderWidth:0.5f];
}

- (void)setRounded
{
    [self.layer setCornerRadius:self.frame.size.height/2];
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
