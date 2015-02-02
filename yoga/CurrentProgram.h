//
//  CurrentProgram.h
//  yoga
//
//  Created by renxlin on 14-7-14.
//  Copyright (c) 2014年 任小林. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CurrentProgram : NSObject


@property(nonatomic,strong)NSString *ad;
@property(nonatomic,strong)NSString *content;
@property(nonatomic,strong)NSString *fid;
@property(nonatomic,strong)NSString *fiid;

@property(nonatomic,strong)NSString *path;
@property(nonatomic,strong)NSString *startTime;
@property(nonatomic,strong)NSString *timelength;
@property(nonatomic,strong)NSString *title;


@property(nonatomic,strong)NSString* progress;

-(void)setValue:(id)value forUndefinedKey:(NSString *)key;



@end
