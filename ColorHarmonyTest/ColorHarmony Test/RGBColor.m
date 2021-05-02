//
//  RGBColor.m
//  ColorHarmony Test
//
//  Created by 莫玄 on 2021/5/2.
//

#import "RGBColor.h"

@implementation RGBColor
-(instancetype)initWithR:(int)Red G:(int)Green B:(int)Blue
{
    if(self=[super init])
    {
    _R=Red;
    _G=Green;
    _B=Blue;
    return self;
    }
    return nil;
}
@end
