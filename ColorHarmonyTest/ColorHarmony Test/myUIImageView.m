//
//  myUIImageView.m
//  ColorHarmony Test
//
//  Created by 莫玄 on 2021/5/1.
//

#import "myUIImageView.h"
@interface myUIImageView()

@end

@implementation myUIImageView

/*
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
    CGContextAddPath(context, path);
    CGContextSetFillColor(<#CGContextRef  _Nullable c#>, <#const CGFloat * _Nullable components#>)
    
    
}
 */
@end
