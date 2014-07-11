//
//  AppDelegate.m
//  yoga
//
//  Created by renxlin on 14-7-10.
//  Copyright (c) 2014年 任小林. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate
{
    UIScrollView * launchScrollView;
    UIPageControl *pageControl;
}
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    //判断是否首次启动
    NSUserDefaults *usrDef = [NSUserDefaults standardUserDefaults];
    BOOL isFirst = [usrDef boolForKey:@"isFirst"];
    if (!isFirst) {
        NSLog(@"第一次启动应用");
        [usrDef setBool:YES forKey:@"isFirst"];
        [usrDef synchronize];
    //加入引导界面
        launchScrollView = [[UIScrollView alloc] init];
        launchScrollView.frame = [UIScreen mainScreen].bounds;
        launchScrollView.contentSize = CGSizeMake(3*[UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
        launchScrollView.pagingEnabled = YES;
        launchScrollView.bounces = NO;
        launchScrollView.delegate = self;
        [self.window addSubview:launchScrollView];

        for (int i = 0; i < 3; i++) {
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(i * [UIScreen mainScreen].bounds.size.width, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
            imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"start0%d_480x800.jpg",i+1]];
            [launchScrollView addSubview:imageView];
        }
        pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/3, [UIScreen mainScreen].bounds.size.height * 4/5, [UIScreen mainScreen].bounds.size.width/3, 20)];
        pageControl.numberOfPages = 3;
        pageControl.currentPage = 0;
        [pageControl addTarget:self action:@selector(pageTurn:) forControlEvents:UIControlEventValueChanged];
        [self.window addSubview:pageControl];
    }

    
    
    
    
    
    
    
    
    self.window.backgroundColor = [UIColor redColor];
    [self.window makeKeyAndVisible];
    return YES;
}
-(void)pageTurn:(UIPageControl *)pageCotr
{
    [launchScrollView setContentOffset:CGPointMake(pageCotr.currentPage * launchScrollView.frame.size.width, 0)];
}
- (void)scrollViewDidScroll:(UIScrollView *)sender {
    
    int page = sender.contentOffset.x / [UIScreen mainScreen].bounds.size.width;
    
    pageControl.currentPage = page;
    
}


- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
