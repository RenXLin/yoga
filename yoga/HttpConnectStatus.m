//
//  HttpConnectStatus.m
//  yoga
//
//  Created by renxlin on 14-8-28.
//  Copyright (c) 2014年 任小林. All rights reserved.
//

#import "HttpConnectStatus.h"
#import "Reachability.h"



@implementation HttpConnectStatus


+(BOOL)isConnectToInitnet
{
    Reachability *reach = [Reachability reachabilityWithHostName:@"http://www.baidu.com"];
    if ([reach currentReachabilityStatus] == NotReachable) {
        return  NO;
    }

    return YES;
}



@end
