//
//  weather.h
//  myWhitePonyWeather
//
//  Created by 莫玄 on 2021/4/18.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface weather : NSObject
@property (strong,nonatomic)NSString *currentTempreture;//当前的气温;
@property (strong,nonatomic)NSString *highAndLowTempreture;//当日最高及最低气温
@property (strong,nonatomic)NSString *mismo;//当前的湿度与大气压
@property (strong,nonatomic)NSString *updateTimeLabel;//刷新的时间;

@end

NS_ASSUME_NONNULL_END
