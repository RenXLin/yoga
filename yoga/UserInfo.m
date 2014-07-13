//
//  UserInfo.m
//  yoga
//
//  Created by renxlin on 14-7-13.
//  Copyright (c) 2014年 任小林. All rights reserved.
//

#import "UserInfo.h"

static UserInfo *_shareUserInfo;


@implementation UserInfo

+(id)shareUserInfo
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _shareUserInfo = [[UserInfo alloc] init];
    });
    return _shareUserInfo;
}


@end
