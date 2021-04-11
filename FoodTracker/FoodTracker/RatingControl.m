//
//  RatingControl.m
//  FoodTracker
//
//  Created by 莫玄 on 2021/2/1.
//  Copyright © 2021 莫玄. All rights reserved.
//

#import "RatingControl.h"
@interface RatingControl()
{
    NSMutableArray *ratingButtons;//请一定要注意进行初始化；
}
@end
IB_DESIGNABLE
@implementation RatingControl
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (instancetype)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    [self setButtons];
    [self addObserver:self forKeyPath:@"rating" options:NSKeyValueObservingOptionNew context:nil];
    return self;
}
- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self setButtons];
        [self addObserver:self forKeyPath:@"rating" options:NSKeyValueObservingOptionNew context:nil];
    }
    return self;
}
-(void)setButtons
{
    //定义button的数量以及长宽等属性；
    [self fresh];
    //清除旧的button
    for (UIButton *button in ratingButtons) {
        [self removeArrangedSubview:button];
        [button removeFromSuperview];
        [ratingButtons removeObject:button];
    }

    //添加button的属性显示效果
    NSBundle *bundle=[NSBundle mainBundle];
    UIImage *emptyImage=[UIImage imageNamed:@"empty" inBundle:bundle compatibleWithTraitCollection:self.traitCollection];
    UIImage *fullImage=[UIImage imageNamed:@"full" inBundle:bundle compatibleWithTraitCollection:self.traitCollection];
    UIImage *highlightImage=[UIImage imageNamed:@"highlight" inBundle:bundle compatibleWithTraitCollection:self.traitCollection];
    //添加新的button
    for(int i=0;i<self.starCount;i++)
    {
        UIButton *button=[[UIButton alloc]init];
        [button setImage:emptyImage forState:UIControlStateNormal];
        [button setImage:fullImage forState:UIControlStateSelected];
        [button setImage:highlightImage forState:UIControlStateHighlighted && UIControlStateSelected];
        button.translatesAutoresizingMaskIntoConstraints=false;
        [button.heightAnchor constraintEqualToConstant:self.starSizeHeight].active=true;
        [button.widthAnchor constraintEqualToConstant:self.starSizeWidth].active=true;
        [button addTarget:self action:@selector(ratingButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        [self addArrangedSubview:button];
        [ratingButtons addObject:button];
        [self updateButtonSelectionStates];
    }
}
-(IBAction)ratingButtonTapped:(id)sender{
    NSUInteger index=[ratingButtons indexOfObject:sender];
    NSUInteger selectedRating=index+1;
    if(selectedRating==self.rating)
    {
        self.rating=0;
    }
    else{
        self.rating=selectedRating;
    }
}
/*-(void)setStarCount:(int)starCount
{
    _starCount=5;
}
-(void)setStarSizeWidth:(float)starSizeWidth
{
    _starSizeWidth=44.0;
}
-(void)setStarSizeHeight:(float)starSizeHeight
{
    _starSizeHeight=44.0;
}*/
-(void)fresh{
    [self setStarCount:5];
    [self setStarSizeHeight:44.0];
    [self setStarSizeWidth:44.0];
    ratingButtons=[[NSMutableArray alloc]init];
}
//设置该按钮的被选中状态
-(void)updateButtonSelectionStates
{
    for (UIButton *button in ratingButtons) {
        NSUInteger index=[ratingButtons indexOfObject:button];
        if(self.rating>index)
        {
            [button setSelected:TRUE];
        }
        else
            [button setSelected:false];
    }
}
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    if([keyPath isEqualToString:@"rating"])
    {
        [self updateButtonSelectionStates];
    }
}
@end
