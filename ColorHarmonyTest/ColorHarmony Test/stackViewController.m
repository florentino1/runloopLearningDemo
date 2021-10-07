//
//  stackViewController.m
//  ColorHarmony Test
//
//  Created by 莫玄 on 2021/5/1.
//
#import "stackViewController.h"
#import "myUIImageView.h"
#import "colorArray.h"
#import "RGBColor.h"


#define WIDTH 24.0
#define HIGHT 24.0
#define IMAGECOUNT 22

@interface stackViewController()
@property (assign,nonatomic)NSUInteger tagtmp;//用于储存正在被拖动的imageView的初始tag；
@property (strong,nonatomic)NSMutableArray *color;//用于储存来自colorArray的随机颜色；
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
    self.tagtmp=1001;
    [self setColorArray];
    [self setImages];
    return self;
}
-(instancetype)initWithCoder:(NSCoder *)coder
{
    self=[super initWithCoder:coder];
    self.tagtmp=1001;
    [self setColorArray];
    [self setImages];
    return self;
}
-(void)setColorArray
{
    colorArray *colorA=[colorArray sharedColorArray];
    if(self.tag==100)
    {
        _color=colorA.myColorArray[0];
    }
    else if(self.tag==200)
    {
        _color=colorA.myColorArray[1];
    }
    else if(self.tag==300)
    {
        _color=colorA.myColorArray[2];
    }
    else if(self.tag==400)
    {
        _color=colorA.myColorArray[3];
    }
}
-(void)setImages
{
    for(int i=1;i<=IMAGECOUNT;i++)
    {
        //设置imageview的基本参数
        myUIImageView *image=[[myUIImageView alloc]init];
        [image.heightAnchor constraintEqualToConstant:HIGHT].active=true;
        [image.widthAnchor constraintEqualToConstant:WIDTH].active=true;

        //设置每个色块的颜色
        [self setSingleImageColorWithimageView:image Index:i ColorArray:_color];

        //设置每个色块的tag;
        [self imageSetTag:image withIndex:(i+(int)self.tag)];

        //设置手势识别器
        [self imageViewSetPanGesture:image];

        [self addArrangedSubview:image];
    }
}
-(void)imageViewSetPanGesture:(myUIImageView *)image
{
    UIPanGestureRecognizer *pan=[[UIPanGestureRecognizer alloc]init];
    pan.maximumNumberOfTouches=1;
    pan.minimumNumberOfTouches=1;
    [pan addTarget:self action:@selector(panMove:)];
    [image addGestureRecognizer:pan];
}
-(void)imageSetTag:(myUIImageView *)image withIndex:(int)i
{
    image.tag=i;
    if(image.tag==(1+self.tag) || image.tag==(22+self.tag))
    {
        image.userInteractionEnabled=NO;
    }
    else
    {
        image.userInteractionEnabled=YES;
    }
}
-(void)setSingleImageColorWithimageView:(myUIImageView *)image Index:(int)i ColorArray:(NSMutableArray *)color
{
    RGBColor *rgbColor=color[i-1];
    UIColor *colorWithCGColor=[UIColor colorWithRed:rgbColor.R/255.0 green:rgbColor.G/255.0 blue:rgbColor.B/255.0 alpha:1.0];
    image.backgroundColor=colorWithCGColor;
    image.colorInfo=rgbColor;
}
-(void)refreshSingleImageViewColor
{
    [self setColorArray];
    for(int i=1;i<=IMAGECOUNT;i++)
    {
        myUIImageView *image=[self viewWithTag:(i+self.tag)];
        [self setSingleImageColorWithimageView:image Index:i ColorArray:self.color];
    }
}
-(void)panMove:(UIPanGestureRecognizer *)sender
{
    myUIImageView *image=(myUIImageView *)sender.view;
    CGPoint trans=[sender translationInView:sender.view.superview];
    CGFloat k=WIDTH+self.spacing;
    if(sender.state==UIGestureRecognizerStateBegan)
    {
        image.positionXForver=sender.view.center.x;
        image.positionX=sender.view.center.x;
        image.positionY=sender.view.center.y;
        image.positionXTEM=image.positionX;
        NSLog(@"当前正在移动的imageview 序号为：%lu,坐标为：%f,%f\n",(unsigned long)image.tag,image.positionX,image.positionY);

    }
   else if(sender.state==UIGestureRecognizerStateChanged)
    {
        NSUInteger index=image.tag;
        //CGFloat temx=trans.x+image.positionX;
        CGFloat distance=trans.x+image.positionX-image.positionXTEM;
        if(trans.x>=0 && distance>=0)
        {
            NSLog(@"色块向右移动:%f,总计移动：%f",trans.x,distance);
            int times=(int)distance/k;
            int res=(int)distance % (int)k;
            if(res>=(WIDTH/2+self.spacing))
                times+=1;
            for (NSUInteger i=1+index;i<=times+index; i++)
            {
                //判断下一个色块是否是最后一个色块
                if(i!=self.tag+22)
                {
                    myUIImageView *imageNext=[self viewWithTag:i];
                    image.tag=self.tagtmp;
                    imageNext.tag=imageNext.tag-1;
                    imageNext.positionX=image.positionXTEM;
                    imageNext.positionY=image.positionY;
                    imageNext.positionXForver=image.positionX;
                    imageNext.positionXTEM=imageNext.positionX;
                    imageNext.center=CGPointMake(imageNext.positionX, imageNext.positionY);
                    NSLog(@"色块%ld移动到位置：%f %f",(long)imageNext.tag, imageNext.positionX,imageNext.positionY);
                    image.tag=i;
                    image.positionX+=trans.x;
                    sender.view.center=CGPointMake(image.positionX, image.positionY);
                    NSLog(@"当前色块移动到位置：%f %f",image.positionX,image.positionY);
                    image.positionXTEM+=k;
                    [sender setTranslation:CGPointMake(0, 0) inView:sender.view.superview];
                    trans.x=0;
                    trans.y=0;
                    k=0;
                }
            }
            image.positionX=image.positionX+trans.x;
          //  image.positionXTEM+=k;
            sender.view.center=CGPointMake(image.positionX, image.positionY);
            [sender setTranslation:CGPointMake(0, 0) inView:sender.view.superview];
        }
        else if(trans.x>=0 && distance<0)
        {
            image.positionX=image.positionX+trans.x;
            sender.view.center=CGPointMake(image.positionX, image.positionY);
            [sender setTranslation:CGPointMake(0, 0) inView:sender.view.superview];
        }

        //判断向左进行移动
        else if(trans.x<0 && distance<=0)
        {
            NSLog(@"色块向左移动:%f,总计移动：%f",trans.x,distance);
            distance=distance*(-1);
            int res=(int)distance% (int)k;
            int times=(int)distance/k;
            if(res>=(WIDTH/2+self.spacing))
                times+=1;
            for(NSUInteger i=index-1;i>=index-times;i--)
            {
                if(i!=self.tag+1)
                {
                    myUIImageView *imageForward=[self viewWithTag:i];
                    image.tag=self.tagtmp;
                    imageForward.tag+=1;
                    imageForward.positionX=image.positionXTEM;
                    imageForward.positionY=image.positionY;
                    imageForward.positionXForver=image.positionX;
                    imageForward.positionXTEM=imageForward.positionX;
                    imageForward.center=CGPointMake(imageForward.positionX, imageForward.positionY);
                    image.tag=i;
                    image.positionX+=trans.x;
                    sender.view.center=CGPointMake(image.positionX, image.positionY);
                    image.positionXTEM-=k;
                    trans.x=0;
                    trans.y=0;
                    [sender setTranslation:CGPointMake(0, 0) inView:sender.view.superview];
                }
            }
            image.positionX+=trans.x;
            if(image.tag==self.tag+2 || image.positionX<=(self.spacing+1.5*WIDTH))
            {
                myUIImageView *firstImage=[self viewWithTag:self.tag+1];
                image.positionX=firstImage.center.x+WIDTH+self.spacing;
                image.tag=self.tag+2;
            }
            sender.view.center=CGPointMake(image.positionX, image.positionY);
            [sender setTranslation:CGPointMake(0, 0) inView:sender.view.superview];
        }
        else if(trans.x<0 && distance>0)
        {
            image.positionX+=trans.x;
            sender.view.center=CGPointMake(image.positionX, image.positionY);
            [sender setTranslation:CGPointMake(0, 0) inView:sender.view.superview];
        }
    }
    else if(sender.state==UIGestureRecognizerStateCancelled || UIGestureRecognizerStateEnded)
    {
        CGFloat distance=image.positionX-image.positionXForver;
        if(distance>0)
        {
            int times=(int)distance/k;
            int res=(int)distance%(int)k;
            if(res>=(WIDTH/2+self.spacing))
                times+=1;
            image.positionX=times*k+image.positionXForver;
        }
        else
        {
            distance=distance *(-1);
            int times=(int)distance/k;
            int res=(int)distance%(int)k;
            if(res>=(WIDTH/2+self.spacing))
                times+=1;
            times=times*(-1);
            image.positionX=k*times+image.positionXForver;
        }
        if(image.tag==self.tag+IMAGECOUNT-1 || image.positionX>=(self.spacing*(IMAGECOUNT-2)+(IMAGECOUNT-1)*WIDTH))
        {
            myUIImageView *lastImage=[self viewWithTag:self.tag+IMAGECOUNT];
            image.positionX=lastImage.center.x-WIDTH-self.spacing;
            image.tag=self.tag+IMAGECOUNT-1;
        }
        if(image.tag==self.tag+2 || image.positionX<=(self.spacing+1.5*WIDTH))
        {
            myUIImageView *firstImage=[self viewWithTag:self.tag+1];
            image.positionX=firstImage.center.x+WIDTH+self.spacing;
            image.tag=self.tag+2;
        }
        sender.view.center=CGPointMake(image.positionX,image.positionY);
        NSLog(@"当前色块最终移动到位置：%f %f",image.positionX,image.positionY);
        image.positionXTEM=image.positionX;
        image.positionXForver=image.positionX;
    }

}
@end
