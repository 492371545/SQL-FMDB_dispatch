//
//  DBManager.h
//  SQLDataBase
//
//  Created by Mengying Xu on 14-10-21.
//  Copyright (c) 2014年 Crystal Xu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabaseQueue.h"

@interface DBManager : NSObject

@property (nonatomic, strong) FMDatabaseQueue *databaseQueue;
+ (DBManager*)currentManager;

- (BOOL)isDatabaseOpened;

- (void)openDataBase;

- (void)closeDataBase;
@end
