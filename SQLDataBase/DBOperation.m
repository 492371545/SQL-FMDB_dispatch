//
//  DBOperation.m
//  SQLDataBase
//
//  Created by Mengying Xu on 14-10-21.
//  Copyright (c) 2014年 Crystal Xu. All rights reserved.
//

#import "DBOperation.h"

@implementation DBOperation
static FMDatabase *dataBase = nil;
static FMDatabaseQueue *_databaseQueue = nil;

- (id)init
{
    self = [super init];
    if(self)
    {
        NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        
        NSString *pathStr = [documentPaths firstObject];
        NSString *path = [pathStr stringByAppendingPathComponent:@"SQLDB.db"];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        BOOL isDir = YES;
        BOOL isExist = [fileManager fileExistsAtPath:path isDirectory:&isDir];
        if (!isExist)
        {
            [fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
        }
        writablePath = [path stringByAppendingPathComponent:@"SQLDB.db"];
        dataBase = [DBOperation currentDataBase:writablePath];
    }
    
    return self;
}
- (void)openDataBase{
    
    if (_databaseQueue == 0x00) {
        return;
    }
    
    [_databaseQueue inDatabase:^(FMDatabase *db){
        [db setShouldCacheStatements:YES];
    }];
}

+ (FMDatabase*)currentDataBase:(NSString*)path
{
    static dispatch_once_t predicate;
    
    dispatch_once(&predicate, ^{
     
        dataBase =[FMDatabase databaseWithPath:path];
        _databaseQueue = [FMDatabaseQueue databaseQueueWithPath:path];
        [dataBase open];
        [_databaseQueue inDatabase:^(FMDatabase *db) {
            [db setShouldCacheStatements:YES];
        }];
    });
	
    return dataBase;
}
- (void)createDataBase
{
    
    [_databaseQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString *sqlA = @"create table if not exists A (key integer primary key, value text)";
        NSString *sqlB = @"create table if not exists B (key integer primary key, value text)";
        
        [db executeUpdate:sqlA];
        
        [db executeUpdate:sqlB];
        
//        if (!res) {
//            NSLog(@"error when insert db table");
//        } else {
//            NSLog(@"success to insert db table");
//        }

    }];
    
//    if([dataBase open])
//    {
//        [dataBase executeUpdate:@"create table if not exists A (key integer primary key, value text)"];
//        NSString *sqlA = @"create table if not exists A (key integer primary key, value text)";
//        NSString *sqlB = @"create table if not exists B (key integer primary key, value text)";
//    
//        BOOL res = [dataBase executeUpdate:sqlA];
//        
//        [dataBase executeUpdate:sqlB];
//        
//        if (!res) {
//            NSLog(@"error when insert db table");
//        } else {
//            NSLog(@"success to insert db table");
//        }
//        [dataBase close];
//    }
//    else
//    {
//        NSLog(@"createDataBase 打开数据库失败");
//    }
}

- (void)writeToDB:(NSString*)fileName Withkey:(NSInteger)key WithValue:(NSString*)value
{
    if(!dataBase)
    {
        dataBase = [DBOperation currentDataBase:writablePath];
    }
//    if([dataBase open])
//    {
        [_databaseQueue inDatabase:^(FMDatabase *db) {
            NSString *sql = [NSString stringWithFormat:@"insert into %@ (key,value) values ('%i','%@')",fileName,key,value];
            
            [dataBase executeUpdate:sql];

        }];
//        NSString *sql = [NSString stringWithFormat:@"insert into %@ (key,value) values ('%i','%@')",fileName,key,value];
//        
//        BOOL res =  [dataBase executeUpdate:sql];
//        
//        if (!res) {
//            NSLog(@"error when insert db table");
//        } else {
//            NSLog(@"success to insert db table");
//        }
//        
//        [dataBase close];
//    }
//    else
//    {
//        NSLog(@"writeToDB 打开数据库失败");
//    }
    
}

- (NSMutableArray*)getDataFromDB:(NSString *)fileName Withkey:(NSInteger)key WithValue:(NSString*)value
{
    if(!dataBase)
    {
        dataBase = [DBOperation currentDataBase:writablePath];
    }
    NSMutableArray *dbArr = [[NSMutableArray alloc] init];
//    if([dataBase open])
//    {
//        NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@",fileName];
//        
//       FMResultSet *rs = [dataBase executeQuery:sql];
//        while ([rs next]) {
//            NSString * key = [rs stringForColumn:@"key"];
//            NSString * value = [rs stringForColumn:@"value"];
//            NSLog(@"key = %@, value = %@", key, value);
//            
//            [dbArr addObject:value];
//        }
//        [dataBase close];
//    }
//    else
//    {
//        NSLog(@"getDataFromDB 打开数据库失败");
//    }
    
    [_databaseQueue inDatabase:^(FMDatabase *db) {
        NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@",fileName];
        
        FMResultSet *rs = [dataBase executeQuery:sql];
        while ([rs next]) {
            NSString * key = [rs stringForColumn:@"key"];
            NSString * value = [rs stringForColumn:@"value"];
            NSLog(@"key = %@, value = %@", key, value);
            
            [dbArr addObject:value];
        }

    }];
    
    return dbArr;
}



@end
