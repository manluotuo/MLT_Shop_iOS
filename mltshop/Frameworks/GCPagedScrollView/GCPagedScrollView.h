//
//  GCPagedScrollView.h
//  GCLibrary
//
//  Created by Guillaume Campagna on 10-11-10.
//  Copyright (c) 2010 LittleKiwi. All rights reserved.
//

#import <UIKit/UIKit.h>
//Simple UIScrollView subclass that automatically handle UIPageControl and paged content
@interface GCPagedScrollView : UIScrollView

@property (nonatomic, assign) NSUInteger page; //Zero based number of page
@property (nonatomic, readonly) NSMutableArray* views;
@property (nonatomic, weak) id<PassValueDelegate> passDelegate;

- (id)initWithFrame:(CGRect)frame andPageControl:(BOOL)showPageControl;

- (void) setPage:(NSUInteger)page animated:(BOOL) animated;

//Add or remove content view from the scrollview
- (void) addContentSubview:(UIView*) view;
- (void) addContentSubview:(UIView*) view atIndex:(NSUInteger) index;
- (void) addContentSubviewsFromArray:(NSArray*) contentViews;

- (void) removeContentSubview:(UIView*) view;
- (void) removeContentSubviewAtIndex:(NSUInteger) index;
- (void) removeAllContentSubviews;

/** 关闭定时器 */
- (void) stopTimer;
/** 开启定时器 */
- (void) starTimer;
/** 销毁定时器 */
- (void)disMissTimer;
/** 创建定时器 */
- (void)createTimer;

@end
