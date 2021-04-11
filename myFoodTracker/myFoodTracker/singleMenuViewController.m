//
//  singleMenuViewController.m
//  myFoodTracker
//
//  Created by 莫玄 on 2021/4/10.
//

#import "singleMenuViewController.h"
#import "singleMeal.h"
#import "ratingController.h"

@interface singleMenuViewController ()<UINavigationBarDelegate,UINavigationControllerDelegate>
@property (strong,nonatomic)ratingController *ratingController;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation singleMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if(self.meal==nil)
        NSLog(@"》》》传入的meal为空");
    if(self.meal.mealPhoto==nil)
    {
        self.imageView.image=[UIImage imageNamed:@"placeholderPic"];
    }
    else
    {
        self.imageView.image=self.meal.mealPhoto;
    }
    self.ratingController.currentRating=self.meal.mealRating;
    self.navigationItem.title=self.meal.mealName;
}
- (IBAction)edit:(UIBarButtonItem *)sender {

}
- (IBAction)cancel:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:TRUE completion:nil];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

@end
