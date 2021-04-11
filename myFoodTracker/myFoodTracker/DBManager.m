//
//  dataBase.m
//  myFoodTracker
//
//  Created by 莫玄 on 2021/4/10.
//

#import "DBManager.h"
#import <FMDatabase.h>

@interface DBManager()
@property(nonatomic,strong)FMDatabase *db;
@end

@implementation DBManager
+(instancetype)sharedDBManager
{
    static dispatch_once_t once=0;
    static DBManager *dbManager=nil;
    dispatch_once(&once, ^{
        dbManager=[[DBManager alloc]init];
    });
    return dbManager;
}
-(void)initDB
{
    NSString *homePath=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *dbPath=[homePath stringByAppendingFormat:@"/mealDB.db"];
    NSLog(@"%@",dbPath);
    self.db=[FMDatabase databaseWithPath:dbPath];
    if([self.db open])
    {
        NSLog(@"》》》数据库初始化成功");
        [self creatTable];
    }
    else
        NSLog(@"》》》数据库初始化失败");
}
-(void)creatTable
{
    if([self.db open])
    {
        NSString *sql=[NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS userDB (mealName TEXT NOT NULL UNIQUE,mealRating TEXT);"];
        BOOL result=[self.db executeUpdate:sql];
        if(result)
            NSLog(@"》》》建表成功");
        else
            NSLog(@"》》》建表失败");
    }
}
-(void)insertMealName:(NSString *)name mealRating:(NSUInteger)rating
{
    [self.db beginTransaction];
    NSString *newRating=[NSString stringWithFormat:@"%lu",(unsigned long)rating];
    BOOL isRollingBack=NO;
    @try {
        BOOL successed=[self.db executeUpdate:@"insert into userDB(mealName,mealRating) values (?,?)",name,newRating];
        if(successed)
            NSLog(@"》》》数据插入成功");
        else
            NSLog(@"》》》数据插入失败");
    } @catch (NSException *exception) {
        isRollingBack=YES;
        [self.db rollback];
    } @finally {
        if(!isRollingBack)
            [self.db commit];
    }
}
-(void)deleteMeal:(NSString *)mealName
{
    NSString *sql=@"delete from userDB where mealName=?";
    BOOL successed=[self.db executeUpdate:sql,mealName];
    if(successed)
        NSLog(@"》》》%@ 删除成功",mealName);
    else
        NSLog(@"》》》%@ 删除失败",mealName);
}
-(void)showDB
{
    NSString *sql=@"select * from userDB";
    FMResultSet *results=[self.db executeQuery:sql];
    NSMutableArray *returnArray=[NSMutableArray array];
    while ([results next]) {
        NSString *mealName=[results stringForColumn:@"mealName"];
        [returnArray addObject:mealName];
    }
    [results close];
    NSLog(@"%@",returnArray);

}
@end

