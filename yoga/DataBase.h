//
//  yoga.h
//
//  Created by renxlin on 15-2-1.
//  Copyright (c) 2014年 任小林. All rights reserved.

#import <Foundation/Foundation.h>
#import "FMDatabase.h"
#import "CurrentProgram.h"
#import "SC_Model.h"


@interface DataBase : NSObject


+(DataBase *)sharedDataBase;

+(DataBase *)newDataBase;

-(void)createDataBase;

-(BOOL)createTableWithObject:(id)obj andTableName:(NSString *)tableName;
-(void)insertWithObject:(id)obj inTable:(NSString *)tableName;
-(void)deleteTable:(NSString *)tableName withCondition:(NSString *)conditonName andConditionData:(NSString *)conditionData;
-(void)updateWithObject:(id)obj inTable:(NSString *)tableName withCondition:(NSString *)conditionStr andConditionData:(NSString *)conditionData;
-(NSDictionary *)selectTable:(NSString *)tableName saveClass:(Class)aClass withCondition:(NSString *)conditionStr andConditionData:(NSString *)conditionData;

-(void)dropTable:(NSString *)tableName;



//通过字段名查询数据库某一表的某一列的某一字段：
-(NSString *)selectTable:(NSString *)tableName whichSeg:(NSString *)seg useSeg:(NSString *)useg useData:(NSString *)data;

//查询表的所有项；
-(NSArray *)selectAllItemInTable:(NSString *)tableName WithClass:(Class)aclas;

-(void)deleteTable:(NSString *)tableName;




/////////////////
-(void)setCurrentProgrem:(NSString *)tableName andObj:(CurrentProgram *)pro;
-(void)setCurProgram_avTv:(NSString *)tableName andObj:(SC_Model *)pro;



@end





