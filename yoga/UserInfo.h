//
//  UserInfo.h
//  yoga
//
//  Created by renxlin on 14-7-13.
//  Copyright (c) 2014年 任小林. All rights reserved.
//  保存用户信息：

#import <Foundation/Foundation.h>

@interface UserInfo : NSObject

@property (nonatomic,strong) NSMutableDictionary *userDict;
@property(strong,nonatomic)NSString *userName;
@property(strong,nonatomic)NSString *token;
@property(strong,nonatomic)NSString *onliePeople;


+(id)shareUserInfo;
@end
