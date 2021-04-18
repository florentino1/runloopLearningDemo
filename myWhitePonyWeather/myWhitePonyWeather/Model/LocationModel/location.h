//
//  location.h
//  myWhitePonyWeather
//
//  Created by 莫玄 on 2021/4/18.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

NS_ASSUME_NONNULL_BEGIN

@interface location : NSObject
@property (assign,nonatomic)CLLocationDegrees latitude;
@property (assign,nonatomic)CLLocationDegrees longitude;
@property (strong,nonatomic)NSString *address;
-(instancetype)initWithLat:(CLLocationDegrees)latitude lon:(CLLocationDegrees)longitude address:(NSString *)address;
-(void)updateWithLat:(CLLocationDegrees)latitude lon:(CLLocationDegrees)longitude address:(NSString *)address;
@end

NS_ASSUME_NONNULL_END
