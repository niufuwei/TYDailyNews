//
//  db.m
//  222
//
//  Created by funsince on 13-6-19.
//  Copyright (c) 2013年 funsince. All rights reserved.
//

#import "db.h"
#import "sqlite3.h"

@implementation db

static sqlite3 *DB =nil;


+(sqlite3 *)openDB
{
    if(DB)
    {
        return DB;
    }
    NSArray *searchPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *documentFolderPath = [searchPaths objectAtIndex:0];
    
    
    //往应用程序路径中添加数据库文件名称，把它们拼接起来， 这里用到了宏定义（目的是不易出错)
    NSString*  dbFilePath = [documentFolderPath stringByAppendingPathComponent:@"cityname.sqlite"];
    
    /*
     为什么要往应用程序里添加数据库文件这个过程：
     因为下面要进行判断，会根据这个路径去查找应用程序的路径中到底有没有这个文件，
     如果有，则不用在此拷贝了，
     如果没有，则重新拷贝一次，
     数据库文件必须添加进取，否则无法进行数据库的操作，而且必须添加一次，
     
     那么为什么必须要添加一次呢？
     因为我们在程序中实现对数据库的修改，然而却又把数据库添加了一次，
     那么新添加的数据库就会把旧的数据库覆盖掉，那么程序中对数据库的修改也不能实现，
     所以数据库只能添加一次且是在程序运行初添加
     */
    
    //根据上面拼接好的路径 dbFilePath ，利用NSFileManager 类的对象的fileExistsAtPath方法来检测是否存在，返回一个BOOL值
    //1. 创建NSFileManager对象  NSFileManager包含了文件属性的方法
    NSFileManager *fm = [NSFileManager defaultManager];
    
    //2. 通过 NSFileManager 对象 fm 来判断文件是否存在，存在 返回YES  不存在返回NO
    BOOL isExist = [fm fileExistsAtPath:dbFilePath];
    
    NSLog(@"dbFilePath==。%@",dbFilePath);
    [[NSUserDefaults standardUserDefaults] setObject:dbFilePath forKey:@"dbFilePath"];
    //如果不存在 isExist = NO，拷贝工程里的数据库到Documents下
    if (!isExist)
    {
        NSLog(@"不存在数据库");
        //拷贝数据库
        
        //获取工程里，数据库的路径,因为我们已在工程中添加了数据库文件，所以我们要从工程里获取路
        NSBundle* bundle=[NSBundle mainBundle];
        
        NSString* backupDbPath=[bundle pathForResource:@"cityname" ofType:@"sqlite"];
 
        
        //这一步实现数据库的添加，
        // 通过NSFileManager 对象的复制属性，把工程中数据库的路径拼接到应用程序的路径上
        [fm copyItemAtPath:backupDbPath toPath:dbFilePath error:nil];
        
       
    }

  
    //BOOL isE = [fm fileExistsAtPath:dbFilePath];
    
    if(sqlite3_open([dbFilePath UTF8String],&DB)!=SQLITE_OK)
    {
        sqlite3_close(DB);
        NSLog(@"数据库打开失败");
    }
    
    return DB;
}


+(void)closeDB
{
    if(DB)
    {
        sqlite3_close(DB);
    }
}

@end
