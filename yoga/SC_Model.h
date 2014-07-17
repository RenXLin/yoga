//
//  SC_Model.h
//  yoga
//
//  Created by cao on 14-7-13.
//  Copyright (c) 2014年 任小林. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SC_Model : NSObject
@property (nonatomic,copy) NSString *ad;
@property (nonatomic,copy) NSString *aid;
@property (nonatomic,copy) NSString *cid;
@property (nonatomic,copy) NSString *path;
@property (nonatomic,copy) NSString *pubdate;
@property (nonatomic,copy) NSString *sort;
@property (nonatomic,copy) NSString *timelength;
@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *content;
@property (nonatomic,copy) NSString *price;
@property (nonatomic,copy) NSString *vid;




@property (nonatomic,copy) NSString *clevel;
@property (nonatomic,copy) NSString *cname;
@property (nonatomic,copy) NSString *corder;
@property (nonatomic,copy) NSString *Id;
@property (nonatomic,copy) NSString *pid;

-(void)setValue:(id)value forUndefinedKey:(NSString *)key;
@end
