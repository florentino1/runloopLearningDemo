//
//  DBManager.m
//  myWhitePonyWeather
//
//  Created by 莫玄 on 2021/4/19.
//

#import "DBManager.h"
#import "location.h"
@interface DBManager()
@property (strong,nonatomic)FMDatabase *db;
@end
@implementation DBManager
+(instancetype)sharedDB
{
    static dispatch_once_t once=0;
    static DBManager *manager=nil;
    dispatch_once(&once, ^{
        manager=[[DBManager alloc]init];
    });
    return manager;
}
-(void)initDB
{
    NSString *path=[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject]stringByAppendingPathComponent:@"db"];
    self.db=[FMDatabase databaseWithPath:path];
    if([self.db open])
    {
        NSLog(@">>>数据库初始化成功");
        [self createTab];
    }
    else
        NSLog(@">>>数据库初始化失败");
}
-(void)createTab
{
    if([self.db open])
    {
        NSString *sql=@"CREATE TABLE IF NOT EXISTS locationInfo (address text UNIQUE,latitude text,longitude text)";
        BOOL success=[self.db executeUpdate:sql];
        if(success)
            NSLog(@">>>建表成功");
        else
            NSLog(@">>>建表失败");
    }
}
-(void)insertLocationWithAddress:(NSString *)address latitude:(CLLocationDegrees)latitude longitude:(CLLocationDegrees)longitude
{
    BOOL success=[self.db executeUpdate:@"insert into locationInfo(address,latitude,longitude) values(?,?,?)",address,@"latitude",@"longitude"];
    if (success) {
        NSLog(@">>>地点信息插入成功");
    }
    else
        NSLog(@">>>地点信息插入失败");
}
-(NSMutableArray *)getAllLocations
{
    NSString *sql=@"select * from locationInfo";
   FMResultSet *resultSet=[self.db executeQuery:sql];
    NSMutableArray *returnArray=[NSMutableArray array];
    while ([resultSet next]) {
        NSString *addrss=[resultSet objectForColumn:@"address"];
        NSString *latString=[resultSet objectForColumn:@"latitude"];
        CLLocationDegrees latitude=[latString doubleValue];
        NSString *lonString=[resultSet objectForColumn:@"longitude"];
        CLLocationDegrees longitude=[lonString doubleValue];
        location *loc=[[location alloc]initWithLat:latitude lon:longitude address:addrss];
        [returnArray addObject:loc];
    }
    return returnArray;

}
@end
