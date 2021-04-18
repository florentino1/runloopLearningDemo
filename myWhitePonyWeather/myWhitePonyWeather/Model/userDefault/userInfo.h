//
//  userInfo.h
//  myWhitePonyWeather
//
//  Created by 莫玄 on 2021/4/18.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

NS_ASSUME_NONNULL_BEGIN

@interface userInfo : NSObject
@property (retain,nonatomic)NSNumber *latitude;
@property (retain,nonatomic)NSNumber *longitude;
@property(strong,nonatomic)NSString *address;
+(instancetype)sharedUserInfo;
@end

NS_ASSUME_NONNULL_END
