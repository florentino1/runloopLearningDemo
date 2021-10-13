//
//  myView.m
//  ColorHarmony Test
//
//  Created by 莫玄 on 2021/5/1.
//

#import "myView.h"

@implementation myView

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    
    //对imageView的轮廓进行自定义绘制
    CGContextRef context=UIGraphicsGetCurrentContext();
    CGMutablePathRef path=CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, rect.origin.x,rect.origin.y);
    CGPathAddLineToPoint(path, NULL, rect.origin.x+IMAGEWIDTH, rect.origin.y);
    CGPathAddLineToPoint(path, NULL, rect.origin.x+IMAGEWIDTH, rect.origin.y+IMAGEHIGHT);
    CGPathAddLineToPoint(path, NULL, rect.origin.x, rect.origin.y+IMAGEHIGHT);
    CGPathCloseSubpath(path);
    CGFloat color[4]={_colorInfo.R/255.0,_colorInfo.G/255.0,_colorInfo.B/255.0,1};
    CGContextSetFillColor(context,color);
    CGContextAddPath(context, path);
    CGContextDrawPath(context, kCGPathFillStroke);
}

-(instancetype)initWithTag:(NSUInteger)tag
{
    if(self=[super init])
    {
        self.tag=tag;
        colorArray *colorArr=[colorArray sharedColorArray];
        int column=(int)tag/100-1;
        int index=tag%100;
        RGBColor *color=colorArr.myColorArray[column][index];
        self.colorInfo=color;
    }
    return self;
}
@end
