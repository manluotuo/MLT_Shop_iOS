//
//  KKFlatButton.m
//  merchant
//
//  Created by mactive.meng on 5/5/14.
//  Copyright (c) 2014 kkche. All rights reserved.
//

#import "KKFlatButton.h"

@implementation KKFlatButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setBackgroundColor:GREENCOLOR];
        [self.titleLabel setFont:FONT_16];
        [self setTitleColor:WHITECOLOR forState:UIControlStateNormal];
        [self.layer setCornerRadius:H_5];
        [self.layer setMasksToBounds:YES];
        
//        UIImage *highlightBG = [KKFlatButton imageWithColor:DARKGREENCOLOR size:frame.size];
//        [self setBackgroundImage:highlightBG forState:UIControlStateSelected];


    }
    return self;
}

- (void)setEnabled:(BOOL)enabled
{
    if (self.buttonStyle == KKFlatButtonStyleLight) {
        if (enabled == NO) {
            [self setBackgroundColor:GRAYEXLIGHTCOLOR];
        }else{
            [self setBackgroundColor:WHITECOLOR];
        }
    }else if (self.buttonStyle == KKFlatButtonStyleColored){
        if (enabled == NO) {
            [self setBackgroundColor:GRAYLIGHTCOLOR];
        }else{
            [self setBackgroundColor:GREENCOLOR];
        }
    }else{
        if (enabled == NO) {
            [self setBackgroundColor:GRAYLIGHTCOLOR];
        }else{
            [self setBackgroundColor:WHITECOLOR];
        }
    }
}

- (void)setTitleColor:(UIColor *)color andStyle:(KKFlatButtonStyle)style;
{
    self.buttonStyle = style;
    if (style == KKFlatButtonStyleLight) {
        [self setTitleColor:color forState:UIControlStateNormal];
        [self setTitleColor:color forState:UIControlStateHighlighted];
        self.backgroundColor = WHITECOLOR;
    }else if (style == KKFlatButtonStyleColored) {
        [self setTitleColor:WHITECOLOR forState:UIControlStateNormal];
        [self setTitleColor:WHITECOLOR forState:UIControlStateHighlighted];
        self.backgroundColor = color;
    }else if (style == KKFlatButtonStyleGray){
        [self setTitleColor:color forState:UIControlStateNormal];
        [self setTitleColor:color forState:UIControlStateHighlighted];
        self.backgroundColor = GRAYLIGHTCOLOR;
    }else{
        [self setTitleColor:color forState:UIControlStateNormal];
        [self setTitleColor:color forState:UIControlStateHighlighted];
        self.backgroundColor = WHITECOLOR;
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
