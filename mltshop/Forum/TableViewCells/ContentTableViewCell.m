//
//  ContentTableViewCell.m
//  mltshop
//
//  Created by 小新 on 15/4/18.
//  Copyright (c) 2015年 manluotuo. All rights reserved.
//

#import "ContentTableViewCell.h"
#import <SDWebImage/UIButton+WebCache.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "ForumDetailModel.h"
#import "emojis.h"
#import "NSString+TimeString.h"
#import "Appdelegate.h"
@interface ContentTableViewCell()


/** 时间 */
@property (nonatomic, strong) UILabel *timeLable;
/** 标题 */
@property (nonatomic, strong) UILabel *titleLable;
/** 内容 */
@property (nonatomic, strong) UILabel *contentLable;

@end

@implementation ContentTableViewCell {
    CGFloat imagePhotoY;
    CGFloat imagePhotoW;
    CGFloat imagePhotoH;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self initCellView];
    }
    return self;
}

- (void)initCellView {
    
    self.userBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.userBtn setFrame:CGRectMake(H_10, H_10, H_40, H_40)];
    self.userBtn.userInteractionEnabled = YES;
    [self.userBtn addTarget:self action:@selector(onUserBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.userBtn];
    
    self.userLable = [[UILabel alloc] initWithFrame:CGRectMake(self.userBtn.x+self.userBtn.width+H_10, H_15, H_100, H_10)];
    [self.userLable setTextColor:BlACKCOLOR];
    [self.userLable setFont:FONT_12];
    [self addSubview:self.userLable];
    
    self.timeLable = [[UILabel alloc] initWithFrame:CGRectMake(self.userLable.x, self.userBtn.y+self.userBtn.height-H_15, WIDTH, H_10)];
    [self.timeLable setTextColor:GRAYLIGHTCOLOR];
    [self.timeLable setFont:FONT_12];
    [self addSubview:self.timeLable];
    
    self.titleLable = [[UILabel alloc] initWithFrame:CGRectMake(self.userBtn.x, self.userBtn.y+self.userBtn.height+H_10, WIDTH-self.userBtn.x*2, H_20)];
    [self.titleLable setFont:[UIFont boldSystemFontOfSize:H_15]];
    [self.titleLable setNumberOfLines:0];
    [self addSubview:self.titleLable];
    
    self.contentLable = [[UILabel alloc] initWithFrame:CGRectMake(self.userBtn.x, self.titleLable.y+self.titleLable.height+H_10, self.titleLable.width, H_10)];
    [self.contentLable setFont:FONT_13];
    [self addSubview:self.contentLable];
}

- (void)setNewData:(ForumDetailModel *)data {
    [self.userBtn sd_setBackgroundImageWithURL:[NSURL URLWithString:data.headerimg] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"logo_luotuo"]];
    self.userLable.text = data.nickname;
    self.timeLable.text = [NSString stringTimeDescribeFromTimeString:data.time];
    self.titleLable.text = [data.text emojizedString];
    CGSize titleSize = [(NSString *)data.text sizeWithWidth:WIDTH-H_20 andFont:FONT_15];
    self.titleLable.height = titleSize.height;
    NSLog(@"Y = %f, H = %f", self.titleLable.y, self.titleLable.height);
    NSArray *array = [self setImageNumber:data];
    CGFloat imageX = 10;
    CGFloat imageY = self.titleLable.y+self.titleLable.height+10;
    CGFloat imageW = WIDTH - 20;
    CGFloat imageH = WIDTH;
    imagePhotoY = self.titleLable.y+self.titleLable.height+10;
    for (NSInteger i = 1; i <= array.count; i++) {
        UIImageView *imagePhoto = [[UIImageView alloc] initWithFrame:CGRectMake(imageX, imageY+((i-1)*(imageH + 10)), imageW, imageH)];
        UITapGestureRecognizer *photoTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onPhotoTap:)];
        imagePhoto.tag = i;
        imagePhoto.userInteractionEnabled = YES;
        [imagePhoto addGestureRecognizer:photoTap];
        [self addSubview:imagePhoto];
        [imagePhoto sd_setImageWithURL:[NSURL URLWithString:array[i-1]] placeholderImage:[UIImage imageNamed:@"defPic"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            
            if (i > 1) {
                imagePhotoY += imagePhotoH+10;
            }
            
            if (image.size.width > image.size.height) {
                if (image.size.width > WIDTH - 10) {
                    imagePhotoW = WIDTH-20;
                    imagePhotoH = image.size.height*((WIDTH-20)/image.size.width);
                    if (imagePhotoH < 0) {
                        imagePhotoH = imagePhotoH*(-1);
                    }
                } else {
                    imagePhotoW = image.size.width;
                    imagePhotoH = image.size.height;
                }
            } else {
                if (image.size.width > WIDTH - 10) {
                    imagePhotoW = WIDTH-20;
                    imagePhotoH = image.size.height*((WIDTH-20)/image.size.width);
                    if (imagePhotoH < 0) {
                        imagePhotoH = imagePhotoH*(-1);
                    }
                } else {
                    imagePhotoW = image.size.width;
                    imagePhotoH = image.size.height;
                }
            }

            NSLog(@"Y = %f", imagePhotoY);
            NSLog(@"W = %f", imagePhotoW);
            NSLog(@"H = %f", imagePhotoH);
            NSLog(@"%f, %f", image.size.width, image.size.height);
        }];
        [imagePhoto setFrame:CGRectMake(imageX, imagePhotoY, imagePhotoW, imagePhotoH)];
    }
    
    _userId = data.userid;
}


- (void)onPhotoTap:(UITapGestureRecognizer *)sender {
    NSLog(@"%d", sender.view.tag);
}

- (NSArray *)setImageNumber:(NSObject *)data {
    NSMutableArray *array = [[NSMutableArray alloc] init];
    ForumDetailModel *model = (ForumDetailModel *)data;
    NSLog(@"%@", model.image1);
    if ([DataTrans noNullString:model.image1]) {
        [array addObject:model.image1];
    }
    if ([DataTrans noNullString:model.image2]) {
        [array addObject:model.image2];
    }
    if ([DataTrans noNullString:model.image3]) {
        [array addObject:model.image3];
    }
    if ([DataTrans noNullString:model.image4]) {
        [array addObject:model.image4];
    }
    if ([DataTrans noNullString:model.image5]) {
        [array addObject:model.image5];
    }
    if ([DataTrans noNullString:model.image6]) {
        [array addObject:model.image6];
    }
    if ([DataTrans noNullString:model.image7]) {
        [array addObject:model.image7];
    }
    if ([DataTrans noNullString:model.image8]) {
        [array addObject:model.image8];
    }
    if ([DataTrans noNullString:model.image9]) {
        [array addObject:model.image9];
    }
    return [NSArray arrayWithArray:array];
}

- (void)onUserBtnClick {
    if ([_delegate respondsToSelector:@selector(contentTableViewCellIconDidClick:)]) {
        [_delegate contentTableViewCellIconDidClick:self];
    }
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
