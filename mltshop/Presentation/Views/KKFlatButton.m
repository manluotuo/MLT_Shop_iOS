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
        [self.titleLabel setFont:FONT_20];
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
    if (enabled == NO) {
        [self setBackgroundColor:GRAYCOLOR];
    }else{
        [self setBackgroundColor:GREENCOLOR];
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
