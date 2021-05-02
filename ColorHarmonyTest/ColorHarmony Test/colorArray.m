//
//  colorArray.m
//  ColorHarmony Test
//
//  Created by 莫玄 on 2021/5/2.
//

#import "colorArray.h"
#import "RGBColor.h"
@implementation colorArray
+(instancetype)sharedColorArray
{
    static dispatch_once_t once=0;
    static colorArray *array=nil;
    dispatch_once(&once, ^{
        array=[[colorArray alloc]init];
    });
    return array;
}
-(void)setColor
{
    self.RGBColorArray=[NSMutableArray array];
    NSArray *hexArrayWithRedAndGreen=[NSArray arrayWithObjects:@"f0430b",@"ef4c15",@"ee541f",@"ed5d29",@"ec6532",@"ea6e3c",@"e97646",@"e87f50",@"e7875a",@"e69064",@"e5986d",@"e4a177",@"e3a981",@"e2b28b",@"e1ba95",@"dfc39f",@"decba8",@"ddd4b2",@"dcdcbc",@"dbe5c6", nil];
    for(int i=0;i<20;i++)
    {
        NSString *HEXColor=hexArrayWithRedAndGreen[i];
        RGBColor *rgbcolor=[self transToRGB:HEXColor];
        [self.RGBColorArray addObject:rgbcolor];
    }
}
-(RGBColor *)transToRGB:(NSString *)string
{
    char *s=[string cStringUsingEncoding:NSUTF8StringEncoding];
    NSMutableArray *resArray=[NSMutableArray array];
    for(int i=0;i<6;i++)
    {
        char c=s[i];
        if(c=='a')
            resArray[i]=@"10";
        else if(c=='b')
            resArray[i]=@"11";
        else if(c=='c')
            resArray[i]=@"12";
        else if(c=='d')
            resArray[i]=@"13";
        else if(c=='e')
            resArray[i]=@"14";
        else if(c=='f')
            resArray[i]=@"15";
        else
        {
            int p=c-'0';
            NSNumber *n=[NSNumber numberWithInt:p];
            resArray[i]=n;
        }

    }
    int Red=16*[resArray[0] intValue]+[resArray[1] intValue];
    int Green=16*[resArray[2] intValue]+[resArray[3] intValue];
    int Blue=16*[resArray[4] intValue]+[resArray[5] intValue];
    RGBColor *color=[[RGBColor alloc]initWithR:Red G:Green B:Blue];
    return color;
}
@end
