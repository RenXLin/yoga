//
//  HelpClass.m
//  yoga
//
//  Created by renxlin on 14-7-13.
//  Copyright (c) 2014年 任小林. All rights reserved.
//

#import "HelpClass.h"
#import "AFNetworking.h"

@implementation HelpClass


-(NSNumber *)getOnliePeople
{
    __block NSNumber *peopleNum;
    AFHTTPRequestOperationManager *ma = [AFHTTPRequestOperationManager manager];
    [ma GET:GETOnliePeople parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        peopleNum = [[responseObject objectForKey:@"data"] objectForKey:@"count"];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    }];
    return peopleNum;
}


@end
