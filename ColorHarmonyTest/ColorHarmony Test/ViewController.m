//
//  ViewController.m
//  ColorHarmony Test
//
//  Created by 莫玄 on 2021/5/1.
//

#import "ViewController.h"

@interface ViewController ()
@property (strong, nonatomic) UIButton *scoreButton;
@property (strong, nonatomic) UIButton *NewTestButton;
@property (strong,nonatomic)  UIStackView *stackView;
@property (strong, nonatomic) NSMutableArray *innerStackViewArr;
@property (strong,nonatomic) NSString *score;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _innerStackViewArr=[NSMutableArray array];
    
    //newtestbutton
    _NewTestButton=[UIButton buttonWithType:UIButtonTypeSystem];
    [_NewTestButton setTitle:@"newTest" forState:UIControlStateNormal];
    _NewTestButton.translatesAutoresizingMaskIntoConstraints=NO;
    [_NewTestButton addTarget:self action:@selector(newTestButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_NewTestButton];
    
    [_NewTestButton.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor constant:10].active=YES;
    [_NewTestButton.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor].active=YES;
    [_NewTestButton.heightAnchor constraintEqualToConstant:44.0].active=YES;
    [_NewTestButton.widthAnchor constraintEqualToConstant:66.0].active=YES;
    
    //stackView
    _stackView=[[UIStackView alloc]init];
    _stackView.axis=UILayoutConstraintAxisVertical;
    _stackView.spacing=SPACINGBETWEENSTACKVIEW;
    _stackView.alignment=UIStackViewAlignmentCenter;
    _stackView.distribution=UIStackViewDistributionEqualSpacing;
    _stackView.translatesAutoresizingMaskIntoConstraints=NO;
    [self.view addSubview:_stackView];
    
    [_stackView.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor].active=true;
    [_stackView.centerYAnchor constraintEqualToAnchor:self.view.centerYAnchor].active=true;
    
    for(int i=0;i<CORLORCOLUMNS;i++)
    {
        stackViewController *innerStackView=[[stackViewController alloc]init];
        innerStackView.tag=100*(i+1);
        [innerStackView innerStackViewDoSomeOtherInit];
        [_innerStackViewArr addObject:innerStackView];
        [_stackView addArrangedSubview:innerStackView];
    }
}
- (void)newTestButtonTapped:(UIButton *)sender {
    colorArray *color=[colorArray sharedColorArray];
    for(int i=0;i<CORLORCOLUMNS;i++)
    {
        [color makeRandom:color.myColorArray[i]];
        [_innerStackViewArr[i] refreshSingleImageViewColor];
    }
}
- (void)scoreButtonTapped:(UIButton *)sender {
    NSUInteger total=0;
    for(int i=0;i<CORLORCOLUMNS;i++)
        total+=[self caculateScore:_innerStackViewArr[i]];
    self.score=[NSString stringWithFormat:@"%lu",total];
    NSString *scoreString=[NSString stringWithFormat:@"your score is :%@ ",self.score];
    UIAlertController *alert=[UIAlertController alertControllerWithTitle:scoreString message:@"分数越低表示对颜色的识别度越高，0分为当前条件下最佳分数" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancel=[UIAlertAction actionWithTitle:@"cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action){
        [self dismissViewControllerAnimated:true completion:nil];
    }];
    UIAlertAction *share=[UIAlertAction actionWithTitle:@"share" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        [self shareScoreToSocial];
    }];
    [alert addAction:cancel];
    [alert addAction:share];
    [self presentViewController:alert animated:TRUE completion:nil];
}
-(void)shareScoreToSocial
{
    NSString *shareTitle=[NSString stringWithFormat:@"我在colorharmony的测试中获得了%@分，快来试试吧！",self.score];
    UIImage *shareImage=[UIImage imageNamed:@"pic"];
#warning url hasn't been modified
    NSURL *shareUrl = [NSURL URLWithString:@"http://www.baidu.com"];
    NSArray *activityItems = @[shareTitle,shareImage,shareUrl];

    UIActivityViewController *activityVC=[[UIActivityViewController alloc]initWithActivityItems:activityItems applicationActivities:nil];
    activityVC.excludedActivityTypes=@[UIActivityTypeAirDrop,UIActivityTypePostToTwitter,UIActivityTypeCopyToPasteboard,UIActivityTypeAddToReadingList,UIActivityTypePrint,UIActivityTypeAssignToContact,UIActivityTypeSaveToCameraRoll];
    activityVC.completionWithItemsHandler=^(UIActivityType _Nullable activityType, BOOL completed, NSArray * _Nullable returnedItems, NSError * _Nullable activityError){
        if(completed)
            NSLog(@"分享成功");
        else
            NSLog(@"分享失败");
    };
    [self presentViewController:activityVC animated:TRUE completion:nil];
}
-(NSUInteger)caculateScore:(stackViewController *)stackView
{
    NSMutableArray *colorIndexArray=[NSMutableArray array];
    for(int i=1;i<=22;i++)
    {
        myUIImageView *image=[stackView viewWithTag:(i+stackView.tag)];
        RGBColor *color=image.colorInfo;
        NSUInteger index=color.index;
        NSNumber *colorIndex=[NSNumber numberWithInteger:index];
        [colorIndexArray addObject:colorIndex];
    }
    NSUInteger score=[self caculateArray:colorIndexArray];
    return score;
}
-(NSUInteger)caculateArray:(NSMutableArray *)array
{
    NSUInteger score=0;
    for(int i=0;i<22;i++)
    {
        NSNumber *colorIndex=array[i];
        NSUInteger index=[colorIndex intValue];
        if(index!=i)
        {
            score+=1;
        }
    }
    return score;
}
@end
