//
//  FaceIconView.m
//  NSStringEmojize
//
//  Created by 小新 on 15/4/11.
//  Copyright (c) 2015年 DIY. All rights reserved.
//

#import "FaceIconView.h"
#import "emojis.h"

#define VIEW_WIDTH [[UIScreen mainScreen] bounds].size.width

@interface FaceIconView()<UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) NSArray *faceArray;
@property (nonatomic, strong) UIView *view;

@end

@implementation FaceIconView {
    NSInteger count;
    NSInteger num;
}

- (void)initView {
    count = 0;
    self.userInteractionEnabled = YES;
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"FaceIcon"
                                                          ofType:@"plist"];
    self.faceArray = [[NSArray arrayWithContentsOfFile:plistPath] copy];
    
    num = [self.faceArray count];
    self.scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
//    self.scrollView.frame.size = CGSizeMake(self.scrollView.frame.size.width, VIEW_WIDTH/7-10);
    self.scrollView.delegate = self;
    self.scrollView.contentSize = CGSizeMake(VIEW_WIDTH*(num/21+1), self.frame.size.height);
    self.scrollView.pagingEnabled = YES;
    for (NSInteger i = 0; i < num/21+1; i++) {
        self.view = [[UIView alloc] initWithFrame:CGRectMake(VIEW_WIDTH*i, 0, VIEW_WIDTH, self.frame.size.height)];
        [self loadSize:CGSizeMake(VIEW_WIDTH/7-10, VIEW_WIDTH/7-10)];
        [self.scrollView addSubview:self.view];
    }
    [self addSubview:self.scrollView];
}

-(void)loadSize:(CGSize)size
{
    //row number
    for (int i = 0; i < 3; i++) {
        for (int y = 0; y < 7; y++) {
            if (count == num) {
                i = 2;
                y = 6;
                UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
                [button setFrame:CGRectMake(5+y*(size.width+10), 5+i*size.height, size.width, size.height)];
                [button setImage:[UIImage imageNamed:@"faceDelete"] forState:UIControlStateNormal];
                button.tag=10000;
                [button addTarget:self action:@selector(selected:) forControlEvents:UIControlEventTouchUpInside];
                [self.view addSubview:button];
                return;
            }
            UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
            [button setFrame:CGRectMake(5+y*(size.width+10), 5+i*size.height, size.width, size.height)];
            if (i == 2 && y == 6) {
                [button setImage:[UIImage imageNamed:@"faceDelete"] forState:UIControlStateNormal];
                button.tag=10000;
            } else {
                [button.titleLabel setFont:[UIFont fontWithName:@"AppleColorEmoji" size:29.0]];
                [button setTitle: [self.faceArray[count] emojizedString] forState:UIControlStateNormal];
                button.tag=count+5000;
            }
            [button addTarget:self action:@selector(selected:) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:button];
            count++;
        }
    }
}


-(void)selected:(UIButton*)bt
{
    if (bt.tag==10000) {
        [self.delegate selectedFacialView:@"delete"];
    }else{
        if (self.delegate) {
            [self.delegate selectedFacialView:self.faceArray[bt.tag-5000]];
        }
    }
}


@end
