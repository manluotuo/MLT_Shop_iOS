//
//  ZBarScanViewController.h
//  merchant
//
//  Created by mactive.meng on 30/7/14.
//  Copyright (c) 2014 kkche. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZBarSDK.h"
#import "PassValueDelegate.h"
@interface ZBarScanViewController : KKViewController<ZBarReaderViewDelegate>
@property(nonatomic, strong)ZBarReaderView * reader;
@property(nonatomic,assign) NSObject<PassValueDelegate> *passDelegate;

@end
