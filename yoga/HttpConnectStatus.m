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
    if (![[Reachability reachabilityForInternetConnection] isReachableViaWWAN] && ![[Reachability reachabilityForInternetConnection] isReachableViaWiFi]) {
        return NO;
    }
    return YES;;
}



@end
