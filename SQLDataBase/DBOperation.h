//
//  DBOperation.h
//  SQLDataBase
//
//  Created by Mengying Xu on 14-10-21.
//  Copyright (c) 2014年 Crystal Xu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabaseQueue.h"
#import "FMDatabase.h"
#import "FMDatabaseAdditions.h"

#import "DBManager.h"

@interface DBOperation : FMDatabase
{
//    FMDatabase *dataBase;
	NSString *writablePath;

}
//@property (nonatomic, strong) FMDatabaseQueue *databaseQueue;

+ (FMDatabase*)currentDataBase:(NSString*)path;

- (void)createDataBase;
- (void)writeToDB:(NSString*)fileName Withkey:(NSInteger)key WithValue:(NSString*)value;
- (NSMutableArray*)getDataFromDB:(NSString *)fileName Withkey:(NSInteger)key WithValue:(NSString*)value;

@end
