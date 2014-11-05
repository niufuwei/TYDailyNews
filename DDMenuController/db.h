//
//  db.h
//  222
//
//  Created by funsince on 13-6-19.
//  Copyright (c) 2013年 funsince. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <sqlite3.h>

@interface db : NSObject

+(sqlite3 *)openDB;//打开数据库
+(void)closeDB;//关闭数据库

@end
