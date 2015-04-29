//
//  PhotoScrollView.m
//  mltshop
//
//  Created by 小新 on 15/4/23.
//  Copyright (c) 2015年 manluotuo. All rights reserved.
//

#import "PhotoScrollView.h"
#import "ZLPhoto.h"
#import "ZLPhotoAssets.h"

@interface PhotoScrollView()

@property (nonatomic, strong) UIScrollView *scrollView;

@end

@implementation PhotoScrollView

- (void)initData:(NSArray *)array {
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    UIImageView *backImage = [[UIImageView alloc] initWithFrame:self.bounds];
    [backImage setImage:[UIImage imageNamed:@"bg_im_chat_face_bar"]];
    [self addSubview:backImage];
    if (array.count < 3) {
        if (array.count == 2) {
            self.scrollView.contentSize = CGSizeMake(WIDTH+H_100, H_160);
        } else {
            self.scrollView.contentSize = CGSizeMake(WIDTH+H_10, H_160);
        }
    } else {
        self.scrollView.contentSize = CGSizeMake(array.count * 140 + 140, H_160);
    }
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    
    [self addSubview:self.scrollView];
    for (NSInteger i = 0; i <= array.count; i++) {
        UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(20+(140*i), 10, 130, 130)];
        image.userInteractionEnabled = YES;
        image.contentMode = UIViewContentModeScaleAspectFit;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onTap:)];
        [image addGestureRecognizer:tap];
        if (i == array.count) {
            image.tag = 100;
            [image setImage:[UIImage imageNamed:@"btn_add_photo_n"]];
        } else {
            image.tag = i;
            [image setImage:[array[i] thumbImage]];
        }
        [self.scrollView addSubview:image];
    }
}

- (void)onTap:(UITapGestureRecognizer *)sender {
    if (sender.view.tag == 100) {
        [self.passDelegate passSignalValue:ON_ADD_BTN andData:[NSNumber numberWithInteger:sender.view.tag]];
    } else {
        [self.passDelegate passSignalValue:ON_DELETE_BTN andData:[NSNumber numberWithBool:sender.view.tag]];
    }
}

@end
