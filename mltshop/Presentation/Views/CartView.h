//
//  CartView.h
//  
//
//  Created by Col on 15/5/11.
//
//

#import <UIKit/UIKit.h>
#import "GoodsModel.h"

@protocol catrViewDelegete <NSObject>
@optional
- (void)donebtnClick:(CartModel *)cartModel;

@end
@interface CartView : UIView
@property (nonatomic, weak)id<catrViewDelegete>delegete;
- (void) setData:(GoodsModel *)model;

@end
