//
//  DatabaseManager.m
//  GQ_Doctor_MobileHospital
//
//  Created by Mengying Xu on 14-10-8.
//  Copyright (c) 2014年 Mengying Xu. All rights reserved.
//

#import "DatabaseManager.h"
#include <sqlite3.h>
#import "FMDatabaseQueue.h"
#import "FMDatabase.h"
@implementation DatabaseManager
static DatabaseManager *manager = nil;
static NSString *_DatabaseDirectory;

static inline NSString* DatabaseDirectory() {
	if(!_DatabaseDirectory) {
        
        NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,YES);
        
        NSString *pathStr = [documentPaths objectAtIndex:0];
        
        //得到完整的文件名
        _DatabaseDirectory=[pathStr stringByAppendingPathComponent:@"cccc.db"];//fileName就是保存文件的文件名
        
        NSFileManager *fileManager = [NSFileManager defaultManager];
        BOOL isDir = YES;
        BOOL isExist = [fileManager fileExistsAtPath:_DatabaseDirectory isDirectory:&isDir];
        if (!isExist)
        {
            [fileManager createDirectoryAtPath:_DatabaseDirectory withIntermediateDirectories:YES attributes:nil error:NULL];
        }
	}
	
	return _DatabaseDirectory;
}

- (id)init{
	if(self = [super init]){
        
		_isDataBaseOpened = NO;
        
        [self setWritablePath:[DatabaseDirectory() stringByAppendingPathComponent:@"cccc.db"]];
        
		[self openDataBase];
	}
	return self;
}

- (BOOL)isDatabaseOpened
{
    return _isDataBaseOpened;
}

- (void)openDataBase{
    
	_databaseQueue = [FMDatabaseQueue databaseQueueWithPath:self.writablePath];
    
    if (_databaseQueue == 0x00) {
        _isDataBaseOpened = NO;
        return;
    }
    
    _isDataBaseOpened = YES;
//    [GQCommonTools showLog:@"Open Database OK!"];
    [_databaseQueue inDatabase:^(FMDatabase *db){
        [db setShouldCacheStatements:YES];
    }];
}

- (void)closeDataBase{
	if(!_isDataBaseOpened){
        NSLog(@"数据库已打开，或打开失败。请求关闭数据库失败。");
		return;
	}
	
	[_databaseQueue close];
	_isDataBaseOpened = NO;
    NSLog(@"关闭数据库成功。");

}

+ (DatabaseManager*)currentManager {
    
	@synchronized(self) {
        
		if(!manager) {
            
			manager = [[DatabaseManager alloc] init];
			
		}
	}
	
	return manager;
}

+ (void)releaseManager{
    
    if(manager){
        
        manager = nil;
    }
}


-(void)dealloc{
	
	[self closeDataBase];
}

@end

