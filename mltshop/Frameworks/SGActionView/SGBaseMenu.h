//
//  SGBaseMenu.h
//  SGActionView
//
//  Created by Sagi on 13-9-18.
//  Copyright (c) 2013年 AzureLab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SGActionView.h"

#define BaseMenuBackgroundColor(style)  (style == SGActionViewStyleLight ? [UIColor colorWithWhite:1.0 alpha:1.0] : [UIColor colorWithWhite:0.2 alpha:1.0])
#define BaseMenuTextColor(style)        (style == SGActionViewStyleLight ? [UIColor darkTextColor] : [UIColor lightTextColor])
#define BaseMenuActionTextColor(style)  ([UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0])
#define TOP_ROUND_CORNER 0.0f
@interface SGButton : UIButton
@end

@interface SGBaseMenu : UIView{
    SGActionViewStyle _style;
}

// if rounded top left/right corner, default is YES.
@property (nonatomic, assign) BOOL roundedCorner;

@property (nonatomic, assign) SGActionViewStyle style;

@end
