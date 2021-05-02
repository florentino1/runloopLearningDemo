//
//  RGBColor.h
//  ColorHarmony Test
//
//  Created by 莫玄 on 2021/5/2.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface RGBColor : NSObject
@property (assign,nonatomic)int R;
@property (assign,nonatomic)int G;
@property (assign,nonatomic)int B;
-(instancetype)initWithR:(int)Red G:(int)Green B:(int)Blue;
@end

NS_ASSUME_NONNULL_END
