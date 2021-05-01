//
//  stackViewController.m
//  ColorHarmony Test
//
//  Created by 莫玄 on 2021/5/1.
//
#import "stackViewController.h"
#import "myUIImageView.h"

#define WIDTH 28.0
#define HIGHT 28.0
#define IMAGECOUNT 20

@interface stackViewController()

@end
@implementation stackViewController

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(instancetype)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    [self setImages];
    return self;
}
-(instancetype)initWithCoder:(NSCoder *)coder
{
    self=[super initWithCoder:coder];
    [self setImages];
    return self;
}
-(void)setImages
{
    for(int i=0;i<IMAGECOUNT;i++)
    {
        CGFloat c[]={250,0,0,1};
        CGColorRef color=CGColorCreate(CGColorSpaceCreateDeviceRGB(), c);
        myUIImageView *image=[[myUIImageView alloc]init];
        image.backgroundColor=[UIColor colorWithCGColor:color];
        [image.heightAnchor constraintEqualToConstant:HIGHT].active=true;
        [image.widthAnchor constraintEqualToConstant:WIDTH].active=true;
        image.index=i;
        if(image.index==0 || image.index==19)
        {
            image.userInteractionEnabled=NO;
        }
        else
        {
            image.userInteractionEnabled=YES;
        }
        UIPanGestureRecognizer *pan=[[UIPanGestureRecognizer alloc]init];
        pan.maximumNumberOfTouches=1;
        pan.minimumNumberOfTouches=1;
        [pan addTarget:self action:@selector(panMove:)];
        [image addGestureRecognizer:pan];
        [self addArrangedSubview:image];
    }
}
-(void)panMove:(UIPanGestureRecognizer *)sender
{
    myUIImageView *image=(myUIImageView *)sender.view;
    CGPoint trans=[sender translationInView:sender.view.superview];
    if(sender.state==UIGestureRecognizerStateBegan)
    {
        image.positionX=sender.view.center.x;
        image.positionY=sender.view.center.y;
        image.positionXTEM=image.positionX;
        NSLog(@"当前正在移动的imageview 序号为：%lu,坐标为：%f,%f\n",(unsigned long)image.index,image.positionX,image.positionY);

    }
   else if(sender.state==UIGestureRecognizerStateChanged)
    {
        CGFloat x=trans.x+image.positionXTEM;
        sender.view.center=CGPointMake(x, image.positionY);
        image.positionXTEM=x;
        NSLog(@"当前imageView移动到位置：%f,%f\n",x,image.positionY);
        [sender setTranslation:CGPointMake(0, 0) inView:sender.view.superview];
    }
    else if(sender.state==UIGestureRecognizerStateCancelled || UIGestureRecognizerStateEnded)
    {
        CGFloat x=image.positionXTEM+trans.x;
        CGFloat distance=x-image.positionX;
        if(distance>0)
        {
            NSLog(@"向右移动");
            int times=(int)distance/32;
            int res=(int)distance%32;
            if(res>=19)
                times+=1;
            x=times*32+image.positionX;
        }
        else
        {
            NSLog(@"向左移动");
            distance=distance *(-1);
            int times=(int)distance/32;
            int res=(int)distance%32;
            if(res>=19)
                times+=1;
            times=times*(-1);
            x=32*times+image.positionX;
        }
        sender.view.center=CGPointMake(x,image.positionY);
        NSLog(@"当前imageView移动到位置：%f,%f\n",x,image.positionY);
    }
}
@end
