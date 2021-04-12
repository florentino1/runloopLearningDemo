//
//  ratingController.m
//  myFoodTracker
//
//  Created by 莫玄 on 2021/4/10.
//

#import "ratingController.h"
@interface ratingController()
{
    NSMutableArray *buttons;//用于储存已经生成的button
}
@end
IB_DESIGNABLE
@implementation ratingController

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
    [self addObserver:self forKeyPath:@"currentRating" options:NSKeyValueObservingOptionNew context:nil];
    [self setButtons];
    [self updateButtonSelectionState];
    return self;
}
-(instancetype)initWithCoder:(NSCoder *)coder
{
    self=[super initWithCoder:coder];
    [self addObserver:self forKeyPath:@"currentRating" options:NSKeyValueObservingOptionNew context:nil];
    [self setButtons];
    [self updateButtonSelectionState];
    return self;

}
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    if([keyPath isEqualToString:@"currentRating"])
    {
        [self updateButtonSelectionState];
    }

}
-(void)fresh
{
    _starCount=5;
    _starWeith=44.0;
    _starHeight=44.0;
    buttons=[[NSMutableArray alloc]init];
}
-(void)setButtons
{
    [self fresh];
    for(UIButton *button in buttons)     //移除原有的button
    {
        [self removeArrangedSubview:button];
        [button removeFromSuperview];
        [buttons removeObject:button];
    }

    NSBundle *bundle=[NSBundle mainBundle];
    UIImage *emptyImage=[UIImage imageNamed:@"empty" inBundle:bundle compatibleWithTraitCollection:self.traitCollection];
    UIImage *fullImage=[UIImage imageNamed:@"full" inBundle:bundle compatibleWithTraitCollection:self.traitCollection];
    UIImage *highlightImage=[UIImage imageNamed:@"highlight" inBundle:bundle compatibleWithTraitCollection:self.traitCollection];
    //添加新的button
    for(int i=0;i<_starCount;i++)
    {
        UIButton *button=[[UIButton alloc]init];
        [button setImage:emptyImage forState:UIControlStateNormal];
        [button setImage:fullImage forState:UIControlStateSelected];
        [button setImage:highlightImage forState:UIControlStateHighlighted && UIControlStateSelected];
        button.translatesAutoresizingMaskIntoConstraints=NO;
        [button.heightAnchor constraintEqualToConstant:self.starHeight].active=true;
        [button.widthAnchor constraintEqualToConstant:self.starWeith].active=true;
        [button addTarget:self action:@selector(ratingButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        [self addArrangedSubview:button];
        [buttons addObject:button];
    }
}
-(IBAction)ratingButtonTapped:(id)sender
{
    NSUInteger index=[buttons indexOfObject:sender];   //用户点击的星星的序号
    NSInteger selectedRating=index+1;//评分等于星星序号+1；
    if(selectedRating==self.currentRating)
        self.currentRating=0;
    else
        self.currentRating=selectedRating;
    [self updateButtonSelectionState];
}
-(void)updateButtonSelectionState
{
        for(UIButton *button in buttons)
        {
            NSUInteger index=[buttons indexOfObject:button];
            NSUInteger rating=index+1;
            if(rating<=self.currentRating)
                [button setSelected:YES];
            else
                [button setSelected:NO];
        }
}
@end
