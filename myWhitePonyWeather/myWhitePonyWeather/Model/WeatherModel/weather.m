//
//  weather.m
//  myWhitePonyWeather
//
//  Created by 莫玄 on 2021/4/18.
//

#import "weather.h"

@implementation weather
-(instancetype)initWithCurrentTem:(NSString *)currentTem hLtem:(NSString *)highLowTem mismo:(NSString *)mismo updateTime:(NSString *)time
{
    self=[super init];
    if(self)
    {
    _currentTempreture=currentTem;
    _mismo=mismo;
    _highAndLowTempreture=highLowTem;
    _updateTime=time;
    }
    return self;
}
@end
