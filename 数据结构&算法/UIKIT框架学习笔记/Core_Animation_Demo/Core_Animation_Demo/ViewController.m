//
//  ViewController.m
//  Core_Animation_Demo
//
//  Created by 莫玄 on 2021/9/8.
//

#import "ViewController.h"
#import <math.h>

@interface ViewController ()
@property(strong,nonatomic)UISlider *animationSpeed;
//@property(strong,nonatomic)UIProgressView *
@property(strong,nonatomic)UIImageView *viewToRotate;
@property(strong,nonatomic)UIImageView *viewToTransform;
@property(strong,nonatomic)UILabel *speedLabel;
@property(strong,nonatomic)UILabel *speedLabelValue;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //place views
    [self setSlider];
    [self setLabel];
    [self setLabelValue];
    [self setViewRotate];
    [self setViewTransform];
}
-(void)setViewTransform
{
    _viewToTransform=[[UIImageView alloc]initWithFrame:CGRectMake(60, 60, 44, 44)];
    _viewToTransform.backgroundColor=UIColor.greenColor;
    _viewToTransform.layer.anchorPoint=CGPointMake(1, 1);
    [self.view addSubview:_viewToTransform];
    [self setTransformPath];
}
-(void)setTransformPath
{
    CGMutablePathRef mutablePath=CGPathCreateMutable();
    CGPathMoveToPoint(mutablePath, NULL, 84, 84);
    CGPathAddCurveToPoint(mutablePath, NULL, 200, 300, 400, 80, 700, 350);
    
    CAShapeLayer *transformpath=[CAShapeLayer layer];
    transformpath.path=mutablePath;
    transformpath.strokeColor=UIColor.redColor.CGColor;
    transformpath.fillColor=nil;
    [self.view.layer insertSublayer:transformpath below:_viewToTransform.layer];
    
    CAKeyframeAnimation *transformAnimation=[CAKeyframeAnimation animationWithKeyPath:@"position"];
    transformAnimation.duration=10.0;
    transformAnimation.fillMode=kCAFillModeForwards;
    transformAnimation.removedOnCompletion=NO;
    transformAnimation.speed=1.0;
    transformAnimation.path=transformpath.path;
    
    [_viewToTransform.layer addAnimation:transformAnimation forKey:@"transformAnimation"];
}
-(void)setViewRotate
{
    _viewToRotate=[[UIImageView alloc]init];
    _viewToRotate.backgroundColor=UIColor.blueColor;
    _viewToRotate.layer.cornerRadius=5.0;
    _viewToRotate.translatesAutoresizingMaskIntoConstraints=NO;
    [self.view addSubview:_viewToRotate];
    [self setViewToRotateConstraints];
    _viewToRotate.layer.anchorPoint=CGPointMake(0.5, 0.5);
    //begin to rotate；
    CABasicAnimation *animator=[self setRotateAnimation];
    animator.speed=1.0;
    [_viewToRotate.layer addAnimation:animator forKey:@"viewToRotateAnimation"];
}
-(CABasicAnimation *)setRotateAnimation
{
    CABasicAnimation *bsAnimation=[CABasicAnimation animation];
    bsAnimation.keyPath=@"transform.rotation";
    bsAnimation.fromValue=0;
    bsAnimation.byValue=@(M_PI *2);
    bsAnimation.repeatCount=INFINITY;
    bsAnimation.duration=2.0;
    return bsAnimation;
}
-(void)setViewToRotateConstraints
{
    [_viewToRotate.centerXAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.centerXAnchor].active=TRUE;
    [_viewToRotate.centerYAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.centerYAnchor constant:-100.0].active=TRUE;
    [_viewToRotate.heightAnchor constraintEqualToConstant:44.0].active=true;
    [_viewToRotate.widthAnchor constraintEqualToConstant:44.0].active=true;
}
-(void)setLabelValue
{
    _speedLabelValue=[[UILabel alloc]init];
    _speedLabelValue.textAlignment=NSTextAlignmentCenter;
    _speedLabelValue.text=[NSString stringWithFormat:@"%.2f",_animationSpeed.value];
    _speedLabelValue.translatesAutoresizingMaskIntoConstraints=NO;
    [self.view addSubview:_speedLabelValue];
    [self setSpeedLabelValueConstraints];
}
-(void)setSpeedLabelValueConstraints
{
    [_speedLabelValue.topAnchor constraintEqualToAnchor:_speedLabel.topAnchor].active=true;
    [_speedLabelValue.leadingAnchor constraintEqualToAnchor:_speedLabel.trailingAnchor].active=true;
    [_speedLabelValue.heightAnchor constraintEqualToAnchor:_speedLabel.heightAnchor].active=true;
    [_speedLabelValue.widthAnchor constraintEqualToConstant:50.0].active=true;
}
-(void)setLabel
{
    _speedLabel=[[UILabel alloc]init];
    _speedLabel.textAlignment=NSTextAlignmentCenter;
    _speedLabel.text=@"speed now: ";
    _speedLabel.translatesAutoresizingMaskIntoConstraints=NO;
    [self.view  addSubview:_speedLabel];
    _speedLabel.layer.backgroundColor=UIColor.grayColor.CGColor;
    _speedLabel.layer.borderColor=UIColor.grayColor.CGColor;
    _speedLabel.layer.cornerRadius=3.0;
    [self setSpeedLabelConstraints];
}
-(void)setSpeedLabelConstraints
{
    [_speedLabel.leadingAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.leadingAnchor].active=true;
    [_speedLabel.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor constant:10.0].active=true;
    [_speedLabel.widthAnchor constraintEqualToConstant:120.0].active=true;
    [_speedLabel.heightAnchor constraintEqualToConstant:44.0].active=true;
}
-(void)setSlider
{
    self.animationSpeed=[[UISlider alloc]init];
    self.animationSpeed.maximumValue=3.0;
    self.animationSpeed.minimumValue=-3.0;
    self.animationSpeed.value=1.0;
    self.animationSpeed.translatesAutoresizingMaskIntoConstraints=NO;
    [self.view addSubview:_animationSpeed];
    [self setSliderConstraints];
    [self.animationSpeed addTarget:self action:@selector(changeSpeedLabelValue) forControlEvents:UIControlEventTouchUpInside];
    
}
-(void)changeSpeedLabelValue
{
    _speedLabelValue.text=[NSString stringWithFormat:@"%.2f",_animationSpeed.value];
    [_viewToRotate.layer removeAnimationForKey:@"viewToRotateAnimation"];
    CABasicAnimation *bsAnimation=[self setRotateAnimation];
    bsAnimation.speed=_animationSpeed.value;
    NSTimeInterval globletime=[_viewToRotate.layer convertTime:CACurrentMediaTime() fromLayer:nil];
    bsAnimation.beginTime=0.25+globletime;
    [_viewToRotate.layer addAnimation:bsAnimation forKey:@"viewToRotateAnimation"];
}
-(void)setSliderConstraints
{
    //animationSpeed
    [self.animationSpeed.bottomAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.bottomAnchor constant:-30].active=true;
    [self.animationSpeed.widthAnchor constraintEqualToConstant:150].active=true;
    [self.animationSpeed.heightAnchor constraintEqualToConstant:30].active=true;
    [self.animationSpeed.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor].active=true;
    [self.animationSpeed.centerYAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.bottomAnchor constant:-45].active=true;
}

@end
