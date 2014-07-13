//
//  UserInfo.h
//  yoga
//
//  Created by renxlin on 14-7-13.
//  Copyright (c) 2014年 任小林. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserInfo : NSObject


@property(strong,nonatomic)NSString *userName;
@property(strong,nonatomic)NSString *token;

+(id)shareUserInfo;
@end
