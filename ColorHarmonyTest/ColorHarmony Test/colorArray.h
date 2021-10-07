//
//  colorArray.h
//  ColorHarmony Test
//
//  Created by 莫玄 on 2021/5/2.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface colorArray : NSObject
@property (strong,nonatomic)NSMutableArray *myColorArray;
+(instancetype)sharedColorArray;
-(void)setColor;
-(void)makeRandom:(NSMutableArray *)array;
@end

NS_ASSUME_NONNULL_END
