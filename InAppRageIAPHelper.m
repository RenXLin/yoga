//
//  InAppRageIAPHelper.m
//  InAppRage
//
//  Created by Ray Wenderlich on 2/28/11.
//  Copyright 2011 Ray Wenderlich. All rights reserved.
//

#import "InAppRageIAPHelper.h"

@implementation InAppRageIAPHelper
{
    NSArray *arr;
}

static InAppRageIAPHelper * _sharedHelper;

+ (InAppRageIAPHelper *) sharedHelper { //非线程安全
    
    if (_sharedHelper != nil) {
        return _sharedHelper;
    }
    _sharedHelper = [[InAppRageIAPHelper alloc] init];
    return _sharedHelper;
    
}

- (id)init {  //产品标识  可采用动态获取（服务器）
    
    NSLog(@"--------");

    if ((self = [super init])) {
        
        if(arr.count==0)
        {
          [self request1];  
        }
        
        
//        NSLog(@"%@",productIdentifiers);
    }
    return self;
    
}
/*  每次进入支付界面从我们本地的服务器获取产品标识（就是在添加产品的时候，设定的标识，拿到这些标识，才可以从苹果服务器获取产品信息，例如价格、描述...等，也就是说，在添加完产品的时候，要顺便把这些标识添加在自己服务器） */
- (void)request1
{
    NSString *urlString = @"http://www.chinayogaonline.com/api/IAPProductId";
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes=[NSSet setWithObject:@"text/html"];
    [manager GET:urlString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSLog(@"%@",responseObject);
         if (responseObject != nil)
         {
             if ([responseObject isKindOfClass:[NSDictionary class]])
             {
                 NSDictionary * dict=[NSDictionary dictionaryWithDictionary:responseObject];
                 if([[dict valueForKey:@"code"]intValue]==200) //请求成功
                 {
                     arr = [dict objectForKey:@"data"];
                     NSSet *productIdentifiers = [NSSet setWithArray:arr];
                     [self initWithProductIdentifiers:productIdentifiers];
                     
                 }
                 
                 
             }
         }
         
         
     }
         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             KAlert(@"请求失败");
             
         } ];
    
}


@end
