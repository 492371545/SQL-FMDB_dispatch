//
//  DBManager.m
//  SQLDataBase
//
//  Created by Mengying Xu on 14-10-21.
//  Copyright (c) 2014年 Crystal Xu. All rights reserved.
//

#import "DBManager.h"


@implementation DBManager
+ (DBManager*)currentManager {

    static DBManager *manager = nil;
    
    static dispatch_once_t predicate;
    
    dispatch_once(&predicate, ^{
        
        manager =[[DBManager alloc] init];
    });
	
    return manager;
}

- (FMDatabaseQueue*)databaseQueue
{
    if(!_databaseQueue)
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
        
        _databaseQueue = [[FMDatabaseQueue alloc] initWithPath:path];
    }
    
    return _databaseQueue;
}


@end
