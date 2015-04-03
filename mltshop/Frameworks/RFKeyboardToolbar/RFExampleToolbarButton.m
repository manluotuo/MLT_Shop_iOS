//
//  RFExampleToolbarButton.m
//
//  Created by Rudd Fawcett on 12/3/13.
//  Copyright (c) 2013 Rex Finn. All rights reserved.
//

#import "RFExampleToolbarButton.h"

@implementation RFExampleToolbarButton

- (NSString*)titleForButton {
    return @"完成";
}

- (void)buttonTarget {
    
    NSLog(@"按钮被点击");
    [[RFToolbarButton textField] resignFirstResponder];
    [[RFToolbarButton textView] resignFirstResponder];
}

@end
