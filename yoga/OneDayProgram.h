//
//  OneDayProgram.h
//  yoga
//
//  Created by renxlin on 14-7-29.
//  Copyright (c) 2014年 任小林. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OneDayProgram : NSObject

@property(nonatomic,strong)NSString *starttime;
@property(nonatomic,strong)NSString *timelength;
@property(nonatomic,strong)NSString *title;
@property(nonatomic,strong)NSString *ad;
@property(nonatomic,strong)NSString *content;

-(void)setValue:(id)value forUndefinedKey:(NSString *)key;

/*
ad = "\U4e2d\U56fd\U745c\U4f3d\U5728\U7ebf \U4e13\U4e1a\U7684\U745c\U4f3d\U89c6\U9891\U5b66\U4e60\U7f51\U7ad9 http://www.chinayogaonline.com";
content = "Yoganidra\U745c\U4f3d\U4f11\U606f\U672f";
fid = 1;
fiid = 78;
path = "yoganidra/yoganidra_T33.mp3";
starttime = "00:00:00";
timelength = 1800;
title = "Yoganidra\U745c\U4f3d\U4f11\U606f\U672f";
*/


@end
