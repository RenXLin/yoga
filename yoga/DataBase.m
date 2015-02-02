//
//  yoga.m
//
//  Created by renxlin on 15-2-1.
//  Copyright (c) 2014年 任小林. All rights reserved.


#import "DataBase.h"
#import "objc/runtime.h"


static DataBase *_sharedDataBase;

@implementation DataBase
{
    FMDatabase *_database;
    NSLock *sqlLock;
}

+(DataBase *)sharedDataBase
{
    if(!_sharedDataBase){
        _sharedDataBase = [[DataBase alloc] init];
    }

    return _sharedDataBase;
}

+(DataBase *)newDataBase
{
    DataBase *newDB = [[DataBase alloc] init];
    return newDB;
}

-(id)init
{
    self = [super init];
    if (self) {
        sqlLock = [[NSLock alloc] init];
    }
    return self;
}


-(void)createDataBase
{
    [sqlLock lock];
    
    NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"/Library/Caches/DB.db"];

    _database = [[FMDatabase alloc] initWithPath:path];

    if([_database open])
    {
        NSLog(@"数据库创建成功！！");
        [_database close];
    }else{
        NSLog(@"数据库创建失败！！");
    }
    
    [sqlLock unlock];
}


//********************************************************************************
-(BOOL)createTableWithObject:(id)obj andTableName:(NSString *)tableName
{
    [sqlLock lock];

    NSArray * keys = [self getPropertiesFromObj:obj];

    NSMutableString *sql = [NSMutableString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (",tableName];

    for (NSString * key in keys) {
        [sql appendFormat:@"%@ text,",key];
    }

    [sql deleteCharactersInRange:NSMakeRange(sql.length-1, 1)];
    [sql appendFormat:@")"];

    [_database open];
    if([_database executeUpdate:sql]){
        [_database close];
        
        [sqlLock unlock];
        return YES;
    }
    [_database close];
    
    [sqlLock unlock];
    return NO;
}

//删除表：
-(void)deleteTable:(NSString *)tableName
{
    [sqlLock lock];

    [_database open];
    NSString *sql = [NSString stringWithFormat:@"DROP TABLE %@",tableName];
    [_database executeUpdate:sql];
    [_database close];
    
    [sqlLock unlock];
}

//插入数据
-(void)insertWithObject:(id)obj inTable:(NSString *)tableName
{
    [sqlLock lock];

    [_database open];
    
    NSArray *keys = [self getPropertiesFromObj:obj];
    
    NSMutableArray * arrKeys = [NSMutableArray array];
    NSMutableArray * arrPhs = [NSMutableArray array];
    NSMutableArray * arrVals = [NSMutableArray array];
    
    for (NSString * key in keys) {
        NSObject * aValue = [obj valueForKey:key];
        if (aValue) {
            //非空才能加入数据：
            [arrKeys addObject:key];
            [arrPhs addObject:@"?"];
            [arrVals addObject:aValue];
        }
    }
    NSString *fields = [arrKeys componentsJoinedByString:@","];
    NSString * phs = [arrPhs componentsJoinedByString:@","];
    NSString * sql = [NSString stringWithFormat:@"INSERT INTO %@ (%@) VALUES (%@)",tableName,fields,phs];
    [_database executeUpdate:sql withArgumentsInArray:arrVals];
    [_database close];
    
    [sqlLock unlock];

}

-(void)deleteTable:(NSString *)tableName withCondition:(NSString *)conditonName andConditionData:(NSString *)conditionData
{
    [sqlLock lock];
    [_database open];
    
    NSString *sqlStr = [NSString stringWithFormat:@"DELETE FROM %@ WHERE %@ = ?",tableName,conditonName];
    
    [_database executeUpdate:sqlStr,conditionData];

    [_database close];
    [sqlLock unlock];
}
-(void)updateWithObject:(id)obj inTable:(NSString *)tableName withCondition:(NSString *)conditionStr andConditionData:(NSString *)conditionData
{
    if(obj == nil || conditionData == nil || conditionStr == nil)
        return;
    
    NSMutableString * sql = [NSMutableString stringWithFormat:@"UPDATE %@ SET ",tableName];
    NSArray * keys = [self getPropertiesFromObj:obj];
    
    NSMutableArray * keyValues = [NSMutableArray array];
    NSMutableArray * args = [NSMutableArray array];
    for (NSString * key in keys) {
        NSObject * aValue = [obj valueForKey:key];
        if ([key isEqualToString:conditionStr]) {
            continue;
        }
        
        else if (aValue != nil && [[aValue class] isSubclassOfClass:[NSString class]]) {
            NSString * keyValue = [NSString stringWithFormat:@"%@ = ?",key];
            [keyValues addObject:keyValue];
            [args addObject:aValue];
        }
        
    }
    
    NSString * strKeyValues = [keyValues componentsJoinedByString:@","];
    NSString * condition = [NSString stringWithFormat:@" WHERE %@ = ?",conditionStr];
    
    [sqlLock lock];
    
    [_database open];
    
    [sql appendString:strKeyValues];
    if (conditionStr && conditionData) {
        [sql appendString:condition];
        [args addObject:conditionData];
    }
    [_database executeUpdate:sql withArgumentsInArray:args];
    [_database close];
    
    [sqlLock unlock];
}

-(void)updateWithObject:(id)obj inTable:(NSString *)tableName
{
    NSMutableString * sql = [NSMutableString stringWithFormat:@"UPDATE %@ SET ",tableName];
    NSArray * keys = [self getPropertiesFromObj:obj];
    
    NSMutableArray * keyValues = [NSMutableArray array];
    NSMutableArray * args = [NSMutableArray array];
    for (NSString * key in keys) {
        NSObject * aValue = [obj valueForKey:key];

        if (aValue != nil && [[aValue class] isSubclassOfClass:[NSString class]]) {
            NSString * keyValue = [NSString stringWithFormat:@"%@ = ?",key];
            [keyValues addObject:keyValue];
            [args addObject:aValue];
        }
        
    }
    
    NSString * strKeyValues = [keyValues componentsJoinedByString:@","];
   
    [sqlLock lock];

    [_database open];

    [sql appendString:strKeyValues];

    [_database executeUpdate:sql withArgumentsInArray:args];
    [_database close];
    
    [sqlLock unlock];
}


-(NSDictionary *)selectTable:(NSString *)tableName saveClass:(Class)aClass withCondition:(NSString *)conditionStr andConditionData:(NSString *)conditionData
{
    NSMutableDictionary *retDic = [[NSMutableDictionary alloc] init];
    NSArray *arr = [self getPropertiesFromClass:aClass];
    NSString * sql = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE %@ = ?",tableName,conditionStr];
    
    [sqlLock lock];

    [_database open];
    FMResultSet * rs = [_database executeQuery:sql,conditionData];
    while ([rs next]){
        for (NSString * key in arr) {
            NSString * value = [rs stringForColumn:key];
            [retDic setValue:value forKeyPath:key];
        }
    }
    [rs close];
    [_database close];
    
    [sqlLock unlock];

    return retDic;
}

-(NSArray *)selectAllItemInTable:(NSString *)tableName WithClass:(Class)aclas
{
    [sqlLock lock];

    NSMutableArray *allItems = [[NSMutableArray alloc] init];
    NSArray *arr = [self getPropertiesFromClass:aclas];
    NSString * sql = [NSString stringWithFormat:@"SELECT * FROM %@",tableName];

    [_database open];
    FMResultSet * rs = [_database executeQuery:sql];
    while ([rs next]){
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        for (NSString * key in arr) {
            NSString * value = [rs stringForColumn:key];
            [dic setValue:value forKey:key];
        }
        [allItems addObject:dic];
    }
    
    [rs close];
    [_database close];
    
    [sqlLock unlock];

    return allItems;
}

//查询数据库某一表的某一列的某一字段：
-(NSString *)selectTable:(NSString *)tableName whichSeg:(NSString *)seg useSeg:(NSString *)useg useData:(NSString *)data
{
    NSString *resultStr = nil;
    
    [sqlLock lock];

    [_database open];
    NSString *sqlStr = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE %@ = ?",tableName,useg];
    FMResultSet *rs = [_database executeQuery:sqlStr,data];
    while ([rs next]) {
        resultStr = [rs stringForColumn:seg];
    }
    [_database close];
    
    [sqlLock unlock];

    return resultStr;
}

-(void)dropTable:(NSString *)tableName
{
    [sqlLock lock];
    
    [_database open];
    NSString *sqlStr = [NSString stringWithFormat:@"DROP TABLE %@",tableName];
    [_database executeUpdate:sqlStr];
    [_database close];
    
    [sqlLock unlock];
}

//获取一个类的所有属性名。
-(NSArray *)getPropertiesFromClass:(Class)aclass
{
    unsigned int outCount, i;
    objc_property_t *properties = class_copyPropertyList(aclass, &outCount);
    NSMutableArray *keys = [[NSMutableArray alloc] initWithCapacity:outCount];
    for (i = 0; i < outCount; i++) {
        objc_property_t property = properties[i];
        NSString *propertyName = [[NSString alloc] initWithCString:property_getName(property) encoding:NSUTF8StringEncoding];
        [keys addObject:propertyName];
    }
    free(properties);
    return keys;

}

-(NSArray *)getPropertiesFromObj:(id)obj
{
    unsigned int outCount, i;
    objc_property_t *properties = class_copyPropertyList([obj class], &outCount);
    NSMutableArray *keys = [[NSMutableArray alloc] initWithCapacity:outCount];
    for (i = 0; i < outCount; i++) {
        objc_property_t property = properties[i];
        NSString *propertyName = [[NSString alloc] initWithCString:property_getName(property) encoding:NSUTF8StringEncoding];
        [keys addObject:propertyName];
    }
    free(properties);
    return keys;
}

//设置当前播放fm，tv，音乐
-(void)setCurrentProgrem:(NSString *)tableName andObj:(CurrentProgram *)pro
{
    NSArray *arr= [self selectAllItemInTable:tableName WithClass:[pro class]];
    if ([arr count] == 0) {
        [self insertWithObject:pro inTable:tableName];
    }else{
        [self updateWithObject:pro inTable:tableName];
    }
}

//设置audio，Video
-(void)setCurProgram_avTv:(NSString *)tableName andObj:(SC_Model*)pro
{
    NSDictionary *dic = [self selectTable:tableName saveClass:[CurrentProgram class] withCondition:@"path" andConditionData:pro.path];

    if ([dic count] == 0) {
        [self insertWithObject:pro inTable:tableName];
    }else{
        [self updateWithObject:pro inTable:tableName withCondition:@"path" andConditionData:pro.path];
    }
    
}

@end