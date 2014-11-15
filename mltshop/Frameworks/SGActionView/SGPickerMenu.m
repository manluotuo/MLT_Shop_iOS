//
//  SGPickerMenu.m
//  merchant
//
//  Created by mactive.meng on 10/6/14.
//  Copyright (c) 2014 kkche. All rights reserved.
//

#import "SGPickerMenu.h"
#import "CDatePickerViewEx.h"
@interface SGPickerMenu()
@property(nonatomic, strong)CDatePickerViewEx *datePicker;
@property(nonatomic, strong)UILabel *titleLabel;
@property(nonatomic, strong)SGButton *doneDateButton;
@property(nonatomic, strong)UIScrollView *contentScrollView;
@property(nonatomic, strong) void (^actionHandle)(NSDate *);

@end

#define kMAX_CONTENT_SCROLLVIEW_HEIGHT   400
#define kPICKER_HEIGHT   220


@implementation SGPickerMenu
@synthesize datePicker;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = BaseMenuBackgroundColor(self.style);

        _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.font = [UIFont boldSystemFontOfSize:17];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor = BaseMenuTextColor(self.style);
        [self addSubview:_titleLabel];
        
        _contentScrollView = [[UIScrollView alloc]initWithFrame:CGRectZero];
        _contentScrollView.contentSize = _contentScrollView.bounds.size;
        _contentScrollView.showsHorizontalScrollIndicator = NO;
        _contentScrollView.showsVerticalScrollIndicator = YES;
        _contentScrollView.backgroundColor = [UIColor clearColor];
        [self addSubview:_contentScrollView];
        
        // Initialization code
        _doneDateButton = [SGButton buttonWithType:UIButtonTypeCustom];
        _doneDateButton.clipsToBounds = YES;
        _doneDateButton.titleLabel.font = [UIFont systemFontOfSize:17];
        [_doneDateButton setTitleColor:BaseMenuTextColor(self.style) forState:UIControlStateNormal];
        [_doneDateButton addTarget:self
                          action:@selector(tapAction:)
                forControlEvents:UIControlEventTouchUpInside];
        [_doneDateButton setTitle:@"完   成" forState:UIControlStateNormal];
        [self addSubview:_doneDateButton];
        
        self.datePicker = [[CDatePickerViewEx alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, kPICKER_HEIGHT)];
        [self.datePicker setBackgroundColor:WHITECOLOR];
        [_contentScrollView addSubview:self.datePicker];
    }
    return self;
}

-(id)initWithTitle:(NSString *)title pickerMode:(UIDatePickerMode)pickerMode date:(NSDate *)theDate
{
    self = [self initWithFrame:[[UIScreen mainScreen] bounds]];
    
    if (self) {
        _titleLabel.text = title;
        [self.datePicker selectDay:theDate];
//        self.datePicker.datePickerMode = pickerMode;
    }
    return self;
}

- (void)setStyle:(SGActionViewStyle)style{
    _style = style;
    
    self.backgroundColor = BaseMenuBackgroundColor(style);
    self.titleLabel.textColor = BaseMenuTextColor(style);
    [self.doneDateButton setTitleColor:BaseMenuActionTextColor(style) forState:UIControlStateNormal];
}

- (void)triggerSelectedAction:(void(^)(NSDate *))actionHandle
{
    self.actionHandle = actionHandle;
}

- (void)tapAction:(SGButton *)sender
{
    if (self.actionHandle) {
        self.actionHandle(self.datePicker.date);
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.titleLabel.frame = (CGRect){CGPointZero, CGSizeMake(self.bounds.size.width, 40)};
    
    UIEdgeInsets margin = UIEdgeInsetsMake(0, 0, 10, 0);
    
    self.contentScrollView.contentSize = CGSizeMake(self.bounds.size.width, kPICKER_HEIGHT + margin.top + margin.bottom);
    

    if (self.contentScrollView.contentSize.height > kMAX_CONTENT_SCROLLVIEW_HEIGHT) {
        self.contentScrollView.bounds = (CGRect){CGPointZero, CGSizeMake(self.bounds.size.width, kMAX_CONTENT_SCROLLVIEW_HEIGHT)};
    }else{
        self.contentScrollView.bounds = (CGRect){CGPointZero, self.contentScrollView.contentSize};
    }
    
    self.contentScrollView.center = CGPointMake(self.contentScrollView.bounds.size.width/2, self.contentScrollView.bounds.size.height/2+self.titleLabel.bounds.size.height);


    
    self.doneDateButton.frame = CGRectMake(self.bounds.size.width*0.05, self.titleLabel.bounds.size.height + self.contentScrollView.bounds.size.height, self.bounds.size.width*0.9, 44);
    
    self.bounds = (CGRect){CGPointZero, CGSizeMake(self.bounds.size.width, self.titleLabel.bounds.size.height + self.contentScrollView.bounds.size.height + self.doneDateButton.bounds.size.height + H_10)};
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
