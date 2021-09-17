//
//  singleton.h
//  test
//
//  Created by 莫玄 on 2021/8/21.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface singleton : NSObject
@property(strong,nonatomic)NSString *name;
+(instancetype)sharedSingleton;
@end

NS_ASSUME_NONNULL_END
