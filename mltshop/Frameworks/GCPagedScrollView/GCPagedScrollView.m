//
//  GCPagedScrollView.m
//  GCLibrary
//
//  Created by Guillaume Campagna on 10-11-10.
//  Copyright (c) 2010 LittleKiwi. All rights reserved.
//

#import "GCPagedScrollView.h"
#import <QuartzCore/CATransaction.h>
#import "StyledPageControl.h"

NSString * const GCPagedScrollViewContentOffsetKey = @"contentOffset";
const CGFloat GCPagedScrollViewPageControlHeight = 24.0;

@interface GCPagedScrollView ()

@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) StyledPageControl *pageControl;

- (void) updateViewPositionAndPageControl;

- (void) changePage:(UIPageControl*) aPageControl;

@end

@implementation GCPagedScrollView {
    CGPoint _offSet;
}


@synthesize views;
@synthesize pageControl;

#pragma mark -
#pragma mark Subclass

- (id)initWithFrame:(CGRect)frame andPageControl:(BOOL)showPageControl {
    if ((self = [super initWithFrame:frame])) {
        self.pagingEnabled = YES;
        self.showsVerticalScrollIndicator = NO;
        self.showsHorizontalScrollIndicator = NO;
        self.scrollsToTop = NO;
        
        
        if (showPageControl) {
            self.pageControl = [[StyledPageControl alloc]initWithFrame:CGRectZero];
            [self.pageControl setFrame:CGRectMake(20,(self.frame.size.height-20)/2,self.frame.size.width-40,20)];
            //        [aPageControl addTarget:self action:@selector(changePage:) forControlEvents:UIControlEventValueChanged];
            [self.pageControl setPageControlStyle:PageControlStyleDefault];
            [self.pageControl setCoreNormalColor:GRAYLIGHTCOLOR];
            [self.pageControl setStrokeSelectedColor:WHITEALPHACOLOR2];
            [self.pageControl setCoreSelectedColor:WHITEALPHACOLOR2];
            [self.pageControl setStrokeNormalColor:WHITEALPHACOLOR2];
            [self.pageControl setUserInteractionEnabled:NO];
            [self addSubview:self.pageControl];
        }
        

        
    }
    return self;
}

- (void) setPagingEnabled:(BOOL) pagingEnabled {
    if (pagingEnabled) [super setPagingEnabled:pagingEnabled];
    else {
        [NSException raise:@"Disabling pagingEnabled" format:@"Paging enabled should not be disabled in GCPagedScrollView"];
    }
}

#pragma mark -
#pragma mark Add/Remove content

- (void) addContentSubview:(UIView *)view {
    [self addContentSubview:view atIndex:[self.views count]];
}

- (void) addContentSubview:(UIView *)view atIndex:(NSUInteger)index {
    [self insertSubview:view atIndex:index];
    [self.views insertObject:view atIndex:index];
    [self updateViewPositionAndPageControl];
    self.contentOffset = CGPointMake(0, - self.scrollIndicatorInsets.top);
}

- (void)addContentSubviewsFromArray:(NSArray *)contentViews {
    for (UIView* contentView in contentViews) {
        [self addContentSubview:contentView];
    }
}

- (void) removeContentSubview:(UIView *)view {
    [view removeFromSuperview];
    
    [self.views removeObject:view];
    [self updateViewPositionAndPageControl];
}

- (void)removeContentSubviewAtIndex:(NSUInteger)index {
    [self removeContentSubview:[self.views objectAtIndex:index]];
}

- (void) removeAllContentSubviews {
    for (UIView* view in self.views) {
        [view removeFromSuperview];
    }
    
    [self.views removeAllObjects];
    [self updateViewPositionAndPageControl];
}

#pragma mark -
#pragma mark Layout

- (void) updateViewPositionAndPageControl {
    [self.views enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        UIView* view = (UIView*) obj;
        view.center = CGPointMake(self.bounds.size.width * idx + self.bounds.size.width / 2,
                                  (self.frame.size.height - 0.0f ) / 2);
        //before 0.0f - GCPagedScrollViewPageControlHeight
    }];
    
    UIEdgeInsets inset = self.scrollIndicatorInsets;
    CGFloat heightInset = inset.top + inset.bottom;
    self.contentSize = CGSizeMake(self.bounds.size.width * [self.views count], self.bounds.size.height - heightInset);
    
    self.pageControl.numberOfPages = self.views.count;
}

- (void) layoutSubviews {
    [super layoutSubviews];
    
    //Avoid that the pageControl move
    [CATransaction begin];
    [CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
    
    CGRect frame = self.pageControl.frame;
    frame.origin.x = self.contentOffset.x;
    frame.origin.y = self.frame.size.height - GCPagedScrollViewPageControlHeight - self.scrollIndicatorInsets.bottom - self.scrollIndicatorInsets.top;
    frame.size.width = self.frame.size.width;
    self.pageControl.frame = frame;
    
    [CATransaction commit];
}

#pragma mark -
#pragma mark Getters/Setters

- (void) setFrame:(CGRect) newFrame {
    [super setFrame:newFrame];
    [self updateViewPositionAndPageControl];
}

- (void) changePage:(UIPageControl*) aPageControl {
    [self setPage:aPageControl.currentPage animated:YES];
}

- (void) setContentOffset:(CGPoint) new {
    new.y = -self.scrollIndicatorInsets.top;
    [super setContentOffset:new];
    
    self.pageControl.currentPage = self.page; //Update the page number
}

- (NSMutableArray*) views {
    if (views == nil) {
        views = [[NSMutableArray alloc] initWithCapacity:1];
    }
    return views;
}

- (NSUInteger) page {
    return (self.contentOffset.x + self.bounds.size.width / 2) / self.bounds.size.width;
//    return self.contentOffset.x / self.bounds.size.width;
}

- (void) setPage:(NSUInteger)page {
    [self setPage:page animated:NO];
}

- (void) setPage:(NSUInteger)page animated:(BOOL) animated {
    [self setContentOffset:CGPointMake(page * self.frame.size.width, - self.scrollIndicatorInsets.top) animated:animated];
}

#pragma mark - Timer
/** 关闭定时器 */
- (void)stopTimer {
    [self.timer setFireDate:[NSDate distantFuture]];
}

/** 创建定时器 */
- (void)createTimer {
    if (self.timer == nil) {
    self.timer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(timerClick) userInfo:nil repeats:YES];
    } else {
        return;
    }
}

/** 开启定时器 */
- (void) starTimer {
    if (self.timer != nil) {
        [self.timer setFireDate:[NSDate distantPast]];
    } else {
        return;
    }
}

/** 定时器触发 */
- (void)timerClick {
    
    _offSet = CGPointMake(self.contentOffset.x + WIDTH, self.contentOffset.y);
    if (self.contentOffset.x == 1280 ) {
        _offSet = CGPointMake(0, 0);
        [UIView animateWithDuration:0.15 animations:^{
            
            self.contentOffset = _offSet;
            
        } completion:^(BOOL finished) {
        }];
    } else {
        [UIView animateWithDuration:0.3 animations:^{
            
            self.contentOffset = _offSet;
            
        } completion:^(BOOL finished) {
        }];
    }
}

/** 销毁定时器 */
- (void)disMissTimer {
    [self.timer invalidate];
    self.timer = nil;
}


#pragma mark -
#pragma mark Dealloc



@end
