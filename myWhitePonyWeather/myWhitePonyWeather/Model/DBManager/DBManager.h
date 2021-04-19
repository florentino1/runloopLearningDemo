//
//  DBManager.h
//  myWhitePonyWeather
//
//  Created by 莫玄 on 2021/4/19.
//

#import <Foundation/Foundation.h>
#import <FMDB.h>
#import <CoreLocation/CoreLocation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DBManager : NSObject
+(instancetype)sharedDB;
-(void)initDB;
-(void)createTab;
-(void)insertLocationWithAddress:(NSString *)address latitude:(CLLocationDegrees)latitude longitude:(CLLocationDegrees)longitude;
-(NSMutableArray *)getAllLocations;

@end

NS_ASSUME_NONNULL_END
