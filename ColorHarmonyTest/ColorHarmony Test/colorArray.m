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
    self.firstColorArray=[NSMutableArray array];
    self.secondColorArray=[NSMutableArray array];
    self.thirdColorArray=[NSMutableArray array];
    self.forthColorArray=[NSMutableArray array];
    //第一列的stackview 需要显示的色块颜色；
    NSArray *first=[NSArray arrayWithObjects:@"c97f7f",@"c98483",@"c98a87",@"c98f8b",@"c8948f",@"c89a93",@"c89f97",@"c8a59b",@"c8aa9f",@"c8afa3",@"c7b5a8",@"c7baac",@"c7bfb0",@"c7c5b4",@"c7cab8",@"c7d0bc",@"c6d5c0",@"c6dac4",@"c6e0c8",@"c6e5cc",@"c6e5d2",@"c6e5d7",nil];
    for(int i=0;i<22;i++)
    {
        NSString *firstColorString=first[i];
        RGBColor *firstcolor=[self transToRGB:firstColorString];
        firstcolor.index=i;
        [self.firstColorArray addObject:firstcolor];
    }
    [self makeRandom:_firstColorArray];
    //第二列的stackview 需要显示的色块颜色；
    NSArray *second=[NSArray arrayWithObjects:@"c9c77f",@"c9c784",@"cac78a",@"cac78f",@"cac794",@"cbc79a",@"cbc79f",@"cbc7a5",@"ccc7aa",@"ccc7af",@"ccc6b5",@"ccc6ba",@"cdc6bf",@"cdc6c5",@"cdc6ca",@"cec6d0",@"cec6d5",@"cec6da",@"cfc6e0",@"cfc6e5",@"cfc6ea",@"cfc6ef",nil];
    for(int i=0;i<22;i++)
    {
        NSString *secondColorString=second[i];
        RGBColor *secondColor=[self transToRGB:secondColorString];
        secondColor.index=i;
        [self.secondColorArray addObject:secondColor];
    }
    [self makeRandom:_secondColorArray];
    //第三列的stackview 需要显示的色块颜色
    NSArray *third=[NSArray arrayWithObjects:@"c97f9b",@"c9839f",@"c987a3",@"c98ba7",@"c88eab",@"c892ae",@"c896b2",@"c89ab6",@"c89eba",@"c8a2be",@"c7a5c2",@"c7a9c6",@"c7adca",@"c7b1ce",@"c7b5d2",@"c7b9d5",@"c6bcd9",@"c6c0dd",@"c6c4e1",@"c6c8e5", @"c6c8ea",@"c6c8ef",nil];
    for(int i=0;i<22;i++)
    {
        NSString *thirdColorString=third[i];
        RGBColor *thirdColor=[self transToRGB:thirdColorString];
        thirdColor.index=i;
        [self.thirdColorArray addObject:thirdColor];
    }
    [self makeRandom:_thirdColorArray];
    //第四列的stackview 需要显示的色块颜色
    NSArray *forth=[NSArray arrayWithObjects:@"c97f9b",@"c9839f",@"c987a3",@"c98ba7",@"c88eab",@"c892ae",@"c896b2",@"c89ab6",@"c89eba",@"c8a2be",@"c7a5c2",@"c7a9c6",@"c7adca",@"c7b1ce",@"c7b5d2",@"c7b9d5",@"c6bcd9",@"c6c0dd",@"c6c4e1",@"c6c8e5",@"c6c8ea",@"c6c8ef",nil];
    for(int i=0;i<22;i++)
    {
        NSString *forthColorString=forth[i];
        RGBColor *forthColor=[self transToRGB:forthColorString];
        forthColor.index=i;
        [self.forthColorArray addObject:forthColor];
    }
    [self makeRandom:_forthColorArray];
}
//将HEX颜色转化为RGB颜色值并储存
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
//将颜色进行乱序排序，但是固定收尾两个色块的颜色不变；
-(void)makeRandom:(NSMutableArray *)array
{
    RGBColor *firstColor=array.firstObject;
    RGBColor *lastColor=array.lastObject;
    [array removeObject:array.firstObject];
    [array removeLastObject];
    NSUInteger count=array.count;
    for(int i=0;i<count;i++)
    {
        int n=(arc4random()%(count-i))+i;
        [array exchangeObjectAtIndex:i withObjectAtIndex:n];
    }
    [array insertObject:firstColor atIndex:0];
    [array addObject:lastColor];
}
@end
