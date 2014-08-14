//
//  AppDelegate.h
//  yoga
//
//  Created by renxlin on 14-7-10.
//  Copyright (c) 2014年 任小林. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PayViewController;
@interface AppDelegate : UIResponder <UIApplicationDelegate,UIScrollViewDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic,strong) NSMutableDictionary *userDict;

@property (strong, nonatomic) PayViewController *payViewController;
@end
