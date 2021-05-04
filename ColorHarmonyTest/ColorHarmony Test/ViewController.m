//
//  ViewController.m
//  ColorHarmony Test
//
//  Created by 莫玄 on 2021/5/1.
//

#import "ViewController.h"
#import "colorArray.h"
#import "stackViewController.h"

@interface ViewController ()
@property (strong, nonatomic) IBOutlet stackViewController *firstStackView;
@property (strong, nonatomic) IBOutlet stackViewController *secondStackView;
@property (strong, nonatomic) IBOutlet stackViewController *thirdStackView;
@property (strong,nonatomic)NSString *score;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (IBAction)newTestButtonTapped:(UIButton *)sender {
    colorArray *color=[colorArray sharedColorArray];
    [color makeRandom:color.firstColorArray];
    [color makeRandom:color.secondColorArray];
    [color makeRandom:color.thirdColorArray];
    [self.firstStackView refreshSingleImageViewColor];
    [self.secondStackView refreshSingleImageViewColor];
    [self.thirdStackView refreshSingleImageViewColor];
    
}
- (IBAction)scoreButtonTapped:(UIButton *)sender {
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


@end
