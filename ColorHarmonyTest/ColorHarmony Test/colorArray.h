//
//  colorArray.h
//  ColorHarmony Test
//
//  Created by 莫玄 on 2021/5/2.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface colorArray : NSObject
@property (strong,nonatomic)NSMutableArray *myColorArray;   //储存由hex 转化为rgb的颜色对象；

+(instancetype)sharedColorArray;
-(void)setColor;
-(void)makeRandom:(NSMutableArray *)array;  //除了首尾两个颜色之外颜色的乱序排列
@end

NS_ASSUME_NONNULL_END
