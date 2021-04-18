//
//  location.m
//  myWhitePonyWeather
//
//  Created by 莫玄 on 2021/4/18.
//

#import "location.h"


@interface location()
@end

@implementation location
-(instancetype)initWithLat:(CLLocationDegrees)latitude lon:(CLLocationDegrees)longitude address:(NSString *)address
{
    self=[super init];
    if (self) {
        _latitude=latitude;
        _longitude=longitude;
        _address=address;
    }
    return self;
}
-(void)updateWithLat:(CLLocationDegrees)latitude lon:(CLLocationDegrees)longitude address:(NSString *)address
{
    self.address=address;
    self.latitude=latitude;
    self.longitude=longitude;
}
@end
