//
//  colorArray.m
//  ColorHarmony Test
//
//  Created by 莫玄 on 2021/5/2.
//

#import "colorArray.h"
#import "RGBColor.h"

#define COLORNUMBERS 22
#define CORLORCOLUMNS 4

@implementation colorArray
+(instancetype)sharedColorArray
{
    static dispatch_once_t once=0;
    static colorArray *array=nil;
    dispatch_once(&once, ^{
        array=[[colorArray alloc]init];
        array.myColorArray=[[NSMutableArray alloc]initWithCapacity:CORLORCOLUMNS];
    });
    return array;
}
-(void)setColor
{
    NSString *HexColorArrayPath=[[NSBundle mainBundle]pathForResource:@"HexColor" ofType:@".plist"];
    NSArray *HexColorArray=[NSArray arrayWithContentsOfFile:HexColorArrayPath];
    for(int i=0;i<CORLORCOLUMNS;i++)
        self.myColorArray[i]=[[NSMutableArray alloc]initWithCapacity:COLORNUMBERS]    ;
    
    for(int i=0;i<CORLORCOLUMNS;i++)
    {
        NSArray *colorForAColumn=HexColorArray[i];
        for(int j=0;j<COLORNUMBERS;j++)
        {
            NSString *hexColorString=colorForAColumn[j];  //字符串形式的16进制颜色表示
            RGBColor *rgbColor=[self transToRGB:hexColorString];  //转化为RGB颜色
            rgbColor.index=j;
            [self.myColorArray[i] addObject:rgbColor];
        }
        [self makeRandom:self.myColorArray[i]];
    }
}
//将HEX颜色转化为RGB颜色值并储存
-(RGBColor *)transToRGB:(NSString *)string
{
    const char *s=[string cStringUsingEncoding:NSUTF8StringEncoding];
    int *resArray=(int *)calloc(6,sizeof(int));
    for(int i=0;i<6;i++)
    {
        if(s[i]>='a' && s[i]<='f')
            resArray[i]=s[i]-0x57;
        else
            resArray[i]=s[i]-'0';
    }
    int Red=16*resArray[0]+resArray[1];
    int Green=16*resArray[2]+resArray[3];
    int Blue=16*resArray[4]+resArray[5];
    RGBColor *color=[[RGBColor alloc]initWithR:Red G:Green B:Blue];
    free(resArray);
    return color;
}
//将颜色进行乱序排序，但是固定首尾两个色块的颜色不变；
-(void)makeRandom:(NSMutableArray *)array
{
    for(int i=0;i<COLORNUMBERS;i++)
    {
        int n=(arc4random()%(COLORNUMBERS-i))+i;
        [array exchangeObjectAtIndex:i withObjectAtIndex:n];
    }
    int first=0;
    int last=0;
    int j=0;
    RGBColor *color=array[j];
    while((color.index==0)||(color.index==COLORNUMBERS-1))
    {
        if(color.index==0)
            first=j;
        if(color.index==COLORNUMBERS-1)
            last=j;
        j++;
        color=array[j];
    }
    [array exchangeObjectAtIndex:first withObjectAtIndex:0];
    [array exchangeObjectAtIndex:last withObjectAtIndex:COLORNUMBERS-1];
}
@end
