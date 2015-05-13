//
//  ADAreaView.h
//  mltshop
//
//  Created by mactive.meng on 9/12/14.
//  Copyright (c) 2014 manluotuo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ADAreaView : UIView

- (void)initWithData:(NSDictionary *)oneArea;
@property (nonatomic, weak) id<PassValueDelegate> passDelegate;

@end


@interface ADAreaOnlyView : UIButton
- (void) initWithItemData:(NSDictionary *)item;
@end

@interface ADAreaOneHeightView : UIButton

- (void)initWithItemData:(NSDictionary *)item;

@end

@interface ADAreaHalfHeightView : UIButton

- (void)initWithItemData:(NSDictionary *)item andPositon:(NSString *)position;

@end